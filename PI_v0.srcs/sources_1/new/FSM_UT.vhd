library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_UT is
    Generic(    NbBits      : integer := 16);
    Port ( clk          : in std_logic;
           rst          : in std_logic;
           length       : in std_logic_vector((NbBits-1) downto 0);
           done_div     : in std_logic;
           start_UT     : in std_logic;
           enable_read  : in std_logic;
           start_div    : out std_logic;
           digit_calc   : out std_logic;
           load_reg     : out std_logic;
           enable_D     : out std_logic;
           enable_U     : out std_logic;
           save_val_ram : out std_logic;
           done_UT      : out std_logic
           );
end FSM_UT;

architecture Behavioral of FSM_UT is

-- INIT, FIRSTLOAD, START_DIV, DIV, LOAD_REG_AND_ENABLE_D, ENABLE_U, LOAD_REG_AND_SET10, START_LAST_DIV, LAST_DIV, STOP
type STATE_TYPE is (INIT, LOAD1, ST_DIV, DIV, LR_ED, EU, LR_10, ST2, DIV2, STOP);
signal current_state : STATE_TYPE;
signal next_state : STATE_TYPE;

signal int_length : integer;
signal iterations : integer:=0;

begin

int_length <= to_integer(unsigned(length));

process (CLK, next_state, iterations)
    begin
        if (CLK'EVENT AND CLK = '1') then
            if RST = '1' then
                current_state <= INIT;
                iterations <= 1;
            else
                if(next_state = ST_DIV) then
                    iterations <= iterations + 1;
                end if;
                current_state <= next_state;
            end if;
         end if;
    end process;

process (current_state, start_UT, done_div, int_length, enable_read)
    begin
        case current_state is 
            when INIT   => if(enable_read = '1') then
                                next_state <= LOAD1;
                           end if;
            when LOAD1  => if(start_UT = '1') then
                                next_state <= ST_DIV;
                           end if;
            when ST_DIV => next_state <= DIV;
            when DIV    => if( (done_div='1')and(enable_read='1'))then
                                next_state <= LR_ED;
                           end if;
            when LR_ED  => next_state <= EU;
            when EU     => if(iterations<int_length) then
                                next_state <= ST_DIV;
                           else
                                next_state <= LR_10;
                           end if;
            when LR_10  => next_state <= ST2;
            when ST2    => next_state <= DIV2;
            when DIV2   => if(done_div='1')then
                                next_state <= STOP;
                           end if;
            when STOP   => next_state <= INIT;
            when others => next_state <= INIT;
        end case;
   end process;

process (current_state, iterations)
    begin
        case current_state is
            when INIT   =>  start_div       <= '0';
                            digit_calc      <= '0';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
            
            when LOAD1  =>  start_div       <= '0';
                            digit_calc      <= '0';
                            load_reg        <= '1';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
            
            when ST_DIV =>  start_div       <= '1';
                            digit_calc      <= '0';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
            
            when DIV    =>  start_div       <= '0';
                            digit_calc      <= '0';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
            
            when LR_ED  =>  start_div       <= '0';
                            digit_calc      <= '0';
                            load_reg        <= '1';
                            enable_D        <= '1';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
            
            when EU     =>  start_div       <= '0';
                            digit_calc      <= '0';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '1';
                            done_UT         <= '0';
                            save_val_ram    <= '1';
            
            when LR_10  =>  start_div       <= '0';
                            digit_calc      <= '1';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
            
            when ST2    =>  start_div       <= '1';
                            digit_calc      <= '1';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
            
            when DIV2   =>  start_div       <= '0';
                            digit_calc      <= '1';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '0';
                            save_val_ram    <= '0';
                            
            when STOP   =>  start_div       <= '0';
                            digit_calc      <= '0';
                            load_reg        <= '0';
                            enable_D        <= '0';
                            enable_U        <= '0';
                            done_UT         <= '1';
                            save_val_ram    <= '0';
       end case;
   end process;

end Behavioral;
