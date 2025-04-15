

//! This is the controller module for execution of operating system internal instructions.
//! There are 3 system instructions which are given by
    // 26: syscall          - Opcode: 21
    //      27: display signed integer    - System Call Code: 1
    //      28: exit                      - System Call Code: 2
    //      29: nop                       - System Call Code: 3
    //      30: display 4 char string     - System Call Code: 4
    //      31: display 8 char string     - System Call Code: 5
    //      32: display 12 char string    - System Call Code: 6
    //      33: display 16 char string    - System Call Code: 7
    //      34: display unsigned integer  - System Call Code: 8
//! The 3 parameters passed between the processor and this module are characterized by
    // rs              - Input Argument 1 containing the type of system instruction to be executed
    // rt1,rt2,rt3,rt4 - Input Argument (2-5) containing the value to be displayed in case of display system instructions
    // rd              - Output Argument 6 this is not used and kept as an high impedance port in this module

/// This is a combinational logic.
module system_top (
    input wire clk,reset,
    input wire [31:0] ir,                   // Instruction Register
    input wire [31:0] instr_ID,             // Decoded instruction ID
    input wire [31:0] rs,rt1,rt2,rt3,rt4,   // 5 input parameters to the system module from processor
    output wire [31:0] rd                   // 1 output parameter from system module to processor
);

    always @(posedge clk) begin
        if(instr_ID != 26) begin end            // Ignore for instructions which are not syscall
        else begin
            if(rs == 32'd1) begin               // The instruction is for displaying signed integer
                $display("%d",$signed(rt1));
            end
            else if(rs == 32'd2) begin          // The instruction is for exiting the program
                #5
                $finish;
            end
            else if(rs == 32'd3) begin end      // The instruction is for a nop system call where we have to ignore the clock cycle
            else if(rs == 32'd4) begin          // The instruction is for displaying 4 char string
                $display("%s",rt1);
            end
            else if(rs == 32'd5) begin          // The instruction is for displaying 8 char string
                $display("%s%s",rt1,rt2);
            end
            else if(rs == 32'd6) begin          // The instruction is for displaying 12 char string
                $display("%s%s%s",rt1,rt2,rt3);
            end
            else if(rs == 32'd7) begin          // The instruction is for displaying 16 char string
                $display("%s%s%s%s",rt1,rt2,rt3,rt4);
            end
            else if(rs == 32'd8) begin          // The instruction is for displaying unsigned integer
                $display("%d",rt1);
            end
        end
    end

endmodule
