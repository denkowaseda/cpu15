library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity cpu15 is
port(
  clk : in std_logic;
  reset_n : in std_logic;
  IO65_IN : in std_logic_vector(15 downto 0);
  IO64_OUT : out std_logic_vector(15 downto 0)
 ); 
end cpu15;

architecture rtl of cou15 is

component clk_gen
port(
  clk : in std_logic;
  clk_FT : out std_logic;
  clk_DC : out std_logic;
  clk_EX : out std_logic;
  clk_WB : out std_logic
 );
end component;

--fetch
component fetch
port(
 clk_FT : in std_logic;
 P_count : in std_logic_vector(7 downto 0);
 PROM_out : out std_logic_vector(14 downto 0)
);
end component;

--decode
component decode
port(
 clk_DC : in std_logic_vector;
 PROM_out : in std_logic_vector(14 downto 0);
 op_code : out std_logic_vector(3 downto 0);
 op_data : out std_logic_vector(7 downto 0)
);
end component;

--reg_dc
component reg_dc
port(
 clk_DC : in std_logic;
 N_reg_in : in std_logic_vector(2 downto 0);
 reg_0 : in std_logic_vector(15 downto 0);
 reg_1 : in std_logic_vector(15 downto 0);
 reg_2 : in std_logic_vector(15 downto 0);
 reg_3 : in std_logic_vector(15 downto 0);
 reg_4 : in std_logic_vector(15 downto 0);
 reg_5 : in std_logic_vector(15 downto 0);
 reg_6 : in std_logic_vector(15 downto 0);
 reg_7 : in std_logic_vector(15 downto 0);
 N_reg_out : out std_logic_vector(2 downto 0);
 reg_out : out std_logic_vector(15 downto 0)
);
end component;

--ram_dc
component ram_dc
port(
 clk_DC : in std_logic;
 ram_AD_in : in std_logic_vector(7 downto 0);
 ram_0 : in std_logic_vector(15 downto 0);
 ram_1 : in std_logic_vector(15 downto 0);
 ram_2 : in std_logic_vector(15 downto 0);
 ram_3 : in std_logic_vector(15 downto 0);
 ram_4 : in std_logic_vector(15 downto 0);
 ram_5 : in std_logic_vector(15 downto 0);
 ram_6 : in std_logic_vector(15 downto 0);
 ram_7 : in std_logic_vector(15 downto 0);
 IO65_IN : in std_logic_vector(15 downto 0);
 ram_AD_out : in std_logic_vector(15 downto 0);
 ram_out : in std_logic_vector(15 downto 0)
);
end component;

--exec 
component exec
port(
 clk_EX : in std_logic;
 reset_n : in std_logic;
 op_code : in std_logic_vector(3 downto 0);
 reg_a : in std_logic_vector(15 downto 0);
 reg_b : in std_logic_vector(15 downto 0);
 op_data : out std_logic_vector(7 downto 0);
 ram_out : in std_logic_vector(15 downto 0);
 P_count : out std_logic_vector(7 downto 0);
 reg_in : out std_logic_vector(15 downto 0);
 ram_in : out std_logic_vector(15 downto 0);
 reg_wen : out std_logic;
 rag_wen : out std_logic 
);
end component;

--reg_wb
component reg_wb
port(
 clk_WB : in std_logic;
 reset_n : in std_logic;
 n_reg : in std_logic_vector(2 downto 0);
 reg_in : in std_logic_vector(15 downto 0);
 reg_wen : in std_logic;
 reg_0 : out std_logic_vector(15 downto 0);
 reg_1 : out std_logic_vector(15 downto 0);
 reg_2 : out std_logic_vector(15 downto 0);
 reg_3 : out std_logic_vector(15 downto 0);
 reg_4 : out std_logic_vector(15 downto 0);
 reg_5 : out std_logic_vector(15 downto 0);
 reg_6 : out std_logic_vector(15 downto 0);
 reg_7 : out std_logic_vector(15 downto 0) 
);

--ram_wb
component ram_wb
port(
 clk_WB : in std_logic;
 ram_addr : in std_logic_vector(7 downto 0);
 ram_in : in std_logic_vector(15 downto 0);
 ram_wen : in std_logic;
 ram_0 : out std_logic_vector(15 downto 0);
 ram_1 : out std_logic_vector(15 downto 0);
 ram_2 : out std_logic_vector(15 downto 0);
 ram_3 : out std_logic_vector(15 downto 0);
 ram_4 : out std_logic_vector(15 downto 0);
 ram_5 : out std_logic_vector(15 downto 0);
 ram_6 : out std_logic_vector(15 downto 0);
 ram_7 : out std_logic_vector(15 downto 0);
 IO64_out : out std_logic_vector(15 downto 0)
);
end component;

