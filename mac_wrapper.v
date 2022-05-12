module mac_wrapper(input clk, reset, 
  input [15:0] A, B,
  output reg [3:0] counter,
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
      if(counter !== 4'b1000)
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

