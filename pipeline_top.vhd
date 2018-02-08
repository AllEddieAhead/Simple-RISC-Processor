-------------------------------------------------------------------------------
--
-- Title       : pipeline_top
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : The top-level module for the 3-stage pipelined RISC processor.
-- This module connects all the pieces of the processor together, and contains code
-- to report the status of each stages information.
-- 
-- All components are implemented in an hierarchal fashion.
-- Stage Progression:
-- Instruction Register => IF/ID => Register File => ID/EXMEM => ALU
--	
-- Input instructions are loaded from the testbench
--
-- All instructions in their opcode order are shown here:
-- NOP : 0000 (No operation)
-- LV  : 0001 (Load value from immediate in instruction)
-- AND : 0010 (AND operation)
-- OR  : 0011 (OR operation)
-- CNTH: 0100 (Count '1's in words)
-- CLZ : 0101 (Count leading zeros)
-- ROT : 0110 (Rotate quadword's bits right)
-- SHLHI:0111 (Shift left words by immediate amount)
-- A   : 1000 (Add doubleword)
-- SFW : 1001 (Subtract doubleword)
-- AH  : 1010 (Add word)
-- SFH : 1011 (Subtract word)
-- AHS : 1100 (Add saturated word)
-- SFHS: 1101 (Subtract saturated word)
-- MPYU: 1110 (Multiply lower doublewords)
-- ADSBD:1111 (Absolute value of bytes)
--
-- Example Instruction:
-- 1001 0001 0010 0011 : Subtract register 2 from register 1 and place the result in register 3.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pipeline_top is
	port(
	clk : in std_logic;
	i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16 : in std_logic_vector(15 downto 0)
	);
end pipeline_top;


architecture pipeline_top of pipeline_top is

signal pc : integer; signal instr : std_logic_vector(15 downto 0);--Stage 1 Testbench Info
signal opcode, rd : std_logic_vector(3 downto 0); signal data1,data2 : std_logic_vector(63 downto 0); signal immediate : std_logic_vector(7 downto 0);--Stage 2 Testbench info
signal write_en : std_logic; signal write_data : std_logic_vector(63 downto 0); signal write_reg : std_logic_vector(3 downto 0);--Stage 3 Testbench Info

--Signals Necessary for connecting components
	signal IFIDinstr_out : std_logic_vector(15 downto 0);--Output of IF/ID register
	signal opcode_out :  STD_LOGIC_VECTOR(3 downto 0);--Outputs of ID/EX register
	signal	   A_out :  STD_LOGIC_VECTOR(63 downto 0);
	signal	   B_out :  STD_LOGIC_VECTOR(63 downto 0);
	signal	   rd_out :  STD_LOGIC_VECTOR(3 downto 0);
	signal	   immediate_out : STD_LOGIC_VECTOR(7 downto 0);
begin
	--Instantiate all top-level components
	instr_reg: entity instruction_register port map(clk,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,pc,instr);
	IFID: entity IF_ID_Reg port map(clk,instr,IFIDinstr_out);
	reg_file: entity register_file port map(write_en,IFIDinstr_out,write_reg,write_data,opcode,data1,data2,immediate,rd);
	IDEX: entity ID_EXMEM_Reg port map(clk,opcode,data1,data2,rd,immediate,opcode_out,A_out,B_out,rd_out,immediate_out);
	ALU: entity ALU_Top port map(opcode_out,A_out,B_out,rd_out,immediate_out,write_data,write_en,write_reg);
		
	process(clk)
	--This code is only used for testing/debugging purposes
	begin
		if (rising_edge(clk)) then
			report "PC is "&to_string(PC)&". "
			&"IF/ID instruction is "&to_string(instr)&". "
			&LF& "ID/EX has the following: Op: "&to_string(opcode)&"."
			&LF& "Data1, Data2: "&to_string(data1)&","&to_string(data2)&"." 
			&LF& "Rd, immediate: "&to_string(rd)&", "& to_string(immediate)&"."
			&LF&"ALU Output is as follows: Write_enable, rd: "&to_string(write_en)&","&to_string(write_reg)&"." 
			&LF&"Write_Data: "&to_string(write_data)&".";
			
		end if;
	end process;
	


end pipeline_top;
