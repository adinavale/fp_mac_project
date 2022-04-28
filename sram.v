// SRAM Module

`timescale 1ns / 1ps

module sram(Cs_n, We_n, Oe_n, Address, IO);

    input Cs_n, We_n, Oe_n;
    input [15:0] Address;
    inout [15:0] IO;
    
    reg [7:0] ram[15:0];
    
    assign IO = (Cs_n == 1'b1 | We_n == 1'b0 | Oe_n == 1'b1) ? 8'bZZZZZZZZ : ram[Address];
    
    always @(We_n, Cs_n)
        begin
           @(negedge We_n)
            if (Cs_n == 1'b0)
                begin
                    ram[Address] <= IO; //Write to RAM
                end 
        end
endmodule