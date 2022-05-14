library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity div_eucli_tb is
end;

architecture bench of div_eucli_tb is

  component div_eucli
      Port    (clk       : in STD_LOGIC;
               dividende : in STD_LOGIC_VECTOR (15 downto 0);
               diviseur  : in STD_LOGIC_VECTOR (15 downto 0);
               quotient  : out STD_LOGIC_VECTOR (15 downto 0);
               reste     : out STD_LOGIC_VECTOR (15 downto 0));
  end component;

  signal clk: STD_LOGIC;
  signal dividende: STD_LOGIC_VECTOR (15 downto 0);
  signal diviseur: STD_LOGIC_VECTOR (15 downto 0);
  signal quotient: STD_LOGIC_VECTOR (15 downto 0);
  signal reste: STD_LOGIC_VECTOR (15 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: div_eucli port map ( clk       => clk,
                            dividende => dividende,
                            diviseur  => diviseur,
                            quotient  => quotient,
                            reste     => reste );

  stimulus: process
  begin
    dividende <= std_logic_vector(to_unsigned(45,16));
    diviseur <= std_logic_vector(to_unsigned(12,16));
    wait for 10 ns;
    dividende <= std_logic_vector(to_unsigned(34,16));
    diviseur <= std_logic_vector(to_unsigned(11,16));
    wait for 10 ns;
    dividende <= std_logic_vector(to_unsigned(14,16));
    diviseur  <= std_logic_vector(to_unsigned(23,16));
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  
