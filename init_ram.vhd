----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.03.2022 15:12:13
-- Design Name: 
-- Module Name: init_ram - Behavioral
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

entity init_ram is
    Generic (NbBits : integer := 16;
             length : integer := 31);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           jaifini : out STD_LOGIC;
           adresse : out STD_LOGIC_VECTOR (6 downto 0);
           donnee : out STD_LOGIC_VECTOR ((NbBits-1) downto 0));
end init_ram;

architecture Behavioral of init_ram is

signal adr : integer := 0;
signal data_out : unsigned (15 downto 0);

begin

process (clk, rst)
begin

    if rising_edge(clk) then
        if rst = '1' then
            adr <= 0;
            jaifini <= '0';
        else
            for i in 0 to 10*length/3 loop
                adr <= adr + 1;
                data_out <= to_unsigned(20,data_out'length);
            end loop;
        end if;    
    end if;
    
    if adr = 10*length/3 then
        jaifini <= '1';
    end if;
end process;

donnee <= std_logic_vector (data_out);
adresse <= std_logic_vector (to_unsigned(adr,7));


end Behavioral;
