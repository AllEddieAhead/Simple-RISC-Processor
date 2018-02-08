-------------------------------------------------------------------------------
--
-- Title       : CLAMMX_Top
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : Top level of the 64-bit CLA design, with MMX functionality.
-- Here, we select B or (not B), as well as the sum for saturation operation functionality.
-- This module covers the 
--
-- The CLA inputs are selected here for either 16 or 8 bit operations, depending on the MUX
-- module operating off the opcode. The MUX controls whether or not carry-in/sum outputs are used.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CLAMMX_Top is
	 port(
		 A : in STD_LOGIC_VECTOR(63 downto 0);
		 B : in STD_LOGIC_VECTOR(63 downto 0);
		 opcode : in STD_LOGIC_VECTOR(3 downto 0);
		 sum : out STD_LOGIC_VECTOR(63 downto 0);
		 en : out std_logic
	     );
end CLAMMX_Top;



architecture CLAMMX_Top of CLAMMX_Top is
	signal cout : std_logic;
	signal c_collect : std_logic_vector(3 downto 0);
	signal temp_sum, temp_B, sat_sum : std_logic_vector(63 downto 0);--Temp values for B and Sum, as well as the signal for sat_sum
	signal sum_select : std_logic_vector(1 downto 0);
	signal ones : std_logic_vector(63 downto 0) := (others => '1');
	signal zeros : std_logic_vector(63 downto 0) := (others => '0');
	--The select is generated from the opcode, as well as the cout. When there is overflow on ADD, cout=1, and the op(0) is 0.
	--In our design, 00 and 01 are normal, non-overflow SAT operations.
	--10 is add, being: (op(0) xor cout) & op(0). Addition overflow causes all 1's, sub overflow causes all 0's.
	
begin
	-- Select whether we are doing addition or two's complement subtraction
	temp_B<=B when opcode(0)='0' else
		not B;

	--Instantiate modules
	CLA: entity cla64_level3 port map(A=>A, B=>temp_B, cout=>cout,c_collect=>c_collect,sum=>temp_sum, opcode=>opcode, cin=>opcode(0));
	MUX2:entity mux_large_input port map(a=>temp_sum, b=>sat_sum, sel=>opcode(2), c=>sum);--Selects for normal OP sum or SAT OP sum using op(2)
	
	--Here, we set the value if the saturation command is used. The operation is done regardless if the saturation command is selected.
	--If cout is different than the opcode(0) for sat_add or sat_sub, then this shows that the sum register has over/underflowed.
	--Thus, we set the sum to either be all 1's or all 0's.
	sat_sum<=temp_sum when (opcode(2)='0') else
	ones when ((opcode(0)xor cout)='1')else
	zeros when((opcode(0)xor cout)='0');
		
	--The entities are connected together, and all thats left for this stage to calculate by itself is what sum is selected by the MUX, either
	--the SAT OP sum, or the normal OP sums.
	sum_select<=opcode(2) & (opcode(0) xor cout);
	en<='1' when (opcode = "1000") or (opcode = "1001") or (opcode = "1010") or (opcode = "1011") or (opcode = "1100") or (opcode = "1101") else
		'0';
	

end CLAMMX_Top;
