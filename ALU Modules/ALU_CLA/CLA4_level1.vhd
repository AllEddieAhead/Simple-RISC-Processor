-------------------------------------------------------------------------------
--
-- Title       : CLA4_level1
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : First level implementation of the 64-bit CLA, to be instantiated
-- 4 times for the second level 16CLA.
--
-- This level1 CLA gets inputs from four full-adders and cin, and outputs the propagate,
-- generate, sum, and cout to be used as inputs for the next level up.
-- 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CLA4_level1 is
	 port(
		 cin : in STD_LOGIC;
		 A : in STD_LOGIC_VECTOR(3 downto 0);
		 B : in STD_LOGIC_VECTOR(3 downto 0);
		 pg : out STD_LOGIC;
		 gg : out STD_LOGIC;
		 sum : out STD_LOGIC_VECTOR(3 downto 0);
		 cout : out STD_LOGIC
	     );
end CLA4_level1;

architecture CLA4_level1 of CLA4_level1 is
	signal p1,p2,p3,p4,g1,g2,g3,g4,c1,c2,c3: std_logic;
begin

	fa0: entity full_adder_block port map( a=>A(0), b=>B(0), p=>p1, g=>g1, sum=>sum(0), cin=>cin);
	fa1: entity full_adder_block port map( a=>A(1), b=>B(1), p=>p2, g=>g2, sum=>sum(1), cin=>c1);
	fa2: entity full_adder_block port map( a=>A(2), b=>B(2), p=>p3, g=>g3, sum=>sum(2), cin=>c2);
	fa3: entity full_adder_block port map( a=>A(3), b=>B(3), p=>p4, g=>g4, sum=>sum(3), cin=>c3);
		
	CLU: entity carry_look_unit  port map( p1,p2,p3,p4,g1,g2,g3,g4,cin,pg,gg,c1,c2,c3,cout);
	
end CLA4_level1;
