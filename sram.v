`timescale 1ns / 1ps

module sram(Cs_b, We_b, Oe_b, Address, IO);

    input Cs_b, We_b, Oe_b;
    input [15:0] Address;
    input [15:0] IO;
    
    reg [7:0] RAM1[255:0];
    
    assign IO = (Cs_b == 1'b1 | We_b == 1'b0 | Oe_b == 1'b1) ? 8'bZZZZZZZZ : RAM1[Address];
    
    always @(We_b, Cs_b)
        begin
           @(negedge We_b)
            if (Cs_b == 1'b0)
                begin
                    RAM1[Address] <= IO; //Write to RAM
                end 
        end
endmodule
