----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2022 22:45:23
-- Design Name: 
-- Module Name: toplevel_RAM_UC - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity toplevel_RAM_UC is
  Generic ( NbBits  : integer := 16;
			NbAdr   : integer := 7);
  Port ( clk : in std_logic;
         rst : in std_logic;
         ce  : in std_logic;
         start : in std_logic;
         done : in std_logic;
         carry_out : in std_logic;
         ram_out : out std_logic_vector((NbBits-1) downto 0));
end toplevel_RAM_UC;

architecture Behavioral of toplevel_RAM_UC is


begin


end Behavioral;
