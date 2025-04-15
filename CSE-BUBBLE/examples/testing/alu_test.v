

`include "../source/alu.v"
`include "../source/branching.v"

module alu_test();
    // Example of decoding the instruction
    reg reset;
    reg [31:0] ir,ID,rs,rt;
    wire [31:0] rd;

    // Instantiating the module for Instruction Decode
    alu_top uut(reset, ir, ID, rs, rt, rd);

    // Control the reset signal for a small amount of time to start the machine
    initial begin
        reset <= 1'b0;
        #1
        reset <= 1'b1;
        #1
        reset <= 1'b0;
    end
    
    initial begin
        ir <= 32'b0; ID <= 32'b0;
        rs <= 32'b0; rt <= 32'b0;
    end

    initial begin
        ir <= 32'b000000_00011_00101_00001_00000_000000;          // This is add $1, $3, $5
        ID <= 32'd1; rs <= 32'd10; rt <= 32'd12;                  // 10 + 12 = 22
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        ir <= 32'b000001_00010_00001_0000000001100100;                // This is sub $1, $2, 100
        ID <= 32'd2; rs <= 32'd10; rt <= 32'd100;                     // 10 - 100 = -90
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        ir <= 32'b000011_00011_00110_00001_00000_000000;              // This is and $1, $3, $6
        ID <= 32'd7; rs <= 32'd10; rt <= 32'd12;                      // 10 & 12 = 8
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010000_00000000000000000001100100;                  // This is j 100
        ID <= 32'd21; rs <= 32'd10; rt <= 32'd12;                     // No change in previous output
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        ir <= 32'b000110_00010_00001_0000000001100011;                // This is ori $1, $2, 99
        ID <= 32'd10; rs <= 32'd10; rt <= 32'd99;                     // 10 | 99 = 109
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010011_00011_00110_00001_00000_000000;              // This is slt $1, $3, $6
        ID <= 32'd24; rs <= 32'd17; rt <= 32'd6;                      // 17 < 6 = 0
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        ir <= 32'b001000_00010_00001_0000000001100100;                // This is lw $1, 100($2)
        ID <= 32'd13; rs <= 32'd10; rt <= 32'd12;                     // No change in previour output
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        ir <= 32'b001001_00010_00001_0000000001100100;                // This is sw $1, 100($2)
        ID <= 32'd14; rs <= 32'd10; rt <= 32'd12;                     // No change in previour output
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The output is %d",$signed(rd));

        #2000 $finish;
    end
endmodule
