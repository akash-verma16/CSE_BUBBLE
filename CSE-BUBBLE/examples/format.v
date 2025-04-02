//! CS220 Assignment 7
//! Devansh Kumar Jha 200318
//! Shivang Pandey 200941

`include "..\source\processor.v"
`include "..\source\decode.v"
`include "..\source\alu.v"
`include "..\source\branching.v"
`include "..\source\system.v"
`include "..\source\memory.v"

module sample_program();

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
        // Write machine codes to enter instruction memory into the machine
            // Instruction 1
        #20 // Instruction 2
        #20 // Instruction 3
        #20 // Instruction 4 .... and so on

        #30
        // Change the add_into flag from instruction to data memory
        add_into <= 1'b1;

        #10
        // Write program to enter data memory into the machine
            // 4 bytes data at location 1
        #20 // 4 bytes data at location 2
        #20 // 4 bytes data at location 3
        #20 // 4 bytes data at location 4 .... and so on

        #30
        // End the data loading phase and start the execution of the program
        start_signal <= 1'b1;
        
        // Execution starts here, you can print certain values here to check execution

    end

endmodule
