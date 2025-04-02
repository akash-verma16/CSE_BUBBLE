//! CS220 Assignment 7
//! Devansh Kumar Jha 200318
//! Shivang Pandey 200941

//! This is the master module which will inturn call all the other modules in the source code.
//! This module controls all the sequential execution of the processor and machine cycle execution.
//! The module should inturn be called with including the other modules of the source in testbench.

module processor #(parameter auto = 0) (clk,reset,start_signal,new_instruction,add_into,end_signal,debug1,debug2,debug3,debug4,debug5,debug6,debug7);
    //! STEP 0 -- FSM DESCRIPTION OF THE PROCESSOR
    /// OVERVIEW
    /// This is the processor top module which controls the complete MIPS ISA program made under this repository.
    /// The program has 3 main steps which cover fetching, decoding as well as executing each of the instructions.

    /// FROM THE TEST BENCH
    // The test bench is required to give the following inputs to the processor before it starts working -
    //  1) The instructions in a sequential manner which needs to be executed.
    //  2) The data in the data memory which is also to be made available in the sequential manner.
    //  3) A synchrnonizing clock signal is to be generated from the testbench itself and used in the processor as well.
    //  4) The testbench should provide a start_signal to denote that all the intruction and data has been provided now.
    // Test bench should not print or monitor anything but only pass the instructions and even the system instructions would
    // be run by the processor itself.

    /// OVERALL WORKING OF THE PROCESSOR
    // The reset signal will provide an intial pulse to the reset the whole processor at a initial value.
    // After that all the data is first loaded into the memory. Now the start_signal is set high.
    // The processor will not start its execution until the start_signal is not high.
    // First the first instruction is fetched at a clock posedge and then decoded at the next posedge of clock.
    // Then the instruction is executed at the next posedge. Execution will take only one clock cycle.
    // This design will work continuously and the next instruction will be taken after execution of the first.

    /// DIVISION UNDER STEPS
    // STEP 1 of the processor code defines the inputs given to the processor.
    // STEP 2 defines the processor registers and there usage and also creates the processor memory.
    // STEP 3 of the processor code defines the initial phase of loading of all data into the memory by the processor.
    // STEP 4 is the start of the execution where the reset conditions are defined for the processor.
    // STEP 5 is the instruction fetch phase algorithm which will fill the required registers from fetch instruction.
    // STEP 6 is the instruction decode phase which will tell the execution phase what is the instruction to be run now.
    // STEP 7 is the execution phase which calls upon the whole set of execution modules to take upon the
    // execution according to the instruction.
    // STEP 8 defines the ending condition of the processor which happens when the end_signal is set to high.
    
    
    //! STEP 1 -- DEFINING INPUTS AND OUTPUTS OF THE MODULE
    /// clk - The synchronizing clock for all processes of the machine.
    /// reset - An initial signal that will be passed for very short time which will be used to reset the whole machine into its initial state.
    /// start_signal - A signal sent by the testbench which means that now the memory elements have all been sent and now the execution
    ///                of the program can start.
    /// new_instruction - Till the start signal is 0 the New Instruction or New Data to be fed in the respective memory is in this register.
    /// add_into - Which memory will the data be fed into in case start signal is still 0. High means data memory.
    /// end_signal - Will be set to 1 upon termination of the program, will be zero initially
    input wire clk,reset;
    input wire start_signal,add_into;
    input wire [31:0] new_instruction;
    output reg end_signal;

    /// debugs - These are registers for the purpose of debugging of the processor FSM. They dont play any part in working.
    output wire signed [31:0] debug1,debug2,debug3,debug4,debug5,debug6,debug7;
    assign debug1 = instr_ID;
    assign debug2 = process[0];
    assign debug3 = final;
    assign debug4 = instr;
    assign debug5 = data;
    assign debug6 = data;
    assign debug7 = final;

    
    //! STEP 2 -- DEFINING THE GENERAL PURPOSE AND OTHER REGISTERS/WIRES INSIDE THE PROCESSOR
    /// Process - Total 32 registers inside the processor each of 32 bits stored under the Process matrix
    /// Registers 0-5 : System controlled registers PC, EPC, Cause, BadVAddr, Status, IR
    /// Registers 6-31 : User controlled registers r0, at, v0-v1, a0-a3, gp, sp, ra, t0-t6, s0-s7
    
    // Register 0 - PC - Program Counter (Denotes the next instruction to be fetched)
    // Register 1 - EPC - Exception Program Counter will denote the location of interrupt handler in case of exception.
    // Register 2 - Cause - This will denote the source of exception which has caused an interrupt.
    // Register 3 - BadVAddr - In case of branching instructions if wrong instruction is loaded then we need to wait for a clock cycle
    // Register 4 - Status - This signifies for how much time the processor has been waiting due to a conditional branching instruction
    // Register 5 - IR - It will Store the Current Instruction which is being executed
    // Register 6 - r0 - This register will be hardwired to 0 at all times
    // Register 7 - at - This register will be used by the Assembler time to time to implement Pseudo Instructions
    // Register (8-9) - (v0-v1) - This will be used for system calls and system instructions by the user
    // Register (10-13) - (a0-a3) - Will be used to provide arguments for function or system calls by the user
    // Register 14 - gp - Global Pointer - Will be pointing to the start of the global area,
    //                                     can be used to point the starting address of heap in data memory
    // Register 15 - sp - Stack Pointer - Will denote the starting location of stack memory in data memory
    // Register 16 - ra - Return Address - Will Store the address of the instruction where we have to return after function exits
    // Register (17-23) - (t0-t6) - Temprorary Registers - Will be used to store values just required temprorarily
    // Register (24-31) - (s0-s7) - Stored Registers - Will be used to store values required over multiple functions or modules
    reg [31:0] process[0:31];
    
    
    //! STEP 3 -- INTERFACING OF INSTRUCTION MEMORY AND DATA MEMORY AND LOADING THE PROGRAM BEFORE STARTING THE PROCESSOR
    /// We have to first execute the memory loading phase where the data memory and instruction memory is fed into the program.
    /// Till the start_signal is 0 we have to ensure that the end_signal remains 0 and all other processes within the processor
    /// do not create any hindrance to the process of loading into the memory.
    
    // The finish register will be used to store the address of last instruction of the program.
    // This will facilitate the ending of processor when required. end_signal will be set to high after executing this instruction.
    reg [31:0] final;
    
    // Other useful registers and wire to be used later on.
    reg [7:0] instr_ad_in,instr_ad_out,data_ad_in,data_ad_out;
    reg [31:0] input_instruction,input_data;
    wire [31:0] instr,data;
    reg instr_mode,data_mode,instr_write,data_write;
    
    // Instruction memory which will be used by the processor is controlled by the veda memory module as below.
    // The instruction memory has a size of 32 bits * 256 registers
    veda_instruction #(.start(auto)) inst(clk,reset,input_instruction,instr,instr_mode,instr_ad_in,instr_ad_out,instr_write);
    
    // Data memory which will be used by the processor is ceontrolled by the veda memory module as below.
    // The data memory has a size of 32 bits * 256 registers
    veda_data #(.start(auto)) dat(clk,reset,input_data,data,data_mode,data_ad_in,data_ad_out,data_write);
    
    // Logic for the entry of data into the respective memories.
    always @(posedge clk) begin
        if(start_signal == 1'b1) begin                      // The case when the data loading is already completed.
            instr_mode <= 1'b1;                             // Keep the instruction memory at read only now.
            final <= (auto == 0) ? instr_ad_in + 1 : 51;
        end
        else if(end_signal == 1'b0) begin
            instr_mode <= 1'b0; data_mode <= 1'b0;          // Keep the memories into write mode for this phase.
            if(add_into == 1'b0) begin                      // When the available data is an instruction
                data_write <= 1'b0;                         // Disable writing into the data memory
                instr_write <= 1'b1;                        // Enable writing into the instruction memory
                input_instruction <= new_instruction;
            end
            else begin                                      // When the available data is a data
                instr_write <= 1'b0;                        // Disable writing into the instruction memory
                data_write <= 1'b1;                         // Enable writing into the data memory
                input_data <= new_instruction;
            end
        end 
    end

    // The memory pointer updations are done at the negedge of the clock cycle.
    always @(negedge clk) begin
        if(start_signal == 1'b1) begin end                  // The case when the data loading is already completed.
        else begin
            if(add_into == 1'b0) begin                      // When the available data is an instruction
                instr_ad_in <= instr_ad_in + 1;
                instr_ad_out <= instr_ad_out + 1;
            end
            else begin                                      // When the available value is a data
                data_ad_in <= data_ad_in + 1;
                data_ad_out <= data_ad_out + 1;
                process[15] <= process[15] + 1;             // The stack pointer also updated simultaneously
            end
        end
    end

    
    //! STEP 4 -- INITIALIZATION OF PROGRAM COUNTER AND OTHER SYSTEM CONTROLLED REGISTERS INSIDE THE PROCESSOR
    /// Reset will be activated for a very small time during the starting of the execution. That will be used by the processor
    /// to intiate all the registers in it.
    /// It will also be used by other modules instantiated in processor for reseting there induvidual memory.
    integer i1;
    always @(posedge reset) begin
        instr_mode <= 1'b1;                                      // Instruction is kept at read only mode
        data_mode <= 1'b0;                                       // Data is kept at write mode
        instr_ad_in <= -2;                                       // Set the input address of instruction memory to 0.
        instr_ad_out <= -2;                                      // Set the output address of instruction memory to 0.
        data_ad_in <= -2;                                        // Set the input address of data memory to 255.
        data_ad_out <= -2;                                       // Set the output address of data memory to 0.
        end_signal <= 0;                                         // Set the end_signal to be 0 initially.
        input_instruction <= 0;                                  // Input instruction to instruction memory is cleared
        input_data <= 0;                                         // Input data to data memory is cleared
        process[0] <= -1;                                        // Set Program Counter (PC) at 0 (start of the program).
        process[3] <= 0;                                         // Clear the BadVAddr register as well in the start
        process[4] <= 0;                                         // Clear the Status register, LOW shows normal program execution
        process[5] <= 0;                                         // Clear the Instruction Register (IR).
        process[6] <= 0;                                         // Register 'r0' is always hardwired to 0.
        process[7] <= 0;                                         // Register 'at' set to 0.
        for(i1=8;i1<=13;i1=i1+1) begin process[i1] <= 0; end     // Clear all v and a registers in processor.
        process[14] <= 0;                                        // Global Pointer initialized at the top of the Data Memory.
        process[15] <= -2;                                       // Stack Pointer initialized at the end of the Data Memory.
        process[16] <= 0;                                        // Register 'ra' set to 0.
        for(i1=17;i1<=31;i1=i1+1) begin process[i1] <= 0; end    // Clear all t and s registers in processor.
        for(i1=0;i1<=10;i1=i1+1) begin inputs[i1] <= 0; end      // Execution input registers are cleared initally.
    end

    
    //! STEP 5 -- INSTRUCTION FETCH PHASE (MODULE WILL BE CALLED WHICH WILL LOAD THE NEXT INSTRUCTION IN IR REGISTER)
    /// The instr_fetch module will be used to control the IR register and it will be a combinational logic.

    // Logic for the instruction fetch phase of the processor FSM
    // process[5] -> The IR register value
    always @(posedge clk) begin
        if(start_signal == 1'b0 || end_signal == 1'b1) begin end      // When data loading going on ignore this phase.
        else if(end_signal == 1'b0) begin
            process[5] <= instr;                                      // On clock posedge take the previous output from the memory.
        end
    end

    // process[0] -> The PC register value
    always @(process[0]) begin
        if(start_signal == 1'b0 || end_signal == 1'b1) begin end      // When data loading going on ignore this phase.
        else if(end_signal == 1'b0) begin
            instr_ad_out <= process[0];                               // On clock negedge set the output wire from memory at address pc.
        end
    end

    
    //! STEP 6 -- INSTRUCTION DECODE PHASE (READ THE IR REGISTER AND SEND THE CONTROL TO THAT PARTICULAR INSTRUCTION DATA PATH)
    /// The instr_decode module will be used to decode the instruction currently present in the IR register.
    /// The instructions are encoded within the following categories broadly -
    /// R type Instructions (32 bits) = Opcode (6 bits)[31:26] + Argument 1 (5 bits)[25:21] + Argument 2 (5 bits)[20:16]
    ///                                  + Destination (Argument 3) (5 bits)[15:11] + Shift Amount (5 bits)[10:6] + Function (6 bits)[5:0]
    /// I type Instructions (32 bits) = Opcode (6 bits)[31:26] + Argument 1 (5 bits)[25:21] + Destination (Argument 3) (5 bits)[20:16]
    ///                                + Constant (Argument 2) (16 bits)[15:0]
    /// J type Instructions (32 bits) = Opcode (6 bits)[31:26] + Constant (Argument 1) (26 bits)[25:0]
    /// The ISA CSE-BUBBLE Implements the following 25 Instructions which are explained below -
    
    /// 6 Airthemetic Instructions
    // 1:  add r0, r1, r2   - R type - Opcode: 0 Function: 0
    // 2:  sub r0, r1, r2   - R type - Opcode: 0 Function: 1
    // 3:  addu r0, r1, r2  - R type - Opcode: 0 Function: 2
    // 4:  subu r0, r1, r2  - R type - Opcode: 0 Function: 3
    // 5:  addi r0, r1, 100 - I type - Opcode: 1
    // 6:  addiu r0, r1, 10 - I type - Opcode: 2
    
    /// 6 Logical Instructions
    // 7:  and r0, r1, r2   - R type - Opcode: 3 Function: 0
    // 8:  or r0, r1, r2    - R type - Opcode: 4 Function: 0
    // 9:  andi r0, r1, 10  - I type - Opcode: 5
    // 10: ori r0, r1, 100  - I type - Opcode: 6
    // 11: sll r0, r1, 10   - R type - Opcode: 7 Function: 0
    // 12: srl r0, r1, 100  - R type - Opcode: 7 Function: 1
    
    /// 2 Data Transfer Instructions
    // 13: lw r0, 10(r1)    - I type - Opcode: 8
    // 14: sw r0, 10(r1)    - I type - Opcode: 9
    
    /// 6 Conditional Branching Instructions
    // 15: beq r0, r1, 10   - I type - Opcode: 10
    // 16: bne r0, r1, 100  - I type - Opcode: 11
    // 17: bgt r0, r1, 10   - I type - Opcode: 12
    // 18: bgte r0, r1, 100 - I type - Opcode: 13
    // 19: ble r0, r1, 10   - I type - Opcode: 14
    // 20: bleq r0, r1, 100 - I type - Opcode: 15
    
    /// 3 Unconditional Branch Instructions
    // 21: j 100            - J type - Opcode: 16
    // 22: jr r0            - J type - Opcode: 17
    // 23: jal 1000         - J type - Opcode: 18
    
    /// 2 Comparison Instructions
    // 24: slt r0, r1, r2   - R type - Opcode: 19 Function: 0
    // 25: slti r0, r1, 100 - I type - Opcode: 20
    
    /// Other Special System Instructions
    // 26: syscall          - J type - Opcode: 21
    //      27: display signed integer    - System Call Code: 1
    //      28: exit                      - System Call Code: 2
    //      29: nop                       - System Call Code: 3
    //      30: display 4 char string     - System Call Code: 4
    //      31: display 8 char string     - System Call Code: 5
    //      32: display 12 char string    - System Call Code: 6
    //      33: display 16 char string    - System Call Code: 7
    //      34: display unsigned integer  - System Call Code: 8
    
    // This will denote the ID of the instruction which will be used later by the execution phase of processor.
    wire [31:0] instr_ID,rs,rt,rd;
    
    // This is a combinational decoder logic which computes the ID of a particular instruction.
    instr_decode decode(reset,process[5],instr_ID,rs,rt,rd);

    
    //! STEP 7 -- EXECUTION PHASE (CALLING THE TOP MODULES OF VARIOUS PARTS OF THE PROCESSOR TO IMPLEMENT THE INSTRUCTION AS REQUIRED)
    /// For a particular decoded ID of the instruction we will call the top modules for all execution units.
    /// It outputs the changes required in the data memory and processor registers.
    /// Each instruction will have its own data path of execution which will be pointed to from here.
    
    // All the outputs from these execution data paths will be taken in the following wire mesh.
    // outputs[1] denote the output from the ALU
    // outputs[2] denote the output from the Data Transfer Module
    // outputs[3] denote the output from the Branching Module
    // outputs[4] denote the output from the system module
    wire [31:0] outputs[0:3];
    wire warn;
    // All the inputs to the modules responsible for execution will be available in the following register mesh.
    // inputs[0]-inputs[7] direct inputs to the top execution modules in order given a pair to all the modules
    // inputs[8]-inputs[10] indirect input registers used to store intermediate values while execution is going on
    reg [31:0] inputs[0:11];

    // This is the top module of control for all Airthmetic Logic Operations in the Processor. This module instantiates
    // the other sub-modules for various ALU tasks. It works on the processor registers only.
    // It is a combinational logic.
    alu_top alu(reset,process[5],instr_ID,inputs[0],inputs[1],outputs[0]);
    
    // This is the top module of control for all Branching Operations in the Processor. This module instantiates the
    // other branching related modules. This works on both instruction memory and processor registers.
    // It is a combinational logic.
    branch_top branch(reset,process[0],process[5],instr_ID,inputs[4],inputs[5],inputs[8],outputs[2],warn);
    
    // This is the top module for implementation of all system instructions which are the special processor instructions
    // They are all independent of the R, I and J type classification.
    // This will be a sequential logic as it can control the working of the actual Pseudo Operating Software.
    system_top sys(clk,reset,process[5],instr_ID,inputs[6],inputs[7],inputs[9],inputs[10],inputs[11],outputs[3]);

    // Logic for execution phase of the Processor FSM
    always @(negedge clk) begin
        if(start_signal == 1'b0 || end_signal == 1'b1) begin end           // When the data is loading ignore this phase.
        else if(process[3] == 32'b1 && process[4] == 32'b0) begin          // Correct the PC setup for correct instruction loading.
            process[0] <= outputs[2];
            process[4] <= process[4] + 1;
        end
        else if(end_signal == 1'b0) begin
            if(instr_ID < 13 || instr_ID == 24 || instr_ID == 25) begin    // An airthmetic, logical or comparison instructions executed.
                data_write <= 1'b0;                                        // Keep the writeEnable of data memory disabled.
                inputs[0] <= process[rs];                                  // Load the parameter 1 into the inputs
                if(instr_ID < 5 || instr_ID == 7 
                    || instr_ID == 8 || instr_ID == 24) begin              // For R type instruction except shift instructions
                    inputs[1] <= process[rt];                              // Load the parameter 2 into the inputs
                end
                else if(instr_ID == 11 || instr_ID == 12) begin            // Shift instructions sll and srl
                    inputs[1] <= rt;
                end
                else begin                                                 // For I type instruction
                    inputs[1] <= rt;                                       // Load the value into parameter 2 directly for inputs
                end
                process[0] <= process[0] + 1;                              // Update the program counter
            end
            else if(instr_ID < 15) begin                                   // A data transfer instruction is being executed.
                data_write <= (instr_ID == 14) ? 1'b1 : 1'b0;              // Keep the writeEnable of data memory enabled for store word.
                if(instr_ID == 13) begin                                   // Load word execution interfacing data memory
                    data_ad_out <= process[rs] + rt;
                end
                else begin                                                 // Store word execution interfacing data memory
                    data_ad_in <= process[rs] + rt;
                    input_data <= process[rd];
                end
                process[0] <= process[0] + 1;                              // Update the program counter
            end                  
            else if(instr_ID < 24) begin                                   // A branching instruction is being executed.
                data_write <= 1'b0;                                        // Keep the writeEnable of data memory disabled.
                inputs[8] <= rt;                                           // Give the jump offset also as an input
                if(instr_ID < 21) begin                                    // I type conditional branch instructions
                    inputs[4] <= process[rd];
                    inputs[5] <= process[rs];
                    process[0] <= process[0] + 1;                          // Update the program counter according to heuristic expectations
                end
                else if(instr_ID == 22) begin                              // J type unconditional jr instruction
                    process[0] <= process[rs];
                end
                else if(instr_ID == 21) begin                              // J type unconditional j instruction
                    process[0] <= rs;
                end
                else begin                                                 // J type unconditional jal instruction
                    process[0] <= rs;
                    process[16] <= process[0] + 1;
                end
            end
            else begin                                                     // A system instruction is being executed.
                data_write <= 1'b0;                                        // Keep the writeEnable of data memory disabled.
                inputs[6] <= process[8];                                   // The v0 register store the system call number
                inputs[7] <= process[10];                                  // The a0 register stores the value to be printed
                inputs[9] <= process[11];                                  // The a1 register stores the value to be printed
                inputs[10] <= process[12];                                 // The a2 register stores the value to be printed
                inputs[11] <= process[13];                                 // The a3 register stores the value to be printed
                process[0] <= process[0] + 1;                              // Update the program counter
            end
        end
    end

    // The part of execution involving dealing with various outputs should be
    // done on the posedge of the clock and thus they are seperated from
    // the negedge part of the execution process.
    always @(posedge clk) begin
        if(start_signal == 1'b0 || end_signal == 1'b1) begin end           // When the data is loading ignore this phase.
        else if(process[3] == 1'b1) begin end                              // In case of wrong instruction do not execute this phase.
        else if(end_signal == 1'b0) begin
            if(instr_ID < 13 || instr_ID == 24 || instr_ID == 25) begin    // An airthmetic, logical or comparison instructions executed.
                process[rd] <= outputs[0];                                 // Unload the previous output to destination
            end
            else if(instr_ID == 13) begin                                  // For the load word instruction
                process[rd] <= data;                                       // Load the value from memory into processor
            end
        end
        if(warn == 1'b1) begin                                             // In case of warning sancioned from the branching module
            if(process[4] == 32'b0) begin process[3] <= 32'b1; end
            else begin process[3] <= 32'b0; process[4] <= 32'b0; end
        end
        else begin process[3] <= 32'b0; process[4] <= 32'b0; end
    end


    //! STEP 8 -- EXITING THE PROGRAM
    /// When the PC becomes equal to final instruction location than the signal will be set.
    /// When the signal is set the processor does not allow the Program Counter to move further and waits for the top-module to finish
    /// the execution of the program.
    
    // Logic for setting of end signal to a high value
    always @(posedge clk) begin
        if(start_signal == 1'b0) begin end                            // When the program is in data loading phase ignore this
        else if(process[0] == final) begin end_signal <= 1'b1; end    // When the PC reaches final value set the end signal
    end

endmodule
