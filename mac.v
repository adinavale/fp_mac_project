//MAC Module

module MAC (input clk, rst, input [15:0] A, B, 
            output reg [15:0] ACC_Result);

  reg  [15:0] In1, In2;
  reg  [31:0] mult;


  always @(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      In1 <= 0;
      In2 <= 0;
      ACC_Result <= 0;
      mult <= 0;
    end
    else
    begin
      In1 <= A;
      In2 <= B;
      mult <= In1 * In2;
      ACC_Result <= ACC_Result + mult;
    end
  end
    
endmodule