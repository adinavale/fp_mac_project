
module PulseCounter(
input Reset,
input Clock,
input In, 
output [3:0] Out
);

reg [3:0] Counter;
reg toggle;

// This module takes a bit input
// and returns the number of times 
// that input has been pulsed.
// It has an active low reset.
  
always @(posedge Clock, negedge Reset) begin
	if ( Reset == 0 ) 
		Counter <= 4'b0000;
	else begin
		if ((In==1) & (toggle==0)) begin
			Counter <= Counter + 1'b1;
			toggle <= 1;
	    end
		else if (In==0) begin
			toggle <= 0;
		end
	end
end
	
assign Out = Counter;

endmodule