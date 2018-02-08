-------------------------------------------------------------------------------
--
-- Title       : ALU_special
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : This ALU file covers the LV and NOP instructions.
-- The LV loads the immediate value wired directly in from the instruction,
-- whereas the NOP instruction just outputs all 0's, for the next stage to do nothing with.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU_special is
	 port(
		 immediate : in STD_LOGIC_VECTOR(7 downto 0);
		 opcode : in STD_LOGIC_VECTOR(3 downto 0); 
		 en : out std_logic;
		 result : out STD_LOGIC_VECTOR(63 downto 0)
	     );
end ALU_special;


architecture ALU_special of ALU_special is
begin
	process(opcode,immediate)
	begin
		en<='1';
		------------------------------------------------------------------
		--LV
		--The operation of LV is just to load the immediate value into the rd
		if opcode="0001" then
			result(63 downto 56)<=immediate;
			result(55 downto 48)<=immediate;
			result(47 downto 40)<=immediate;
			result(39 downto 32)<=immediate;
			result(31 downto 24)<=immediate;
			result(23 downto 16)<=immediate;
			result(15 downto 8)<=immediate;
			result(7 downto 0)<=immediate;
		------------------------------------------------------------------
		--NOP
		--Pass on a '0', the next stage will know to do nothing
		elsif opcode="0000" then
			en<='0';
			result<=(others=>'0');

		else
			en<='0';
		end if;
	end process;


end ALU_special;
