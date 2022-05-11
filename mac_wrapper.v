`ifdef VERIF
`include "mac.v"
`endif

module mac_wrapper(input clk, reset, 
  input [15:0] A, B,
  output reg [2:0] counter,
  output [15:0] mac_result);

  reg enable;

  //MAC
  MAC mac(.clk(clk), .rst(reset), .enable(enable), .A(A), .B(B), .ACC_Result(mac_result));
  
  always @ (posedge clk or posedge reset)
  begin
    if(reset)
    begin
      enable <= 0;
      counter <= 0;
    end
    else
    begin
      if(counter !== 3'b111)
      begin
        counter  <= counter + 1;
        enable <= 1; 
      end
      else
      begin
        counter <= counter;
        enable <= 0;
      end

    end
  end

endmodule
