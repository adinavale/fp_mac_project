module debounce(input clk, in,
                output out);
					 
	 wire Q1,Q2, Q0;

	  d_ff d0(clk, in, Q0);
     d_ff d1(clk, Q0, Q1 );
     d_ff d2(clk, Q1, Q2 );
	  
     assign out = Q1 & ~Q2;

endmodule