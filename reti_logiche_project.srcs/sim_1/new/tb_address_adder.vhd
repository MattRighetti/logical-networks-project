----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 12/23/2018 02:03:49 AM
-- Design Name:
-- Module Name: tb_address_adder - Behavioral
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

ENTITY tb_address_adder IS
END tb_address_adder;

ARCHITECTURE Behavioral OF tb_address_adder IS

	COMPONENT address_adder IS
		PORT (
			X : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Active: IN STD_LOGIC := '0';
			Sum : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
 
	SIGNAL X_input : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Y_input : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Do      : STD_LOGIC := '0';
	SIGNAL Sum_out : STD_LOGIC_VECTOR(15 DOWNTO 0); 

BEGIN
	program_counter : address_adder
	PORT MAP(X => X_input, Y => Y_input, Active => Do, Sum => Sum_out);
 
	PROCESS
	BEGIN
	    Do <= not Do after 10ns;
        X_input <= "0000000000000000";
        Y_input <= "0000000000000010";
        WAIT FOR 100ns;
        
        X_input <= Sum_out;
        Do <= not Do after 10ns;
        WAIT FOR 30ns;
        
        X_input <= Sum_out;
        Do <= not Do after 10ns;
        WAIT FOR 30ns;
        
        X_input <= Sum_out;
        Do <= not Do after 10ns;
        WAIT FOR 30ns;
           
        X_input <= Sum_out;     
        Do <= not Do after 10ns;
        WAIT FOR 100ns;
 
		ASSERT(FALSE) REPORT "Simulation OK" SEVERITY FAILURE;
 
	END PROCESS;
END Behavioral;