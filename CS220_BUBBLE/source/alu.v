

//! This is the file which contains implementation of all airthmetic, logical and comparison instructions.
//! There are 17 instructions implemented here which are given by
    // 1:  add r0, r1, r2   - R type - Opcode: 0 Function: 0
    // 2:  sub r0, r1, r2   - R type - Opcode: 0 Function: 1
    // 3:  addu r0, r1, r2  - R type - Opcode: 0 Function: 2
    // 4:  subu r0, r1, r2  - R type - Opcode: 0 Function: 3
    // 5:  addi r0, r1, 100 - I type - Opcode: 1
    // 6:  addiu r0, r1, 10 - I type - Opcode: 2
    // 7:  and r0, r1, r2   - R type - Opcode: 3 Function: 0
    // 8:  or r0, r1, r2    - R type - Opcode: 4 Function: 0
    // 9:  andi r0, r1, 10  - I type - Opcode: 5
    // 10: ori r0, r1, 100  - I type - Opcode: 6
    // 11: sll r0, r1, 10   - I type - Opcode: 7 Function: 0
    // 12: srl r0, r1, 100  - I type - Opcode: 7 Function: 1
    // 24: slt r0, r1, r2   - R type - Opcode: 19 Function: 0
    // 25: slti r0, r1, 100 - I type - Opcode: 20
    // 26: madd r0, r1      - R type - Opcode: 21 Function: 0
    // 27: maddu r0, r1     - R type - Opcode: 22 Function: 0
    // 28: mul r0, r1       - R type - Opcode: 23 Function: 0
//! The 3 parameters passed between the processor and this module are characterized by
    // rs - Input Argument 1 contains parameter 1 of the ALU instruction. It is the address of processor register to be used.
    // rt - Input Argument 2 contains parameter 2 of the ALU instruction. It is the address of processor register or a constant.
    // rd - Output Argument 3 contains destination processor register address where the result will be stored.


