

`include "../source/system.v"

module system_test();
    // Example of decoding the instruction
    reg clk, reset;
    reg [31:0] ir,ID,rs,rt1,rt2,rt3,rt4;
    wire [31:0] rd;

    // Instantiating the module for Instruction Decode
    system_top uut(clk, reset, ir, ID, rs, rt1, rt2, rt3, rt4, rd);

    // Control the reset signal for a small amount of time to start the machine
    initial begin
        reset <= 1'b0;
        #1
        reset <= 1'b1;
        #1
        reset <= 1'b0;
    end
    
    initial begin
        ir <= 32'b0; ID <= 32'b0; rs <= 32'b0;
        rt1 <= 32'b0; rt2 <= 32'b0; rt3 <= 32'b0; rt4 <= 32'b0;
        #10
        clk <= 1'b0;
        forever #10 clk <= ~clk;
    end

    initial begin
        ir <= 32'b001001_00010_00001_0000000001100100;                // This is sw $1, 100($2)
        ID <= 32'd14; rs <= 32'd10;                                   // Nothing printed or seen in registers specifically
        rt1 <= 32'd100; rt2 <= 32'd0; rt3 <= 32'd0; rt4 <= 32'd0;
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));
        
        ir <= 32'b010101_00000000000000000000000000;                  // This is syscall to display signed integer value in rt1
        ID <= 32'd26; rs <= 32'd1;                                    // The value -1001 is visible on screen
        rt1 <= -32'd1001; rt2 <= 32'd0; rt3 <= 32'd0; rt4 <= 32'd0;
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010101_00000000000000000000000000;                  // This is syscall to display unsigned integer value in rt1
        ID <= 32'd26; rs <= 32'd8;                                    // The value 2^32-1001 is visible on screen
        rt1 <= -32'd1001; rt2 <= 32'd0; rt3 <= 32'd0; rt4 <= 32'd0;
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010101_00000000000000000000000000;                  // This is syscall to display 4 char string in rt1
        ID <= 32'd26; rs <= 32'd4;                                    // The value 1001 is visible on screen
        rt1 <= "ABCD"; rt2 <= "EFGH"; rt3 <= "IJKL"; rt4 <= "MNOP";
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010101_00000000000000000000000000;                  // This is syscall to display 8 char string in rt1, rt2
        ID <= 32'd26; rs <= 32'd5;                                    // The value 1001 is visible on screen
        rt1 <= "ABCD"; rt2 <= "EFGH"; rt3 <= "IJKL"; rt4 <= "MNOP";
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010101_00000000000000000000000000;                  // This is syscall to display 12 char string in rt1, rt2, rt3
        ID <= 32'd26; rs <= 32'd6;                                    // The value 1001 is visible on screen
        rt1 <= "ABCD"; rt2 <= "EFGH"; rt3 <= "IJKL"; rt4 <= "MNOP";
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010101_00000000000000000000000000;                  // This is syscall to display 16 char string in rt1, rt2, rt3, rt4
        ID <= 32'd26; rs <= 32'd7;                                    // The value 1001 is visible on screen
        rt1 <= "ABCD"; rt2 <= "EFGH"; rt3 <= "IJKL"; rt4 <= "MNOP";
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010101_00000000000000000000000000;                 // This is nop instruction
        ID <= 32'd26; rs <= 32'd3;                                   // No change in previour output
        rt1 <= 32'd12; rt2 <= 32'd0; rt3 <= 32'd0; rt4 <= 32'd0;
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        ir <= 32'b010101_00000000000000000000000000;                 // This is syscall for finishing program
        ID <= 32'd26; rs <= 32'd2;                                   // The program exits here
        rt1 <= 32'd12; rt2 <= 32'd0; rt3 <= 32'd0; rt4 <= 32'd0;
        #10
        $display("The decoded instruction ID is %d",ID);
        $display("The parameters extracted are as follows");
        $display("The input 1 is %d",$signed(rs));
        $display("The input 2 is %d",$signed(rt1));
        $display("The output is %d",$signed(rd));

        #2000 $finish;

    end
endmodule
