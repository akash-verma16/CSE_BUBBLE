# SOURCE
Source code for the Instruction Set Architecture and Finite State Machine implemented in Verilog VHDL.

## FILES INCLUDED
1) *processor.v* - The top central module which will be called by the user program or testbenches. It simulates the CPU which will handle the whole execution of the program. It also controls all the sequential component of the machine except system instruction execution and memory data retrieval.
2) *decode.v* - Contains the instruction decode phase of the FSM.
3) *memory.v* - All data and instruction memory modules are present in this file. It also contains a default program loaded into it which can be used by specifying the *auto* parameter of processor module as done in *bubble_sort_auto.v* file in bubble_sort example.
4) *branching.v* - Implements the execution of all conditional branching instructions.
5) *alu.v* - Implements all arithmetic, logical and comparison based instructions.
