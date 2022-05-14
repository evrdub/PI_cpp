----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2022 14:58:43
-- Design Name: 
-- Module Name: Toplevel - Behavioral
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

entity Toplevel is
    Port ( clk          : in  std_logic;
           rst          : in  std_logic;
           ce           : in  std_logic;
           UART_check   : in  std_logic;
           digit        : out std_logic_vector (15 downto 0);
           enable_UART  : out std_logic);
end Toplevel;

architecture Behavioral of Toplevel is

component RAM_SP_64_8 is
 Generic ( NbBits        : integer := 16;
		   NbAdr         : integer := 7);
    Port ( ADD           : in  STD_LOGIC_VECTOR ((NbAdr-1) downto 0);
           DATA_IN       : in  STD_LOGIC_VECTOR ((NbBits-1) downto 0);
           R_W           : in  STD_LOGIC;
           ENABLE        : in  STD_LOGIC;
           clk           : in  STD_LOGIC;
		   ce            : in  STD_LOGIC;
		   --jaifini       : out STD_LOGIC;
           DATA_OUT      : out  STD_LOGIC_VECTOR ((NbBits-1) downto 0)
);
end component;

component Control_Unit is
    Port ( clk 					 : in  STD_LOGIC;
	       ce					 : in  STD_LOGIC;
           rst 					 : in  STD_LOGIC;
           UART_check            : in  STD_LOGIC;
	       save_val_ram			 : in  STD_LOGIC;
	       done_ligne            : in  STD_LOGIC;
	       jaifini               : in  STD_LOGIC;
           enable_mem 			 : out STD_LOGIC;
           enable_read           : out STD_LOGIC;
		   start 			     : out  STD_LOGIC;
           rw 		             : out  STD_LOGIC;
           enable_UART           : out  STD_LOGIC;   
		   adr_PC    		     : out  STD_LOGIC_VECTOR(6 downto 0));
end component;

component Processing_Unit is
    Generic(NbBits      : integer := 16);
    Port(   clk         : in std_logic;
            rst         : in std_logic;
            carry_in    : in std_logic_vector((NbBits-1) downto 0);
            value_in    : in std_logic_vector((NbBits-1) downto 0);
            length      : in std_logic_vector((NbBits-1) downto 0);
            start_UT    : in std_logic;
            enable_read : in std_logic;
            
            done_UT     : out std_logic;
            carry_out   : out std_logic_vector((NbBits-1) downto 0);
            value_out   : out std_logic_vector((NbBits-1) downto 0);
            save_val_ram: out std_logic
            );
 end component;
 
 component init_ram is
    Generic (NbBits : integer := 16;
             length : integer := 15);
    Port ( clk     : in STD_LOGIC;
           rst     : in STD_LOGIC;
           jaifini : out STD_LOGIC;
           adresse : out STD_LOGIC_VECTOR (6 downto 0);
           donnee  : out STD_LOGIC_VECTOR ((NbBits-1) downto 0));
 end component;
 
 signal s_enable     : std_logic;
 signal s_boot       : std_logic;
 signal s_jaifini    : std_logic;
 signal s_done_col   : std_logic;
 signal s_done_ligne : std_logic;
 signal s_enable_mem : std_logic;
 signal s_start      : std_logic;
 signal s_rw         : std_logic;
 signal s_adr        : std_logic_vector(6 downto 0);
 signal s_adr_PC     : std_logic_vector(6 downto 0);
 signal s_carry_in   : std_logic_vector(15 downto 0);
 signal s_carry_out  : std_logic_vector(15 downto 0);
 signal s_value_in   : std_logic_vector(15 downto 0);
 signal s_value_out  : std_logic_vector(15 downto 0);
 signal s_ram_in     : std_logic_vector(15 downto 0);
 signal s_ram_out    : std_logic_vector(15 downto 0);
 signal s_adr_ram    : std_logic_vector(6 downto 0);
 signal s_data_in    : std_logic_vector(15 downto 0);
 signal s_quotient   : std_logic_vector(15 downto 0);
 signal save         : std_logic;
 
 signal s_enable_read: std_logic;



begin

s_ram_in <= s_data_in when s_jaifini = '0' else s_carry_out;
s_adr_ram <= s_adr when s_jaifini = '0' else s_adr_PC;

UC : Control_Unit 
Port map (clk => clk,
          ce  => ce,
          rst => rst,
          jaifini => s_jaifini,
          UART_check  => UART_check, 
          save_val_ram => save,
          done_ligne => s_done_ligne,
          enable_mem => s_enable_mem,
          enable_read  => s_enable_read,
          start => s_start,
          enable_UART  => enable_UART,
          rw => s_rw,
          adr_PC => s_adr_PC); 
          
UT : Processing_Unit
    Generic map (NbBits  => 16)
    Port map(   clk      => clk,
                rst      => rst,
                carry_in => "0000000000000000",
                value_in => s_ram_out,
                length   => "0000000000001111",
                start_UT => s_start,
                enable_read => s_enable_read,
                
                done_UT   => s_done_ligne, 
                carry_out => s_carry_out,
                value_out => s_quotient,
                save_val_ram => save);
        
UM : RAM_SP_64_8
    Generic map( NbBits => 16 ,
			     NbAdr  => 7)
    Port map( ADD      => s_adr_ram,
              DATA_IN  => s_ram_in,
              R_W      => s_rw,
              ENABLE   => s_enable_mem,
              clk      => clk,
		      ce       => ce,
		     -- jaifini  => s_jaifini, 
              DATA_OUT => s_ram_out);
              
Initialisation : init_ram

  Generic map (NbBits => 16,
               length => 15)
  Port map (clk => clk,
            rst => rst,
            jaifini => s_jaifini,
            adresse => s_adr,
            donnee  => s_data_in ); 
end Behavioral;
