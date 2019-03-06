`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 12:47:21 AM
// Design Name: 
// Module Name: SHADOW_Z
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


module SHADOW_Z(
     input Z,
     input FLG_SHAD_LD,
     input clk,
     output logic SHAD_Z_FLG
     
    );
    
    logic Z_TEMP_FLAG;
    
    always_ff @ (posedge clk)
    begin: SHAD_Z
        if (FLG_SHAD_LD == 1'B1)
            Z_TEMP_FLAG <= Z;
        else
            Z_TEMP_FLAG <= Z_TEMP_FLAG;
    end
    
    assign SHAD_Z_FLG = Z_TEMP_FLAG;
    
endmodule
