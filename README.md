# IITK_MINI_MIPS
This repository contains the course project of CS220A. We have made an Instruction Set Architecture with 25 Instructions using the verilog hardware description language.

## FILES AND FOLDERS IN THE PROJECT
1) *problem.pdf* - Contains the explanantion of the problem statement required to be solved.
2) **source** - Folder for source code.
3) **examples** - Some examples of execution of simple programs using FSM controlled by the source code.
4) **testing** - Debugging testbenches are present in this folder.
5) *documentation.pdf* - Contains the description of the design of Instruction Set Architecture including processor architecture, instructions supported with machine conversion and memory architecture.

## INSTRUCTIONS FOR USAGE
To run any program of your choice using the FSM -
1) Go to **examples** folder and create a verilog module file.
```
cd examples
```
2) Copy the contents of file *format.v* in your file.
3) Add instructions converted to machine code in the instruction section and data in data section.
4) Run the test bench using
```
iverilog -o test program_name.v
vvp test
```
Replace the phrase program_name with the name of your verilog program file.

## INSTRUCTIONS TO CHECK EXECUTION
1) **PDS - 1** -  The details are mentioned in the documentation.

2) **PDS - 2** -  The details are mentioned in the documentation.

3) **PDS - 3** -  The details are mentioned in the documentation.

4) **PDS - 4** -  The instruction fetch phase has been implemented in "processor.v" file in source folder from lines 179 to 197.
```
cd source
```

5) **PDS - 5** -  The instruction decode phase has been implemented in "decode.v", and "processor.v" lines 200 to 262, in the source folder
```
cd source
```

6) **PDS - 6** - The ALU has been implemented in "alu.v" in the source folder.
```
cd source
```

7) **PDS - 7** - The branching operations have been implemented in "branching.v" in the source folder.
```
cd source
```

8) **PDS - 8** - Go to fsm_test folder in examples folder. *fsm_test.asm* contains the MIPS code which is used to test the functioning of the Finite State Machine of the source code.
```
cd examples\fsm_test
iverilog -o test fsm_test.v
vvp test
```
The line 47 (monitor command) in this file is used to print the state of the FSM at each clock cycle, it can be commented out if we just want to see the output of the machine.

9) **PDS - 9** - Go to bubble_sort folder in examples folder and run the program *bubble_sort.asm* on QtSpim to check the execution of MIPS assembly program. This program is converted into source machine code and is mentioned in file *bubble_sort_isa.txt*.
```
cd examples\bubble_sort
```
10) **PDS - 10** - Run the verilog programs bubble_sort_auto.v or bubble_sort.v to see the output of the buble_sort program.
```
cd examples\bubble_sort
iverilog -o test bubble_sort_auto.v
vvp test
```
This will show the output of bubble sort program. Note that you can also use *bubble_sort.v* in place of *bubble_sort_auto.v*.
If you use *bubble_sort.v* you can change the array enterred in the program by changing the data section in file *bubble_sort.v* testbench area.
