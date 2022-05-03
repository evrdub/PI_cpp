library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_UT is
    Generic(    NbBits      : integer := 16);
    Port ( clk          : in std_logic;
           rst          : in std_logic;
           length       : in std_logic_vector((NbBits-1) downto 0);
           div_done     : in std_logic;
           div_start    : out std_logic;
           digit_calc   : out std_logic;
           load_reg     : out std_logic;
           enable_coeff : out std_logic
           
           );
end FSM_UT;

architecture Behavioral of FSM_UT is

type STATE_TYPE is (INIT, STATE1);
signal current_state : STATE_TYPE;
signal next_state : STATE_TYPE;

begin

process (CLK)
    begin
        if (CLK'EVENT AND CLK = '1') then
            if RST = '1' then
                current_state <= INIT;
            else
                current_state <= next_state;
            end if;
         end if;
    end process;

process (current_state)
    begin
        case current_state is 
            when INIT   => 
            when STATE1 => 
            when others => next_state <= INIT;
        end case;
   end process;

process (current_state)
    begin
        case current_state is
            when INIT   => 
            when STATE1 => 
       end case;
   end process;

end Behavioral;
