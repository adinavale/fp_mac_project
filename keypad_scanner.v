module keypad_scanner(clk, rst, col_out, row_in, val);
	input clk, rst;
	input [3:0] row_in;
	output reg [3:0] col_out;
	output reg [15:0] val;
	
	reg test_LED;
	reg ready;

	reg [23:0] debounce;
	

	always @(posedge clk or negedge rst) begin
		if (rst == 0) begin
			ready <= 0;
			col_out	<= 4'b1110;
			val <= 4'h0;
			test_LED <= 0;
			debounce <= 0;
			
		end else begin
			if (row_in != 4'b1111) begin
			
					if (debounce != 24'hFFFFFF) begin//if a key is pressed set the value of its row and column to val
						debounce <= debounce + 1;
					end else begin
					   val = val << 4;
						val[3:0] <= get_value(row_in,col_out);
						ready <= 1;
						debounce <= 0;
					end
			end else begin							//if no key is pressed, scan the col, turn on 
				ready <= 0; 
				test_LED <= 1;
				case(col_out) 
					4'b1110: col_out <= 4'b1101;
					4'b1101: col_out <= 4'b1011;
					4'b1011: col_out <= 4'b0111;
					4'b0111: col_out <= 4'b1110;
					default: col_out <= 4'b1110;
				endcase
			end
		end
	end

	
	function [3:0] get_value;
		input [3:0] row, col;
		case ({row,col})
			8'b11101110: // row 1, col 1
				get_value = 4'hd;
			8'b11101101: // row 1, col 2
				get_value = 4'hF;
			8'b11101011: // row 1, col 3
				get_value = 4'h0;
			8'b11100111: // row 1, col 4
				get_value = 4'hE;

			8'b11011110: // row 2, col 1
				get_value = 4'hc;
			8'b11011101: // row 2, col 2
				get_value = 4'h9;
			8'b11011011: // row 2, col 3
				get_value = 4'h8;
			8'b11010111: // row 2, col 4
				get_value = 4'h7;

			8'b10111110: // row 3, col 1
				get_value = 4'hb;
			8'b10111101: // row 3, col 2
				get_value = 4'h6;
			8'b10111011: // row 3, col 3
				get_value = 4'h5;
			8'b10110111: // row 3, col 4
				get_value = 4'h4;

			8'b01111110: // row 4, col 1
				get_value = 4'hA;
			8'b01111101: // row 4, col 2
				get_value = 4'h3;
			8'b01111011: // row 4, col 3
				get_value = 4'h2;
			8'b01110111: // row 4, col 4
				get_value = 4'h1;
			default:	 // should never occur
				get_value = 4'h0;	
			endcase
	endfunction
			
	
endmodule
