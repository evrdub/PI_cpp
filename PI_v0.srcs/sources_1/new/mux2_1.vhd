library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux2_1 is
    Generic(    NbBits      : integer := 16);
    Port ( in1    : in   std_logic_vector ((NbBits-1) downto 0);
           in2    : in   std_logic_vector ((NbBits-1) downto 0);
           sel    : in   std_logic;
           output : out  std_logic_vector ((NbBits-1) downto 0));
end mux2_1;

architecture Behavioral of mux2_1 is

begin

Process(sel,in2,in1)
   Begin
	if sel='1' then
      output <= in2;
	else
	   output <= in1;
   end if;
end Process;

end Behavioral;
