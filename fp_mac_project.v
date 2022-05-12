// FP MAC Project Top Module

`timescale 1ns / 1ps


module fp_mac_project(input clk, 
  input rst,
  input ns_button,
  input [3:0] row_in,
  
  output [3:0] col_out,
  output [4:0] arduino_out,
  
  output [7:0] hex0_disp,
  output [7:0] hex1_disp,
  output [7:0] hex2_disp,
  output [7:0] hex3_disp,
  
  output [9:0] led
);
  
  
  //###########################################################################
  //Parameters
  //###########################################################################
  
  parameter RESET = 2'b00, SRAM_A = 2'b01, SRAM_B = 2'b10, RESULT = 2'b11;
  parameter INPUT_0 = 3'b000, INPUT_1 = 3'b001, INPUT_2 = 3'b010, INPUT_3 = 3'b011, INPUT_4 = 3'b100, INPUT_5 = 3'b101, INPUT_6 = 3'b110, INPUT_7 = 3'b111; 
  
  //###########################################################################
  //Regs and Wires
  //###########################################################################
  
  reg [1:0]  curr_state, next_state;
  reg [2:0]  curr_state_sram, next_state_sram;
  
  wire clk_1mhz;
  wire ns_button_db;
  wire [15:0] hex_display_in;
  
  wire key_en;
  
  wire cs_a, we_a, oe_a;
  wire cs_b, we_b, oe_b;
  wire [3:0] sram_addr; 
  wire [15:0] key_data, sram_data_a, sram_data_b;
  
  wire mac_en;
  wire [3:0] mac_counter;
  wire [15:0] mac_result;
  
  //###########################################################################
  // Assign Statements
  //###########################################################################
  
  assign arduino_out = {curr_state, curr_state_sram};
  
  assign hex_display_in = (curr_state == RESET) ? 16'h0 :
                          (curr_state == SRAM_A || curr_state == SRAM_B) ? key_data : mac_result;
  
  assign key_en = (curr_state == SRAM_A || curr_state == SRAM_B) ? 1'b1 : 1'b0;
  
  assign led = {4'b0, clk_1mhz, key_en, key_data[3:0]};
  
  assign sram_addr = (curr_state == RESULT) ? mac_counter : curr_state_sram;
  
  assign sram_data_a = (curr_state == SRAM_A) ? key_data : 16'hz;
  assign sram_data_b = (curr_state == SRAM_B) ? key_data : 16'hz;
  
  assign cs_a   = (curr_state == SRAM_A || curr_state == RESULT) ? 1'b0 : 1'b1;
  assign cs_b   = (curr_state == SRAM_B || curr_state == RESULT) ? 1'b0 : 1'b1;
  assign we_a   = (curr_state == SRAM_A) ? ns_button : 1'b1;
  assign we_b   = (curr_state == SRAM_B) ? ns_button : 1'b1;
  assign oe_a   = (curr_state == RESULT) ? 1'b0 : 1'b1; 
  assign oe_b   = (curr_state == RESULT) ? 1'b0 : 1'b1; 
  
  assign mac_en = (curr_state == RESULT) ? 1'b1 : 1'b0;
  
  //###########################################################################
  // Module instances
  //###########################################################################
  
  //clk_div
  clock_div clk_div(.clk(clk), .rst(rst), .div_clk(clk_1mhz));
  
  //Debounce
  debounce db_ns_button(.clk(clk), .in(ns_button), .out(ns_button_db));
  
  //HEX Display
  hex_code hex0(.in(hex_display_in[03:00]), .out(hex0_disp));
  hex_code hex1(.in(hex_display_in[07:04]), .out(hex1_disp));
  hex_code hex2(.in(hex_display_in[11:08]), .out(hex2_disp));
  hex_code hex3(.in(hex_display_in[15:12]), .out(hex3_disp));
  
  //Keypad
  keypad_scanner keypad(.clk(clk), .rst(key_en), .row_in(row_in), .col_out(col_out), .val(key_data));
  
  //SRAM
  sram sram_a(.Cs_n(cs_a), .We_n(we_a), .Oe_n(oe_a), .Address(sram_addr), .IO(sram_data_a));
  sram sram_b(.Cs_n(cs_b), .We_n(we_b), .Oe_n(oe_b), .Address(sram_addr), .IO(sram_data_b));
  
  //MAC
  mac_wrapper mac_wap(.clk(clk), .reset(mac_en), .A(sram_data_a), .B(sram_data_b), .counter(mac_counter),.mac_result(mac_result));

  
  //###########################################################################
  // State Machines
  //###########################################################################  
  
  // Seq Logic
  always @ (negedge rst or negedge ns_button_db)
  begin
    if(rst == 0) 
    begin
      curr_state <= RESET;
      curr_state_sram <= INPUT_0;
    end
    else
    begin 
      curr_state <= next_state;
      curr_state_sram <= next_state_sram;
    end
  end
  
  //Combo Logic
  always @ (curr_state or curr_state_sram)
  begin
    
    case(curr_state)
      RESET :
      begin
        next_state = SRAM_A;
        next_state_sram = INPUT_0;
      end
      SRAM_A :
      begin
        case(curr_state_sram)
          INPUT_0 :
          begin
            next_state = SRAM_A;
            next_state_sram = INPUT_1;
          end
          INPUT_1 :
          begin
            next_state = SRAM_A;
            next_state_sram = INPUT_2;
          end 
          INPUT_2 :
          begin
            next_state = SRAM_A;
            next_state_sram = INPUT_3;
          end
          INPUT_3 :
          begin
            next_state = SRAM_A;
            next_state_sram = INPUT_4;
          end
          INPUT_4 :
          begin
            next_state = SRAM_A;
            next_state_sram = INPUT_5;
          end
          INPUT_5 :
          begin
            next_state = SRAM_A;
            next_state_sram = INPUT_6;
          end
          INPUT_6 :
          begin
            next_state = SRAM_A;
            next_state_sram = INPUT_7;
          end
          INPUT_7 :
          begin
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
            next_state = SRAM_B;
            next_state_sram = INPUT_1;
          end
          INPUT_1 :
          begin
            next_state = SRAM_B;
            next_state_sram = INPUT_2;
          end 
          INPUT_2 :
          begin
            next_state = SRAM_B;
            next_state_sram = INPUT_3;
          end
          INPUT_3 :
          begin
            next_state = SRAM_B;
            next_state_sram = INPUT_4;
          end
          INPUT_4 :
          begin
            next_state = SRAM_B;
            next_state_sram = INPUT_5;
          end
          INPUT_5 :
          begin
            next_state = SRAM_B;
            next_state_sram = INPUT_6;
          end
          INPUT_6 :
          begin
            next_state = SRAM_B;
            next_state_sram = INPUT_7;
          end
          INPUT_7 :
			 begin
            next_state = RESULT;
            next_state_sram = INPUT_0;
          end
        endcase
 
      end
      RESULT : 
      begin
        next_state = RESULT;
        next_state_sram = INPUT_7;
      end
    endcase
  end
  
endmodule
