-------------------------------------------------------------------------------
--
-- Title       : register_file
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : The register file, containing 16x64-bit registers.
-- Given an instruction, it selects the appropriate register data, and passes along the decoded opcode, data,
-- and destination register.
-- It also receives data from the ALU, writing to Rd when the write_en signal is high.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity register_file is
	 port(
		 write_en : in STD_LOGIC;
		 instr_in : in STD_LOGIC_VECTOR(15 downto 0);
		 write_reg : in STD_LOGIC_VECTOR(3 downto 0);
		 write_data : in STD_LOGIC_VECTOR(63 downto 0);
		 opcode : out STD_LOGIC_VECTOR(3 downto 0);
		 A : out STD_LOGIC_VECTOR(63 downto 0);
		 B : out STD_LOGIC_VECTOR(63 downto 0);
		 immediate: out std_logic_vector(11 downto 4);
		 rd : out STD_LOGIC_VECTOR(3 downto 0)
	     );
end register_file;

architecture register_file of register_file is
	signal r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15 : std_logic_vector(63 downto 0) :=(others=>'0');
	type table_type is array(0 to 15) of std_logic_vector(63 downto 0);
	signal outputs : table_type := (r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15);
	
begin
opcode<=instr_in(15 downto 12);
A<=write_data when (instr_in(7 downto 4)=write_reg) else
  	outputs(to_integer(unsigned(instr_in(7 downto 4))));
B<=write_data when (instr_in(7 downto 4)=write_reg) else
  	outputs(to_integer(unsigned(instr_in(11 downto 8))));
immediate<=instr_in(11 downto 4);--For the LV instruction, special case
--Rd, for all operations
rd<=instr_in(3 downto 0);
outputs(to_integer(unsigned(write_reg)))<=write_data when (write_en='1');
		
end register_file;
