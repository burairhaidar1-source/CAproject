`timescale 1ns / 1ps
// Course Project - Data Memory
// Expanded to hold Fibonacci output: 8 words x 4 bytes = 32 bytes from addr 0
module Data_Memory(
    input  [63:0] Memory_Address,
    input  [63:0] Write_Data,
    input         clk,
    input         MemWrite,
    input         MemRead,
    output reg [63:0] ReadData,
    // Waveform observation wires for Fibonacci results
    output [63:0] w0, w1, w2, w3, w4, w5, w6, w7
);
    reg [7:0] DataMemory [511:0];
    integer i;

    initial begin
        for (i = 0; i < 512; i = i + 1)
            DataMemory[i] = 0;
    end

    // Observe Fibonacci results: 8 words at addresses 0,4,8,...,28
    assign w0 = {32'b0, DataMemory[3],  DataMemory[2],  DataMemory[1],  DataMemory[0]};
    assign w1 = {32'b0, DataMemory[7],  DataMemory[6],  DataMemory[5],  DataMemory[4]};
    assign w2 = {32'b0, DataMemory[11], DataMemory[10], DataMemory[9],  DataMemory[8]};
    assign w3 = {32'b0, DataMemory[15], DataMemory[14], DataMemory[13], DataMemory[12]};
    assign w4 = {32'b0, DataMemory[19], DataMemory[18], DataMemory[17], DataMemory[16]};
    assign w5 = {32'b0, DataMemory[23], DataMemory[22], DataMemory[21], DataMemory[20]};
    assign w6 = {32'b0, DataMemory[27], DataMemory[26], DataMemory[25], DataMemory[24]};
    assign w7 = {32'b0, DataMemory[31], DataMemory[30], DataMemory[29], DataMemory[28]};

    always @(posedge clk) begin
        if (MemWrite) begin
            DataMemory[Memory_Address+3] <= Write_Data[31:24];
            DataMemory[Memory_Address+2] <= Write_Data[23:16];
            DataMemory[Memory_Address+1] <= Write_Data[15:8];
            DataMemory[Memory_Address]   <= Write_Data[7:0];
        end
    end

    always @(*) begin
        if (MemRead) begin
            ReadData[7:0]   <= DataMemory[Memory_Address];
            ReadData[15:8]  <= DataMemory[Memory_Address+1];
            ReadData[23:16] <= DataMemory[Memory_Address+2];
            ReadData[31:24] <= DataMemory[Memory_Address+3];
            ReadData[63:32] <= 32'b0;
        end else
            ReadData = 64'bx;
    end
endmodule