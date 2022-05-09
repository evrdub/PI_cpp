library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Processing_Unit is
    Generic(NbBits      : integer := 16);
    Port(   clk         : in std_logic;
            rst         : in std_logic;
            carry_in    : in std_logic_vector((NbBits-1) downto 0);
            value_in    : in std_logic_vector((NbBits-1) downto 0);
            length      : in std_logic_vector((NbBits-1) downto 0);
            start_UT    : in std_logic;
            
            done_UT     : out std_logic;
            carry_out   : out std_logic_vector((NbBits-1) downto 0);
            value_out   : out std_logic_vector((NbBits-1) downto 0);
            save_val_ram: out std_logic
            );
end Processing_Unit;

architecture Behavioral of Processing_Unit is



component FSM_UT is
    Generic(    NbBits      : integer := 16);
    Port ( clk          : in std_logic;
           rst          : in std_logic;
           length       : in std_logic_vector((NbBits-1) downto 0);
           done_div     : in std_logic;
           start_UT     : in std_logic;
           start_div    : out std_logic;
           digit_calc   : out std_logic;
           load_reg     : out std_logic;
           enable_D     : out std_logic;
           enable_U     : out std_logic;
           save_val_ram : out std_logic;          
           done_UT      : out std_logic
           );
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
    Generic ( NbBits : integer := 16);
    Port(     data_in1 : in STD_LOGIC_VECTOR((NbBits-1) downto 0);
              data_in2 : in STD_LOGIC_VECTOR((NbBits-1) downto 0);
              result   : out STD_LOGIC_VECTOR((NbBits-1) downto 0)
              );
end component;

component coeffs is
    Generic( NbBits : integer := 16);
    Port(    clk       : in std_logic;
             rst       : in std_logic;
             enableD   : in std_logic;
             enableU   : in std_logic;
             length    : in std_logic_vector((NbBits-1) downto 0);
             U         : out std_logic_vector((NbBits-1) downto 0);
             D         : out std_logic_vector((NbBits-1) downto 0)
             );
end component;

-- signaux
constant NumberBits     : integer := 16;
-- signaux FSM_UT
signal s_start_div      : std_logic;
signal s_digit_calc     : std_logic;
signal s_load_reg       : std_logic;
signal s_enable_D       : std_logic;
signal s_enable_U       : std_logic;
signal s_save_val_ram_FSM: std_logic;
-- signaux reg16b
signal s_data_out_R     : std_logic_vector((NumberBits-1) downto 0);
-- signaux coeffs
signal s_U              : std_logic_vector((NumberBits-1) downto 0);
signal s_D              : std_logic_vector((NumberBits-1) downto 0);
-- signaux euclidean divider
signal s_div_data_in2   : std_logic_vector((NumberBits-1) downto 0);
signal s_done_div       : std_logic;
signal s_quotient       : std_logic_vector((NumberBits-1) downto 0);
signal s_remainder      : std_logic_vector((NumberBits-1) downto 0);
--signaux adder
signal s_adder_data_in1 : std_logic_vector((NumberBits-1) downto 0);
signal s_adder_data_out : std_logic_vector((NumberBits-1) downto 0);


begin

comp_FSM_UT : FSM_UT
Generic map( NbBits       => NumberBits)
Port map(    clk          => clk,
             rst          => rst,
             length       => length,
             done_div     => s_done_div,
             start_UT     => start_UT,
             start_div    => s_start_div,
             digit_calc   => s_digit_calc,
             load_reg     => s_load_reg,
             enable_D     => s_enable_D,
             enable_U     => s_enable_U,
             save_val_ram => s_save_val_ram_FSM,
             done_UT      => done_UT  
             );

reg16b_data1_divider : Registre_16bits
Generic map( NbBits       => NumberBits)
Port map(    data_in      => s_adder_data_out,
             clk          => clk,
             rst          => rst,
             load         => s_load_reg,
             data_out     => s_data_out_R
             );

comp_coeff : coeffs 
Generic map( NbBits  => NumberBits)  
Port map(    clk        => clk,
             rst        => rst,
             enableD    => s_enable_D,
             enableU    => s_enable_U,
             length     => length,
             U          => s_U,
             D          => s_D
             );

s_div_data_in2 <= s_D when s_digit_calc = '0' else std_logic_vector(to_unsigned(10,s_div_data_in2'length));

divider : euclidean_divider
Generic map( NbBits     => NumberBits)
Port map(    rst        => rst,
             clk        => clk,
             data_in1   => s_data_out_R,
             data_in2   => s_div_data_in2,
             start      => s_start_div,
             done       => s_done_div,
             quotient   => s_quotient,
             remainder  => s_remainder
             );

adder16bits : adder
Generic map( NbBits    => NumberBits )
Port map(    data_in1  => s_adder_data_in1,
             data_in2  => value_in,
             data_out  => s_adder_data_out
             );

mult16bits : multi
Generic map( NbBits    => NumberBits)
Port map(    data_in1  => s_quotient,
             data_in2  => s_U,
             result    => s_adder_data_in1
             );

value_out <= s_quotient;
carry_out <= s_remainder;
save_val_ram <= s_save_val_ram_FSM;

end Behavioral;
