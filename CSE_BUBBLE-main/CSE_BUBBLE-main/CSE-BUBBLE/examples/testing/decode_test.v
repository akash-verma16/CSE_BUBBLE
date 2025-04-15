

`include "../source/decode.v"

module decode_test();
    // Example of decoding the instruction
    reg reset;
    reg [31:0] ir;
    wire [31:0] ID,rs,rt,rd;

    // Instantiating the module for Instruction Decode
    instr_decode uut(reset, ir, ID, rs, rt, rd);

    // Control the reset signal for a small amount of time to start the machine
    initial begin
        reset <= 1'b0;
        #1
        reset <= 1'b1;
        #1
        reset <= 1'b0;
    end
    
    initial begin
        ir <= 32'b000000_00011_00101_00001_00000_000000;          // This is add $1, $3, $5
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        ir <= 32'b000001_00010_00001_0000000001100100;                // This is addi $1, $2, 100
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        ir <= 32'b000011_00011_00110_00001_00000_000000;              // This is and $1, $3, $6
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        ir <= 32'b010000_00000000000000000001100100;                  // This is j 100
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        ir <= 32'b000110_00010_00001_0000000001100100;                // This is ori $1, $2, 100
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        ir <= 32'b010011_00011_00110_00001_00000_000000;              // This is slt $1, $3, $6
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        ir <= 32'b001000_00010_00001_0000000001100100;                // This is lw $1, 100($2)
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        ir <= 32'b001001_00010_00001_0000000001100100;                // This is sw $1, 100($2)
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The parameter 1 is %d",rs);
        $display("The parameter 2 is %d",rt);
        $display("The parameter 3 is %d",rd);

        #2000 $finish;
    end
endmodule
