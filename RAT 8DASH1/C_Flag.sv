`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2019 08:01:09 PM
// Design Name: 
// Module Name: C_Flag
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


module C_Flag(
        input clk,
        input C,
        input C_CLEAR,
        input C_SET,
        input C_LD,
        output C_FLAG
    );
    reg TEMP_C_FLAG;
    
    always_ff @(posedge clk)
    begin
        if (C_CLEAR == 1)
            TEMP_C_FLAG <= 1'b0;    //clears carry
            
        else if (C_SET == 1)
            TEMP_C_FLAG <= 1'b1;    //sets carry
            
        else if (C_LD == 1)
            TEMP_C_FLAG <= C;  //the temp value holds the new value
            
    end
    
    assign C_FLAG = TEMP_C_FLAG;    //the new value is always storing the temp value in the ff.
      
endmodule
