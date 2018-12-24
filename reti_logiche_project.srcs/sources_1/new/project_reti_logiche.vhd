----------------------------------------------------------------------------------
-- Engineer: Mattia Righetti
-- Codice Persona: 10489408
-- Matricola: 486580
--
-- Create Date: 14.12.2018 19:31:46
-- Design Name:
-- Module Name: project_reti_logiche - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY project_reti_logiche IS
	PORT (
		i_clk : IN STD_LOGIC; -- segnale di CLOCK generato dal testbench
		i_start : IN STD_LOGIC; -- signale di START generato dal testbench
		i_rst : IN STD_LOGIC; -- segnale di RESET generato dal testbench
		i_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- vettore di bit letti da memoria
		o_address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- vettore di bit
		o_done : OUT STD_LOGIC; -- segnale di DONE indicante la fine della computazione
		o_en : OUT STD_LOGIC; -- segnale di ENABLE per poter accedere (scrittura/lettura) alla memoria
		o_we : OUT STD_LOGIC; -- segnale di WRITE_ENABLE per poter scrivere in memoria
		o_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- vettore di dati da scrivere in memoria
	);
END project_reti_logiche;

ARCHITECTURE Behavioral OF project_reti_logiche IS
	TYPE State_type IS (RST, 
	S0, 
	S1, 
	S2, 
	S3, 
	S4, 
	S5, 
	S6, 
	S7, 
	S8, 
	S9,
	S10,
	S11
	);

	COMPONENT adder_8bit IS
		PORT (
			X : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Y : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Sum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT abs_calculator IS
		PORT (
			CLK : IN STD_LOGIC;
			X : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Y : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Abs_Out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL State : State_type := RST;

	SIGNAL centroid_mask : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL point_x : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL point_y : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL centroid_x : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centroid_y : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL temp_x_sum : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL temp_y_sum : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL manhattan_distance : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL minimum_distance : std_logic_vector(7 DOWNTO 0) := (OTHERS => '1');

	SIGNAL output_mask : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL current_address : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');

	SIGNAL Mask_index : INTEGER;
	SIGNAL index: UNSIGNED(7 downto 0) := (OTHERS=>'0');

BEGIN
	centroid_calculator : PROCESS (i_clk, i_rst, i_start, State)
	BEGIN
		IF i_rst = '1' THEN
			State <= RST;
		END IF;
 
		IF falling_edge(i_clk) THEN
			CASE State IS
 
				WHEN RST => 
					Mask_index <= 0;
					o_address <= "0000000000010001"; -- Indirizzo settato alla cella della X del Punto Principale
					current_address <= "0000000000010001";
					output_mask <= (OTHERS => '0');
					manhattan_distance <= (OTHERS => '0');
					minimum_distance <= (OTHERS => '1');
					temp_x_sum <= (OTHERS => '0');
					temp_y_sum <= (OTHERS => '0');
					State <= S0;
 
				WHEN S0 => 
					IF i_start = '1' THEN
						o_en <= '1';
						o_we <= '0';
						State <= S1;
					END IF;
 
				WHEN S1 => 
					point_x <= i_data;
					o_address <= "0000000000010010";
					State <= S2;
 
 
				WHEN S2 => 
					point_y <= i_data;
					o_address <= (OTHERS => '0'); -- Indirizzo 19 per leggere la maschera
					current_address <= (OTHERS => '0');
					State <= S3;
 
				WHEN S3 => 
					centroid_mask <= i_data;
					o_address <= current_address + "0000000000000001";
					current_address <= current_address + "0000000000000001";
					index <= "00000001";
					State <= S4;
 
				WHEN S4 => 
					IF (Mask_index < 8) THEN
                        IF centroid_mask(Mask_index) = '1' THEN
                            centroid_x <= i_data;
                            o_address <= current_address + "0000000000000001";
                            current_address <= current_address + "0000000000000001";
                            State <= S5;
                        ELSE
                            Mask_index <= Mask_index + 1;
                            o_address <= current_address + "0000000000000010";
                            current_address <= current_address + "0000000000000010";
                            index <= shift_left(index, 1);
                        END IF;
                     ELSE
                        State <= S9;
                     END IF;
 
				WHEN S5 => 
					centroid_y <= i_data;
					State <= S6;
 
				WHEN S6 => 
					IF (centroid_x < point_x) THEN
						temp_x_sum <= point_x - centroid_x;
					ELSE
						IF (centroid_x > point_x) THEN
							temp_x_sum <= centroid_x - point_x;
						ELSE
							temp_x_sum <= (OTHERS => '0');
						END IF;
					END IF;
 
					IF (centroid_y < point_y) THEN
						temp_y_sum <= point_y - centroid_y;
					ELSE IF (centroid_y > point_y) THEN
						temp_y_sum <= centroid_y - point_y;
					ELSE
						temp_y_sum <= (OTHERS => '0');
					END IF;
			        END IF;
			        State <= S7;
 
				WHEN S7 => 
				manhattan_distance <= temp_x_sum + temp_y_sum;
				State <= S8;
 
				WHEN S8 => 
				IF manhattan_distance < minimum_distance THEN
				    output_mask <= "00000000";
					output_mask <= output_mask OR index;
					minimum_distance <= manhattan_distance;
					o_address <= current_address + "0000000000000001";
					current_address <= current_address + "0000000000000001";
					Mask_index <= Mask_index + 1;
					index <= shift_left(index, 1);
					State <= S4;
				ELSE
					IF (manhattan_distance = minimum_distance) THEN
						output_mask <= output_mask OR index;
						o_address <= current_address + "0000000000000001";
                        current_address <= current_address + "0000000000000001";
                        Mask_index <= Mask_index + 1;
                        index <= shift_left(index, 1);
						State <= S4;
				    ELSE
				        o_address <= current_address + "0000000000000001";
                        current_address <= current_address + "0000000000000001";
				        Mask_index <= Mask_index + 1;
				        index <= shift_left(index, 1);
				        State <= S4;
					END IF;
				END IF;
 
				WHEN S9 => 
				current_address <= (0 => '1', 1 => '1', 4 => '1', OTHERS => '0');
				o_we <= '1';
				State <= S10;
 
				WHEN S10 => 
				o_data <= std_logic_vector(output_mask);
				o_done <= '1';
				State <= S11;
 
				WHEN S11 => 
				o_done <= '0';
				o_en <= '0';
				State <= RST;
 
		END CASE;
	END IF;
 
	END PROCESS centroid_calculator;
END Behavioral;