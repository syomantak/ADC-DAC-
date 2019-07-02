library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity rs  is
  port (X: in std_logic_vector(10 downto 0);
		  Z: out std_logic_vector(7 downto 0));
end entity rs;

architecture str of rs is
begin

	
	Z(7 downto 0) <= X(10 downto 3);
	
end str;
