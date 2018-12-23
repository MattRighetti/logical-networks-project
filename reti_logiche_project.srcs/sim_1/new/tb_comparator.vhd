----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2018 12:35:09 AM
-- Design Name: 
-- Module Name: tb_comparator - Behavioral
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

entity tb_comparator is
end tb_comparator;

architecture testbench_comparator of tb_comparator is

component comparator is
    Port (
        X: in STD_LOGIC_VECTOR(7 downto 0);
        Y: in STD_LOGIC_VECTOR(7 downto 0);
        Result: out STD_LOGIC
    );
end component;

SIGNAL X_test   : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL Y_test   : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL Result_out : STD_LOGIC;

begin

    COMPARATOR_TEST: comparator
    port map (
        X => X_test,
        Y => Y_test,
        Result => Result_out
    );
    
    PROCESS
    BEGIN
    
        X_test <= "00000000";
        Y_test <= "00000001";
        -- -------------------------- Current Time: 100ns
        WAIT FOR 100ns;
        X_test <= "01000000";
        Y_test <= "01000000";
        -- --------------------------- Current Time: 300ns
        WAIT FOR 100ns;
        X_test <= "10000000";
        Y_test <= "01000000";
        -- ---------------------------- Current Time: 500ns
        WAIT FOR 1500ns;
        ASSERT(FALSE) REPORT "Simulation OK" SEVERITY FAILURE;
        
    END PROCESS;


end testbench_comparator;
