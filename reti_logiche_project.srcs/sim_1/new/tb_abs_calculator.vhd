----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2018 01:11:42 AM
-- Design Name: 
-- Module Name: tb_abs_calculator - Behavioral
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

entity tb_abs_calculator is
end tb_abs_calculator;

architecture Behavioral of tb_abs_calculator is

    component abs_calculator is
        Port(
            X: in STD_LOGIC_VECTOR(7 downto 0);
            Y: in STD_LOGIC_VECTOR(7 downto 0);
            Abs_Out: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    signal X_in : STD_LOGIC_VECTOR(7 downto 0);
    signal Y_in : STD_LOGIC_VECTOR(7 downto 0);
    signal Output: STD_LOGIC_VECTOR(7 downto 0);

begin
    
    abs_op: abs_calculator
    port map(
        X => X_in,
        Y => Y_in,
        Abs_Out => Output
    );

    process
    begin
    
        X_in <= "00010000";
        WAIT FOR 3ns;
        Y_in <= "10000000";
        WAIT FOR 100ns;
        
        X_in <= "00110000";
        WAIT FOR 5ns;
        Y_in <= "10000000";
        WAIT FOR 100ns;
        
        Y_in <= "00000010";
        WAIT FOR 3ns;
        X_in <= "00010000";
        WAIT FOR 100ns;
                
        X_in <= "00010000";
        Y_in <= "00010000";
        WAIT FOR 100ns;
        
        X_in <= "00000000";
        Y_in <= "00000000";
        WAIT FOR 200ns;
        
        for i in 0 to 7 loop
            X_in <= (i => '1', others=>'0');
            Y_in <= ((7-i)=>'1', others=>'0');
            WAIT FOR 10ns;
            end loop;
        
        ASSERT(FALSE) REPORT "Simulation OK" SEVERITY FAILURE;
    
    end process;

end Behavioral;
