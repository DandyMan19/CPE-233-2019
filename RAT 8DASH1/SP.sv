`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2019 11:03:28 AM
// Design Name: 
// Module Name: SP
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


module SP(
        input RST, SP_LD, SP_INCR, SP_DECR, clk,
        input [7:0] DATA_IN, 
        output [7:0] SP_DATA_OUT
    );
    
    logic [7:0] temp_DATA;
    
    always @(posedge clk)
    begin
        if (RST == 1'b1)
            temp_DATA <= 8'b00000000;
        else if (SP_LD == 1'b1)
            temp_DATA <= DATA_IN;
        else if (SP_INCR == 1'b1)
            temp_DATA <= temp_DATA + 1;
        else if (SP_DECR == 1'b1)
            temp_DATA <= temp_DATA - 1;
        else
            temp_DATA <= temp_DATA;
    end
    
    assign SP_DATA_OUT = temp_DATA;
    
endmodule
