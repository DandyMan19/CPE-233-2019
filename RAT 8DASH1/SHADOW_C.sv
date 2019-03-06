`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 12:30:26 AM
// Design Name: 
// Module Name: SHADOW_C
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


module SHADOW_C(
     input C,
     input FLG_SHAD_LD,
     input clk,
     output logic SHAD_C_FLG
     
    );
    
    logic C_TEMP_FLAG;
    
    always_ff @ (posedge clk)
    begin: SHAD_C
        if (FLG_SHAD_LD == 1'B1)
            C_TEMP_FLAG <= C;
        else
            C_TEMP_FLAG <= C_TEMP_FLAG;
    end
    
    assign SHAD_C_FLG = C_TEMP_FLAG;
    
endmodule
