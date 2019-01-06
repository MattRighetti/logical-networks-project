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
	S10,
	S11,
	S12
	);
 
	SIGNAL next_state : state_type := INIT;
	SIGNAL current_state : state_type := INIT;

	SIGNAL point_x : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL point_y : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	
	SIGNAL centroid_mask : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL centroid_x : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centroid_y : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL temp_x_sum : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL temp_y_sum : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL manhattan_distance : std_logic_vector(8 DOWNTO 0) := (OTHERS => '0');
	
	SIGNAL temp_x_sum_nine_bit : std_logic_vector(8 DOWNTO 0) := (OTHERS => '0');
	SIGNAL temp_y_sum_nine_bit : std_logic_vector(8 DOWNTO 0) := (OTHERS => '0');

	SIGNAL minimum_distance : std_logic_vector(8 DOWNTO 0) := (OTHERS => '1');

	SIGNAL output_mask : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL current_address : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');

	SIGNAL mask_index : INTEGER := 0;
	SIGNAL index : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL stop_computing : std_logic := '0';

BEGIN
	state_transition : PROCESS (i_clk)
	BEGIN
		IF rising_edge(i_clk) THEN
		  current_state <= next_state;
		END IF;
	END PROCESS;
 
	state_switcher : PROCESS (i_clk, current_state, i_rst)
	BEGIN
		IF falling_edge(i_clk) THEN
			CASE current_state IS
				WHEN INIT => 
					IF i_rst = '1' THEN
						next_state <= RST;
					END IF;
					
				WHEN RST => 
					IF i_start = '1' THEN
						next_state <= S0;
					END IF;
				
                    WHEN S0 =>
                        next_state <= S1;
                        
                    WHEN S1 =>
                        next_state <= S2;
                        
                    WHEN S2 =>
                        next_state <= S3;
                        
                    WHEN S3 =>
                        next_state <= S4;
                        
                    WHEN S4 =>
                        next_state <= S5;
     
                    WHEN S5 =>
                        IF stop_computing = '1' THEN
                            next_state <= S11;
                        ELSE
                            next_state <= S6;
                        END IF;
                        
                    WHEN S6 =>
                        next_state <= S7;
                        
                    WHEN S7 =>
                        next_state <= S8;
                        
                    WHEN S8 =>
                        next_state <= S9;
                        
                    WHEN S9 =>
                        next_state <= S10;
                    
                    WHEN S10 =>
                        next_state <= S4;
                                     
                    WHEN S11 =>
                        next_state <= S12;
                    
                    WHEN S12 =>
                        next_state <= RST;
                    
			END CASE;
		END IF;
	END PROCESS;

	centroid_calculator : PROCESS (i_clk, current_state, i_data, output_mask, current_address, minimum_distance, manhattan_distance, temp_x_sum, temp_y_sum)
	BEGIN
		IF falling_edge(i_clk) THEN
			CASE current_state IS
 
			WHEN INIT =>
			     o_done <= '0';
			     
			WHEN RST =>
			     mask_index <= 0;
			     -- Indirizzo di lettura X Punto
			     o_address <= "0000000000010001";
			     current_address <= "0000000000010001";
			     -- Resetto variabili della computazione
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
		          current_address <= "0000000000010010";
		    
		    WHEN S2 =>
		          point_y <= i_data;
		          o_address <= (OTHERS => '0');
		          current_address <= (OTHERS => '0');
		    
		    WHEN S3 =>
		          centroid_mask <= i_data;
		          o_address <= current_address + "0000000000000001";
		          current_address <= current_address + "0000000000000001";
		          index <= "00000001";
		    
		    WHEN S4 =>
		          IF mask_index < 8 THEN
		              centroid_x <= i_data;
                      o_address <= current_address + "0000000000000001";
                      current_address <= current_address + "0000000000000001";
                  ELSE
                      o_address <= (0 => '1', 1 => '1', 4 => '1', OTHERS => '0');
                      current_address <= (0 => '1', 1 => '1', 4 => '1', OTHERS => '0');
                      o_we <= '1';
                      stop_computing <= '1';
		          END IF;
		    
		    WHEN S5 =>
		          centroid_y <= i_data;
		    
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
		          
		    WHEN S7 =>
		          IF (centroid_y < point_y) THEN
                        temp_y_sum <= point_y - centroid_y;
                  ELSE
                        IF (centroid_y > point_y) THEN
                            temp_y_sum <= centroid_y - point_y;
                        ELSE
                            temp_y_sum <= (OTHERS => '0');
                        END IF;
                  END IF;
                  
            WHEN S8 =>
                  temp_x_sum_nine_bit <= std_logic_vector(resize(unsigned(temp_x_sum), temp_x_sum_nine_bit'length));
                  temp_y_sum_nine_bit <= std_logic_vector(resize(unsigned(temp_y_sum), temp_y_sum_nine_bit'length));
            
            WHEN S9 =>
                manhattan_distance <= temp_x_sum_nine_bit + temp_y_sum_nine_bit;
            
            WHEN S10 =>
                  -- Entra solo se è stata ispezionata tutta la maschera
                    IF centroid_mask(mask_index) = '1' THEN
                        IF manhattan_distance < minimum_distance THEN
                            output_mask <= "00000000" OR index;
                            minimum_distance <= manhattan_distance;
                            o_address <= current_address + "0000000000000001";
                            current_address <= current_address + "0000000000000001";
                            mask_index <= mask_index + 1;
                            index <= shift_left(index, 1);
                        ELSE
                            IF manhattan_distance = minimum_distance THEN
                                output_mask <= output_mask OR index;
                                o_address <= current_address + "0000000000000001";
                                current_address <= current_address + "0000000000000001";
                                mask_index <= mask_index + 1;
                                index <= shift_left(index, 1);
                            ELSE
                                o_address <= current_address + "0000000000000001";
                                current_address <= current_address + "0000000000000001";
                                mask_index <= mask_index + 1;
                                index <= shift_left(index, 1);
                            END IF;
                        END IF;
                     ELSE
                        o_address <= current_address + "0000000000000001";
                        current_address <= current_address + "0000000000000001";
                        mask_index <= mask_index + 1;
                        index <= shift_left(index, 1);
                     END IF;
                     
            WHEN S11 =>
                o_data <= std_logic_vector(output_mask);
                o_done <= '1';
            
            WHEN S12 =>
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';         
            
            END CASE;
            END IF;
	END PROCESS;
 
END Behavioral;