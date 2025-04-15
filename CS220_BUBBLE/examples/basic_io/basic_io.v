


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
            new_instruction <= 32'b001000_00110_11011_0000000000001010;               // lw $27, 10($6)  $s3 = 9 (main)
        #20 new_instruction <= 32'b000001_00110_11010_0000000000001011;               // addi $26, $6, 11  $s2 = 11
        #20 new_instruction <= 32'b000001_00110_01001_0000000000000010;               // addi $9, $6, 2
        #20 new_instruction <= 32'b010010_00000000000000000000000110;                 // jal 6
        #20 new_instruction <= 32'b000001_00110_01000_0000000000000010;               // addi $8, $6, 2
        #20 new_instruction <= 32'b010101_00000000000000000000000000;                 // syscall
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
        #20 new_instruction <= "Ente";                        // strInit
        #20 new_instruction <= "rred";
        #20 new_instruction <= " arr";
        #20 new_instruction <= "ay: ";
        #20 new_instruction <= "Sort";                        // strResult
        #20 new_instruction <= "ed a";
        #20 new_instruction <= "rray";
        #20 new_instruction <= ":   ";
        #20 new_instruction <= 32'd10;                         // n
        #20 new_instruction <= 32'd643;                       // arr
        #20 new_instruction <= 32'd573;
        #20 new_instruction <= 32'd532;
        #20 new_instruction <= 32'd087;
        #20 new_instruction <= 32'd879;
        #20 new_instruction <= 32'd242;
        #20 new_instruction <= 32'd64;
        #20 new_instruction <= 32'd805;
        #20 new_instruction <= 32'd868;
        #20 new_instruction <= 32'd170;

        #30
        // End the data loading phase and start the execution of the program
        start_signal <= 1'b1;
        
        // Execution starts here, you can print certain values here to check execution

    end

endmodule
