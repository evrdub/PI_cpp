----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.03.2022 14:35:30
-- Design Name: 
-- Module Name: div_eucli - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity div_eucli is
    Port    (clk       : in STD_LOGIC;
             dividende : in STD_LOGIC_VECTOR (15 downto 0);
             diviseur  : in STD_LOGIC_VECTOR (15 downto 0);
             quotient  : out STD_LOGIC_VECTOR (15 downto 0);
             reste     : out STD_LOGIC_VECTOR (15 downto 0));
end div_eucli;

architecture Behavioral of div_eucli is

signal s_quotient : integer range 0 to 65355;
signal s_reste    : integer range 0 to 65355;
signal compteur   : unsigned (15 downto 0) := to_unsigned(0,16);

begin

process (clk, dividende, diviseur, compteur)
begin
if rising_edge(clk) then
    if ((to_integer(unsigned(dividende) - unsigned(diviseur)*compteur)) <= to_integer(unsigned(diviseur))) then
        s_quotient <= to_integer(unsigned (diviseur));
        s_reste <= to_integer(unsigned(dividende) - unsigned(diviseur)*compteur);
    else
        compteur <= compteur + 1;
    end if;
end if;
end process;

quotient <= std_logic_vector(to_unsigned(s_quotient,16));
reste <= std_logic_vector(to_unsigned(s_reste,16));

end behavioral;
