`timescale 1ns / 1ps

module fpmac_design(
    input clock, reset,
    input [1:0] current_state,
    input [15:0] IO_1, IO_2, //Input from the keypad
    output reg [15:0] sram_a, sram_b,
    output reg [7:0] ssd0, ssd1, ssd2, ssd3 //Seven-segment display input
    );
    
    always @(current_state)
    begin
        case(current_state)
            2'b00:begin //reset
                sram_a = 16'h0000;
                sram_b = 16'h0000;
                ssd0 = 8'b00000000;
                ssd1 = 8'b00000000;
                ssd2 = 8'b00000000;
                ssd3 = 8'b00000000;
            end
            2'b01:begin //First input from keypad
                sram_a = IO_1; 
                //Drive output to seven segment displays here
            end
            2'b10:begin //Second input from keypad
                sram_b = IO_2; 
                //Drive output to seven segment displays here
            end
            2'b11:begin
                //drive output to arduino LCD here and perform FP mac calculations
            end
        endcase
    end
endmodule
