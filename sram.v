// SRAM Module

`timescale 1ns / 1ps

module sram(Cs_n, We_n, Oe_n, Address, IO);

    input Cs_n, We_n, Oe_n;
    input [3:0] Address;
    inout [15:0] IO;

    wire [15:0] ram_0;
    wire [15:0] ram_1;
    wire [15:0] ram_2;
    wire [15:0] ram_3;
    wire [15:0] ram_4;
    wire [15:0] ram_5;
    wire [15:0] ram_6;
    wire [15:0] ram_7;
    
    reg [15:0] ram[7:0];
    
    assign IO = (Cs_n == 1'b1 | We_n == 1'b0 | Oe_n == 1'b1) ? 16'hzzzz : ram[Address];
    assign ram_0 = ram[0];
    assign ram_1 = ram[1];
    assign ram_2 = ram[2];
    assign ram_3 = ram[3];
    assign ram_4 = ram[4];
    assign ram_5 = ram[5];
    assign ram_6 = ram[6];
    assign ram_7 = ram[7];
    
    always @(negedge We_n or negedge Cs_n)
        begin
           if(We_n == 1'b0)
             if (Cs_n == 1'b0)
               ram[Address] = IO; //Write to RAM
        end
endmodule
