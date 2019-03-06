`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2019 01:39:59 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0] SEL,    //signal to determine which instruction passes
    input [7:0] A,      //8 bit instruction to be performed with B
    input [7:0] B,      //8 bit instruction to be performed with A
    input CIN,          //carry value
    output reg [7:0] RESULT,    //output of the operation
    output reg C,       //result of certain operations that result in a carry
    output reg Z        //result of certain operations that result in a zero
    );
    
    reg [8:0] temp_result; //temperary result of 8 bit instruction with a flag hence 9bits
    
    always @(A, B, CIN, SEL) //dont include always_comb, otherwise verilof won't SIM.
        begin
            case(SEL)            
                4'b0000 : temp_result = ({1'b0,A}) + B; // does ADD
                4'b0001 : temp_result = (({1'b0,A}) + B + CIN); // does ADDC
                4'b0010 : temp_result = ({1'b1,A}) - ({1'b1,B}); // does SUB
                4'b0011 : temp_result = (({1'b1,A}) - ({1'b1,B}) - CIN); // does SUBC
                4'b0100 : temp_result = ({1'b1,A}) - ({1'b1,B}); //does CMP, why is this similiar to SUB?
                4'b0101 : temp_result = ({1'b0,(A & B)}); // does AND
                4'b0110 : temp_result = ({1'b0,(A | B)}); //does OR
                4'b0111 : temp_result = ({1'b0,(A ^ B)}); //does EXOR
                4'b1000 : temp_result = ({1'b0,(A & B)}); // does TEST, why is this the same as AND?
                4'b1001 : temp_result = ({A[7], A[6:0], CIN}); //does LSL
                4'b1010 : temp_result = ({1'b0, CIN, A[7:1]}); //does LSR
                4'b1011 : temp_result = ({A[7], A[6:0], A[7]}); // does ROL
                4'b1100 : temp_result = ({A[0], A[0], A[7:1]}); // does ROR
                4'b1101 : temp_result = ({A[0], A[7], A[7:1]}); //does ASR
                4'b1110 : temp_result = ({CIN, B}); // does MOV
                default: temp_result = 9'b000000000; //unused values
           endcase
          end
          
    assign RESULT = temp_result[7:0]; //sets RESULT to the performed instruction
    assign C = temp_result[8]; //sets the carry flag to the ninth bit of the temp_result
    
    always @(temp_result, SEL) begin
            if (temp_result[7:0] == 8'b00000000 && SEL[3:0] != 4'b1110)
                Z = 1'b1;
            else if (temp_result[7:0] != 8'b00000000 && SEL[3:0] != 4'b1110)
                Z = 1'b0;
            else
                Z = 0;
          end
               
endmodule