/// This will be a combinational logic.
module alu_top (
    input wire reset,
    input wire [31:0] ir,                    // Instruction Register
    input wire [31:0] instr_ID,              // Decoded instruction ID
    input wire signed [31:0] rs,rt,          // Input Arguments 1 and 2 got from processor
    output wire signed [31:0] rd,            // Output Argument 3 sent to processor
    output wire [31:0] hi,                   // Added hi register output
    output wire [31:0] lo                    // Added lo register output
);

    // Register to update the output of ALU
    reg [31:0] rd_reg;
    reg [31:0] hi_reg, lo_reg;
    // Wire mesh to capture outputs from all ALU submodules
    wire [31:0] opt[0:16];                   // Expanded to include new operations
    wire [31:0] hi_out[0:2];                 // For hi outputs of mul operations
    wire [31:0] lo_out[0:2];                 // For lo outputs of mul operations

    // Calling all subordinate modules
    add alu0(rs,rt,opt[0]);
    sub alu1(rs,rt,opt[1]);
    addu alu2(rs,rt,opt[2]);
    subu alu3(rs,rt,opt[3]);
    addi alu4(rs,rt,opt[4]);
    addiu alu5(rs,rt,opt[5]);
    andk alu6(rs,rt,opt[6]);
    ork alu7(rs,rt,opt[7]);
    andi alu8(rs,rt,opt[8]);
    ori alu9(rs,rt,opt[9]);
    sll alu10(rs,rt,opt[10]);
    srl alu11(rs,rt,opt[11]);
    slt alu12(rs,rt,opt[12]);
    slti alu13(rs,rt,opt[13]);
    madd alu14(rs, rt, {hi_reg, lo_reg}, hi_out[0], lo_out[0]);
    maddu alu15(rs, rt, {hi_reg, lo_reg}, hi_out[1], lo_out[1]);
    mul alu16(rs, rt, hi_out[2], lo_out[2]);
    
    // Combinational Always block to select the correct output from the above outputs. 
    always @(*) begin
        if(reset == 1'b1) begin 
            rd_reg <= 32'b0;
            hi_reg <= 32'b0;
            lo_reg <= 32'b0;
        end
        else if(instr_ID == 0) begin end                         // No instruction fetched till now
        else if(instr_ID < 13) begin                             // Presence of an Airthmetic or Logical instruction
            rd_reg <= opt[instr_ID - 32'd1];
        end
        else if(instr_ID == 24 || instr_ID == 25) begin          // Presence of a Comparison instruction
            rd_reg <= opt[instr_ID - 32'd12];
        end
        else if(instr_ID == 26) begin                            // madd
            hi_reg <= hi_out[0];
            lo_reg <= lo_out[0];
        end
        else if(instr_ID == 27) begin                            // maddu
            hi_reg <= hi_out[1];
            lo_reg <= lo_out[1];
        end
        else if(instr_ID == 28) begin                            // mul
            hi_reg <= hi_out[2];
            lo_reg <= lo_out[2];
            rd_reg <= lo_out[2];                                 // mul stores result in rd as well
        end
        else begin end                                           // Ignore this if it is not an ALU or comparison instruction
    end

    // Assigning output to the communicating output port variable.
    assign rd = rd_reg;
    assign hi = hi_reg;
    assign lo = lo_reg;

endmodule


/// AIRTHEMETIC INSTRUCTIONS
// Module for supporting signed addition operation.
// add r0, r1, r2
module add (
    input wire signed [31:0] rs,rt,
    output wire signed [31:0] rd
);
    assign rd = rs + rt;
endmodule

// Module for supporting signed subtraction operation.
// sub r0, r1, r2
module sub (
    input wire signed [31:0] rs,rt,
    output wire signed [31:0] rd
);
    assign rd = rs - rt;
endmodule

// Module for supporting unsigned addition operation.
// addu r0, r1, r2
module addu (
    input wire unsigned [31:0] rs,rt,
    output wire unsigned [31:0] rd
);
    assign rd = rs + rt;
endmodule

// Module for supporting unsigned subtraction operation.
// subu r0, r1, r2
module subu (
    input wire unsigned [31:0] rs,rt,
    output wire unsigned [31:0] rd
);
    assign rd = rs - rt;
endmodule

// Module for supporting signed immediate addition operation.
// addi r0, r1, 1000
module addi (
    input wire signed [31:0] rs,rt,
    output wire signed [31:0] rd
);
    assign rd = rs + rt;
endmodule

// Module for supporting unsigned immediate addition operation.
// addiu r0, r1, 100
module addiu (
    input wire unsigned [31:0] rs,rt,
    output wire unsigned [31:0] rd
);
    assign rd = rs + rt;
endmodule


/// LOGICAL INSTRUCTIONS
// Module for supporting logical and operation.
// and r0, r1, r2
module andk (
    input wire unsigned [31:0] rs,rt,
    output wire unsigned [31:0] rd
);
    assign rd = rs & rt;
endmodule

// Module for supporting logical or operation.
// or r0, r1, r2
module ork (
    input wire unsigned [31:0] rs,rt,
    output wire unsigned [31:0] rd
);
    assign rd = rs | rt;
endmodule

// Module for supporting logical immediate and operation.
// andi r0, r1, 10
module andi (
    input wire unsigned [31:0] rs,rt,
    output wire unsigned [31:0] rd
);
    assign rd = rs & rt;
endmodule

// Module for supporting logical immediate or operation.
// ori r0, r1, 1000
module ori (
    input wire unsigned [31:0] rs,rt,
    output wire unsigned [31:0] rd
);
    assign rd = rs | rt;
endmodule

// Module for supporting shift left logical operation.
// sll r0, r1, 10
module sll (
    input wire signed [31:0] rs,
    input wire unsigned [31:0] rt,
    output wire signed [31:0] rd
);
    assign rd = rs << rt;
endmodule

// Module for supporting shift right logical operation.
// srl r0, r1, 10
module srl (
    input wire signed [31:0] rs,
    input wire unsigned [31:0] rt,
    output wire signed [31:0] rd
);
    assign rd = rs >> rt;
endmodule


/// COMPARISON INSTRUCTIONS
// Module for supporting Set if Less than operation
// slt r0, r1, r2
module slt (
    input wire signed [31:0] rs,rt,
    output wire signed [31:0] rd
);
    wire o1,o2,o3;
    comparator p1(rs,rt,o1,o2,o3);
    
    assign rd = (o3 == 1'b1) ? 32'b1 : 32'b0;
endmodule

// Module for supporting Set if Less than immediate operation
// slti r0, r1, 100
module slti (
    input wire signed [31:0] rs,rt,
    output wire signed [31:0] rd
);
    wire o1,o2,o3;
    comparator p2(rs,rt,o1,o2,o3);
    
    assign rd = (o3 == 1'b1) ? 32'b1 : 32'b0;
endmodule


/// MULTIPLICATION INSTRUCTIONS
// Module for supporting signed multiply-add operation
// madd r0,r1
module madd (
    input wire signed [31:0] rs, rt,
    input wire [63:0] hilo,
    output wire [31:0] hi_out,
    output wire [31:0] lo_out
);
    wire signed [63:0] product;
    wire signed [63:0] sum;
    
    assign product = rs * rt;
    assign sum = product + hilo;
    assign hi_out = sum[63:32];
    assign lo_out = sum[31:0];
endmodule

// Module for supporting unsigned multiply-add operation
// maddu r0,r1
module maddu (
    input wire [31:0] rs, rt,
    input wire [63:0] hilo,
    output wire [31:0] hi_out,
    output wire [31:0] lo_out
);
    wire [63:0] product;
    wire [63:0] sum;
    
    assign product = rs * rt;
    assign sum = product + hilo;
    assign hi_out = sum[63:32];
    assign lo_out = sum[31:0];
endmodule

// Module for supporting multiplication operation
// mul r0,r1
module mul (
    input wire signed [31:0] rs, rt,
    output wire [31:0] hi_out,
    output wire [31:0] lo_out
);
    wire signed [63:0] product;
    
    assign product = rs * rt;
    assign hi_out = product[63:32];
    assign lo_out = product[31:0];
endmodule
