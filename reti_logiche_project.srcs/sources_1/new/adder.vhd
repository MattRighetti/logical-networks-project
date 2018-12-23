----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2018 12:15:38 AM
-- Design Name: 
-- Module Name: adder - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder is
    Port(
        X: in STD_LOGIC_VECTOR(7 downto 0);
        Y: in STD_LOGIC_VECTOR(7 downto 0);
        Selector: in STD_LOGIC;
        Sum: out STD_LOGIC_VECTOR(7 downto 0)
    );
end adder;

architecture Behavioral of adder is

begin

    process(X, Y, Selector)
    begin
    if (Selector = '1') then
        Sum <= Y - X;
    else
        Sum <= X - Y;
    end if;
    end process;

end Behavioral;
