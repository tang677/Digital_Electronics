`timescale 1ns / 1ps



module clkrst(
  input         CLK100MHZ   ,//On-board input clock
  input         rstn_btn    ,//On-board reset from button, HIGH active
  output        clk_out     ,//The working clk for the rest of circuit
  output        rstn         //The working reset for the rest of circuit, LOW active
);
// For I/O signals

// For internal signals

// Circuit implementation
assign rstn    = rstn_btn;
assign clk_out = CLK100MHZ;


endmodule


