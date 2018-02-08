-------------------------------------------------------------------------------
--
-- Title       : full_adder_block
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : Basic Full Adder block, a building block for higher level modules.
-- The sum is calculated for any particular block, with the carry in value either
-- coming from the CLU or a multiplexor, depending on the position of the adder in the larger module.
-- 
-- This FA also generates propagate and generate values to be used in a CLA adder design.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity full_adder_block is
	 port(
		 a : in STD_LOGIC;
		 b : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 sum : out STD_LOGIC;
		 p : out STD_LOGIC;
		 g : out STD_LOGIC
	     );
end full_adder_block;



architecture full_adder_block of full_adder_block is
begin

	sum<=a xor b xor cin;
	p<=a or b;
	g<=a and b;
	

end full_adder_block;
