LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY project_tb113 IS
END project_tb113;
ARCHITECTURE projecttb113 OF project_tb113 IS
	CONSTANT c_CLOCK_PERIOD : TIME := 100ns;
	SIGNAL tb_done : std_logic;
	SIGNAL mem_address : std_logic_vector (15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL tb_rst : std_logic := '0';
	SIGNAL tb_start : std_logic := '0';
	SIGNAL tb_clk : std_logic := '0';
	SIGNAL mem_o_data, mem_i_data : std_logic_vector (7 DOWNTO 0);
	SIGNAL enable_wire : std_logic;
	SIGNAL mem_we : std_logic;

	TYPE ram_type IS ARRAY (65535 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0);
	SIGNAL RAM : 
	ram_type := (0 => std_logic_vector(to_unsigned(58, 8)), 
	             1 => std_logic_vector(to_unsigned(181, 8)), 
	             2 => std_logic_vector(to_unsigned(112, 8)), 
	             3 => std_logic_vector(to_unsigned(215, 8)), 
	             4 => std_logic_vector(to_unsigned(165, 8)), 
	             5 => std_logic_vector(to_unsigned(134, 8)), 
	             6 => std_logic_vector(to_unsigned(190, 8)), 
	             7 => std_logic_vector(to_unsigned(109, 8)), 
	             8 => std_logic_vector(to_unsigned(25, 8)), 
	             9 => std_logic_vector(to_unsigned(194, 8)), 
	             10 => std_logic_vector(to_unsigned(142, 8)), 
	             11 => std_logic_vector(to_unsigned(86, 8)), 
	             12 => std_logic_vector(to_unsigned(18, 8)), 
	             13 => std_logic_vector(to_unsigned(171, 8)), 
	             14 => std_logic_vector(to_unsigned(81, 8)), 
	             15 => std_logic_vector(to_unsigned(98, 8)), 
	             16 => std_logic_vector(to_unsigned(119, 8)), 
	             17 => std_logic_vector(to_unsigned(208, 8)), 
	             18 => std_logic_vector(to_unsigned(89, 8)), 
	             19 => std_logic_vector(to_unsigned(181, 8)), 
	             OTHERS => (OTHERS => '0'));
	COMPONENT project_reti_logiche IS
		PORT (
			i_clk      : IN std_logic;
			i_start    : IN std_logic;
			i_rst      : IN std_logic;
			i_data     : IN std_logic_vector(7 DOWNTO 0); --1 byte
			o_address  : OUT std_logic_vector(15 DOWNTO 0); --16 bit addr: max size is 255*255 + 3 more for max x and y and thresh.
			o_done     : OUT std_logic;
			o_en       : OUT std_logic;
			o_we       : OUT std_logic;
			o_data     : OUT std_logic_vector (7 DOWNTO 0)
		);
	END COMPONENT project_reti_logiche;
BEGIN
	UUT : project_reti_logiche
	PORT MAP(
		i_clk      => tb_clk, 
		i_start    => tb_start, 
		i_rst      => tb_rst, 
		i_data     => mem_o_data, 
		o_address  => mem_address, 
		o_done     => tb_done, 
		o_en       => enable_wire, 
		o_we       => mem_we, 
		o_data     => mem_i_data
	);

	p_CLK_GEN : PROCESS IS
	BEGIN
		WAIT FOR c_CLOCK_PERIOD/2;
		tb_clk <= NOT tb_clk;
	END PROCESS p_CLK_GEN;
 
 
	MEM : PROCESS (tb_clk)
	BEGIN
		IF tb_clk'EVENT AND tb_clk = '1' THEN
			IF enable_wire = '1' THEN
				IF mem_we = '1' THEN
					RAM(conv_integer(mem_address)) <= mem_i_data;
					mem_o_data <= mem_i_data;
				ELSE
					mem_o_data <= RAM(conv_integer(mem_address));
				END IF;
			END IF;
		END IF;
	END PROCESS;

 
	test : PROCESS IS
	BEGIN
		WAIT FOR 100 ns;
		WAIT FOR c_CLOCK_PERIOD;
		tb_rst <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_rst <= '0';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '1';
		WAIT FOR c_CLOCK_PERIOD;
		tb_start <= '0';
		WAIT UNTIL tb_done = '1';
		WAIT UNTIL tb_done = '0';
		WAIT UNTIL rising_edge(tb_clk);

		ASSERT RAM(19) = "00010000" REPORT "Failed test" SEVERITY failure;
		ASSERT false REPORT "Simulation Ended!, test passed" SEVERITY failure;
	END PROCESS test;

END projecttb113;