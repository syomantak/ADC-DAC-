library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac is
   port (clk,rst,intl: in std_logic;
         cs,wr,rd: out std_logic;
         data : in std_logic_vector(7 downto 0);
			out_data: out std_logic_vector(7 downto 0));
			end entity;


architecture Behave of dac is

	Component ctd_1m is 
			port(clk,reset : in std_logic;
				Done : out std_logic);
	end Component;

	signal strobe: std_logic;
	signal state: std_logic_vector(2 downto 0);
	signal count: std_logic_vector(3 downto 0);
	signal in_reg: std_logic_vector(7 downto 0);
	signal cs_buff: std_logic;
	signal rd_buff: std_logic;
	signal wr_buff: std_logic;
	

begin

	str : ctd_1m port map(clk,rst,strobe);
	
  process(clk, strobe,intl,state,count,rst,data)
    variable ncs: std_logic;
	 variable nrd: std_logic;
    variable nwr: std_logic;
	 variable ncount: std_logic_vector(3 downto 0);
	 variable nstate: std_logic_vector(2 downto 0);

    
  begin
    -- default values.
    ncs := cs_buff;
	 nwr := wr_buff;
	 nrd := rd_buff;
    nstate := state;
	 ncount := count;

    -- delta, mu, lambda functions.
    case state is
       when "111" => 
				if(strobe = '0') then 
					ncs := '0';
					nstate := "011";
					out_data <= in_reg;
				end if;
				
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
				in_reg <= data;
					
					
					
				
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
			  
        else
           state <= nstate;       
			  count <= ncount;
			  cs <= ncs;
			  rd <= nrd;
			  wr <= nwr;
			  cs_buff <= ncs;
			  rd_buff <= nrd;
			  wr_buff <= nwr;
			  
        end if;
    end if;
  end process;

end Behave;
