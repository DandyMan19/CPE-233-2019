`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2019 12:04:49 AM
// Design Name: 
// Module Name: RAT2_Core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PROG_COUNTER( 

       input  clk, PC_LD, PC_INC, RST,
       input  [1:0] PC_MUX_SEL, 
       input  [9:0] FROM_STACK, FROM_IMMED,
       output reg [9:0] PC_COUNT 
    );
       
       reg [9:0] DIN; //reg D_OUT is meant to be an input and output value.

       always @(PC_MUX_SEL, FROM_IMMED, FROM_STACK, DIN)
       begin 
            case (PC_MUX_SEL)
                2'b00 : DIN = FROM_IMMED;
                2'b01 : DIN = FROM_STACK;
                2'b10 : DIN = 10'h3FF;
                2'b11 : DIN = 0;
                default DIN = 0;
            endcase
       end
                
      always @(posedge clk)
        begin 
           if (RST == 1'b1)     
              PC_COUNT <= 0;
           else if (PC_LD == 1) 
              PC_COUNT <= DIN; 
           else if (PC_INC == 1)
              PC_COUNT <= PC_COUNT +1; 
        end  
endmodule
