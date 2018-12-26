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
	TYPE State_type IS (
	INIT,
	RST, 
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
	S10
	);
	
    SIGNAL next_state: state_type := INIT;
    SIGNAL current_state : state_type := INIT;

	SIGNAL centroid_mask : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL point_x : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL point_y : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL centroid_x : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centroid_y : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL temp_x_sum : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL temp_y_sum : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL manhattan_distance : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	
	SIGNAL stop_computing: std_logic := '0';
	SIGNAL skip: std_logic := '0';

	SIGNAL minimum_distance : std_logic_vector(7 DOWNTO 0) := (OTHERS => '1');

	SIGNAL output_mask : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL current_address : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');

	SIGNAL Mask_index : INTEGER;
	SIGNAL index: UNSIGNED(7 downto 0) := (OTHERS=>'0');

BEGIN

    state_transition: process(i_clk)
    begin
        if rising_edge(i_clk) then
            current_state <= next_state;
        end if;
    end process;
    
    state_switcher: process(i_clk, current_state, i_start, i_rst, stop_computing, skip)
    begin
        if falling_edge(i_clk) then
            case current_state is
                when INIT =>
                    if i_rst = '1' then
                        next_state <= RST;
                    end if;
                when RST =>
                    if i_start = '1' then
                        next_state <= S0;
                    end if;
                when S0 =>
                    next_state <= S1;
                when S1 =>
                    next_state <= S2;
                when S2 =>
                    next_state <= S3;
                when S3 =>
                    next_state <= S4;
                when S4 =>
                    if stop_computing = '1' then
                        next_state <= S9;
                    end if;
                    
                    if skip = '1' then
                        next_state <= S4;
                    end if;
                    
                    if stop_computing = '0' then
                        next_state <= S5;
                    end if;
                    
                when S5 =>
                    next_state <= S6;
                when S6 =>
                    next_state <= S7;
                when S7 =>
                    next_state <= S8;
                when S8 =>
                    next_state <= S4;
                when S9 =>
                    next_state <= S10;
                when S10 =>
                    next_state <= RST;
                    
            end case;
        end if;
    end process;

	centroid_calculator : PROCESS (i_clk , current_state, i_data, output_mask, current_address, minimum_distance, manhattan_distance, temp_x_sum, temp_y_sum)
	BEGIN
 
		IF falling_edge(i_clk) THEN
			CASE current_state IS
			
			    when INIT =>
			         stop_computing <= '0';
			         skip <= '0';
 
				WHEN RST => 
					Mask_index <= 0;
					o_address <= "0000000000010001"; -- Indirizzo settato alla cella della X del Punto Principale
					current_address <= "0000000000010001";
					output_mask <= (OTHERS => '0');
					manhattan_distance <= (OTHERS => '0');
					minimum_distance <= (OTHERS => '1');
					temp_x_sum <= (OTHERS => '0');
					temp_y_sum <= (OTHERS => '0');
 
				WHEN S0 =>
			        o_en <= '1';
				    o_we <= '0';
					
 
				WHEN S1 => 
					point_x <= i_data;
					o_address <= "0000000000010010";
 
 
				WHEN S2 => 
					point_y <= i_data;
					o_address <= (OTHERS => '0'); -- Indirizzo 19 per leggere la maschera
					current_address <= (OTHERS => '0');
 
				WHEN S3 => 
					centroid_mask <= i_data;
					o_address <= current_address + "0000000000000001";
					current_address <= current_address + "0000000000000001";
					index <= "00000001";
 
				WHEN S4 => 
					IF (Mask_index < 8) THEN
                        IF centroid_mask(Mask_index) = '1' THEN
                            centroid_x <= i_data;
                            o_address <= current_address + "0000000000000001";
                            current_address <= current_address + "0000000000000001";
                            skip <= '0';
                            stop_computing <= '0';
                        ELSE
                            Mask_index <= Mask_index + 1;
                            o_address <= current_address + "0000000000000010";
                            current_address <= current_address + "0000000000000010";
                            index <= shift_left(index, 1);
                            skip <= '1';
                        END IF;
                     ELSE
					 	o_address <= (0 => '1', 1 => '1', 4 => '1', OTHERS => '0');
						current_address <= (0 => '1', 1 => '1', 4 => '1', OTHERS => '0');
						o_we <= '1';
						skip <= '0';
						stop_computing <= '1';
                     END IF;
 
				WHEN S5 => 
					centroid_y <= i_data;
					IF (centroid_x < point_x) THEN
						temp_x_sum <= point_x - centroid_x;
					ELSE
						IF (centroid_x > point_x) THEN
							temp_x_sum <= centroid_x - point_x;
						ELSE
							temp_x_sum <= (OTHERS => '0');
						END IF;
					END IF;
 
				WHEN S6 => 
					IF (centroid_y < point_y) THEN
						temp_y_sum <= point_y - centroid_y;
					ELSE IF (centroid_y > point_y) THEN
						temp_y_sum <= centroid_y - point_y;
					ELSE
						temp_y_sum <= (OTHERS => '0');
					END IF;
			        END IF;
 
				WHEN S7 => 
				manhattan_distance <= temp_x_sum + temp_y_sum;
 
				WHEN S8 => 
				IF manhattan_distance < minimum_distance THEN
				    output_mask <= "00000000";
					output_mask <= output_mask OR index;
					minimum_distance <= manhattan_distance;
					o_address <= current_address + "0000000000000001";
					current_address <= current_address + "0000000000000001";
					Mask_index <= Mask_index + 1;
					index <= shift_left(index, 1);
				ELSE
					IF (manhattan_distance = minimum_distance) THEN
						output_mask <= output_mask OR index;
						o_address <= current_address + "0000000000000001";
                        current_address <= current_address + "0000000000000001";
                        Mask_index <= Mask_index + 1;
                        index <= shift_left(index, 1);
				    ELSE
				        o_address <= current_address + "0000000000000001";
                        current_address <= current_address + "0000000000000001";
				        Mask_index <= Mask_index + 1;
				        index <= shift_left(index, 1);
					END IF;
				END IF;
 
				WHEN S9 => 
				o_data <= "11111111";
				o_done <= '1';
 
				WHEN S10 => 
				o_done <= '0';
				o_en <= '0';
				o_we <= '0';
 
		END CASE;
	END IF;
 
	END PROCESS centroid_calculator;
END Behavioral;