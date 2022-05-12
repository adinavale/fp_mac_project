module multiplier(input [15:0] in1, in2, en,
                  output reg [15:0] result);
						
  reg [31:0] mult, mult_norm;
			
   always @ (posedge en)
   begin	
	  mult = in1 * in2;
	  mult_norm = mult + (32'b1 << 8); // Rounding
	  mult_norm = mult_norm >> 9; 
		  
	  case({in1[15],in2[15]})
		 2'b00 : result = (mult[31:24] != 0) ? 16'h7FFF : mult[24:9];
		 2'b01 : result = (mult[31:24] != 1) ? 16'h8001 : mult[24:9];
		 2'b10 : result = (mult[31:24] != 1) ? 16'h8001 : mult[24:9];
		 2'b11 : result = (mult[31:24] != 0) ? 16'h7FFF : mult[24:9];
	  endcase
	end
	
endmodule