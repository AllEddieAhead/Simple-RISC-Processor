-------------------------------------------------------------------------------
--
-- Title       : ID_EXMEM_Reg
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : The ID/EXE&MEM register. Holds the values fetched by the IF stage
-- for execution in the next stage.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ID_EXMEM_Reg is
	port(
		 clk : in std_logic;
		 opcode : in STD_LOGIC_VECTOR(3 downto 0);
		 A : in STD_LOGIC_VECTOR(63 downto 0);
		 B : in STD_LOGIC_VECTOR(63 downto 0);
		 rd : in STD_LOGIC_VECTOR(3 downto 0);
		 immediate : in STD_LOGIC_VECTOR(7 downto 0);
		 
		 opcode_out : out STD_LOGIC_VECTOR(3 downto 0);
		 A_out : out STD_LOGIC_VECTOR(63 downto 0);
		 B_out : out STD_LOGIC_VECTOR(63 downto 0);
		 rd_out : out STD_LOGIC_VECTOR(3 downto 0);
		 immediate_out : out STD_LOGIC_VECTOR(7 downto 0)
	     );
end ID_EXMEM_Reg;


architecture ID_EXMEM_Reg of ID_EXMEM_Reg is
begin

	process(clk)
	begin
		--Just store and pass along values. Nothing special here.
		if (rising_edge(clk)) then
			opcode_out<=opcode;
			A_out<=A;
			B_out<=B;
			rd_out<=rd;
			immediate_out<=immediate;
			
		end if;
	end process;


end ID_EXMEM_Reg;
