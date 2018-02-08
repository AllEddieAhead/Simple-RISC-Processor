-------------------------------------------------------------------------------
--
-- Title       : IF_ID_Reg
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description :  The IF/ID register. The 16-bit instruction is retreived from the instruction register
-- (which is loaded from the testbench) and stored here until the next clock cycle.
-- Nothing else happens in this stage.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity IF_ID_Reg is
	 port(
		 clk : in STD_LOGIC;
		 instr_in : in STD_LOGIC_VECTOR(15 downto 0);
		 instr_out : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end IF_ID_Reg;


architecture IF_ID_Reg of IF_ID_Reg is
	signal temp : std_logic_vector(15 downto 0);
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			instr_out<=instr_in;
		end if;
	end process;
end IF_ID_Reg;
