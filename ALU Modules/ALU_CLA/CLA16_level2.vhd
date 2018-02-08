-------------------------------------------------------------------------------
--
-- Title       : cla16_level2
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : Second level of 64CLA, incorporating 4x4CLA and 16 bit ranges
-- to generate the inputs for a 64CLA.
--
-- This level accepts the propagate, generate, cin, and sum values from the first level
-- and outputs its own pg, gg, cout, and sum.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cla16_level2 is
	 port(
		 cin : in STD_LOGIC;
		 A : in STD_LOGIC_VECTOR(15 downto 0);
		 B : in STD_LOGIC_VECTOR(15 downto 0);
		 pg : out STD_LOGIC;
		 gg : out STD_LOGIC;
		 cout : out STD_LOGIC;
		 sum : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end cla16_level2;


architecture cla16_level2 of cla16_level2 is
	signal p1,p2,p3,p4,g1,g2,g3,g4,c1,c2,c3 : std_logic;
begin

	CLU1: entity cla4_level1 port map(A=>A(3 downto 0), B=>B(3 downto 0), cin=>cin, pg=>p1,gg=>g1,sum=>sum(3 downto 0));
	CLU2: entity cla4_level1 port map(A=>A(7 downto 4), B=>B(7 downto 4), cin=>c1, pg=>p2,gg=>g2,sum=>sum(7 downto 4));	
	CLU3: entity cla4_level1 port map(A=>A(11 downto 8), B=>B(11 downto 8), cin=>c2, pg=>p3,gg=>g3,sum=>sum(11 downto 8));
	CLU4: entity cla4_level1 port map(A=>A(15 downto 12), B=>B(15 downto 12), cin=>c3, pg=>p4,gg=>g4,sum=>sum(15 downto 12));
		
	CLUO: entity carry_look_unit port map(p1,p2,p3,p4,g1,g2,g3,g4,cin,pg,gg,c1,c2,c3,cout);

end cla16_level2;
