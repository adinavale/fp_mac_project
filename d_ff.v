module d_ff(input clk, D, output reg Q);
  
  always @ (posedge clk)
  begin
    Q <= D;
  end
  
endmodule