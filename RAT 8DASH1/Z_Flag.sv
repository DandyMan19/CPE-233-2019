`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2019 08:01:32 PM
// Design Name: 
// Module Name: Z_Flag
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


module Z_Flag(
        input clk,
        input Z_LD,
        input Z,
        output wire Z_FLAG
    );
    reg TEMP_Z_FLAG;
    always_ff @ (posedge clk)
    begin
        if (Z_LD == 1'b1)
            TEMP_Z_FLAG <= Z;
    end
     
    assign Z_FLAG = TEMP_Z_FLAG;
      
endmodule
