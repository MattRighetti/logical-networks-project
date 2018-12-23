----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2018 12:24:11 AM
-- Design Name: 
-- Module Name: tb_adder - Behavioral
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

entity tb_adder is
end tb_adder;

architecture Behavioral of tb_adder is

    component adder is
        Port(
            X: in STD_LOGIC_VECTOR(7 downto 0);
            Y: in STD_LOGIC_VECTOR(7 downto 0);
            Selector: in STD_LOGIC;
            Sum: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    signal X_test : STD_LOGIC_VECTOR(7 downto 0);
    signal Y_test : STD_LOGIC_VECTOR(7 downto 0);
    signal Selector_test: STD_LOGIC;
    signal Sum_out: STD_LOGIC_VECTOR(7 downto 0);

begin

    ADD: adder
    port map(
        X => X_test,
        Y => Y_test,
        Selector => Selector_test,
        Sum => Sum_out
    );
    
    process
    begin
    
    X_test <= "00000001";
    Y_test <= "00000011";
    Selector_test <= '1';
    WAIT FOR 100ns;
    
    X_test <= "00000011";
    Y_test <= "00000010";
    Selector_test <= '0';
    WAIT FOR 100ns;
        
    X_test <= "00000001";
    Y_test <= "00000111";
    Selector_test <= '1';
    WAIT FOR 100ns;
    ASSERT(FALSE) REPORT "Simulation OK" SEVERITY FAILURE;
    
    end process;
end Behavioral;
