//MAC Module
module MAC (input clk, rst, 
            input signed [15:0] A, B, 
            output reg [15:0] acc_result);

  reg signed [15:0] In1, In2, mult_norm;
  reg signed [31:0] mult;

  always @(posedge clk or negedge rst)
  begin
    if(rst == 0)
    begin
      In1 <= 0;
      In2 <= 0;
      acc_result <= 0;
      mult <= 0;
      mult_norm <= 0;
    end
    else
    begin
      In1 <= A;
      In2 <= B;
      mult <= In1 * In2;
      mult_norm <= mult_norm_rnd(mult);
      acc_result <= add_norm(acc_result, mult_norm);
    end
  end
  
  function [15:0] mult_norm_rnd(input [31:0] num);
    begin
      
      mult_norm_rnd = 16'h0;

      if(num[9:6] != 4'b0100)
      begin
        num = num + (32'h1 << 8);
      end

      if(num[24] === 0 && num[31:24] !== 8'h0)
      begin
        mult_norm_rnd = 16'h7FFF;
      end
      else if(num[24] === 1 && num[31:24] !== 8'hFF)
      begin
        mult_norm_rnd = 16'h7FFF;
      end
      else
      begin
        mult_norm_rnd = num[24:9];
      end

    end
  endfunction


  function [15:0] add_norm(input [15:0] A, B);
    begin
      reg [16:0] sum;
      sum = A + B; 

      if(A[15] == 1'b1 && B[15] == 1'b1 && sum[15] == 1'b0)
      begin
        add_norm = 16'h8001;
      end
      else if(A[15] == 1'b0 && B[15] == 1'b0 && sum[15] == 1'b1)
      begin
        add_norm = 16'h7FFF;
      end
      else
      begin
        add_norm = sum[15:0];
      end

    end
  endfunction


endmodule

module mac_wrapper(input clk, reset, 
  input [15:0] A, B,
  output reg [4:0] counter,
  output [15:0] mac_result);

  reg enable;
  reg [15:0] A_q, B_q;

  //MAC
  MAC mac(.clk(clk), .rst(reset), .A(A_q), .B(B_q), .acc_result(mac_result));
  
  always @ (posedge clk or negedge reset)
  begin
    if(reset == 0)
    begin
      enable <= 0;
      counter <= 0;
      A_q <= 0;
      B_q <= 0;
    end
    else
    begin
      if(counter !== 4'b1010)
      begin
        counter  <= counter + 3'b1;
        enable <= 1'b1;
        A_q <= A;
        B_q <= B;
      end
      else
      begin
        counter <= counter;
        enable <= 1'b0;
        A_q <= 0;
        B_q <= 0;
      end
    end
  end

endmodule

