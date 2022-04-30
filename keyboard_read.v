module keyboard_read(input clk, rst, enable,
                     input  [3:0]  key_row,
							output [3:0]  key_col,
                     output [15:0] data_out);

  //Nets and Regs
  reg key_ready_q;
  reg [15:0] data_q;
  
  wire key_read, key_ready;
  wire [3:0] key_data, press_cnt;
  
  //Assign statements
  assign key_read = enable & ~(key_ready_q);
  assign data_out = data_q;
  
  //Module Instances							
  KeyPadInterpreter key_intrp( .Clock(clk), .ResetButton(rst), .KeyRead(key_read), .RowDataIn(key_row), .KeyReady(key_ready), .DataOut(key_data), .ColDataOut(key_col), .PressCount(press_cnt));
  
  always @ (key_ready or key_data)
  begin
    if(key_ready == 0)
	 begin
	   key_ready_q <= key_ready;
	   data_q <= 16'b0;
	 end
	 else
	 begin
	   key_ready_q <= key_ready;
	   data_q [15:4] <= data_q[11:0];
		data_q [3:0]  <= key_data;
	 end
  end
  
  
endmodule 

