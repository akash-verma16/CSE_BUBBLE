

//! This module will control the Instruction Decode phase of the FSM.
//! The decoder logic is presented in the processor module also.
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
    // 11: sll r0, r1, 10   - R type - Opcode: 7 Function: 0
    // 12: srl r0, r1, 100  - R type - Opcode: 7 Function: 1
    // 13: lw r0, 10(r1)    - I type - Opcode: 8
    // 14: sw r0, 10(r1)    - I type - Opcode: 9
    // 15: beq r0, r1, 10   - I type - Opcode: 10
    // 16: bne r0, r1, 100  - I type - Opcode: 11
    // 17: bgt r0, r1, 10   - I type - Opcode: 12
    // 18: bgte r0, r1, 100 - I type - Opcode: 13
    // 19: ble r0, r1, 10   - I type - Opcode: 14
    // 20: bleq r0, r1, 100 - I type - Opcode: 15
    // 21: j 100            - J type - Opcode: 16
    // 22: jr r0            - J type - Opcode: 17
    // 23: jal 1000         - J type - Opcode: 18
    // 24: slt r0, r1, r2   - R type - Opcode: 19 Function: 0
    // 25: slti r0, r1, 100 - I type - Opcode: 20
    // 26: syscall          - J type - Opcode: 21
    //      27: display signed integer    - System Call Code: 1
    //      28: exit                      - System Call Code: 2
    //      29: nop                       - System Call Code: 3
    //      30: display 4 char string     - System Call Code: 4
    //      31: display 8 char string     - System Call Code: 5
    //      32: display 12 char string    - System Call Code: 6
    //      33: display 16 char string    - System Call Code: 7
    //      34: display unsigned integer  - System Call Code: 8
//! The 3 parameters extracted by decoding and provided to the processor work as the following
    // rs - The argument 1 of the instruction not applied for system instructions.
    // rt - The argument 2 of the instruction not applied for system or unconditional jump instructions.
    // rd - The argument 3 of the instruction not applied for system or unconditional jump instructions.
    // R type Instructions (32 bits) = Opcode (6 bits)[31:26] + Argument 1 (5 bits)[25:21] + Argument 2 (5 bits)[20:16]
    //                                  + Destination (Argument 3) (5 bits)[15:11] + Shift Amount (5 bits)[10:6] + Function (6 bits)[5:0]
    // I type Instructions (32 bits) = Opcode (6 bits)[31:26] + Argument 1 (5 bits)[25:21] + Destination (Argument 3) (5 bits)[20:16]
    //                                + Constant (Argument 2) (16 bits)[15:0]
    // J type Instructions (32 bits) = Opcode (6 bits)[31:26] + Constant (Argument 1) (26 bits)[25:0]

/// This is a purely combinational logic.
module instr_decode (
    input wire reset,
    input wire [31:0] ir,                   // Instruction Register
    output wire [31:0] ID,                  // Decoded Instruction ID
    output wire signed [31:0] rs,rt,rd      // 3 parameters extracted from the instruction
);
    // Wires for fragmenting the instruction in IR register.
    wire [5:0] opcode,func;
    reg [31:0] id_reg,rs_reg,rt_reg,rd_reg;

    assign opcode = ir[31:26];
    assign func = ir[5:0];

    // Whenever the values under ir are changed this module will be signalled and the always block will execute.
    // ID gets the particular instruction ID and parameter outputs are set as explained above.
    always @(*) begin
        if(reset == 1'b1 || ir == 32'b0) begin id_reg <= 32'b0; end
        else if(opcode == 6'd0) begin
            id_reg <= {27'b0,{func+5'd1}};
            rs_reg <= {27'b0,ir[25:21]}; rt_reg <= {27'b0,ir[20:16]}; rd_reg <= {27'b0,ir[15:11]};
        end
        else if(opcode <= 6'd6) begin
            id_reg <= {27'b0,{opcode+5'd4}};
            if(opcode == 3 || opcode==4) begin
                rs_reg <= {27'b0,ir[25:21]}; rt_reg <= {27'b0,ir[20:16]}; rd_reg <= {27'b0,ir[15:11]};
            end
            else begin
                rs_reg <= {27'b0,ir[25:21]}; rt_reg <= {{16{ir[15]}},ir[15:0]}; rd_reg <= {27'b0,ir[20:16]};
            end
        end
        else if(opcode == 6'd7) begin
            id_reg <= {27'b0,{func+5'd11}};
            rs_reg <= {27'b0,ir[20:16]}; rt_reg <= {27'b0,ir[10:6]}; rd_reg <= {27'b0,ir[15:11]};
        end
        else begin
            id_reg <= {27'b0,{opcode+5'd5}};
            if(opcode < 16 || opcode == 20) begin
                rs_reg <= {27'b0,ir[25:21]}; rt_reg <= {{16{ir[15]}},ir[15:0]}; rd_reg <= {27'b0,ir[20:16]};
            end
            else if(opcode < 19 || opcode == 26) begin rs_reg <= {6'b0,ir[25:0]}; end
            else begin
                rs_reg <= {27'b0,ir[25:21]}; rt_reg <= {27'b0,ir[20:16]}; rd_reg <= {27'b0,ir[15:11]};
            end
        end
    end

    // Assign appropriate values to the output wires.
    assign ID = id_reg;
    assign rs = rs_reg;
    assign rt = rt_reg;
    assign rd = rd_reg;
endmodule
