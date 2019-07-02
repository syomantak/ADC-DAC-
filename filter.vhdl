library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Gates.all;

entity filter is
   port (clk,rst,intl: in std_logic;
         cs,wr,rd: out std_logic;
         data : in std_logic_vector(7 downto 0);
			--led_data: out std_logic_vector(7 downto 0);
			out_data: out std_logic_vector(7 downto 0));
			end entity;


architecture Behave of filter is

	Component ctd_1m is 
			port(clk,reset : in std_logic;
				Done : out std_logic);
	end Component;
	
	component rs is
	port (X: in std_logic_vector(10 downto 0);
		  Z: out std_logic_vector(7 downto 0));
	end component rs;

	signal strobe: std_logic;
	signal state: std_logic_vector(2 downto 0);
	signal count: std_logic_vector(3 downto 0);
	signal in_reg: std_logic_vector(7 downto 0);
	signal cs_buff: std_logic;
	signal rd_buff: std_logic;
	signal wr_buff: std_logic;
	
	
	signal x1: std_logic_vector(10 downto 0);
	signal x2: std_logic_vector(10 downto 0);
	signal x3: std_logic_vector(10 downto 0);
	signal x4: std_logic_vector(10 downto 0);
	signal x5: std_logic_vector(10 downto 0);
	signal x6: std_logic_vector(10 downto 0);
	signal x7: std_logic_vector(10 downto 0);
	signal x8: std_logic_vector(10 downto 0);
		
	
	signal tot: std_logic_vector(10 downto 0);
	


begin

	str : ctd_1m port map(clk,rst,strobe);
	
	sh: rs
		port map (X => tot, Z => out_data);

	
  process(clk, strobe,intl,state,count,rst,x1,x2,x3,x4,x5,x6,x7,x8,data)
    variable ncs: std_logic;
	 variable nrd: std_logic;
    variable nwr: std_logic;
	 variable ncount: std_logic_vector(3 downto 0);
	 variable nstate: std_logic_vector(2 downto 0);
	 
	 variable ntot: std_logic_vector(10 downto 0);
	 
	 variable nx1: std_logic_vector(10 downto 0);
	 variable nx2: std_logic_vector(10 downto 0);
	 variable nx3: std_logic_vector(10 downto 0);
	 variable nx4: std_logic_vector(10 downto 0);
	 variable nx5: std_logic_vector(10 downto 0);
	 variable nx6: std_logic_vector(10 downto 0);
	 variable nx7: std_logic_vector(10 downto 0);
	 variable nx8: std_logic_vector(10 downto 0);

    
  begin
  
    -- default values.
    ncs := cs_buff;
	 nwr := wr_buff;
	 nrd := rd_buff;
    nstate := state;
	 ncount := count;
	 
	 nx1 := x1;
	 nx2 := x2;
	 nx3 := x3;
	 nx4 := x4;
	 nx5 := x5;
	 nx6 := x6;
	 nx7 := x7;
	 nx8 := x8;
	 
	 --led_data <= out_data;
	 
	 ntot := tot;
	 
    -- delta, mu, lambda functions.
    case state is
       when "111" => 
				if(strobe = '0') then 
					ncs := '0';
					nstate := "011";
					
				end if;
				
				ntot := std_logic_vector(unsigned(x1)+unsigned(x2)+unsigned(x3)+unsigned(x4)+unsigned(x5)+unsigned(x6)+unsigned(x7)+unsigned(x8));
				
       when "011" => 
				nwr := '0';
				nstate := "001"; 
				ncount := "0000";
       when "001" => 
				if(unsigned(count)=5) then
					nstate := "000";
					ncount := "0000";
					nwr := '1';
				else
					ncount := std_logic_vector(unsigned(count)+1); 
				end if;
		
		when "000" =>
				if(unsigned(count)<10) then
					ncount := std_logic_vector(unsigned(count)+1);
				else 
					if(intl='0') then
						nstate := "010";
						nrd := '0';
						ncount := "0000";
					end if;
				end if;
		
		when "010" =>
				if(unsigned(count)<7) then
					ncount := std_logic_vector(unsigned(count)+1);
				else
					nstate := "110";
					nrd := '1';
					ncount := "0000";
				end if;
				
	   when "110" =>
				nstate := "111";
				ncs := '1';
				
				nx1(7 downto 0) := data;
					
				nx2 := x1;
				nx3 := x2;	
				nx4 := x3;
				nx5 := x4;					
				nx6 := x5;
				nx7 := x6;
				nx8 := x7;
				
		 when others => null;   
    end case;
	 
	 

    -- update state, registers.
    if(clk'event and clk='1') then
        if(rst = '1') then
           state <= "111";
			  cs <= '1';
			  rd <= '1';
			  wr <= '1';
			  cs_buff <= '1';
			  rd_buff <= '1';
			  wr_buff <= '1';
			  
			  x1 <= "00000000000";
			  x2 <= "00000000000";
			  x3 <= "00000000000";
			  x4 <= "00000000000";
			  x5 <= "00000000000";
			  x6 <= "00000000000";
			  x7 <= "00000000000";
			  x8 <= "00000000000";
			  
			  tot <= "00000000000";
			  
        else
           state <= nstate;       
			  count <= ncount;
			  cs <= ncs;
			  rd <= nrd;
			  wr <= nwr;
			  cs_buff <= ncs;
			  rd_buff <= nrd;
			  wr_buff <= nwr;
			  
			  x1 <= nx1;
			  x2 <= nx2;
			  x3 <= nx3;
			  x4 <= nx4;
			  x5 <= nx5;
			  x6 <= nx6;
			  x7 <= nx7;
			  x8 <= nx8;
			  
			  tot <= ntot;
			  
        end if;
    end if;
  end process;

end Behave;
