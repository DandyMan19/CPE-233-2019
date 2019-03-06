`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2019 08:00:47 PM
// Design Name: 
// Module Name: Flags
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


module Flags(
        input clk,
        input C,
        input C_CLEAR,
        input C_SET,
        input C_LD,
        input FLG_LD_SEL,
        input FLG_SHAD_LD,
        output logic C_FLAG,
        input Z_LD,
        input Z,
        output logic Z_FLAG       
    );
    
    logic SHAD_C_FLG;
    logic SHAD_Z_FLG;
    logic C_FLAG_OUT;
    logic C_TEMP_FLAG;
    logic Z_FLAG_OUT;
    logic Z_TEMP_FLAG;
    
    FLAG_C_MUX  FLAG_C_MUX(
    .C_IN   (C),
    .SHAD_C (SHAD_C_FLG),
    .FLG_LD_SEL (FLG_LD_SEL),
    .C_FLAG_OUT (C_FLAG_OUT)
    );
    
    C_Flag  UUT(
    .clk    (clk),
    .C      (C_FLAG_OUT),
    .C_CLEAR    (C_CLEAR),
    .C_SET  (C_SET),
    .C_LD   (C_LD),
    .C_FLAG (C_TEMP_FLAG)
    );
    
    SHADOW_C    SHAD_C(
    .C  (C_TEMP_FLAG),
    .FLG_SHAD_LD    (FLG_SHAD_LD),
    .clk    (clk),
    .SHAD_C_FLG    (SHAD_C_FLG)
    );
    
    Z_Flag  UUUT(
    .clk    (clk),
    .Z_LD   (Z_LD),
    .Z      (Z_FLAG_OUT),
    .Z_FLAG (Z_TEMP_FLAG)
    );
    
    FLAG_Z_MUX  FLAG_Z_MUX(
    .Z_IN  (Z),
    .SHAD_Z    (SHAD_Z_FLG),
    .FLG_LD_SEL    (FLG_LD_SEL),
    .Z_FLAG_OUT (Z_FLAG_OUT)
    );
    
    SHADOW_Z    SHADOW_Z(
    .Z  (Z_TEMP_FLAG),
    .FLG_SHAD_LD    (FLG_SHAD_LD),
    .clk    (clk),
    .SHAD_Z_FLG (SHAD_Z_FLG)
    );
    
    assign C_FLAG = C_TEMP_FLAG;
    assign Z_FLAG = Z_TEMP_FLAG;
    
endmodule
