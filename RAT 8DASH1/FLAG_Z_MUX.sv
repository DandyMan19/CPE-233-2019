`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 12:44:14 AM
// Design Name: 
// Module Name: FLAG_Z_MUX
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


module FLAG_Z_MUX(
        input Z_IN,
        input SHAD_Z,
        input FLG_LD_SEL,
        output logic Z_FLAG_OUT
    );
    
    always_comb
        begin
            case(FLG_LD_SEL)
                1'b0: Z_FLAG_OUT = Z_IN;
                1'B1: Z_FLAG_OUT = SHAD_Z;
            default:
                Z_FLAG_OUT = Z_IN;
            endcase
        end
endmodule
