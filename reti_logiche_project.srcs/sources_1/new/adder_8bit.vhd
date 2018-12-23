----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2018 05:05:47 AM
-- Design Name: 
-- Module Name: adder_8bit - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity adder_8bit is
    Port (
        X: in STD_LOGIC_VECTOR(7 downto 0);
        Y: in STD_LOGIC_VECTOR(7 downto 0);
        Sum: out STD_LOGIC_VECTOR(7 downto 0)
    );
end adder_8bit;

architecture Behavioral of adder_8bit is

begin
    
    Sum <= X + Y;

end Behavioral;
