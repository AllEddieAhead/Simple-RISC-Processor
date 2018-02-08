-------------------------------------------------------------------------------
--
-- Title       : ALU_Top
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : The top-level ALU module, combining the structural CLA module, the behavioral module, and the special module.
-- All values are passed into the ALU for completion of the selected operation, and results are output to the next stage.
-- Either the operation is performed in the CLA 64-bit adder, or they are executed in a behavioral style.
--
-- The 'opcode' determines the operation that is performed, registers 'A' and 'B' are the operating registers, and
-- 'rd' marks the destination register. The 'immediate' contains the potential immediate value, and the 'write' fields
-- mark the result of the operation (if there is one)
--
-- All instructions (in their opcode order from 0000 to 1111) and their method of implementation are shown here:
-- NOP: ALU Behavioral
-- LV : ALU Special
-- AND,OR,CNTH,CLZ,ROT,SHLHI: ALU Behavioral
-- A,SFW,AH,SFH,AHS,SFHS : ALU CLA
-- MPYU,ADSBD: ALU Behavioral
--	
-- When the desired operation is performed, the correct output is selected from the modules,
-- and is sent along with rd to the register file.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU_Top is
	 port(
		 opcode : in STD_LOGIC_VECTOR(3 downto 0);
		 A : in STD_LOGIC_VECTOR(63 downto 0);
		 B : in STD_LOGIC_VECTOR(63 downto 0);
		 rd : in STD_LOGIC_VECTOR(3 downto 0);
		 immediate : in STD_LOGIC_VECTOR(7 downto 0);
		 write_data : out STD_LOGIC_VECTOR(63 downto 0);
		 write_en : out STD_LOGIC;
		 write_reg : out STD_LOGIC_VECTOR(3 downto 0)
	     );
end ALU_Top;


architecture ALU_Top of ALU_Top is
	signal sel1,sel2,sel3 : std_logic;
	signal data1,data2,data3: std_logic_vector(63 downto 0);
begin
	--Instantiate the three ALU modules
	ALU1: entity ALU_special port map(immediate,opcode,sel1,data1);
	ALU2: entity ALU_behavioral port map(opcode,A,B,data2,sel2);
	ALU3: entity CLAMMX_Top port map(A,B,opcode,data3,sel3);
	
	--Select which destination the output data will be selected from, then output
	--the destination register and whether or not write is enabled	
	write_data<=data1 when sel1='1' else
				data2 when sel2='1' else
				data3 when sel3='1' else
				(others=>'0');
	write_reg<=rd;
	write_en<='1' when sel1='1' else
				'1' when sel2='1' else
				'1' when sel3='1' else
				'0';

end ALU_Top;