--internal signal
signal clk_FT : std_logic;
signal clk_DC : std_logic;
signal clk_EX : std_logic;
signal clk_WB : std_logic;
signal P_count : std_logic_vector(7 downto 0);
signal Prom_count : std_logic_vector(14 downto 0);
signal op_code : std_logic_vector(3 downto 0);
signal op_data : std_logic_vector(7 downto 0);
signal n_reg_a : std_logic_vector(2 downto 0);
signal n_reg_b : std_logic_vector(2 downto 0);
signal reg_in : std_logic_vector(15 downto 0);
signal reg_a : std_logic_vector(15 downto 0);
signal reg_b : std_logic_vector(15 downto 0);
signal reg_wen : std_logic;
signal reg_0 : std_logic_vector(15 downto 0);
signal reg_1 : std_logic_vector(15 downto 0);
signal reg_2 : std_logic_vector(15 downto 0);
signal reg_3 : std_logic_vector(15 downto 0);
signal reg_4 : std_logic_vector(15 downto 0);
signal reg_5 : std_logic_vector(15 downto 0);
signal reg_6 : std_logic_vector(15 downto 0);
signal reg_7 : std_logic_vector(15 downto 0);
signal ram_addr : std_logic_vector(7 downto 0);
signal ram_in : std_logic_vector(15 downto 0);
signal ram_out : std_logic_vector(15 downto 0);
signal ram_wen : std_logic;
signal ram_0 : std_logic_vector(15 downto 0);
signal ram_1 : std_logic_vector(15 downto 0);
signal ram_2 : std_logic_vector(15 downto 0);
signal ram_3 : std_logic_vector(15 downto 0);
signal ram_4 : std_logic_vector(15 downto 0);
signal ram_5 : std_logic_vector(15 downto 0);
signal ram_6 : std_logic_vector(15 downto 0);
signal ram_7 : std_logic_vector(15 downto 0);


begin
  
  c1 : clk_gen port map(clk => clk, clk_FT => clk_FT, clk_DC => clk_DC, clk_EX => clk_EX, clk_WB => clk_WB);

  c2 : fetch port map(clk_FT => clk_FT, P_count => P_count, Prom_out => Prom_out);
  
  c3 : decode port map(clk_DC => clk_DC, Prom_out => Prom_out, op_code => op_code, op_data => op_data);
  
  c4 : reg_dc port map(clk_DC => clk_DC, n_reg_in => Prom_out(10 downto 8), 
							  reg_0 => reg_0, reg_1 => reg_1, reg_2 => reg_2, reg_3 => reg_3, reg_4 => reg_4,
                       reg_5 => reg_5, reg_6 => reg_6, reg_7 => reg_7, n_reg_out => n_reg_a, reg_out => reg_a);
							  
  c5 : reg_dc port map(clk_DC => clk_DC, n_reg_in => Prom_out(7 downto 5), 
							  reg_0 => reg_0, reg_1 => reg_1, reg_2 => reg_2, reg_3 => reg_3, reg_4 => reg_4,
                       reg_5 => reg_5, reg_6 => reg_6, reg_7 => reg_7, n_reg_out => n_reg_b, reg_out => reg_b);	
  
  c6 : ram_dc port map(clk_DC => clk_DC, ram_AD_in => prom_out(7 downto 0), 
                       ram0 => ram0, ram1 => ram1, ram2 => ram2, ram3 => ram3, ram4 => ram4, 
							  ram5 => ram5, ram6 => ram6, ram7 => ram7, IO65_IN => IO65_IN, ram_AD_out => ram_addr, ram_out => ramout);		

  c7 : exec port map(clk_EX => clk_EX, reset_n => reset_n, op_code => op_code,
							  reg_a => reg_a, reg_b => reg_b, op_data => op_data, ram_out => ram_out, p_count => p_count,
							  reg_in => reg_in, ram_in => ram_in, reg_wen => reg_wen, ram_wen => ram_wen);  
  
  c8 : reg_wb port map(clk_WB => clk_WB, reset_n => reset_n, n_reg => n_reg, reg_in => reg_in, reg_wen => reg_wen,
                       reg_0 => reg_0, reg_1 => reg_1, reg_2 => reg_2, reg_3 => reg_3, reg_4 => reg_4,
                       reg_5 => reg_5, reg_6 => reg_6, reg_7 => reg_7);	
							  
  c9 : ram_wb port map(clk_WB => clk_WB, ram_addr => ram_addr, ram_in => ram_in, ram_wen => ram_wen,
                       ram0 => ram0, ram1 => ram1, ram2 => ram2, ram3 => ram3, ram4 => ram4, 
							  ram5 => ram5, ram6 => ram6, ram7 => ram7, IO64_out => IO64_out);
							  
end rtl;