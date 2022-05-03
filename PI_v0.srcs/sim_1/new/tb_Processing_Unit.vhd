library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Processing_Unit is
--  Port ( );
end tb_Processing_Unit;

architecture Behavioral of tb_Processing_Unit is

component Processing_Unit is
    Generic(NbBits      : integer := 16);
    Port(   clk         : in std_logic;
            rst         : in std_logic;
            start       : in std_logic;
            carry_in    : in std_logic_vector((NbBits-1) downto 0);
            value_in    : in std_logic_vector((NbBits-1) downto 0);
            
            line_done   : out std_logic;
            col_done    : out std_logic;
            carry_out   : out std_logic_vector((NbBits-1) downto 0);
            value_out   : out std_logic_vector((NbBits-1) downto 0)
            );
end component;

constant NumberBits  : integer := 16; 
constant NbAdr       : integer := 6;
signal s_rst         : std_logic;
signal s_clk         : std_logic;
signal s_start       : std_logic;                             
signal s_carry_in    : std_logic_vector((NumberBits-1) downto 0); 
signal s_value_in    : std_logic_vector((NumberBits-1) downto 0);             
signal s_line_done    : std_logic;
signal s_col_done    : std_logic;
signal s_carry_out   : std_logic_vector((NumberBits-1) downto 0);
signal s_value_out   : std_logic_vector((NumberBits-1) downto 0);

signal s_data_in1   : std_logic_vector((NumberBits-1) downto 0);
signal s_data_in2   : std_logic_vector((NumberBits-1) downto 0);

constant clock_period: time := 10 ns;
signal stop_the_clock: boolean := false;

subtype Mot is Std_Logic_Vector ((NumberBits-1) downto 0);
type TAB is array (integer range 0 to ((2**(NbAdr)-1))) of Mot;
signal mem : TAB;							  
signal val_temp : Std_Logic_Vector ((NumberBits-1) downto 0) := (others=> '0');    
			

begin

uut : Processing_Unit
Generic map(NbBits      => 16)
Port map(   clk         => s_clk,
            rst         => s_rst,
            start       => s_start,
            carry_in    => s_carry_in,
            value_in    => s_value_in,
            line_done   => s_line_done,
            col_done    => s_col_done,
            carry_out   => s_carry_out,
            value_out   => s_value_out
            );

clocking: process
begin
    while not stop_the_clock loop
        s_CLK <= '0', '1' after clock_period / 2;
        wait for clock_period;
        end loop;
        wait;
end process;

s_value_in <= std_logic_vector(to_unsigned(20, s_value_in'length));
s_start <=  '1' after 20ns;
s_RST  <= '1','0' after 15ns;

s_data_in1 <= std_logic_vector(to_unsigned(2002, s_data_in1'length));
s_data_in2 <= std_logic_vector(to_unsigned(7, s_data_in2'length));

end Behavioral;
