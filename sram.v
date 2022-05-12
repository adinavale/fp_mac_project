
module sram(Cs_n, We_n, Oe_n, Address, IO);

    input Cs_n, We_n, Oe_n;
    input [2:0] Address;
    inout [15:0] IO;

    reg [15:0] ram[7:0];
    
    assign IO = (Cs_n == 1'b1 | We_n == 1'b0 | Oe_n == 1'b1) ? 16'hzzzz : ram[Address];
    
    always @(negedge We_n or negedge Cs_n)
        begin
           if(We_n == 1'b0)
             if (Cs_n == 1'b0)
               ram[Address] = IO; //Write to RAM
        end
endmodule