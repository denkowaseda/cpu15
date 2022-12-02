library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity clk_gen is
port(
  clk : in std_logic;
  clk_FT : out std_logic;
  clk_DC : out std_logic;
  clk_EX : out std_logic;
  clk_WB : out std_logic
);
end clk_gen;


architecture rtl of clk_gen is 

signal count : std_logic_vector(1 downto 0) := "00";

begin
 process(clk)
  begin
   if(clk'event and clk = '1') then
	  case count is
	    when "00" =>
		   clk_FT <= '1';
		   clk_DC <= '0';
			clk_EX <= '0';
			clk_WB <= '0';
			
		 when "01" =>
		   clk_FT <= '0';
		   clk_DC <= '1';
			clk_EX <= '0';
			clk_WB <= '0';
			
		 when "10" =>
		   clk_FT <= '1';
		   clk_DC <= '0';
			clk_EX <= '1'; 
			clk_WB <= '0';
			
		 when "11" =>
		   clk_FT <= '0';
		   clk_DC <= '0';
			clk_EX <= '0'; 
			clk_WB <= '1';
			
		 when others =>
		   null;
		
		end case;
		
		 count <= count + 1;
	end if;
 end process;
end rtl;