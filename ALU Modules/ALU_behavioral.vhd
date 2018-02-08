-------------------------------------------------------------------------------
--
-- Title       : ALU_behavioral
-- Design      : RISC Processor
-- Author      : Edmundo Welker
--
-------------------------------------------------------------------------------
--
-- Description : The behavioral components of the ALU, specifically the following:
-- AND  :0010
-- OR   :0011
-- CNTH :0100 (Count '1's in halfword)
-- CLZ  :0101 (Count leading zeros in word)
-- ROT  :0110 (Rotate 64-bit value right by immediate)
-- SLHI :0111 (Shift left halfword by immediate)
-- MPYU :1110 (Multiply lower half-words)
-- ABSDB:1111 (Absolute value of bytes)
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity ALU_behavioral is
	 port(
		 opcode : in STD_LOGIC_VECTOR(3 downto 0);
		 A : in STD_LOGIC_VECTOR(63 downto 0);
		 B : in STD_LOGIC_VECTOR(63 downto 0);
		 result : out STD_LOGIC_VECTOR(63 downto 0);
		 en : out STD_LOGIC
	     );
end ALU_behavioral;



architecture ALU_behavioral of ALU_behavioral is
begin 
	
	process(opcode,A,B)
	--All the variables used in the various operations. Each line contains all the variables necessary for each operation.
		variable cnth_counter1, cnth_counter2, cnth_counter3, cnth_counter4 : integer;
		variable clz_counter1, clz_counter2 : integer;
		variable rot_counter : integer; variable rot_temp : std_logic_vector(63 downto 0);
		variable shi_counter1,shi_counter2, shi_counter3, shi_counter4 : integer; variable shi_temp1,shi_temp2,shi_temp3,shi_temp4 : std_logic_vector(15 downto 0);
		variable mpyu1, mpyu2 : integer;
		variable absdb_temp : integer;
	begin
		
	en<='1';--Default setting. If the opcode is not valid for this piece of the ALU, is overwritten by en<='0' as one of the last statements
	-------------------------------------------------------------------------------------------------		
	--AND
	if (opcode="0010") then
		result<= A and B;
	-------------------------------------------------------------------------------------------------		
	--OR 
	elsif (opcode="0011") then
		result<= A or B;
	-------------------------------------------------------------------------------------------------
	--CNTH
	--This operation counts the amount of '1's in each of the 4 16-bit slices and returns those counts
	--in the return register
	elsif(opcode="0100") then
		--Initialize counters
		cnth_counter1:=0;
		cnth_counter2:=0;
		cnth_counter3:=0;
		cnth_counter4:=0;
		--Count the 1's in each 16-bit slice of the operand
		for i in 0 to 15 loop
			if (A(i)='1') then
				cnth_counter1:=cnth_counter1+1;
			end if;
			if (A(i+16)='1') then
				cnth_counter2:=cnth_counter2+1;
			end if;
			if (A(i+32)='1') then
				cnth_counter3:=cnth_counter3+1;
			end if;
			if (A(i+48)='1') then
				cnth_counter4:=cnth_counter4+1;
			end if;
		end loop;
		--Convert counter integer values to STD_LOGIC_VECTOR of length 16
		result(15 downto 0)<=std_logic_vector(to_unsigned(cnth_counter1,16));
		result(31 downto 16)<=std_logic_vector(to_unsigned(cnth_counter2,16));
		result(47 downto 32)<=std_logic_vector(to_unsigned(cnth_counter3,16));
		result(63 downto 48)<=std_logic_vector(to_unsigned(cnth_counter4,16));
	-------------------------------------------------------------------------------------------------	
	--CLZ	
	--Count the leading zeroes in each word
	elsif(opcode="0101") then
		--Initialize counters
		clz_counter1:=0;
		clz_counter2:=0;
		for j in 0 to 31 loop
			--For both halves of rs1, count the leading 0's, up to 32.
			if ((A(31-j)='1')) then
				exit;
			else 
				clz_counter1:=clz_counter1+1;
			end if;
		end loop;
		for j in 32 to 63 loop
			if (A(63-j)='1') then
				exit;
			else
				clz_counter2:=clz_counter2+1;
			end if;
		end loop;
		result(31 downto 0)<=std_logic_vector(to_unsigned(clz_counter1,32));
		result(63 downto 32)<=std_logic_vector(to_unsigned(clz_counter2,32));
	-------------------------------------------------------------------------------------------------
	--ROT
	--Rotate to the right the entire 64-bit value
	elsif(opcode="0110") then
		rot_counter:=0;
		rot_temp:=(others=>'0');
		--Convert the value to an integer, then use the integer as the termination condition of the loop
		rot_counter:=to_integer(unsigned(B(5 downto 0)));
		if (rot_counter=0) then
			result<=A;
		else
			for k in 0 to rot_counter loop
				rot_temp:=A(0)& A(63 downto 1);--Simple bit adjustments for the actual rotation
			end loop;
			result<=rot_temp;
		end if;
	
	-------------------------------------------------------------------------------------------------
	--SHLHI
	--Shift left the halfwords by an immediate value, appending 0's
	elsif(opcode="0111") then
		shi_counter1:=to_integer(unsigned(B(15 downto 0)));
		shi_counter2:=to_integer(unsigned(B(31 downto 16)));
		shi_counter3:=to_integer(unsigned(B(47 downto 32)));
		shi_counter4:=to_integer(unsigned(B(63 downto 48)));
		--After getting the counter values, we SLL the appropriate contents of rs1
		--Since all the counter values are different, we can't do it all simultaneously
		for i in 0 to shi_counter1 loop
			shi_temp1:=A(14 downto 0)&'0';
		end loop;
		for i in 0 to shi_counter2 loop
			shi_temp2:=A(30 downto 16)&'0';
		end loop;
		for i in 0 to shi_counter3 loop
			shi_temp3:=A(46 downto 32)&'0';
		end loop;
		for i in 0 to shi_counter4 loop
			shi_temp4:=A(62 downto 48)&'0';
		end loop;
		result(15 downto 0)<=shi_temp1;
		result(31 downto 16)<=shi_temp2;
		result(47 downto 32)<=shi_temp3;
		result(63 downto 48)<=shi_temp4;
		
	-----------------------------------------------------------------------------------------------
	--MPYU
	--Multiple the two lower-half words of register A and B, store the two 32-bit values in the destination register
	elsif(opcode="1110") then
		--Initialize
		mpyu1:=0;
		mpyu2:=0;
		--The 16-bit multiplicands are turned into integers, multiplied, then returned as 32-bit vectors
		mpyu1:=to_integer(unsigned(A(47 downto 32))) * to_integer(unsigned(B(47 downto 32)));
		mpyu2:=to_integer(unsigned(A(15 downto 0))) * to_integer(unsigned(B(15 downto 0)));
		result(63 downto 32)<=std_logic_vector(to_unsigned(mpyu1,32));
		result(31 downto 0)<=std_logic_vector(to_unsigned(mpyu2,32));
	--------------------------------------------------------------------------------------------------
	--ABSDB
	--Get the absolute value of each byte and store it all in a single register
	elsif(opcode="1111") then
			result(63 downto 56)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(63 downto 48)))-to_integer(signed(B(63 downto 48)))),8));
			result(55 downto 48)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(55 downto 48)))-to_integer(signed(B(55 downto 48)))),8));
			result(47 downto 40)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(47 downto 40)))-to_integer(signed(B(47 downto 40)))),8));
			result(39 downto 32)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(39 downto 32)))-to_integer(signed(B(39 downto 32)))),8));
			result(31 downto 24)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(31 downto 24)))-to_integer(signed(B(31 downto 24)))),8));
			result(23 downto 16)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(23 downto 16)))-to_integer(signed(B(23 downto 16)))),8));
			result(15 downto 8)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(15 downto 8)))-to_integer(signed(B(15 downto 8)))),8));
			result(7  downto 0)<=std_logic_vector(to_unsigned(abs(to_integer(signed(A(7 downto 0)))-to_integer(signed(B(7 downto 0)))),8));

		  
	else
		en<='0';--Allows for selection on the top level of the ALU. EN=1 means that the result of this piece of the ALU is the valid result
	end if;
	end process;
end ALU_behavioral;
