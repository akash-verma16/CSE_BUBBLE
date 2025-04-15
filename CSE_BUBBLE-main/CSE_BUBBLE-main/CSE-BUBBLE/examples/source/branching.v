

//! This is the file which contains implementation of all conditional or unconditional branch instructions.
//! There are 9 instructions implemented here which are given by
    // 15: beq r0, r1, 10   - I type - Opcode: 10
    // 16: bne r0, r1, 100  - I type - Opcode: 11
    // 17: bgt r0, r1, 10   - I type - Opcode: 12
    // 18: bgte r0, r1, 100 - I type - Opcode: 13
    // 19: ble r0, r1, 10   - I type - Opcode: 14
    // 20: bleq r0, r1, 100 - I type - Opcode: 15
//! The 3 parameters passed between the processor and this module are characterized by
    // rs - Input Argument 1 contains parameter 1 of the Conditional Branch instruction. First operand in logical comparison.
    // rt - Input Argument 2 parameter 2 of the Conditional Branch instruction. Second operand in logical comparison.
    // rd - Input Argument 3 contains destination offset for the program counter next position.
    // out - Output Argument 4 contains the extra jump to be followed by the program counter.

/// This will be a combinational logic.
module branch_top (
    input wire reset,
    input wire [31:0] pc_in,ir,                     // Program Counter and Instruction Register
    input wire [31:0] instr_ID,                     // Decoded instruction ID
    input wire signed [31:0] rs,rt,rd,              // Input Arguments 1, 2 and 3 got from processor
    output wire [31:0] out,                         // Output Argument 4 sent to processor
    output wire warn_signal
);
    // Register to update the output of ALU
    reg [31:0] out_reg;
    reg warn_signal_reg;
    // Wire mesh to capture outputs from all ALU submodules
    wire [31:0] opt[0:13];
    wire warn[0:13];
    wire o1,o2,o3;
    
    // Calling all subordinate modules
    beq branch0(pc_in,o1,o2,o3,rd,opt[0],warn[0]);
    bne branch1(pc_in,o1,o2,o3,rd,opt[1],warn[1]);
    bgt branch2(pc_in,o1,o2,o3,rd,opt[2],warn[2]);
    bgte branch3(pc_in,o1,o2,o3,rd,opt[3],warn[3]);
    ble branch4(pc_in,o1,o2,o3,rd,opt[4],warn[4]);
    bleq branch5(pc_in,o1,o2,o3,rd,opt[5],warn[5]);
    comparator comp(rs,rt,o1,o2,o3);

    // Combinational Always block to select the correct output from the above outputs. 
    always @(*) begin
        if(reset == 1'b1) begin out_reg <= 1'b0; warn_signal_reg <= 1'b0; end
        else if(instr_ID >=15 && instr_ID <= 20) begin           // Presence of any Branch instruction
            out_reg <= opt[instr_ID - 32'd15];
            warn_signal_reg <= warn[instr_ID - 32'd15];
        end
        else begin warn_signal_reg <= 1'b0; end                  // Ignore this if it is not a Branch instruction
    end

    // Assigning output to the communicating output port variable.
    assign out = out_reg;
    assign warn_signal = warn_signal_reg;

endmodule

/// CONDITIONAL BRANCH INSTRUCTIONS
// Module for supporting branch if equal operation.
// beq r0, r1, 10
module beq (
    input wire [31:0] pc_in,
    input wire o1,o2,o3,
    input wire signed [31:0] rd,
    output wire [31:0] out,
    output wire warn
);
    assign out = (o2 == 1'b1) ? pc_in + rd : pc_in;
    assign warn = (o2 == 1'b1);
endmodule

// Module for supporting branch if not equal operation.
// bne r0, r1, 10
module bne (
    input wire [31:0] pc_in,
    input wire o1,o2,o3,
    input wire signed [31:0] rd,
    output wire [31:0] out,
    output wire warn
);
    assign out = (o2 == 1'b0) ? pc_in + rd : pc_in;
    assign warn = (o2 == 1'b0);

endmodule

// Module for supporting branch if greater than operation.
// bgt r0, r1, 10
module bgt (
    input wire [31:0] pc_in,
    input wire o1,o2,o3,
    input wire signed [31:0] rd,
    output wire [31:0] out,
    output wire warn
);
    assign out = (o1 == 1'b1) ? pc_in + rd : pc_in;
    assign warn = (o1 == 1'b1);
endmodule

// Module for supporting branch if greater than equal to operation.
// bgte r0, r1, 10
module bgte (
    input wire [31:0] pc_in,
    input wire o1,o2,o3,
    input wire signed [31:0] rd,
    output wire [31:0] out,
    output wire warn
);
    assign out = (o3 == 1'b0) ? pc_in + rd : pc_in;
    assign warn = (o3 == 1'b0);
endmodule

// Module for supporting branch if less than operation.
// ble r0, r1, 10
module ble (
    input wire [31:0] pc_in,
    input wire o1,o2,o3,
    input wire signed [31:0] rd,
    output wire [31:0] out,
    output wire warn
);
    assign out = (o3 == 1'b1) ? pc_in + rd : pc_in;
    assign warn = (o3 == 1'b1);
endmodule

// Module for supporting branch if less than equal to operation.
// bleq r0, r1, 10
module bleq (
    input wire [31:0] pc_in,
    input wire o1,o2,o3,
    input wire signed [31:0] rd,
    output wire [31:0] out,
    output wire warn
);
    assign out = (o1 == 1'b0) ? pc_in + rd : pc_in;
    assign warn = (o1 == 1'b0);
endmodule

// COMPARATOR MODULE
// This is the module which compares two values and returns the outputs
// in 3 bits o1, o2 and o3.
module comparator (
    input wire signed [31:0] rs,rt,
    output wire o1,o2,o3
);
    reg o1_reg,o3_reg;
    wire [30:0] mag1,mag2;
    assign mag1 = rs[30:0];
    assign mag2 = rt[30:0];
    assign o2 = (rs == rt);
    
    always @(*) begin
        if(rs[31] == rt[31]) begin
            if(rs[31] == 1'b0) begin
                o1_reg <= (mag1 > mag2); o3_reg <= (mag1 < mag2);
            end
            else begin
                o3_reg <= (mag1 > mag2); o1_reg <= (mag1 < mag2);
            end
        end
        else begin
            o1_reg <= (rt[31] == 1'b1); o3_reg <= (rs[31] == 1'b1);
        end
    end

    assign o1 = o1_reg;
    assign o3 = o3_reg;

endmodule
