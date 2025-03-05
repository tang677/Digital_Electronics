`timescale 1ns / 1ps

module tb_top();

///////////////////////////  parameter list ///////////////////////////
//CLK: 100MHz
parameter       periodCLK_2     = 5;

parameter       perioddump      = 10;
parameter       delay           = 1;
parameter       delay_in        = 2;


reg           CLK_TB         ;
reg           RSTN           ;
reg    [5:0]  data_in_0      ;
reg    [5:0]  data_in_1      ;
reg    [3:0]  alu_control    ;
wire   [5:0]  alu_result     ;


integer       i              ;
integer       j              ;
integer       k              ;
reg   [31:0]  ERROR          ;
reg   [31:0]  COUNT          ;

// CLK_TB //
initial
begin
  CLK_TB = 1'b0;
  #(perioddump);
  CLK_TB = 1'b1;
  forever
  begin
    CLK_TB = !CLK_TB;
    #(periodCLK_2);
  end
end

alu u_alu(
  .clk         (CLK_TB         ),
  .rstn        (RSTN           ),
  .data_in_0   (data_in_0      ),
  .data_in_1   (data_in_1      ),
  .alu_control (alu_control    ),
  .alu_result  (alu_result     )
);

 
initial begin
  $display("===================");
  $display("Start Test Scenario");
  $display("===================");
  global_reset();

  repeat(1)  @(posedge CLK_TB); #delay;

  //wait (result_1); i =16; #1; disp_error(result_0, 30); 
  repeat(1) @(posedge CLK_TB); #delay;



  repeat(10) @(posedge CLK_TB);#delay;
  
  
  /////////////////////////////////////////////////////////
  //Check all 16 opcodes for:                            //
  //data0: 6'h0, data1: 6'h0;                            //
  /////////////////////////////////////////////////////////
  COUNT          = 32'h1;
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h0; data_in_1=6'h0; alu_control=4'h0; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h00);//d0 + d1;
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h0; data_in_1=6'h0; alu_control=4'h1; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h00);//d0 - d1;
  
  
  /////////////////////////////////////////////////////////
  //Check all 16 opcodes for:                            //
  //data0: 6'h1, data1: 6'h0;                            //
  /////////////////////////////////////////////////////////
  COUNT          = 32'h2;
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h1; data_in_1=6'h0; alu_control=4'h0; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h01);//d0 + d1;   
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h1; data_in_1=6'h0; alu_control=4'h1; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h01);//d0 - d1;   
 
  /////////////////////////////////////////////////////////
  //Check all 16 opcodes for:                            //
  //data0: 6'hA, data1: 6'h3;                            //
  /////////////////////////////////////////////////////////
  COUNT          = 32'h3;
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'hA; data_in_1=6'h3; alu_control=4'h0; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h0D);//d0 + d1;   
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'hA; data_in_1=6'h3; alu_control=4'h1; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h07);//d0 - d1;   
  
  /////////////////////////////////////////////////////////
  //Check all 16 opcodes for:                            //
  //data0: 6'h3, data1: 6'hA;                            //
  /////////////////////////////////////////////////////////
  COUNT          = 32'h4;
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h3; data_in_1=6'hA; alu_control=4'h0; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h0D);//d0 + d1;   
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h3; data_in_1=6'hA; alu_control=4'h1; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h39);//d0 - d1;   
  
  /////////////////////////////////////////////////////////
  //Check all 16 opcodes for:                            //
  //data0: 6'h3A, data1: 6'hC;                           //
  /////////////////////////////////////////////////////////
  COUNT          = 32'h5;
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h3A; data_in_1=6'h0C; alu_control=4'h0; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h46);//d0 + d1;   
  repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h3A; data_in_1=6'h0C; alu_control=4'h1; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h2E);//d0 - d1;   
  
  /////////////////////////////////////////////////////////
  //Simulate all arithmetic/logic operation combinations.//
  //64*64*16 operations would be executed here.          //
  //But no automatic checking.                           //
  /////////////////////////////////////////////////////////
  for (i = 0; i < 64; i = i +1) 
  begin
    for (j = 0; j < 64; j = j +1)
    begin
      for (k = 0; k < 15; k = k +1)
      begin
        repeat(1) @(posedge CLK_TB); #delay_in; data_in_0 = i; data_in_1 = j; alu_control = k;
      end
    end
    repeat(1) @(posedge CLK_TB); #delay_in; COUNT = COUNT+1;
    repeat(1) @(posedge CLK_TB);
  end
  
  
  /////////////////////////////////////////////////////////
  //Simulate an error: 0+1 should be 1, but the expected //
  //value is 0                                           //
  //==> disp_error task gives an error, and stop         //
  //simulation                                           //
  /////////////////////////////////////////////////////////
  //repeat(1) @(posedge CLK_TB); #delay; data_in_0=6'h0; data_in_1=6'h1; alu_control=4'h0; repeat(1) @(posedge CLK_TB); #delay; disp_error(alu_result, 6'h00);

  /////////////////////////////////////////////////////////
  //End of simulation.                                   //
  /////////////////////////////////////////////////////////
  test_finish(ERROR);
  $stop;
end


task global_reset;
begin
  repeat(2)  @(posedge CLK_TB);   #delay;
  ERROR          = 32'h0;
  i              = 0;
  j              = 0;
  k              = 0;
  data_in_0      = 6'h0;
  data_in_1      = 6'h0;  
  alu_control    = 4'h0;  
  RSTN           = 1'b1;
  COUNT          = 32'h0;

  repeat(2)  @(posedge CLK_TB); #delay;
  RSTN          = 1'b0;
  
  repeat(2) @(posedge CLK_TB); #delay;
  RSTN          = 1'b1;

  //repeat(2) @(posedge CLK_TB);
 
end
endtask


task disp_error;
input   [31:0]  RD;
input   [31:0]  EXP;
begin
  if (RD !== EXP)
  begin
    ERROR = ERROR + 1;
    $display("==> disp_error: RD: %H, EXP: %H", RD, EXP);
    repeat(10)  @(posedge CLK_TB);
    test_finish(ERROR);
  end
end
endtask


// Test Scenario Finish
task test_finish;
input   [31:0]  ERROR;
begin
  $display ( " " );
  $display ( "                 \\\\\\|///" );
  $display ( "                \\ _   _ /" );
  $display ( "                ( @   @ )" );
  $display ( "+-----------o00o---(_)---o00o-------------+" );
  if ( ERROR == 32'h0 )
    $display ( "| *** Verilog_Simulation_PASS *** v(^o^)v |" );
  else
    $display ( "| *** Verilog_Simulation_FAIL *** /(x_x)? |" );
  $display ( "+-----------------------------------------+" );
  $display ( " " );
  repeat(50) @(posedge CLK_TB);
  $stop;
//  $finish;
end

endtask

endmodule
