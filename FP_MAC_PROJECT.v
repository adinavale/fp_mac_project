// FP MAC Project Top Module

`timescale 1ns / 1ps

module FP_MAC_PROJECT(input i_clk, 
                      input i_rst,
							 input i_push_btn,
							 input [7:0] i_keypad,
                      output [31:0] ssd,
				          output [4:0] reg arduino;
							 );
   
	// SRAM Connection
	wire cs_a, cs_b;
	wire we_a, we_b;
	wire oe_a, oe_b;
	wire [3:0] addr;
	wire [7:0] sram_io;
	
	// HEX Connections
	reg [3:0] hex0_in, hex1_in, hex2_in, hex3_in;
	
	// SRAM Instances
	sram sram_a(.Cs_n(cs_a), .We_n(we_a), .Oe_n(oe_a), .Address(addr), .IO(sram_io));
	sram sram_b(.Cs_n(cs_b), .We_n(we_b), .Oe_n(oe_b), .Address(addr), .IO(sram_io));
	
	//Hex display instances
	hex_code hex0(.in(), .out(ssd[7:0]));
   hex_code hex1(.in(), .out(ssd[15:8]));
   hex_code hex2(.in(), .out(ssd[23:16]))
   hex_code hex3(.in(), .out(ssd[31:24]))	
	
	// State Parameter
	parameter STATE_RST = 2'b00, STATE_SRAM_A = 2'b01, STATE_SRAM_B = 2'b10, STATE_MAC_CALC = 2'b11;
	
   // State Registers	
	reg [1:0] curr_state, next_state;

	// SM : Sequential Logic
   always @ (posedge i_push_btn or negedge i_rst)
   begin
	  if(i_rst == 0)
	  begin
	    curr_state <= STATE_RST;
	  end
	  else 
	  begin
	    curr_state <= next_state;
	  end
   end
	
	//SM :Combination Logic
	always @ (curr_state)
	begin
	  case(curr_state)
	    STATE_RST :
		   begin
			  // Display Reset on LCD
			  arduino = 5'b0_0000;
			  
			  // SET SSD to 0
			  hex0_in = 5'b1_0000;
			  hex1_in = 5'b1_0000;
			  hex2_in = 5'b1_0000;
			  hex3_in = 5'b1_0000;
			  
			  next_state = STATE_SRAM_A;
			end
		 STATE_SRAM_A :
		   begin
			  next_state = STATE_SRAM_B; 
			end
		 STATE_SRAM_B :
		   begin
			  next_state = STATE_MAC_CALC; 
			end
		 STATE_MAC_CALC :
		   begin
			  
			end
	  endcase
	end
endmodule 