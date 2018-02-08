-------------------------------------------------------------------------------
--
-- Title       : pipeline_testbench
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description :  Testbench for the pipeline processor.
-- Each instruction to be loaded in is described in detail. The testbench is kept simple
-- and easily editable for quick instruction verification.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pipeline_testbench is
end pipeline_testbench;


architecture pipeline_testbench of pipeline_testbench is
signal clk : std_logic :='0';

signal i1 : std_logic_vector(15 downto 0) := "0001000011110000";--LV 0F,r0
signal i2 : std_logic_vector(15 downto 0) := "0001000011000001";--LV 0C,r1
signal i3 : std_logic_vector(15 downto 0) := "0101000000011101";--AND : Result=0C,r2
signal i4 : std_logic_vector(15 downto 0) := "0011000000010010";--OR : Result=0F,r2

signal i5 : std_logic_vector(15 downto 0) := "0001000000100000";--LV: 02, r0
signal i6 : std_logic_vector(15 downto 0) := "0110001000000011";--ROT: Rotate r2 by r0(5:0)(Rotate right 0F), result (0xA2) in r3
signal i7 : std_logic_vector(15 downto 0) := "0001000000010000";--LV, 0F, r0
signal i8 : std_logic_vector(15 downto 0) := "0111000000000101";--SHLI. Shift r0, by r0. Result should be (0x02)

signal i9 : std_logic_vector(15 downto 0) := "1110000000000110";--MPYU, r0 by r0 to r6 (0202 x 0202)=????
signal i10 : std_logic_vector(15 downto 0) := "1111000000000000";--ABSDB, r0 by r0 to r0, should turn out to be 0x00
signal i11 : std_logic_vector(15 downto 0) := "0001000000100111";--LV, load 02 to r7
signal i12 : std_logic_vector(15 downto 0) := "0001000000011000";--LV, load 01 to r8

signal i13 : std_logic_vector(15 downto 0) := "1001100001111001";--SUB, r7-r8 = 0x01 in r9
signal i14 : std_logic_vector(15 downto 0) := "1101011110001010";--SUBHALFSAT, r8-r7 = All 0's in r10
signal i15 : std_logic_vector(15 downto 0) := "0001100000001011";--LV, 0x80 in r11.
signal i16 : std_logic_vector(15 downto 0) := "1100101110111100";--AHS,r11 +r11 = FF in r12
--CLZ r11, store in r12
-- 

constant period : time := 2 ns;									 

begin
	pipeline: entity pipeline_top port map(clk, i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16);
	
	process
	begin
		clk<='0';
		wait for period/2;
		clk<='1';
		wait for period/2;
	end process;

end pipeline_testbench;
