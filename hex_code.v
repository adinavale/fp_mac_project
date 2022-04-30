module hex_code(input [4:0] in,
                output reg [7:0] out);

  always @ (in)
  begin
    case(in)
	   //              D654_3210            
	   4'h0 : out = 8'b1100_0000;
		4'h1 : out = 8'b1111_1001;
		4'h2 : out = 8'b1010_0100;
		4'h3 : out = 8'b1011_0000;
		4'h4 : out = 8'b1001_1001;
		4'h5 : out = 8'b1001_0010;
		4'h6 : out = 8'b1000_0011;
		4'h7 : out = 8'b1111_1000;
		4'h8 : out = 8'b1000_0000;
		4'h9 : out = 8'b1001_0000;
		4'hA : out = 8'b1000_1000;
		4'hB : out = 8'b1000_0011;
		4'hC : out = 8'b1100_0110;
		4'hD : out = 8'b1010_0001;
		4'hE : out = 8'b1000_0110;
		4'hF : out = 8'b1000_1110;
		default :
	   begin	
		       out = 8'b1111_1111; 
	   end
	 endcase
  end
  
endmodule