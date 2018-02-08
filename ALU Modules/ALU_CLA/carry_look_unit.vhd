-------------------------------------------------------------------------------
--
-- Title       : carry_look_unit
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : This CLU takes 4 propagates, 4 generates, and a carry in, to
-- calculate 4 carry outs and its own propagate and generate.
--
-- This is a structural module, meant to be used many times in higher level modules.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity carry_look_unit is
	 port(
		 p1 : in STD_LOGIC;
		 p2 : in STD_LOGIC;
		 p3 : in STD_LOGIC;
		 p4 : in STD_LOGIC;
		 g1 : in STD_LOGIC;
		 g2 : in STD_LOGIC;
		 g3 : in STD_LOGIC;
		 g4 : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 
		 pg : out STD_LOGIC;
		 gg : out STD_LOGIC;
		 c1 : out STD_LOGIC;
		 c2 : out STD_LOGIC;
		 c3 : out STD_LOGIC;
		 c4 : out STD_LOGIC
	     );
end carry_look_unit;

--}} End of automatically maintained section

architecture carry_look_unit of carry_look_unit is
begin
	pg<=p1 and p2 and p3 and p4;
	gg<=(g4) or (g3 and p4) or (g2 and p3 and p4) or (g1 and p2 and p3 and p4) or (cin and p1 and p2 and p3 and p4);
	
	c1<=g1 or (p1 and cin);
	c2<=g2 or (g1 and p2) or (cin and p1 and p2);
	c3<=g3 or (g2 and p3) or (g1 and p2 and p3) or (cin and p1 and p2 and p3);
	c4<=g4 or (g3 and p4) or (g2 and p3 and p4) or (g1 and p2 and p3 and p4) or (cin and p1 and p2 and p3 and p4);

end carry_look_unit;
