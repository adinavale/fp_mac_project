module hex_code(input [4:0] in,
                output reg [7:0] out);

  always @ (in)
  begin
    case(in)
	    //              D654_3210            
	    5'h0 : out = 8'b1100_0000; // C0
		  5'h1 : out = 8'b1111_1001; // F9
		  5'h2 : out = 8'b1010_0100;
		  5'h3 : out = 8'b1011_0000;
		  5'h4 : out = 8'b1001_1001;
		  5'h5 : out = 8'b1001_0010;
		  5'h6 : out = 8'b1000_0011;
		  5'h7 : out = 8'b1111_1000;
		  5'h8 : out = 8'b1000_0000;
		  5'h9 : out = 8'b1001_0000;
		  5'hA : out = 8'b1000_1000;
		  5'hB : out = 8'b1000_0011;
		  5'hC : out = 8'b1100_0110;
		  5'hD : out = 8'b1010_0001;
		  5'hE : out = 8'b1000_0110;
		  5'hF : out = 8'b1000_1110;
		default :
	   begin	
		   out = 8'b1111_1111; 
	   end
	 endcase
  end
  
endmodule
