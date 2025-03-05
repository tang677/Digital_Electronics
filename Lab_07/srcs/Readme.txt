This design is for DigiPen/SIT Mechtronics Systems MET1301 Digital Electronics Lab 7.

I/O signals:
alu_control: the bottom switch bits [15:12]
==> when the alu_control is 0: data_in_0 + data_in_1 
==> when the alu_control is 1: data_in_0 - data_in_1 
data_in_0  : the bottom switch bits [ 5:0]
data_in_1  : the bottom switch bits [11:6]
BTNC: display a fixed number on the 7-segment LED
BTNU: increase the 7-segment LED scan refreshing rate
BTND: decrease the 7-segment LED scan refreshing rate
BTNL: LED[5:0] displays ALU result (press) or 7-segment LED scan refreshing rate parameter (release): 
Refreshing indicator: 9 - 29, in decimal: 9 indicates the fastest refreshing rate, while 29 indicates the slowest refreshing rate;

Source code of this example:
https://github.com/tang677/Digital_Electronics.git