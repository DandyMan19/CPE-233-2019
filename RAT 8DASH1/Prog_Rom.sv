`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2019 05:14:16 PM
// Design Name: 
// Module Name: Prog_Rom
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


module Prog_Rom(
    input PROG_CLK,
    input [9:0] PROG_ADDR, 
    output reg [17:0] PROG_IR
    );
    
    (*rom_style = "{distributed | block}" *)
    reg [17:0] rom [0:1023];
    //initialize the rom with prog rom file
    initial 
    begin
        $readmemh("8a.mem", rom, 0, 1023);
    end
   always @ (posedge PROG_CLK)
       begin
       PROG_IR <= rom[PROG_ADDR];
       end
endmodule