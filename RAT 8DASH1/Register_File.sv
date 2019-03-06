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

module Register_File(
        input [7:0] DIN,
        input [4:0] ADRX, ADRY,
        input RF_WR,
        input clk,
        output reg [7:0] DX_OUT, DY_OUT
     );
     
   integer i;
   reg [7:0] ram [0:32];
    
   initial begin
    for (i=0; i<32; i = i + 1) begin
        ram[i] = 0;
    end
   end 
   
   always @(posedge clk) begin        
    if (RF_WR == 1'b1) begin
        ram[ADRX] <= DIN;
    end
     // DX_OUT <= ram[ADRX];          // this separates the DX_OUT and DY_OUT from the main ram module
      //DY_OUT <= ram[ADRY];            // also this is not on the same clock cycle
   end
   
    assign DX_OUT = ram[ADRX];    // this combines the DX_OUT and DY_OUT together with the ram module
    assign DY_OUT = ram[ADRY];      //this is on the same clock cycle and read asynchronously
    
endmodule
