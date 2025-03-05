`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project: MET1301 lab 7 example
// Description: This example shows a primitive ALU for 6 bits addition/subtraction
//              and LED display.
// Author: Tang Liang
// -------------------------------------------------------------------------------
// Revision History
// Author    Version Date       Info
// Tang      V1.0    23-Feb-25  Initial version
//////////////////////////////////////////////////////////////////////////////////
module Nexys4_ALU_Top(
//CLK Input
  input CLK100MHZ,
  input CPU_RESETN,
   
//Push Button Inputs   
  input BTNC,
  input BTNU,
  input BTND,
  input BTNR,
  input BTNL,
   
// Slide Switch Inputs
  input [15:0] SW, 
  
// LED Outputs
  output [15:0] LED,
  output  LED16_B,  //3 color LED 
  output  LED16_G,  //
  output  LED16_R,  //
  output  LED17_B,  //
  output  LED17_G,  //
  output  LED17_R,  //
  
// Seven Segment Display Outputs
  output CA,
  output CB,
  output CC,
  output CD,
  output CE,
  output CF,
  output CG,
  output [7:0] AN, 
  output DP
);

//Clock & reset signals
wire          clk_main       ;
wire          rstn           ;

//ALU signals
wire   [5:0]  data_in_0      ;
wire   [5:0]  data_in_1      ;
wire   [3:0]  alu_control    ;
wire   [5:0]  alu_result     ;

//Test signals
wire          test_disp_fix  ;//Test signal: display a fixed/predefined number
wire          test_disp_sw   ;//Test signal: display switch
wire          test_scan_up   ;//Test signal: increase 7 segment display scanning rate
wire          test_scan_down ;//Test signal: decrease 7 segment display scanning rate
wire          test_color     ;//Test signal: 
wire   [31:0] disp_fix_num   ;//The fixed 7 segment LED display number: 0x12345678

//Seven Segment Display Signal
wire   [ 6:0] seg            ;//Single digit 7 segment LED
wire   [31:0] disp_num       ;//Display number, input to seg7 to define segment pattern
wire   [ 4:0] seg_sel_pos    ;

// Circuit implementation
assign test_disp_fix  = BTNC;
assign test_disp_sw   = BTNL;
assign test_scan_up   = BTNU;
assign test_scan_down = BTND;
assign test_color     = BTNR;

assign data_in_0    = SW[ 5: 0];
assign data_in_1    = SW[11: 6];
assign alu_control  = SW[15:12];

assign CA = seg[0];
assign CB = seg[1];
assign CC = seg[2];
assign CD = seg[3];
assign CE = seg[4];
assign CF = seg[5];
assign CG = seg[6];

assign disp_fix_num = 32'h12345678;
assign disp_num = test_disp_fix? disp_fix_num : {26'h0, alu_result};

assign LED[15:6] = SW[15:6];
//assign LED[ 5:0] = test_disp_sw? alu_result : SW[ 5:0];
assign LED[ 5:0] = test_disp_sw? alu_result : {1'b1,seg_sel_pos};

assign LED16_B = SW[0];
assign LED16_G = SW[1];
assign LED16_R = test_color;
assign LED17_B = test_color;
assign LED17_G = SW[6];
assign LED17_R = SW[7];

clkrst u_clkrst(
  .CLK100MHZ   (CLK100MHZ      ),
  .rstn_btn    (CPU_RESETN     ),
  .clk_out     (clk_main       ),
  .rstn        (rstn           ) 
);

alu u_alu(
  .clk         (clk_main       ),
  .rstn        (rstn           ),
  .data_in_0   (data_in_0      ),
  .data_in_1   (data_in_1      ),
  .alu_control (alu_control    ),
  .alu_result  (alu_result     )
);

led_7seg u_led_7seg (
  .clk         (clk_main       ),
  .rstn        (rstn           ),
  .led_data_in (disp_num       ),
  .scan_up     (test_scan_up   ),
  .scan_down   (test_scan_down ),
  .led_a2g     (seg            ),
  .an          (AN             ),
  .dp          (DP             ),
  .sel_pos     (seg_sel_pos    )
);

endmodule