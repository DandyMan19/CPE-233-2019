`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 01:06:46 AM
// Design Name: 
// Module Name: I_FLAG
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


module I_FLAG(
    input I_SET,
    input I_CLR,
    input clk,
    output logic I_FLAG_OUT
    );
    
    logic I_TEMP_FLAG;
    
    always_ff @(posedge clk)
    begin: I_FLAG
        if(I_CLR == 1'B1)
        begin
            I_TEMP_FLAG <= 1'B0;
        end
        else if (I_SET == 1'B1)
        begin
            I_TEMP_FLAG <= 1'b1;
        end
//        else
//        begin
//            I_TEMP_FLAG <= I_TEMP_FLAG;
//        end
    end
    
    assign I_FLAG_OUT = I_TEMP_FLAG;
    
endmodule
