// FP MAC Project Top Module

`timescale 1ns / 1ps

module FP_MAC_PROJECT(input clk, rst,
                      input ns_button,
                      output [1:0] arduino_out,
					       output [7:0] hex0_disp,
					       output [7:0] hex1_disp,
					       output [7:0] hex2_disp,
					       output [7:0] hex3_disp);
	
	//Parameters
	parameter RESET = 2'b00, INPUT_1 = 2'b01, INPUT_2 = 2'b10, RESULT = 2'b11;

	//Regs and Wires
   reg [1:0]  curr_state, next_state;
	reg [1:0]  arduino_out_q;
	reg [31:0] hex_display_q;
	reg [15:0] in1, in2;
	reg [31:0] mult;
	reg [15:0] mult_norm;
	
	//Assign Statements
	assign arduino_out = arduino_out_q;
	
	//Module Instances
	hex_code hex0(.in(hex_display_q[07:00]), .out(hex0_disp));
	hex_code hex1(.in(hex_display_q[15:08]), .out(hex1_disp));
	hex_code hex2(.in(hex_display_q[23:16]), .out(hex2_disp));
	hex_code hex3(.in(hex_display_q[31:24]), .out(hex3_disp));
	
	
	//FSMs
	always @ (posedge clk or negedge rst)
	begin
	  if(!rst) curr_state <= RESET;
	  else curr_state <= next_state;
	end
	
	always @ (curr_state or ns_button)
	begin
	  
	  arduino_out_q = 0;
	  hex_display_q = 0;
	  
	  case(curr_state)
	    RESET :
		   begin
			  arduino_out_q = RESET;
			  hex_display_q = 32'hFFFF_FFFF; // BLANK 7-SegD
			  mult = 0;
			  mult_norm = 0;
			  next_state = INPUT_1;
			end
		 INPUT_1 :
		   begin
			  arduino_out_q = INPUT_1;
			  in1 = 16'h4480; //4.5
			  hex_display_q = in1;
			  next_state = INPUT_2;
			end
		 INPUT_2 :
		   begin
			  arduino_out_q = INPUT_2;
			  in2 = 16'hFE80; //-0.75
			  hex_display_q = in2;
			  next_state = RESULT;
			end
		 RESULT : 
		   begin
			  arduino_out_q = RESULT;
			  mult = in1 * in2;
			  
			  //Check for Saturation
			  case({in1[15],in2[15]})
			    2'b00 : mult_norm = (mult[31:24] != 0) ? 16'h7FFF : mult[24:9];
				 2'b01 : mult_norm = (mult[31:24] != 1) ? 16'h8001 : mult[24:9];
				 2'b10 : mult_norm = (mult[31:24] != 1) ? 16'h8001 : mult[24:9];
				 2'b11 : mult_norm = (mult[31:24] != 0) ? 16'h7FFF : mult[24:9];
			  endcase
			  
			  hex_display_q = mult_norm;
			  next_state = RESULT;
			end
	  endcase
	  
	end
	
endmodule

