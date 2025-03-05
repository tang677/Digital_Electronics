`timescale 1ns / 1ps
module alu(
  input             clk         ,//Input clock
  input             rstn        ,//A-sync reset signal, low active
  input      [5:0]  data_in_0   ,//ALU operand 0
  input      [5:0]  data_in_1   ,//ALU operand 1
  input      [3:0]  alu_control ,//ALU control signal, opcode
  output reg [5:0]  alu_result   //ALU result
);
// For internal signals
wire   [5:0]  result_0_add   ;//ALU result for opcode 0000: addtion;
wire   [5:0]  result_1_sub   ;//ALU result for opcode 0001: subtraction;


// Circuit implementation
assign result_0_add  = data_in_0 + data_in_1;
assign result_1_sub  = data_in_0 - data_in_1;

always @ (posedge clk or negedge rstn) begin
  if (!rstn) begin
    alu_result <= 6'h0;
  end
  else begin
    case (alu_control)
      4'b0000: alu_result <= result_0_add ;
      4'b0001: alu_result <= result_1_sub ;
   	default: alu_result <= 6'h0;
    endcase
  end
end

endmodule


