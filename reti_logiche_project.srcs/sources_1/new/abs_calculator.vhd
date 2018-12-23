----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2018 01:00:50 AM
-- Design Name: 
-- Module Name: abs_calculator - Behavioral
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

entity abs_calculator is
    Port(
        X: in STD_LOGIC_VECTOR(7 downto 0);
        Y: in STD_LOGIC_VECTOR(7 downto 0);
        Abs_Out: out STD_LOGIC_VECTOR(7 downto 0)
    );
end abs_calculator;

architecture Behavioral of abs_calculator is

    component comparator is
        Port (
            X: in STD_LOGIC_VECTOR(7 downto 0);
            Y: in STD_LOGIC_VECTOR(7 downto 0);
            Result: out STD_LOGIC
        );
    end component;
    
    component adder is
        Port(
            X: in STD_LOGIC_VECTOR(7 downto 0);
            Y: in STD_LOGIC_VECTOR(7 downto 0);
            Selector: in STD_LOGIC;
            Sum: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
   
    signal Selector_out: STD_LOGIC;

begin

    switch_values_check: comparator
        port map(
            X => X, 
            Y => Y, 
            Result => Selector_out
        );
    
    op_sub: adder
        port map(X => X, Y => Y, Selector => Selector_out, Sum => Abs_out);

end Behavioral;
