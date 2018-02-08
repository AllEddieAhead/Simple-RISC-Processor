-------------------------------------------------------------------------------
--
-- Title       : mux_2_input
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description :  Simple MUX modules for use in larger modules
--
-- This design file contains different MUXs, to be selected upon instantiation.
--
-- 2:1 MUX, with 1 bit inputs and outputs.
-- 4:1 MUX, with 1 bit inputs and outputs.
-- 2:1 MUX, with 64 bit inputs and a 64-bit output.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_2_input is
	 port(
		 a : in STD_LOGIC;
		 b : in STD_LOGIC;
		 sel : in STD_LOGIC;
		 c : out STD_LOGIC
	     );
end mux_2_input;


architecture mux_2_input of mux_2_input is
begin

	 c<=(a and not sel) or (b and sel);

end mux_2_input;



-------------------------------------------------------------------------------
--	
--
--Simple 4-to-1 MUX for general use	 
--
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux_4_input is
	port(
	a,b,c,d : in std_logic_vector(63 downto 0);
	sel : in std_logic_vector(1 downto 0);
	z : out std_logic_vector(63 downto 0)
	);
end mux_4_input;

architecture mux_4_input of mux_4_input is
begin
	z<=A when (sel="00") else B when (sel="01") else C when (sel="10") else D when (sel="11");
end mux_4_input;



--2-input MUX with 64-bit inputs
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_large_input is
	 port(
		 a : in STD_LOGIC_VECTOR(63 downto 0);
		 b : in STD_LOGIC_VECTOR(63 downto 0);
		 sel : in STD_LOGIC;
		 c : out STD_LOGIC_VECTOR(63 downto 0)
	     );
end mux_large_input;


architecture mux_large_input of mux_large_input is
begin

	c<=a when (sel='0') else b;

end mux_large_input;