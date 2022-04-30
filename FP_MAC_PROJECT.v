// FP MAC Project Top Module

`timescale 1ns / 1ps

module FP_MAC_PROJECT(input clk, rst,
                      input ns_button,
							 
							 input  [3:0] key_row,
							 output [3:0] key_col,
                      
							 output [4:0] arduino_out,
							 
					       output [7:0] hex0_disp,
					       output [7:0] hex1_disp,
					       output [7:0] hex2_disp,
					       output [7:0] hex3_disp);
	
	//Parameters
	parameter RESET = 2'b00, SRAM_A = 2'b01, SRAM_B = 2'b10, RESULT = 2'b11;
	parameter INPUT_0 = 3'b000, INPUT_1 = 3'b001, INPUT_2 = 3'b010, INPUT_3 = 3'b011, INPUT_4 = 3'b100, INPUT_5 = 3'b101, INPUT_6 = 3'b110, INPUT_7 = 3'b111; 

	//Regs and Wires
   reg [1:0]  curr_state, next_state;
	reg [2:0]  curr_state_sram, next_state_sram;
	
	reg [4:0]  arduino_out_q;
	reg [31:0] hex_display_q;
	
	wire cs_a, we_a, oe_a;
	wire cs_b, we_b, oe_b;
	wire key_en;
	wire [3:0] sram_addr, key_data, sram_data_a, sram_data_b;
	
	wire [31:0] hex_display_in;
	
	
	//Assign Statements
	assign arduino_out = arduino_out_q;
	
	assign hex_display_in = (key_en) ? {28'b0, key_data} : hex_display_q;
	
	assign sram_addr = curr_state_sram;
	assign sram_data_a = (curr_state == SRAM_A) ? key_data : 4'bz;
	assign sram_data_b = (curr_state == SRAM_B) ? key_data : 4'bz;
	
	assign key_en = (curr_state == SRAM_A || curr_state == SRAM_B) ? 1'b1 : 1'b0;
	assign cs_a   = (curr_state == SRAM_A || curr_state == RESULT) ? 1'b1 : 1'b0;
	assign we_a   = ~(ns_button);
	assign we_b   = ~(ns_button);

	
	//Module Instances//
	//HEX Display
	hex_code hex0(.in(hex_display_in[07:00]), .out(hex0_disp));
	hex_code hex1(.in(hex_display_in[15:08]), .out(hex1_disp));
	hex_code hex2(.in(hex_display_in[23:16]), .out(hex2_disp));
	hex_code hex3(.in(hex_display_in[31:24]), .out(hex3_disp));
	
	//SRAM
	sram sram_a(.Cs_n(cs_a), .We_n(we_a), .Oe_n(oe_a), .Address(sram_addr), .IO(sram_data_a));
	sram sram_b(.Cs_n(cs_b), .We_n(we_b), .Oe_n(oe_b), .Address(sram_addr), .IO(sram_data_b));
	
	//Keyboard
	keyboard_read keyboard (.clk(clk), .rst(rst), .key_row(key_row), .key_col(key_col), .enable(key_en), .data_out(key_data));
	
	//FSMs
	
	// Seq Logic
	always @ (posedge clk or negedge rst)
	begin
	  if(!rst) 
	  begin
	    curr_state <= RESET;
		 curr_state_sram <= INPUT_0; 
	  end
	  else
	  begin 
	    curr_state <= next_state;
		 curr_state_sram <= next_state_sram;
	  end
	end
	
	//Combo Logic
	always @ (ns_button or curr_state or curr_state_sram)
	begin
	  
	  arduino_out_q = curr_state + curr_state_sram;
	  hex_display_q = 32'h0;
	  
	  case(curr_state)
	    RESET :
		   begin
			  hex_display_q = 32'hFFFF_FFFF; // BLANK 7-SegD
			  next_state = SRAM_A;
			  next_state_sram = INPUT_0;
			end
		 SRAM_A :
		   begin
			  case(curr_state_sram)
			    INPUT_0 :
				   begin
					  next_state = SRAM_A;
					  next_state_sram = INPUT_1;
					end
				 INPUT_1 :
				   begin
					  next_state = SRAM_A;
					  next_state_sram = INPUT_2;
					end 
				 INPUT_2 :
				   begin
					  next_state = SRAM_A;
					  next_state_sram = INPUT_3;
					end
				 INPUT_3 :
				   begin
					  next_state = SRAM_A;
					  next_state_sram = INPUT_4;
					end
				 INPUT_4 :
				   begin
					  next_state = SRAM_A;
					  next_state_sram = INPUT_5;
					end
				 INPUT_5 :
				   begin
					  next_state = SRAM_A;
					  next_state_sram = INPUT_6;
					end
				 INPUT_6 :
				   begin
					  next_state = SRAM_A;
					  next_state_sram = INPUT_7;
					end
				 INPUT_7 :
				   begin
					  next_state = SRAM_B;
					  next_state_sram = INPUT_0;
					end
			  endcase
			end
		 SRAM_B :
		   begin
			  next_state = RESULT;
			  next_state_sram = INPUT_0;
			end
		 RESULT : 
		   begin
			  next_state = RESULT;
			  next_state_sram = INPUT_0;
			end
	  endcase
	end
		
endmodule
