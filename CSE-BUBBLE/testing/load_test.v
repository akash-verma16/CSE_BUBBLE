//! CS220 Assignment 7
//! Devansh Kumar Jha 200318
//! Shivang Pandey 200941

`include "..\source\memory.v"

module load_test();

    // Instantiation of the UUT (Unit Under Test)
    reg [31:0] a,b,c;
    wire [31:0] out;
    reg clk,reset,mode,write;

    // Change as per the program to be tested
    veda_instruction #(.width(32),.depth(32),.len(32)) uut(clk,reset,a,out,mode,b,c,write);

    initial begin  
        #10
        clk <= 1'b0; 
        forever #5 clk <= ~clk;
    end

    initial begin  
        reset <= 1'b0;
        #1
        reset <= 1'b1;
        #1
        reset <= 1'b0;
    end
    
    initial begin
        #10

        a <= 134; b <= 13; c <= 13; mode <= 0; write <= 1;
        #10
        $display("The clock value is ",clk);
        $display("The values of input and address are ",a," ",b," ",c);
        $display("The outputs are ",out);
        
        a <= 144; b <= 10; c <= 10; mode <= 0; write <= 1;
        #10
        $display("The clock value is ",clk);
        $display("The values of input and address are ",a," ",b," ",c);
        $display("The outputs are ",out);
        
        a <= 170; b <= 11; c <= 10; mode <= 0; write <= 1;
        #10
        $display("The clock value is ",clk);
        $display("The values of input and address are ",a," ",b," ",c);
        $display("The outputs are ",out);
        
        a <= 200; b <= 10; c <= 3; mode <= 1; write <= 1;
        #10
        $display("The clock value is ",clk);
        $display("The values of input and address are ",a," ",b," ",c);
        $display("The outputs are ",out);
        
        a <= 210; b <= 13; c <= 13; mode <= 0; write <= 1;
        #10
        $display("The clock value is ",clk);
        $display("The values of input and address are ",a," ",b," ",c);
        $display("The outputs are ",out);
        
        a <= 201; b <= 13; c <= 13; mode <= 0; write <= 1;
        #10
        $display("The clock value is ",clk);
        $display("The values of input and address are ",a," ",b," ",c);
        $display("The outputs are ",out);
        
        #2000 $finish;
    end

endmodule
