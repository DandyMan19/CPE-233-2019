`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2019 11:50:21 PM
// Design Name: 
// Module Name: FLAG_C_MUX
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


module FLAG_C_MUX(
        input C_IN,
        input SHAD_C,
        input FLG_LD_SEL,
        output logic C_FLAG_OUT
    );
    
    always_comb
        begin
            case(FLG_LD_SEL)
                1'b0: C_FLAG_OUT = C_IN;
                1'B1: C_FLAG_OUT = SHAD_C;
            default:
                C_FLAG_OUT = C_IN;
            endcase
        end
endmodule
