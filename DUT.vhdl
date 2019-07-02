-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  Full-adder.

library ieee;
use ieee.std_logic_1164.all;
entity DUT is
   port(input_vector: in std_logic_vector(10 downto 0);
       	output_vector: out std_logic_vector(8 downto 0));
end entity;

architecture DutWrap of DUT is
   component Mul_FSM is
     port(A,B: in std_logic_vector(3 downto 0);
				CLK,Start,RST:in std_logic;
         	Done:out std_logic;
			P: out std_logic_vector(7 downto 0));
   end component;
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: Mul_FSM 
			port map (
					-- order of inputs Cin B A
					CLK   => input_vector(10),
					RST => input_vector(9),
					Start => input_vector(8),
					
					A   => input_vector(7 downto 4),
					B => input_vector( 3 downto 0),
                                        -- order of outputs S Cout
					Done => output_vector(8),
					P => output_vector(7 downto 0));

end DutWrap;
	
