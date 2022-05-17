module keypad_scanner(clk, rst, ColOut, RowIn, Data);
	input clk, rst;
	input [3:0] RowIn;
	output reg [3:0] ColOut;
	output reg [15:0] Data;
	reg [23:0] dbnc;

	always @(posedge clk or negedge rst)
  begin
		if (rst == 0)
    begin
			ColOut	<= 4'b1110;
			Data <= 4'h0;
			dbnc <= 0;

		end else begin
			if (RowIn != 4'b1111)
      begin
					if (dbnc != 24'hFFFFFF)
          begin
						dbnc <= dbnc + 1;
					end
          else
          begin
					  Data = Data << 4;
						Data[3:0] <= get_value(RowIn,ColOut);
						dbnc <= 0;
					end
			end
      else
      begin
				case(ColOut)
					4'b1110: ColOut <= 4'b1101;
					4'b1101: ColOut <= 4'b1011;
					4'b1011: ColOut <= 4'b0111;
					4'b0111: ColOut <= 4'b1110;
					default: ColOut <= 4'b1110;
				endcase
			end
		end
	end


	function [3:0] get_value;
		input [3:0] row, col;
		case ({row,col})
			8'b11101110: get_value = 4'hd;
			8'b11101101: get_value = 4'hF;
			8'b11101011: get_value = 4'h0;
			8'b11100111: get_value = 4'hE;
			8'b11011110: get_value = 4'hc;
			8'b11011101: get_value = 4'h9;
			8'b11011011: get_value = 4'h8;
			8'b11010111: get_value = 4'h7;
			8'b10111110: get_value = 4'hb;
			8'b10111101: get_value = 4'h6;
			8'b10111011: get_value = 4'h5;
			8'b10110111: get_value = 4'h4;
			8'b01111110: get_value = 4'hA;
			8'b01111101: get_value = 4'h3;
			8'b01111011: get_value = 4'h2;
			8'b01110111: get_value = 4'h1;
			default:	get_value = 4'h0;
		endcase
	endfunction
endmodule
