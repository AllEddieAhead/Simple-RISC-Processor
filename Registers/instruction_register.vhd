-------------------------------------------------------------------------------
--
-- Title       : instruction_register
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : The instruction register, containing 16 instructions loaded from a testbench.
-- The PC is output for testbench purposes, and is kept track of internally by a signal.
-- There is write-back protection in case stage 3 finishes an operation which stage 2 needs the result of,
-- implemented in the WB stage.
--
-- The 16 registers are each 16 bits long, containing the 4 bit opcode, and either three 4-bit register designations
-- for registers or two 4-bit and a 4-bit immediate value.
-- 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity instruction_register is
	port(
		 clk: in std_logic;
		 i1 : in STD_LOGIC_VECTOR(15 downto 0);
		 i2 : in STD_LOGIC_VECTOR(15 downto 0);
		 i3 : in STD_LOGIC_VECTOR(15 downto 0);
		 i4 : in STD_LOGIC_VECTOR(15 downto 0);
		 i5 : in STD_LOGIC_VECTOR(15 downto 0);
		 i6 : in STD_LOGIC_VECTOR(15 downto 0);
		 i7 : in STD_LOGIC_VECTOR(15 downto 0);
		 i8 : in STD_LOGIC_VECTOR(15 downto 0);
		 i9 : in STD_LOGIC_VECTOR(15 downto 0);
		 i10 : in STD_LOGIC_VECTOR(15 downto 0);
		 i11 : in STD_LOGIC_VECTOR(15 downto 0);
		 i12 : in STD_LOGIC_VECTOR(15 downto 0);
		 i13 : in STD_LOGIC_VECTOR(15 downto 0);
		 i14 : in STD_LOGIC_VECTOR(15 downto 0);
		 i15 : in STD_LOGIC_VECTOR(15 downto 0);
		 i16 : in STD_LOGIC_VECTOR(15 downto 0);
		 pc_out : out integer;
		 instr_out : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end instruction_register;


architecture instruction_register of instruction_register is
	signal pc : integer := 0;
	--Here, I create an array for the instructions to be loaded into, so they can be easily loaded
	type table_type is array(0 to 15) of std_logic_vector(15 downto 0);
	signal outputs : table_type := (i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16);
	begin
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (pc=16) then
				instr_out<=(others=>'0');--NOP operations if there are no more instructions
			else
				pc_out<=pc;--Output the PC to the testbench
				pc<=pc+1;--Increment the PC
				instr_out<=outputs(pc);--Load the next instruction
			end if;
		end if;	
	 end process;
end instruction_register;
