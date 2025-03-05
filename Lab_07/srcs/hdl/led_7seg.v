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
module led_7seg(
  input              clk,
  input              rstn,
  input       [31:0] led_data_in,
  input              scan_up,
  input              scan_down,
  output reg  [ 6:0] led_a2g,
  output reg  [ 7:0] an,
  output wire        dp,
  output reg  [ 4:0] sel_pos
);
   
reg  [ 2:0] digi_sel;
wire [ 4:0] sel_pos_max;
wire [ 4:0] sel_pos_min;
reg  [ 3:0] digit;
reg  [31:0] clkdiv;
reg         scan_up_p1;
reg         scan_up_p2;
reg         scan_down_p1;
reg         scan_down_p2;

assign dp = 1;

always @(posedge clk or negedge rstn) begin
  if (!rstn)
  begin
    clkdiv <= 32'h0;
  end
  else
  begin
    clkdiv <= clkdiv+1;
  end
end

assign sel_pos_max = 5'd28;
assign sel_pos_min = 5'd10;
always @(posedge clk or negedge rstn) begin
  if (!rstn)
  begin
    scan_up_p1 <= 1'b0;
    scan_up_p2 <= 1'b0;
  end
  else
  begin
    scan_up_p1 <= scan_up;
    scan_up_p2 <= scan_up_p1;
  end
end

always @(posedge clk or negedge rstn) begin
  if (!rstn)
  begin
    scan_down_p1 <= 1'b0;
    scan_down_p2 <= 1'b0;
  end
  else
  begin
    scan_down_p1 <= scan_down;
    scan_down_p2 <= scan_down_p1;
  end
end


always @(posedge clk or negedge rstn) begin
  if (!rstn)
  begin
    sel_pos  <= 5'd17;
  end
  else
  begin
    if (scan_up&&(!scan_up_p1)&&(!scan_up_p2))
    begin
      if (sel_pos>=sel_pos_min)
      begin
        sel_pos <= sel_pos - 1'b1;
      end
    end
    else if (scan_down&&(!scan_down_p1)&&(!scan_down_p2))
    begin
      if (sel_pos<=sel_pos_max)
      begin
        sel_pos <= sel_pos + 1'b1;
      end
    end
  end
end

always @(posedge clk or negedge rstn) begin
  if (!rstn)
  begin
    digi_sel <= 3'h0;
  end
  else
  begin
    case(sel_pos)
      10: digi_sel <= clkdiv[12:10];
      11: digi_sel <= clkdiv[13:11];
      12: digi_sel <= clkdiv[14:12];
      13: digi_sel <= clkdiv[15:13];
      14: digi_sel <= clkdiv[16:14];
      15: digi_sel <= clkdiv[17:15];
      16: digi_sel <= clkdiv[18:16];
      17: digi_sel <= clkdiv[19:17];
      18: digi_sel <= clkdiv[20:18];
      19: digi_sel <= clkdiv[21:19];
      20: digi_sel <= clkdiv[22:20];
      21: digi_sel <= clkdiv[23:21];
      22: digi_sel <= clkdiv[24:22];
      23: digi_sel <= clkdiv[25:23];
      24: digi_sel <= clkdiv[26:24];
      25: digi_sel <= clkdiv[27:25];
      26: digi_sel <= clkdiv[28:26];
      27: digi_sel <= clkdiv[29:27];
      28: digi_sel <= clkdiv[30:28];
      default: digi_sel <= clkdiv[19:17];
    endcase
    //digi_sel <= clkdiv[30:28];
  end
end


//According to digi_sel, assign correct display value
always @(digi_sel)
begin
  case(digi_sel)
  0: digit <= led_data_in[3:0];
  1: digit <= led_data_in[7:4];
  2: digit <= led_data_in[11:8];
  3: digit <= led_data_in[15:12];
  4: digit <= led_data_in[19:16];
  5: digit <= led_data_in[23:20];
  6: digit <= led_data_in[27:24];
  7: digit <= led_data_in[31:28];
  default: digit <= led_data_in[3:0];
  endcase
end



always @(posedge clk or negedge rstn) begin
  if (!rstn)
  begin
    an <= 8'b11111111;
  end
  else
  begin
    case(digi_sel)
    0: an <= 8'b11111110;
    1: an <= 8'b11111101;
    2: an <= 8'b11111011;
    3: an <= 8'b11110111;
    4: an <= 8'b11101111;
    5: an <= 8'b11011111;
    6: an <= 8'b10111111;
    7: an <= 8'b01111111;
    default: an <= 8'b11111111;
    endcase
  end
end

//         a  
//        __                    
//     f|    |b                 
//        g                      
//        __
//     e|    |c                 
//        __                      
//        d 
//////////<---MSB-LSB<---
//////////////gfedcba////////////////////////////////////////////
always @(digit)
begin
  case(digit)
    0  : led_a2g <= 7'b1000000; // 0                        
    1  : led_a2g <= 7'b1111001; // 1                        
    2  : led_a2g <= 7'b0100100; // 2                        
    3  : led_a2g <= 7'b0110000; // 3                        
    4  : led_a2g <= 7'b0011001; // 4                        
    5  : led_a2g <= 7'b0010010; // 5                         
    6  : led_a2g <= 7'b0000010; // 6
    7  : led_a2g <= 7'b1111000; // 7
    8  : led_a2g <= 7'b0000000; // 8
    9  : led_a2g <= 7'b0010000; // 9
    'hA: led_a2g <= 7'b0001000; // A
    'hB: led_a2g <= 7'b0000011; // b
    'hC: led_a2g <= 7'b1000110; // C
    'hD: led_a2g <= 7'b0100001; // d
    'hE: led_a2g <= 7'b0000110; // E
    'hF: led_a2g <= 7'b0001110; // F
    default: led_a2g <= 7'b1111111; // all black
  endcase
end

endmodule
