
`include "..\..\source\processor.v"
`include "..\..\source\decode.v"
`include "..\..\source\alu.v"
`include "..\..\source\branching.v"
`include "..\..\source\system.v"
`include "..\..\source\memory.v"

module bubble_sort_auto_test();

    // Registers and wires which will be used as an interface between processor and test benches
    reg clk,reset,start_signal;
    reg add_into;
    reg [31:0] new_instruction;
    wire end_signal;
    wire [31:0] debug1,debug2,debug3,debug4,debug5,debug6,debug7;

    // Call the processor module for the execution of the program in the machine.
    // Keep the Auto signal at HIGH to load the default program from processor.
    wire auto_val;
    assign auto_val = 1'b1;
    processor #(.auto(1)) psd(clk,reset,start_signal,new_instruction,add_into,end_signal,debug1,debug2,debug3,debug4,debug5,debug6,debug7);

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

endmodule
