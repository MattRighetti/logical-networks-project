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
	PORT 
	(
		i_clk     : IN STD_LOGIC;                      -- segnale di CLOCK generato dal testbench
		i_start   : IN STD_LOGIC;                      -- signale di START generato dal testbench
		i_rst     : IN STD_LOGIC;                      -- segnale di RESET generato dal testbench
		i_data    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- vettore di bit letti da memoria
		o_address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- vettore di bit
		o_done    : OUT STD_LOGIC;                     -- segnale di DONE indicante la fine della computazione
		o_en      : OUT STD_LOGIC;                     -- segnale di ENABLE per poter accedere (scrittura/lettura) alla memoria
		o_we      : OUT STD_LOGIC;                     -- segnale di WRITE_ENABLE per poter scrivere in memoria
	    o_data    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)   -- vettore di dati da scrivere in memoria
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
	S9
	);
 
	COMPONENT adder_8bit IS
		PORT 
		(
			X   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Y   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Sum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT address_adder IS
		PORT 
		(
			X      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Y      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Active : IN STD_LOGIC := '0';
			Sum    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT abs_calculator IS
		PORT 
		(
			X       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Y       : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Abs_Out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT adder IS
		PORT 
		(
			X        : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Y        : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Selector : IN STD_LOGIC;
			Sum      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL State              : State_type := RST;

	SIGNAL centroid_mask      : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL point_x            : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL point_y            : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL centroid_x         : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centroid_y         : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL temp_x_sum         : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL temp_y_sum         : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL manhattan_distance : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
 
	SIGNAL minimum_distance   : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	SIGNAL output_mask        : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL current_address    : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Sum_active         : std_logic := '0';
	SIGNAL address_increment  : std_logic_vector(15 DOWNTO 0) := (1 => '1', OTHERS => '0');
 
	SIGNAL Mask_index         : INTEGER;

BEGIN
	program_counter : address_adder
	PORT MAP(X => current_address, Y => address_increment, Sum => current_address);
	
	x_module_calculator : abs_calculator
	PORT MAP(X => point_x, Y => centroid_x, Abs_out => temp_x_sum);
	
	y_module_calculator : abs_calculator
	PORT MAP(X => point_y, Y => centroid_y, Abs_out => temp_y_sum);
	
    manhattan_distance_calculator : adder_8bit
    PORT MAP(X => temp_x_sum, Y => temp_y_sum, Sum => manhattan_distance);

    o_address_update : PROCESS (current_address)
    BEGIN
        o_address  <= current_address;
        Sum_active <= '0' AFTER 5ns;
    END PROCESS o_address_update;

    centroid_calculator : PROCESS (i_clk, i_rst, i_start, State)
    
    BEGIN
        IF i_rst = '1' THEN
            State <= RST;
        END IF;
    
        IF rising_edge(i_clk) THEN
            CASE State IS
    
                WHEN RST => 
                    Mask_index         <= 0;
                    o_address          <= (4 => '1', OTHERS => '0'); -- Indirizzo settato alla cella della X del Punto Principale
                    current_address    <= (4 => '1', OTHERS => '0');
                    output_mask        <= (OTHERS => '0');
                    manhattan_distance <= (OTHERS => '0');
                    minimum_distance   <= (OTHERS => '0');
                    temp_x_sum         <= (OTHERS => '0');
                    temp_y_sum         <= (OTHERS => '0');
    
                WHEN S0 => 
                    IF i_start = '1' THEN
                        o_en  <= '1';
                        o_we  <= '0';
                        State <= S1;
                    END IF;
     
                WHEN S1 => 
                    point_x    <= i_data;
                    Sum_active <= '1';
                    State      <= S2;
     
    
                WHEN S2 => 
                    point_y         <= i_data;
                    current_address <= (OTHERS => '0'); -- Indirizzo 19 per leggere la maschera
                    State           <= S3;
    
                WHEN S3 => 
                    centroid_mask <= i_data;
                    Sum_active    <= '1';
                    State         <= S4;
    
                WHEN S4 => 
                    WHILE Mask_index < 8 LOOP
                    IF centroid_mask(Mask_index) = '1' THEN
                        centroid_x <= i_data;
                        Sum_active <= '1';
                        State      <= S5;
                        Mask_index <= Mask_index + 1;
                    ELSE
                        output_mask(Mask_index) <= '0';
                        current_address         <= current_address + "0000000000000010";
                        Mask_index              <= Mask_index + 1;
                    END IF;
            END LOOP;
            State <= S7;
    
                WHEN S5 => 
                centroid_y <= i_data;
                Sum_active <= '1';
                State      <= S6;
    
                WHEN S6 => 
                IF manhattan_distance < minimum_distance THEN
                    output_mask      <= (Mask_index => '1', OTHERS => '0');
                    minimum_distance <= manhattan_distance;
                ELSE
                    IF (manhattan_distance = minimum_distance) THEN
                        output_mask(Mask_index) <= '1';
                    END IF;
                END IF;
     
                WHEN S7 => 
                current_address <= (0 => '1', 1 => '1', 4 => '1', OTHERS => '0');
                o_we            <= '1';
                State           <= S8;
     
                WHEN S8 => 
                o_data <= output_mask;
                o_done <= '1';
                State  <= S9;
     
                WHEN S9 => 
                o_done <= '0';
                o_en   <= '0';
                State  <= RST;
    
        END CASE;
    END IF;
    
    END PROCESS centroid_calculator;
END Behavioral;