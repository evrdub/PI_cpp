library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity line_counter is
    Generic( NbBits        : integer := 16);
    Port ( clk          : in std_logic;
           rst          : in std_logic;
           length       : in std_logic_vector((NbBits-1) downto 0);
           calc_done    : in std_logic;
           line_done    : out std_logic);
end line_counter;

architecture Behavioral of line_counter is

signal internal_count : integer;

begin

process(clk,rst,calc_done)
begin
    if (rst = '1') then
        line_done <= '0';
        internal_count <= 0;
    elsif (CLK'event and CLK = '1') then
        if (calc_done = '1') then
            internal_count <= internal_count + 1;
        end if;
        if ( internal_count+1 >= to_integer(unsigned(length)) ) then
            line_done <= '1';
        end if;
    end if;
end process;

end Behavioral;
