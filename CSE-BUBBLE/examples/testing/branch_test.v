
`include "../source/branching.v"

module branch_test();
    // Example of decoding the instruction
    reg reset;
    reg [31:0] pc_in,ir,ID,rs,rt,rd;
    wire [31:0] out;
    wire warn_signal;

    // Instantiating the module for Instruction Decode
    branch_top uut(reset, pc_in, ir, ID, rs, rt, rd, out, warn_signal);

    // Control the reset signal for a small amount of time to start the machine
    initial begin
        reset <= 1'b0;
        #1
        reset <= 1'b1;
        #1
        reset <= 1'b0;
    end
    
    initial begin
        ir <= 32'b0; ID <= 32'b0; pc_in <= 32'b0;
        rs <= 32'b0; rt <= 32'b0; rd <= 32'b0;
    end

    initial begin
        ir <= 32'b001010_00001_00011_0000000000000001;                  // This is beq $1, $3, 1
        ID <= 32'd15; rs <= 32'd10; rt <= 32'd12; rd <= 32'd1;          // Output will be 0
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        ir <= 32'b001011_00001_00011_0000000000000010;                  // This is bne $1, $3, 2
        ID <= 32'd16; rs <= 32'd10; rt <= 32'd12; rd <= 32'd2;          // Output will be 2
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        ir <= 32'b001100_00001_00011_0000000001100011;                  // This is bgt $1, $3, 99
        ID <= 32'd17; rs <= 32'd10; rt <= 32'd10; rd <= 32'd99;         // Output will be 0
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        ir <= 32'b001101_00001_00010_0000000001100011;                  // This is bgte $1, $2, 99
        ID <= 32'd18; rs <= 32'd10; rt <= 32'd10; rd <= 32'd99;         // Output will be 99
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        ir <= 32'b001100_00001_00011_0000000001100011;                  // This is ble $1, $3, 99
        ID <= 32'd19; rs <= 32'd10; rt <= 32'd10; rd <= 32'd99;         // Output will be 0
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        ir <= 32'b001101_00001_00010_0000000001100011;                  // This is bleq $1, $2, 99
        ID <= 32'd20; rs <= 32'd10; rt <= 32'd10; rd <= 32'd99;         // Output will be 99
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        ir <= 32'b010000_00000000000000000001100100;                  // This is j 100
        ID <= 32'd21; rs <= 32'd100;                                  // Output is 100
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));
        
        ir <= 32'b010001_00000000000000000000000101;                  // This is jr $5
        ID <= 32'd22; rs <= 32'd5;                                    // Output is 5
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        ir <= 32'b010010_00000000000000000001100100;                  // This is jal 100
        ID <= 32'd23; rs <= 32'd100;                                  // Output is 100
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt));
        $display("The set output offset is %d",$signed(rd));
        $display("The output is %d",$signed(out));

        #2000 $finish;
    end
endmodule
