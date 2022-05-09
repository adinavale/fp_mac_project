//MAC Module

module MAC (input clk, rst, enable, input [15:0] A, B, 
            output reg [15:0] ACC_Result);

  reg  [15:0] In1, In2;
  reg  [31:0] mult;

  // //Check for Saturation
  // case({in1[15],in2[15]})
	//	2'b00 : mult_norm = (mult[31:24] != 0) ? 16'h7FFF : mult[24:9];
	//	2'b01 : mult_norm = (mult[31:24] != 1) ? 16'h8001 : mult[24:9];
	//	2'b10 : mult_norm = (mult[31:24] != 1) ? 16'h8001 : mult[24:9];
	//	2'b11 : mult_norm = (mult[31:24] != 0) ? 16'h7FFF : mult[24:9];
  // endcase

  always @(posedge clk or posedge rst or posedge enable)
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
      if(enable)
      begin
        In1 <= A;
        In2 <= B;
        mult <= In1 * In2;
        ACC_Result <= ACC_Result + mult;
      end
      else
      begin
        In1 <= A;
        In2 <= B;
        mult <= mult;
        ACC_Result <= ACC_Result;
      end
    end
  end
    
endmodule
