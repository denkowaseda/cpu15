library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity fetch is
port(
 clk_FT : in std_logic;
 P_count : in std_logic_vector(7 downto 0);
 PROM_out : out std_logic_vector(14 downto 0)
);
end fetch;


architecture rtl of fetch is 

subtype word is std_logic_vector(14 downto 0);

type memory is array (0 to 15) of word;

constant MEM : memory :=
 (
  "100100000000000",  --ldh reg0, 0 
  "100000000000000",  --ldh reg0, 0 
  "100100100000000",  --ldh reg1, 0 
  "100000100000001",  --ldh reg1, 1 
  "100101000000000",  --ldh reg2, 0 
  "100001000000000",  --ldh reg2, 0 
  "100101100000000",  --ldh reg3, 0 
  "100001100001010",  --ldh reg3, 10 
  "000101000100000",  --add reg2, reg1 
  "000100001000000",  --add reg0, reg2
  "111000001000000",  --st reg0, 64(40h) 
  "101001001100000",  --cmp reg2, reg3
  "101100000001110",  --je 14(Eh) 
  "110000000001000",  --jmp 8(8h) 
  "111100000000000",  --hlt
  "000000000000000"   --nop
 );
 


begin
 process(clk_FT)
  begin
   if(clk_FT'event and clk_FT = '1') then
	   prom_out <= MEM(conv_interger(p_count(3 downto 0)));
	end if;
 end process;
end rtl;