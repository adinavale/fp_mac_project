// FP MAC Project Top Module

`timescale 1ns / 1ps

`ifdef VERIF
`include "hex_code.v"
`include "sram.v"
`include "keypadscanner.v"
`include "mac_wrapper.v"
`endif

module FP_MAC_PROJECT(input clk, 
  input rst,
  input ns_button,
  
  input  [3:0] key_row,
  output [3:0] key_col,
  
  output [4:0] arduino_out,
  
  output [7:0] hex0_disp,
  output [7:0] hex1_disp,
  output [7:0] hex2_disp,
  output [7:0] hex3_disp);
  
  //Parameters
  parameter RESET = 2'b00, SRAM_A = 2'b01, SRAM_B = 2'b10, RESULT = 2'b11;
  parameter INPUT_0 = 3'b000, INPUT_1 = 3'b001, INPUT_2 = 3'b010, INPUT_3 = 3'b011, INPUT_4 = 3'b100, INPUT_5 = 3'b101, INPUT_6 = 3'b110, INPUT_7 = 3'b111; 
  
  //Regs and Wires
  reg [1:0]  curr_state, next_state, next_state_q;
  reg [2:0]  curr_state_sram, next_state_sram, next_state_sram_q;
  
  reg [4:0]  arduino_out_q;
  reg [19:0] hex_display_q;
  reg oe_a_q, oe_b_q;

  reg key_en;

  reg [2:0] mac_counter;
  
  wire cs_a, we_a, oe_a;
  wire cs_b, we_b, oe_b;
  wire wr_e;
  wire [3:0] sram_addr; 
  wire [15:0] key_data, sram_data_a, sram_data_b;
  
  wire [19:0] hex_display_in;

  wire mac_rst;
  wire [15:0] mac_result;
  
  //Assign Statements
  assign arduino_out = arduino_out_q;
  
  assign hex_display_in = (key_en) ? {1'b0, key_data[15:12], 1'b0, key_data[11:8], 1'b0, key_data[7:4], 1'b0, key_data[3:0] } : hex_display_q;
  
  assign sram_addr = curr_state_sram + mac_counter;
  assign sram_data_a = (curr_state == SRAM_A) ? key_data : 16'hz;
  assign sram_data_b = (curr_state == SRAM_B) ? key_data : 16'hz;
  assign cs_a   = (curr_state == SRAM_A || curr_state == RESULT) ? 1'b0 : 1'b1;
  assign cs_b   = (curr_state == SRAM_B || curr_state == RESULT) ? 1'b0 : 1'b1;
  assign we_a   = (curr_state == SRAM_A) ? ns_button : 1'b1;
  assign we_b   = (curr_state == SRAM_B) ? ns_button : 1'b1;
  assign oe_a   = (curr_state == RESULT) ? 1'b0 : 1'b1; 
  assign oe_b   = (curr_state == RESULT) ? 1'b0 : 1'b1; 
  
  assign mac_rst = (curr_state == RESULT) ? 1'b0 : 1'b1;


  //Module Instances//
  //HEX Display
  hex_code hex0(.in(hex_display_in[04:00]), .out(hex0_disp));
  hex_code hex1(.in(hex_display_in[09:05]), .out(hex1_disp));
  hex_code hex2(.in(hex_display_in[14:10]), .out(hex2_disp));
  hex_code hex3(.in(hex_display_in[19:15]), .out(hex3_disp));
  
  //SRAM
  sram sram_a(.Cs_n(cs_a), .We_n(we_a), .Oe_n(oe_a), .Address(sram_addr), .IO(sram_data_a));
  sram sram_b(.Cs_n(cs_b), .We_n(we_b), .Oe_n(oe_b), .Address(sram_addr), .IO(sram_data_b));
  
  //Keyboard
  KeyPadScanner keyboard (.Clock(clk), .reset(~key_en), .RowIn(key_row),   .ColOut(key_col),  .KeyRd(key_en),  .ready(wr_e), .mem_reg(key_data));

  //Mac_Wrapper 
 mac_wrapper mac_wrap(.clk(clk), .reset(mac_rst), .A(sram_data_a), .B(sram_data_b), .counter(mac_counter), .mac_result(mac_result));
  
  //FSMs
  
  // Seq Logic
  always @ (posedge clk or negedge rst or negedge ns_button)
  begin
    if(!rst) 
    begin
      curr_state <= RESET;
      curr_state_sram <= INPUT_0;
      next_state_q <= RESET;
      next_state_sram_q <= RESET;
    end
    else
    begin 
      if(ns_button == 0)
      begin
        next_state_q <= next_state;
        next_state_sram_q <= next_state_sram;
      end
        curr_state <= next_state_q;
        curr_state_sram <= next_state_sram_q;
    end
  end
  
  //Combo Logic
  always @ (curr_state or curr_state_sram)
  begin
    
    arduino_out_q = curr_state * 5'h8 + curr_state_sram;
    hex_display_q = 20'h0;
    key_en = 0;
    oe_a_q = 0;
    oe_b_q = 0;
    
    case(curr_state)
      RESET :
      begin
        hex_display_q = 20'hF_FFFF; // BLANK 7-SegD
        
        next_state = SRAM_A;
        next_state_sram = INPUT_0;
        
      end
      SRAM_A :
      begin
        case(curr_state_sram)
          INPUT_0 :
          begin
            key_en = 1;
            next_state = SRAM_A;
            next_state_sram = INPUT_1;
          end
          INPUT_1 :
          begin
            key_en = 1;
            next_state = SRAM_A;
            next_state_sram = INPUT_2;
          end 
          INPUT_2 :
          begin
            key_en = 1;
            next_state = SRAM_A;
            next_state_sram = INPUT_3;
          end
          INPUT_3 :
          begin
            key_en = 1;
            next_state = SRAM_A;
            next_state_sram = INPUT_4;
          end
          INPUT_4 :
          begin
            key_en = 1;
            next_state = SRAM_A;
            next_state_sram = INPUT_5;
          end
          INPUT_5 :
          begin
            key_en = 1;
            next_state = SRAM_A;
            next_state_sram = INPUT_6;
          end
          INPUT_6 :
          begin
            key_en = 1;
            next_state = SRAM_A;
            next_state_sram = INPUT_7;
          end
          INPUT_7 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_0;
          end
        endcase
      end
      SRAM_B :
      begin
        case(curr_state_sram)
          INPUT_0 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_1;
          end
          INPUT_1 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_2;
          end 
          INPUT_2 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_3;
          end
          INPUT_3 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_4;
          end
          INPUT_4 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_5;
          end
          INPUT_5 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_6;
          end
          INPUT_6 :
          begin
            key_en = 1;
            next_state = SRAM_B;
            next_state_sram = INPUT_7;
          end
          INPUT_7 :
          begin
            key_en = 1;
            next_state = RESULT;
            next_state_sram = INPUT_0;
          end
        endcase
 
      end
      RESULT : 
      begin
        next_state = RESULT;
        next_state_sram = INPUT_0;
      end
    endcase
  end
  
endmodule

