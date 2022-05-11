//MAC Module

module MAC (input clk, rst, enable, input [15:0] A, B, 
            output reg [15:0] ACC_Result);

  reg  [15:0] In1, In2;
  reg  [31:0] mult;
  reg  [15:0] mult_norm;

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
        mult_norm <= mult_sat_n_rnd(mult);
        ACC_Result <= add_n_sat(ACC_Result, mult_norm);
      end
      else
      begin
        In1 <= A;
        In2 <= B;
        mult <= mult;
        mult_norm <= mult_norm;
        ACC_Result <= ACC_Result;
      end
    end
  end

  function [15:0] mult_sat_n_rnd(input [31:0] num);
    begin
       num = num + (32'b1 << 9); //+K 9=Q_Dec

       if ((num >> 9) > 16'h7FFF)
          mult_sat_n_rnd = 16'h7FFF;
	     else if ((num >> 9) < (16'h8000 * -16'h1))
         mult_sat_n_rnd = 16'h8001;
       else 
         mult_sat_n_rnd = num[15:0];
    end
  endfunction

  function [15:0] add_n_sat(input [15:0] A, B);
    begin
      bit [31:0] tmp, a_32, b_32;

      a_32 = A;
      b_32 = B;

      tmp = a_32 + b_32;

      if (tmp > 32'h7FFF)
        add_n_sat = 16'h7FFF;
      else if (tmp < (32'h8000 * -32'h1))
        add_n_sat = 16'h8001;
      else
        add_n_sat = tmp[15:0]; 
    end
  endfunction
    
endmodule
