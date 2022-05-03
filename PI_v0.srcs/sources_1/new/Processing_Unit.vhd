library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Processing_Unit is
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
end Processing_Unit;

architecture Behavioral of Processing_Unit is



component line_counter is
    Generic( NbBits        : integer := 16);
    Port ( clk          : in std_logic;
           rst          : in std_logic;
           length       : in std_logic_vector((NbBits-1) downto 0);
           calc_done    : in std_logic;
           line_done    : out std_logic);
end component;

component Registre_16bits is
    Generic(    NbBits      : integer := 16);
    Port ( data_in  : in  std_logic_vector ((NbBits-1) downto 0);
           clk      : in  std_logic;
           rst      : in  std_logic;
           load     : in  std_logic;
           data_out : out  std_logic_vector ((NbBits-1) downto 0)
           );
end component;

component euclidean_divider is
    Generic(NbBits      : integer := 16);
    Port(   rst         : in std_logic;
            clk         : in std_logic;
            data_in1    : in std_logic_vector((NbBits-1) downto 0);
            data_in2    : in std_logic_vector((NbBits-1) downto 0);
            
            start       : in std_logic;
            done        : inout std_logic;
            quotient    : out std_logic_vector((NbBits-1) downto 0);
            remainder   : out std_logic_vector((NbBits-1) downto 0)
            );
end component;

component adder is
    Generic( NbBits   : integer := 16);
    Port(    data_in1 : in std_logic_vector((NbBits-1) downto 0);
             data_in2 : in std_logic_vector((NbBits-1) downto 0);
             data_out : out std_logic_vector((NbBits-1) downto 0)
             );
end component;

component multi is
    Generic (   NbBits : integer := 16);
    Port    (   data_in1 : in STD_LOGIC_VECTOR((NbBits-1) downto 0);
                data_in2 : in STD_LOGIC_VECTOR((NbBits-1) downto 0);
                result   : out STD_LOGIC_VECTOR((NbBits-1) downto 0)
                );
end component;

component coeffs is
    Generic( NbBits : integer := 16);
    Port( clk       : in std_logic;
          rst       : in std_logic;
          enable    : in std_logic;
          length    : in std_logic_vector((NbBits-1) downto 0);
          U         : out std_logic_vector((NbBits-1) downto 0);
          D         : out std_logic_vector((NbBits-1) downto 0)
          );
end component;

-- signaux
constant NumberBits     : integer := 16;
-- signaux reg16b
signal s_data_out       : std_logic_vector((NumberBits-1) downto 0);
-- signaux line_counter
signal s_calc_done      : std_logic;
-- signaux coeffs
signal s_length         : std_logic_vector((NumberBits-1) downto 0);
signal s_U              : std_logic_vector((NumberBits-1) downto 0);
signal s_D              : std_logic_vector((NumberBits-1) downto 0);
-- signaux euclidean divider
signal s_div_data_in1   : std_logic_vector((NumberBits-1) downto 0);
signal s_div_data_in2   : std_logic_vector((NumberBits-1) downto 0);
signal s_done           : std_logic;
signal s_quotient       : std_logic_vector((NumberBits-1) downto 0);
signal s_remainder      : std_logic_vector((NumberBits-1) downto 0);
--signaux adder
signal s_adder_data_in1 : std_logic_vector((NumberBits-1) downto 0);
signal s_adder_data_in2 : std_logic_vector((NumberBits-1) downto 0);
signal s_adder_data_out : std_logic_vector((NumberBits-1) downto 0);


begin

reg16b_data1_divider : Registre_16bits
Generic map( NbBits       => NumberBits)
Port map(    data_in      => s_div_data_in1,
             clk          => clk,
             rst          => rst,
             load         => s_calc_done,
             data_out     => s_data_out
             );

s_length <= std_logic_vector (to_unsigned(NumberBits,s_length'length));

comp_line_counter : line_counter
Generic map( NbBits       => NumberBits)
Port map(    clk          => clk,
             rst          => rst,
             length       => s_length,
             calc_done    => s_calc_done,
             line_done    => line_done
             );

comp_coeff : coeffs 
Generic map( NbBits  => NumberBits)  
Port map(    clk        => clk,
             rst        => rst,
             enable     => s_calc_done,
             length     => s_length,
             U          => s_U,
             D          => s_D
             );

s_div_data_in2 <= s_D when s_done = '0' else std_logic_vector(to_unsigned(10,s_div_data_in2'length));

divider : euclidean_divider
Generic map( NbBits     => NumberBits)
Port map(    rst        => rst,
             clk        => clk,
             data_in1   => s_data_out,
             data_in2   => s_div_data_in2,
             start      => start,
             done       => s_calc_done,
             quotient   => s_quotient,
             remainder  => s_remainder
             );

adder16bits : adder
Generic map( NbBits    => NumberBits )
Port map(    data_in1  => s_adder_data_in1,
             data_in2  => value_in,
             data_out  => s_div_data_in1
             );

mult16bits : multi
Generic map( NbBits    => NumberBits)
Port map(    data_in1  => s_quotient,
             data_in2  => s_U,
             result    => s_adder_data_in1
             );

value_out <= s_quotient;
carry_out <= s_remainder;
col_done  <= s_calc_done;

end Behavioral;
