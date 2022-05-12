module clock_div(input clk, rst,
                 output reg div_clk);

 reg [24:0] count;
 
 always @ (negedge clk)
 begin
	if(rst == 0)
	begin
	  count <= 0;
	  div_clk <= 0;
	end
	else
	begin
	  if(count == 25'd24_999_999)
	  begin
	    count <= 0;
		  div_clk <= ~div_clk;
	  end
	  else
	  begin
	    count <= count + 25'b1;
	  end
	end
 end
endmodule