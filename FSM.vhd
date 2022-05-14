----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2022 15:07:07
-- Design Name: 
-- Module Name: FSM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
  Port (clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        boot : in std_logic );
end FSM;

architecture Behavioral of FSM is
type type_etat is (Init, Init_RAM, FetchOperand, Calcul, Store, Store_delay);
signal etat_present, etat_futur : type_etat;

begin

state_reg : process(clk, rst)
begin
if rst='1' then
    etat_present <= Init;
elsif (clk'event and clk='1') then
    if ce= '1' then
        if(boot = '1') then
            etat_present <= Init;
        else
            etat_present <= etat_futur ;
        end if;
    end if;
end if;	
end process;

process(etat_present, boot)
begin
    case etat_present is
        when Init =>
            if(boot = '1') then
                etat_futur <= Init;
            else
                etat_futur <= Init_RAM;
            end if;
        when Init_RAM =>
            if(boot = '1') then
                etat_futur <= Init_RAM;
            else
                etat_futur <= FetchOperand;
            end if;
        when FetchOperand =>
            etat_futur <= Calcul;      
        when Calcul =>
            etat_futur <= Store;
        when Store =>
            etat_futur <= Store_delay;
        when Store_delay =>
            etat_futur <= FetchOperand;
    end case;
end process;


calcul_sortie : process(etat_present)
begin
	case etat_present is
		when Init =>
			
end process;

end Behavioral;
