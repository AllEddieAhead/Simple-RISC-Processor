-------------------------------------------------------------------------------
--
-- Title       : CLA64_level3
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description :  The final level of the 64CLA. Implements 4x16CLA blocks,
-- allowing for two 64 bit inputs. The sum is collected here.
-- In addition, this implementation method allows for easy changes in the form of
-- multiplexors for a top-level design.
--
-- From here, the MUX's act to intercept the sum/cin ports from the 16-bit level2 CLA modules,
-- allowing for word/halfword operations.
--
-- As with lower levels, 4 CLAs are hooked to a CLU, and from here the final result of the operation can be obtained.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CLA64_level3 is
	port(
		 opcode : in STD_LOGIC_VECTOR(3 downto 0);
		 cin : in STD_LOGIC;
		 A : in STD_LOGIC_VECTOR(63 downto 0);
		 B : in STD_LOGIC_VECTOR(63 downto 0);
		 pg,gg : out std_logic; --Is apparently needed :/
		 cout : out STD_LOGIC; --c_collect is used instead of c_out
		 c_collect: out STD_LOGIC_VECTOR(3 downto 0);--Collects the Couts of the 16CLA for use in SAT operations
		 sum : out STD_LOGIC_VECTOR(63 downto 0)
	     );
end CLA64_level3;


architecture CLA64_level3 of CLA64_level3 is
signal p1,p2,p3,p4,g1,g2,g3,g4,c1,c2,c3 : std_logic;
signal c1_temp,c2_temp,c3_temp,c4_temp : std_logic;	--c2_temp and c4_temp not used
signal sel : std_logic := (opcode(1) or opcode(2));
begin

	CLU1: entity cla16_level2 port map(A=>A(15 downto 0),B=>B(15 downto 0), sum=>sum(15 downto 0), cin=>opcode(0), pg=>p1, gg=>g1, cout=>c_collect(0));
	CLU2: entity cla16_level2 port map(A=>A(31 downto 16),B=>B(31 downto 16), sum=>sum(31 downto 16), cin=>c_collect(0), pg=>p2, gg=>g2, cout=>c_collect(1));
	CLU3: entity cla16_level2 port map(A=>A(47 downto 32),B=>B(47 downto 32), sum=>sum(47 downto 32), cin=>opcode(0), pg=>p3, gg=>g3, cout=>c_collect(2));
	CLU4: entity cla16_level2 port map(A=>A(63 downto 48),B=>B(63 downto 48), sum=>sum(63 downto 48), cin=>c_collect(2), pg=>p4, gg=>g4, cout=>c_collect(3));
		 
	CLUO: entity carry_look_unit port map(p1,p2,p3,p4,g1,g2,g3,g4,opcode(0),pg,gg,c1_temp,c2_temp,c3_temp,cout);
	--Here, we add MUX support for the cin values for c0,c15,c31,c47. The c_temp values are the ones intercepted by the MUX, whereas
	--the c1,c2,c3 values entered into the CLA16's will be the outputs of the MUX. For our adder, c0 will always be opcode(0), ditto for c31
	MUX1: entity mux_2_input port map(a=>c1_temp, b=>opcode(0), sel=>sel, c=>c1);
	MUX2: entity mux_2_input port map(a=>c3_temp, b=>opcode(0), sel=>sel, c=>c3);
	--The MUX's select whether or not this is a 16 or 32 bit operation, using the opcode bits. c15 and c47 are selected from the MUX
	
end CLA64_level3;
