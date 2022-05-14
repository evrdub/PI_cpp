library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Toplevel_tb is
end;

architecture bench of Toplevel_tb is

  component Toplevel
    Port ( clk          : in  std_logic;
           rst          : in  std_logic;
           ce           : in  std_logic;
           UART_check   : in  std_logic;
           digit        : out std_logic_vector (15 downto 0);
           enable_UART  : out std_logic);
  end component;

 signal clk: std_logic;
  signal rst: std_logic;
  signal ce: std_logic;
  signal UART_check: std_logic;
  signal digit: std_logic_vector (15 downto 0);
  signal enable_UART: std_logic;
  
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Toplevel port map ( clk         => clk,
                           rst         => rst,
                           ce          => ce,
                           UART_check  => UART_check,
                           digit       => digit,
                           enable_UART => enable_UART );

  stimulus: process
  begin
  
  rst <= '0';
  ce <= '1';
  wait for 20 ns;
  rst <= '1';
  wait for 5 ns;
  rst <= '0';
  wait for 60 ns;
  UART_check <= '1';
  wait for 1000 ns;
  
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




 