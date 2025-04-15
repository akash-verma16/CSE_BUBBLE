

`include "..\..\source\processor.v"
`include "..\..\source\decode.v"
`include "..\..\source\alu.v"
`include "..\..\source\branching.v"
`include "..\..\source\system.v"
`include "..\..\source\memory.v"

module fsm_test();

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
        // Comment out this command to see the output of this program.
        // This command enables us to see the inside working of the processor.
        $monitor("clk = %d instruction_ID = %d Program_Counter = %d Program_Size = %d Instruction_loaded = %b",clk,debug1,debug2,debug3,debug4);

        #10
        $display("Loading of instruction memory begins");
        // Write program to enter instruction memory into the machine
            new_instruction <= 32'b000001_00110_10101_0000000000000100;                     // addi $t4, $0, 4
        #20 new_instruction <= 32'b000001_00110_10110_0000000000000101;                     // addi $t5, $0, 5
        #20 new_instruction <= 32'b000001_00110_10111_0000000000000110;                     // addi $t6, $0, 6
        #20 new_instruction <= 32'b001000_10101_10001_0000000000000000;                     // lw $t0, 0($t4)
        #20 new_instruction <= 32'b001000_10110_10010_0000000000000000;                     // lw $t1, 0($t5)
        #20 new_instruction <= 32'b001000_10111_10011_0000000000000000;                     // lw $t2, 0($t6)
        #20 new_instruction <= 32'b000001_00110_01000_0000000000000111;                     // addi $v0, $0, 7
        #20 new_instruction <= 32'b000001_00110_01010_0000000000000000;                     // addi $a0, $0, 0
        #20 new_instruction <= 32'b001000_01010_01010_0000000000000000;                     // lw $a0, 0($a0)
        #20 new_instruction <= 32'b000001_00110_01011_0000000000000001;                     // addi $a1, $0, 1
        #20 new_instruction <= 32'b001000_01011_01011_0000000000000000;                     // lw $a1, 0($a1)
        #20 new_instruction <= 32'b000001_00110_01100_0000000000000010;                     // addi $a2, $0, 2
        #20 new_instruction <= 32'b001000_01100_01100_0000000000000000;                     // lw $a2, 0($a2)
        #20 new_instruction <= 32'b000001_00110_01101_0000000000000011;                     // addi $a3, $0, 3
        #20 new_instruction <= 32'b001000_01101_01101_0000000000000000;                     // lw $a3, 0($a3)
        #20 new_instruction <= 32'b010101_00000000000000000000000000;                       // syscall
        #20 new_instruction <= 32'b000000_10011_10010_10101_00000_000000;                   // add $t4, $t2, $t1
        #20 new_instruction <= 32'b000001_00110_01000_0000000000000001;                     // addi $v0, $0, 1 (loopp1)
        #20 new_instruction <= 32'b000001_10101_01010_0000000000000000;                     // addi $a0, $t4, 0
        #20 new_instruction <= 32'b010101_00000000000000000000000000;                       // syscall
        #20 new_instruction <= 32'b000001_10101_10101_0000000000000001;                     // addi $t4, $t4, 1
        #20 new_instruction <= 32'b001110_10001_10101_1111111111111011;                     // ble $t4, $t0, -5
        #20 new_instruction <= 32'b000001_00110_01000_0000000000000010;                     // addi $v0, $0, 2
        #20 new_instruction <= 32'b010101_00000000000000000000000000;                       // syscall

        #30
        $display("Change of loading memory target to data memory happens");
        // Change the add_into flag from instruction to data memory
        add_into <= 1'b1;

        #10
        $display("Loading of data memory begins");
        // Write program to enter data memory into the machine
            new_instruction <= "Prin";             // strResult
        #20 new_instruction <= "ted ";
        #20 new_instruction <= "Valu";
        #20 new_instruction <= "es: ";
        #20 new_instruction <= 32'd10;             // num1:   .word 10 stored at data[0]
        #20 new_instruction <= -32'd10;             // num2:   .word -10 stored at data[1]
        #20 new_instruction <= 32'd13;             // num3:   .word 13 stored at data[2]

        #30
        $display("The input to memory is now stopped");
        // End the data loading phase and start the execution of the program
        start_signal <= 1'b1;

        $display("The execution of program starts here");
        // Execution starts here, you can print certain values here to check execution

    end

endmodule
