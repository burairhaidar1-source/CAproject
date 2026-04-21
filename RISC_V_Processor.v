`timescale 1ns / 1ps
module RISC_V_Processor(
    input clk,
    input reset
);
    wire [4:0] RS1, RS2, RD;
    wire [63:0] shifted_data, Data_Out, Out1, Out2, w0, w1, w2, w3, w4, w5, w6;
    wire [31:0] Instruction;
    wire [6:0] opcode, func7; 
    wire [63:0] PC_in, PC_out, ReadData, ReadData1, ReadData2, WriteData, ImmData, Result; 
    wire [2:0] func3;  
    wire [3:0] Operation, Funct;
    wire [1:0] ALUOp;
    wire RegWrite, MemRead, MemWrite, MemtoReg;
    wire ALUSrc, Zero, Branch, PCSrc, BranchSelect; 
    

    
    // IF
    Adder fouradder(PC_out, 64'd4, Out1);
    mux branch(Out1, Out2, (Branch & BranchSelect), PC_in);
    Program_Counter PC(clk, reset, PC_in, PC_out);
    Instruction_Memory IM(PC_out, Instruction); 
    
    // ID    
    instruction_parser IP(Instruction, opcode, RD, func3, RS1, RS2, func7);
    immediate_data_extractor IG(Instruction, ImmData);
    control_unit CU(opcode,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    registerFile RF(WriteData, RS1, RS2, RD, RegWrite, clk, reset, ReadData1, ReadData2);
    Branch_unit branchDecision(func3, ReadData1, ReadData2, BranchSelect);
    assign Funct = {Instruction[30],Instruction[14:12]};
    
    
    // EXE 
    assign shifted_data = ImmData << 1;
    Adder BRANCHADDER(PC_out, shifted_data, Out2); 
    mux ALUSRC(ReadData2, ImmData, ALUSrc, Data_Out);
    ALU_control ALUC(ALUOp, Funct, Operation);
    ALU_64_bit ALU(ReadData1, Data_Out, Operation, Result, Zero);
    
    
    // MEM
    Data_Memory DM(Result, ReadData2, clk, MemWrite, MemRead, ReadData, w0, w1, w2, w3, w4, w5, w6);
    
    // WB
    mux WB(Result, ReadData, MemtoReg, WriteData);
    
    
endmodule