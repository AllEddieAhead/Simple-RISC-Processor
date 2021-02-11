# RISC Processor
This is a simple RISC three-stage pipeline processor, capable of executing sixteen different commands.
The stages are: Instruction Fetch (IF), Instruction Decode and Read (ID), and execution/write-back (E/WB).

The processor does not have write-back collisions, and therefore no miss stall cycles. There is no external memory, and thus no cache stall cycles.

The processor is capable of performing "packed" operations. The registers inside the processor are 64-bits wide. However, not every operation needs to be 64-bits in length. We can perform four 16-bit operations at the same time, or two 32-bit operations at once, depending on the instruction being executed.

The ALU of the processor is coded in two styles. For half of the total instructions (eight), the ALU utilizes a 64-bit CLA adder, capable of doing packed operations. This logic was designed structurally, built up from pure logic gates and component instantiation. The other half of the operations are coded in a behavioral style.

The details of each instruction are included in "pipeline_top", the top level module of the project.

Included in the project is a testbench for fully testing all instructions using assertion statements. Each stage of the processor is output to the console, detailing the contents of each stage's register and the arguments/result of the ALU.

The instructions the processor is capable of are as follows:
(Note: word = 16 bits, doubleword = 32-bits, quadword = 64-bits)
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

Example Instruction:
-- 1001 0001 0010 0011 : (SFW)Subtract the two 32-bit values in register 2 from the two in register 1 and place the two results in register 3.
