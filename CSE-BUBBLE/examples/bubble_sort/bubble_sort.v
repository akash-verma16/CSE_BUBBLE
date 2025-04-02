//! CS220 Assignment 7
//! Devansh Kumar Jha 200318
//! Shivang Pandey 200941

`include "..\..\source\processor.v"
`include "..\..\source\decode.v"
`include "..\..\source\alu.v"
`include "..\..\source\branching.v"
`include "..\..\source\system.v"
`include "..\..\source\memory.v"

module bubble_sort_test();

    // Registers and wires which will be used as an interface between processor and test benches
    reg clk,reset,start_signal;
    reg add_into;
    reg [31:0] new_instruction;
    wire end_signal;
    wire [31:0] debug1,debug2,debug3,debug4,debug5,debug6,debug7;

    // Call the processor module for the execution of the program in the machine.
    wire auto_val;
    assign auto_val = 1'b0;
    processor #(.auto(0)) psd(clk,reset,start_signal,new_instruction,add_into,end_signal,debug1,debug2,debug3,debug4,debug5,debug6,debug7);

    // Control the reset signal for a small amount of time to start the machine
    initial begin
        reset <= 1'b0;
        #1
        reset <= 1'b1;
        #1
        reset <= 1'b0;
    end

    // Machine process synchronizing clock signal generation
    initial begin
        start_signal <= auto_val;
        add_into <= 1'b0;
        new_instruction <= 32'b0;
        #10
        clk <= 1'b0;
        forever #10 clk <= ~clk;
    end

    // Input the instructions in the processor in the data loading phase
    // After that input the data into the processor
    // After that set the start_signal to HIGH
    initial begin
        
        #10
        // Write program to enter instruction memory into the machine
            new_instruction <= 32'b001000_00110_11011_0000000000001010;               // lw $27, 10($6)  $s3 = 10 (main)
        #20 new_instruction <= 32'b000001_00110_11010_0000000000001011;               // addi $26, $6, 11  $s2 = 11
        #20 new_instruction <= 32'b000001_00110_01001_0000000000000010;               // addi $9, $6, 2
        #20 new_instruction <= 32'b010010_00000000000000000000100000;                 // jal 32
        #20 new_instruction <= 32'b010010_00000000000000000000001001;                 // jal 9
        #20 new_instruction <= 32'b000001_00110_01001_0000000000000110;               // addi $9, $6, 6
        #20 new_instruction <= 32'b010010_00000000000000000000100000;                 // jal 32
        #20 new_instruction <= 32'b000001_00110_01000_0000000000000010;               // addi $8, $6, 2
        #20 new_instruction <= 32'b010101_00000000000000000000000000;                 // syscall
        #20 new_instruction <= 32'b000001_00110_10001_0000000000000000;               // addi $17, $6, 0 (bubble_sort)
        #20 new_instruction <= 32'b000000_11011_10001_10010_00000_000001;             // sub $18, $27, $17 (outer)
        #20 new_instruction <= 32'b000001_10010_10010_1111111111111111;               // addi $18, $18, -1
        #20 new_instruction <= 32'b000001_00110_10011_0000000000000000;               // addi $19, $6, 0
        #20 new_instruction <= 32'b000000_10011_10010_11001_00000_000001;             // sub $25, $19, $18
        #20 new_instruction <= 32'b010011_11001_00110_11111_00000_000000;             // slt $31, $25, $6
        #20 new_instruction <= 32'b001010_00110_11111_0000000000001101;               // beq $31, $6, 13
        #20 new_instruction <= 32'b001101_00110_11001_0000000000001100;               // bgte $25, $6, 12
        #20 new_instruction <= 32'b000111_00000_10011_10100_00000_000000;             // sll $20, $19, 0 (inner)
        #20 new_instruction <= 32'b000000_10100_11010_10100_00000_000000;             // add $20, $20, $26
        #20 new_instruction <= 32'b000001_10100_10101_0000000000000001;               // addi $21, $20, 1
        #20 new_instruction <= 32'b001000_10100_10110_0000000000000000;               // lw $22, 0($20)
        #20 new_instruction <= 32'b001000_10101_10111_0000000000000000;               // lw $23, 0($21)
        #20 new_instruction <= 32'b000000_10110_10111_11000_00000_000001;             // sub $24, $22, $23
        #20 new_instruction <= 32'b010011_11000_00110_11111_00000_000000;             // slt $31, $24, $6
        #20 new_instruction <= 32'b001011_00110_11111_0000000000000010;               // bne $31, $6, 2
        #20 new_instruction <= 32'b001001_10101_10110_0000000000000000;               // sw $22, 0($21)
        #20 new_instruction <= 32'b001001_10100_10111_0000000000000000;               // sw $23, 0($20)
        #20 new_instruction <= 32'b000001_10011_10011_0000000000000001;               // addi $19, $19, 1 (inend)
        #20 new_instruction <= 32'b001011_10010_10011_1111111111110100;               // bne $19, $18, -12
        #20 new_instruction <= 32'b000001_10001_10001_0000000000000001;               // addi $17, $17, 1 (oend)
        #20 new_instruction <= 32'b001011_11011_10001_1111111111101011;               // bne $17, $27, -21
        #20 new_instruction <= 32'b010001_00000000000000000000010000;                 // jr $16 (end1)
        #20 new_instruction <= 32'b000001_00110_01000_0000000000000111;               // addi $8, $6, 7 (print)
        #20 new_instruction <= 32'b000001_01001_01010_0000000000000000;               // addi $10, $9, 0
        #20 new_instruction <= 32'b001000_01010_01010_0000000000000000;               // lw $10, 0($10)
        #20 new_instruction <= 32'b000001_01001_01011_0000000000000001;               // addi $11, $9, 1
        #20 new_instruction <= 32'b001000_01011_01011_0000000000000000;               // lw $11, 0($11)
        #20 new_instruction <= 32'b000001_01001_01100_0000000000000010;               // addi $12, $9, 2
        #20 new_instruction <= 32'b001000_01100_01100_0000000000000000;               // lw $12, 0($12)
        #20 new_instruction <= 32'b000001_01001_01101_0000000000000011;               // addi $13, $9, 3
        #20 new_instruction <= 32'b001000_01101_01101_0000000000000000;               // lw $13, 0($13)
        #20 new_instruction <= 32'b010101_00000000000000000000000000;                 // syscall
        #20 new_instruction <= 32'b000001_00110_10010_0000000000000000;               // addi $18, $6, 0
        #20 new_instruction <= 32'b000001_11010_10001_0000000000000000;               // addi $17, $26, 0
        #20 new_instruction <= 32'b000001_00110_01000_0000000000000001;               // addi $8, $6, 1 (loop2)
        #20 new_instruction <= 32'b001000_10001_01010_0000000000000000;               // lw $10, 0($17)
        #20 new_instruction <= 32'b010101_00000000000000000000000000;                 // syscall
        #20 new_instruction <= 32'b000001_10010_10010_0000000000000001;               // addi $18, $18, 1
        #20 new_instruction <= 32'b000001_10001_10001_0000000000000001;               // addi $17, $17, 1
        #20 new_instruction <= 32'b001011_11011_10010_1111111111111010;               // bne $18, $27, -6
        #20 new_instruction <= 32'b010001_00000000000000000000010000;                 // jr $16 (end2)

        #30
        // Change the add_into flag from instruction to data memory
        add_into <= 1'b1;

        #10
        // Write program to enter data memory into the machine
            new_instruction <= " ";                           // strCT
        #20 new_instruction <= "\n";                          // strCR
        #20 new_instruction <= "Init";                        // strInit
        #20 new_instruction <= "ial ";
        #20 new_instruction <= "arra";
        #20 new_instruction <= "y:  ";
        #20 new_instruction <= "Sort";                        // strResult
        #20 new_instruction <= "ed a";
        #20 new_instruction <= "rray";
        #20 new_instruction <= ":   ";
        #20 new_instruction <= 32'd15;                        // n
        #20 new_instruction <= 32'd643;                       // arr
        #20 new_instruction <= 32'd573;
        #20 new_instruction <= 32'd532;
        #20 new_instruction <= 32'd087;
        #20 new_instruction <= 32'd879;
        #20 new_instruction <= 32'd242;
        #20 new_instruction <= 32'd64;
        #20 new_instruction <= 32'd805;
        #20 new_instruction <= 32'd868;
        #20 new_instruction <= 32'd57320;
        #20 new_instruction <= 32'd378;
        #20 new_instruction <= 32'd868;
        #20 new_instruction <= 32'd57320;
        #20 new_instruction <= 32'd0;
        #20 new_instruction <= 32'd3;

        #30
        // End the data loading phase and start the execution of the program
        start_signal <= 1'b1;
        
        // Execution starts here, you can print certain values here to check execution

    end

endmodule
