library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Port ( clk         :  in std_logic;
           rst         :  in std_logic;
           ce          :  in std_logic;
           codeop      :  in std_logic_vector(1 downto 0);
           carry       :  in std_logic;
           boot        :  in std_logic;
           
           clear_PC    : out std_logic;
           enable_PC   : out std_logic;
           enable_mem  : out std_logic;
           W_mem       : out std_logic
           );
end FSM;

architecture Behavioral of FSM is

begin



end Behavioral;
