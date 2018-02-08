# RISC Processor
This is a simple RISC three-stage pipeline processor, capable of taking sixteen different commands.
It utilizses the following stages: Instruction fetch, instruction decode and read, and execution/write-back.

The processor doesn't cause collisions in the write-back stage, letting there be no need for stalling cycles.

The original design document listed the sixteen required instructions, the widths of the registers, and the three stages to be used. Every part of the design was created to fit those specifications.

The processor is capable of performing "packed" operations. The registers inside the processor are 64-bits wide. However, not every operation needs to be 64-bits in length. We can perform four 16-bit operations at the same time, or two 32-bit operations at once.

The ALU of the processor is coded in two styles. For half of the total instructions (eight), the ALU utilizes a 64-bit CLA adder, capable of doing packed operations. This was designed using basic logic gates, in a structural style. Full-adders were grouped into blocks, and those blocks were grouped into their own blocks. The other half of the operations are coded in a behavioral style.

There is no external memory. The processor uses very simple registers, and there is no write or read delays involved.

The details of each instruction are included in "pipeline_top", the top level module of the project.

The testbench is a simple testbench for testing individual instructions. Each stage of the processor is output to the console, detailing the contents of each stage's register and the arguments/result of the ALU.

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
