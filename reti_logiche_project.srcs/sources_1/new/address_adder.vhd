----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 12/23/2018 01:59:53 AM
-- Design Name:
-- Module Name: address_adder - Behavioral
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

ENTITY address_adder IS
	PORT (
		X : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Active: IN STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END address_adder;

ARCHITECTURE Behavioral OF address_adder IS

BEGIN
	
	PROCESS(Active) IS
	BEGIN
	
	   IF Active = '1' THEN
	       Sum <= X + Y;
	   END IF;
    
    END PROCESS;
 
END Behavioral;