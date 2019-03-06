`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2019 11:37:59 PM
// Design Name: 
// Module Name: Register_File
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

module Scratch_RAM(
        input [9:0] DATA_IN,
        input [7:0] SCR_ADDR,
        input SCR_WE,
        input clk,
        output reg [9:0] DATA_OUT
     );
   
   integer i;
   reg [9:0] ram [255:0];
    
   initial begin
    for (i=0; i<256; i = i + 1) begin
        ram[i] = 0;
    end
   end
   
   always @(posedge clk) begin        
    if (SCR_WE == 1'b1) begin
        ram[SCR_ADDR] <= DATA_IN;
    end
     // DX_OUT <= ram[ADRX];          // this separates the DX_OUT and DY_OUT from the main ram module
      //DY_OUT <= ram[ADRY];            // also this is not on the same clock cycle
   end
   
    assign DATA_OUT = ram[SCR_ADDR];    // this combines the DX_OUT and DY_OUT together with the ram module
endmodule