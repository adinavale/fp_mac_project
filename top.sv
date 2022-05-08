`include "FP_MAC_PROJECT.v"

`timescale 1ns / 1ps

module top();

  logic clk, rst;
  logic ns_button;
  logic [3:0] key_row, key_col;
  logic [4:0] arduino_out;
  logic [7:0] hex0_disp, hex1_disp, hex2_disp, hex3_disp;


  FP_MAC_PROJECT dut(.clk(clk), .rst(rst), .ns_button(ns_button), .key_row(key_row), .key_col(key_col),
      .arduino_out(arduino_out), .hex0_disp(hex0_disp), .hex1_disp(hex1_disp), .hex2_disp(hex2_disp), .hex3_disp(hex3_disp));

  initial
  begin
    #50ns;
    rst = 1;

    repeat(5) @ (posedge clk);
    ns_button = 0;
    @(negedge clk);
    ns_button = 1;


    repeat(100) @ (posedge clk);
    ns_button = 0;
    @(negedge clk);
    ns_button = 1;
  end

  initial
  begin
    #2000us;
    $finish;
  end


  always @ (key_col)
  begin
		if(key_col === 4'bzzz0) key_row = 4'b1111;
		if(key_col === 4'bzz0z) key_row = 4'b1111;
		if(key_col === 4'bz0zz) key_row = 4'b1101;
		if(key_col === 4'b0zzz) key_row = 4'b1111;
  end

  initial
  begin
    clk = 0;
    rst = 0;
    key_row = 4'b1111;
    ns_button = 1;
    forever #(10ns) clk = ~clk;
  end

  initial
  begin
    $dumpfile("waves.vcd");
    $dumpvars;
  end

endmodule
