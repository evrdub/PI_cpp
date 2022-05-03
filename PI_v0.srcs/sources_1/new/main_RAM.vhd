library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_RAM is
    Generic(    NbBits        : integer := 16;
			    NbAdr         : integer := 7
				);
    Port ( ADD      : in  STD_LOGIC_VECTOR ((NbAdr-1) downto 0);
           DATA_IN  : in  STD_LOGIC_VECTOR ((NbBits-1) downto 0);
           R_W      : in  STD_LOGIC;
           ENABLE   : in  STD_LOGIC;
           clk      : in  STD_LOGIC;
		   ce       : in  STD_LOGIC;
           DATA_OUT : out  STD_LOGIC_VECTOR ((NbBits-1) downto 0)
		   );
end main_RAM;

architecture Behavioral of main_RAM is    

subtype Mot is Std_Logic_Vector ((NbBits-1) downto 0);
type TAB is array (integer range 0 to ((2**(NbAdr)-1))) of Mot;
signal mem : TAB;							  
signal val_temp : Std_Logic_Vector ((NbBits-1) downto 0) := (others=> '0');    
			
begin
		heart : process (clk)
         begin  -- process heart
			if (clk'event and clk='1') then
		    if (ce= '1')  then
			   if (enable='1') then 
				     if (R_W='1') then mem(TO_INTEGER(UNSIGNED(ADD))) <= DATA_IN;     --ecriture
                     else val_temp <= mem(TO_INTEGER(UNSIGNED(ADD)));    --lecture
					 end if;
				 else
				     val_temp <= val_temp;
				end if;
			end if;
        end if;
      end process heart;
      DATA_OUT <= val_temp;
end Behavioral;
