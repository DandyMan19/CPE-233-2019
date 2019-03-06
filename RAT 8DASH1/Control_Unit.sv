`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 01:57:14 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input clk, C_FLAG, Z_FLAG, INTV, RESET,
    input [4:0] OPCODE_HI_5,
    input [1:0] OPCODE_LOW_2,
    output reg RST,
    output reg I_SET, I_CLR,
    output reg PC_LD, PC_INC,
    output reg [1:0] PC_MUX_SEL,
    output reg ALU_OPY_SEL,
    output reg [3:0] ALU_SEL,
    output reg RF_WR,
    output reg [1:0] RF_WR_SEL,
    output reg SP_LD, SP_INCR, SP_DECR,
    output reg SCR_WE, SCR_DATA_SEL,
    output reg [1:0] SCR_ADDR_SEL, 
    output reg C_CLEAR, C_LD, C_SET, Z_LD,
    output reg FLG_LD_SEL, FLG_SHAD_LD,
    output reg IO_STRB
    );
    
    parameter [1:0] ST_IN_STATE = 0;
    parameter [1:0] ST_FET_STATE = 1;
    parameter [1:0] ST_EXE_STATE = 2;
    parameter [1:0] ST_INT_STATE = 3;
    
    reg [1:0] PS;
    reg [1:0] NS;
    reg [6:0] SIG_OPCODE_7BITS;
    wire [5:0] EXEC_STATE;

    always_ff @(posedge clk)//,posedge RESET
    begin
       PS <= NS;
       if (RESET == 1'b1)
        PS <= ST_IN_STATE;
       end
       
    always @(OPCODE_HI_5, OPCODE_LOW_2, PS, INTV, C_FLAG, Z_FLAG, SIG_OPCODE_7BITS)
        begin
            SIG_OPCODE_7BITS = {OPCODE_HI_5, OPCODE_LOW_2};
            RST = 1'b0;
            I_SET = 1'b0;
            I_CLR = 1'b0;
            PC_LD = 1'b0;
            PC_INC = 1'b0;
            PC_MUX_SEL = 2'b00;
            ALU_OPY_SEL = 1'b0;
            ALU_SEL = 4'b0000;
            RF_WR = 1'b0;
            RF_WR_SEL = 2'b00;
            SP_LD = 1'b0;
            SP_INCR = 1'b0;
            SP_DECR = 1'b0;
            SCR_WE = 1'b0; 
            SCR_DATA_SEL = 1'b0;
            SCR_ADDR_SEL = 2'b00;
            C_CLEAR  = 1'b0;
            C_LD = 1'b0;
            C_SET = 1'b0;
            Z_LD = 1'b0;
            FLG_LD_SEL = 1'b0;
            FLG_SHAD_LD = 1'b0;
            IO_STRB = 1'b0;
       case(PS)
        ST_IN_STATE:
            begin
             NS = ST_FET_STATE;
             RST = 1'b1;
            end
        ST_FET_STATE:
            begin
             NS = ST_EXE_STATE;
             PC_INC = 1'b1;
            end
            
        ST_INT_STATE:
           begin
                NS = ST_FET_STATE;
                PC_LD = 1'B1;
                PC_MUX_SEL = 2'B10;
                SCR_WE = 1'B1;
                SCR_DATA_SEL = 1'B1;
                SCR_ADDR_SEL = 2'B11;
                SP_DECR = 1'B1;
                FLG_SHAD_LD = 1'B1;
                I_CLR = 1'B1;
            end
        ST_EXE_STATE:
            begin
             NS = ST_FET_STATE;
             case(SIG_OPCODE_7BITS)
                7'b0000100: //ADD REG-REG TYPE
                begin
                    ALU_SEL = 4'b0000;
                    RF_WR = 1'b1;
                    C_LD = 1'b1;
                    Z_LD = 1'b1;
                end
               7'b1010000, 7'b1010001, 7'b1010010, 7'b1010011: //ADD REG-IMMED TYPE
               begin
                   ALU_SEL = 4'b0000;
                   ALU_OPY_SEL = 1'b1;
                   RF_WR = 1'b1;
                   C_LD = 1'b1;
                   Z_LD = 1'b1;
               end
               7'b0000101: //ADDC REG-REG TYPE
               begin
                   ALU_SEL = 4'b0001;
                   RF_WR = 1'b1;
                   C_LD = 1'b1;
                   Z_LD = 1'b1;
               end
               7'b1010100, 7'b1010101, 7'b1010110, 7'b1010111: //ADDC REG-IMMED TYPE
               begin
                   ALU_SEL = 4'b0001;
                   ALU_OPY_SEL = 1'b1;
                   RF_WR = 1'b1;
                   C_LD = 1'b1;
                   Z_LD = 1'b1;
              end
              7'b0000000: //AND REG-REG TYPE
               begin
                   ALU_SEL = 4'b0101;
                   RF_WR = 1'b1;
                   C_CLEAR = 1'b1;
                   Z_LD = 1'b1;
               end
               7'b1000000, 7'b1000001, 7'b1000010, 7'b1000011://AND REG-IMMED TYPE
               begin
                   ALU_SEL = 4'b0101;
                   ALU_OPY_SEL = 1'b1;
                   RF_WR = 1'b1;
                   C_CLEAR = 1'b1;
                   Z_LD = 1'b1;
              end
              7'b0100100:   //ASR REG-REG TYPE
               begin
                   ALU_SEL = 4'b1101;
                   RF_WR = 1'b1;
                   C_LD = 1'b1;
                   Z_LD = 1'b1;
               end
               7'b0010101:  //BRCC
               begin
                if (C_FLAG == 1'b0)
                    PC_LD = 1'b1;
                else
                    PC_LD = 1'b0;
               end 
               7'b0010100:    //BRCS
               begin
                if (C_FLAG == 1'b1)
                    PC_LD = 1'b1;
                else
                    PC_LD = 1'b0;
              end
              7'b0010000:    //BRN
               begin
                    PC_LD = 1'b1;
              end
              7'b0010010:  //BREQ  
               begin
                if (Z_FLAG == 1'b1)
                    PC_LD = 1'b1;
                else
                    PC_LD = 1'b0;
              end
              7'b0010011:    //BRNE
               begin
                if (Z_FLAG == 1'b0)
                    PC_LD = 1'b1;
                else
                    PC_LD = 1'b0;
              end
              7'b0110000:    //CLC
               begin
                    RF_WR = 1'b1;
                    C_CLEAR = 1'b1;
              end
              7'b0001000:    //CMP REG-REG
               begin
                    ALU_SEL = 4'b0100;
                    C_LD = 1'b1;
                    Z_LD = 1'b1;
              end
              7'b1100000, 7'b1100001, 7'b1100010, 7'b1100011:    //CMP REG-IMMED
               begin
                    ALU_SEL = 4'b0100;
                    ALU_OPY_SEL = 1'b1;
                    C_LD = 1'b1;
                    Z_LD = 1'b1;
              end
              7'b0000010:    //EXOR REG-REG
               begin
                    ALU_SEL = 4'b0111;
                    RF_WR = 1'b1;
                    C_CLEAR = 1'b1;
                    Z_LD = 1'b1;
              end
              7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011:    //EXOR REG-IMMED
               begin
                    ALU_SEL = 4'b0111;
                    ALU_OPY_SEL = 1'b1;
                    RF_WR = 1'b1;
                    C_CLEAR = 1'b1;
                    Z_LD = 1'b1;
              end
              7'b1100100, 7'b1100101, 7'b1100110, 7'b1100111:    //IN REG-IMMED
               begin
                RF_WR = 1'b1;
                RF_WR_SEL = 2'b11;
              end
               7'b0100000:    //LSL REG-REG
               begin
                    ALU_SEL = 4'b1001;
                    RF_WR = 1'b1;
                    C_LD = 1'b1;
                    Z_LD = 1'b1;
               end
               7'b0100001:    //LSR REG-REG
               begin
                    ALU_SEL = 4'b1010;
                    RF_WR = 1'b1;
                    C_LD = 1'b1;
                    Z_LD = 1'b1;
               end
               7'b0001001:    //MOV REG-REG
               begin
                    ALU_SEL = 4'b1110;
                    RF_WR = 1'b1;
               end
               7'b1101100, 7'b1101101, 7'b1101110, 7'b1101111:    //MOV REG-IMMED
               begin
                    RF_WR = 1'b1;
                    ALU_SEL = 4'b1110;
                    ALU_OPY_SEL = 1'b1;
              end
              7'b1101000, 7'b1101001, 7'b1101010, 7'b1101011:    //OUT REG-REG
               begin
                    IO_STRB = 1'b1;
              end
              7'b0000011:    //TEST REG-REG
               begin
                    ALU_SEL = 4'b1000;
                    Z_LD = 1'b1;
                    C_CLEAR = 1'b1;
               end
               7'b1001100, 7'b1001101, 7'b1001110, 7'b1001111:   //TEST REG-IMMED 
               begin
                    Z_LD = 1'b1;
                    C_CLEAR = 1'b1;
                    ALU_SEL = 4'b1000;
                    ALU_OPY_SEL = 1'b1;
              end
              7'b0000111:    //SUBC REG-REG
               begin
                    RF_WR = 1'b1;
                    ALU_SEL = 4'b0011;
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
               end
               7'b1011100, 7'b1011101, 7'b1011110, 7'b1011111:    //SUBC REG-IMMED
               begin
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
                    ALU_SEL = 4'b0011;
                    ALU_OPY_SEL = 1'b1;
                    RF_WR = 1'b1;
              end
              7'b0000110:    //SUB REG-REG
               begin
                    RF_WR = 1'b1;
                    ALU_SEL = 4'b0010;
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
               end
               7'b1011000, 7'b1011001, 7'b1011010, 7'b1011011:    //SUB REG-IMMED
               begin
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
                    ALU_SEL = 4'b0010;
                    ALU_OPY_SEL = 1'b1;
                    RF_WR = 1'b1;
              end
              7'b0110001:    //SEC REG-REG
               begin
                    RF_WR = 1'b1;
                    C_SET = 1'b1;
               end
              7'b0100011:    //ROR REG-REG
               begin
                    RF_WR = 1'b1;
                    ALU_SEL = 4'b1100;
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
               end
               7'b0100010:    //ROL REG-REG
               begin
                    RF_WR = 1'b1;
                    ALU_SEL = 4'b1011;
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
               end
               7'b0000001:    //OR REG-REG
               begin
                    RF_WR = 1'b1;
                    ALU_SEL = 4'b0110;
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
               end
               7'b1000100, 7'b1000101, 7'b1000110, 7'b1000111:    //OR REG-IMMED
               begin
                    Z_LD = 1'b1;
                    C_LD = 1'b1;
                    ALU_SEL = 4'b0110;
                    ALU_OPY_SEL = 1'b1;
                    RF_WR = 1'b1;
              end
              7'b0001010:   //LD REG-REG
              begin
                    RF_WR = 1'b1;
                    RF_WR_SEL = 2'b01;
              end
              7'b1110000, 7'b1110001, 7'b1110010, 7'b1110011:   //LD REG-IMMED
              begin
                    RF_WR = 1'b1;
                    RF_WR_SEL = 2'b01;
                    SCR_ADDR_SEL = 2'b01;
              end
              7'b0010001:      //CALL (REG-IMMED)
              begin
                    SCR_WE = 1'b1;
                    PC_LD = 1'b1;
                    SP_DECR = 1'b1; 
                    SCR_DATA_SEL = 1'b1;
                    SCR_ADDR_SEL = 2'b11;
              end
              7'b0100110:   //POP REG
              begin
                   
                    SP_INCR = 1'b1;
                    SCR_ADDR_SEL = 2'b10;
                    RF_WR = 1'b1;
                    RF_WR_SEL = 2'b01;
                    
              end
              7'b0100101:   //PUSH REG
              begin
                    SCR_WE = 1'b1;
                    SP_DECR = 1'b1; 
                    SCR_ADDR_SEL = 2'b11;
              end
              7'b0101000:   //WSP
              begin
                    SP_LD = 1'b1;
              end
//              7'b0101001:   //RSP-----not certain
//              begin
//                    SCR_ADDR_SEL = 2'b10;
//                    RF_WR_SEL = 2'b01;
//                    RF_WR = 1'b1;
//              end
              7'b0110010:   //RET
              begin
                    SP_INCR = 1'b1; 
                    SCR_ADDR_SEL = 2'b10;
                    PC_LD = 1'b1;
                    PC_MUX_SEL = 2'b01;
              end
//              7'b0110011:   //NOP----not certain
//              begin
              
//              end
              7'b0001011:   //ST REG-REG
              begin
                    SCR_WE = 1'b1;
                    RF_WR_SEL = 2'b01;
              end
              7'b1110100, 7'b1110101, 7'b1110110, 7'b1110111:   //ST REG-IMMED
              begin
                    SCR_WE = 1'b1;
                    RF_WR_SEL = 2'b01;
                    SCR_ADDR_SEL = 2'b01;
              end
              7'b0110111:   //RETIE
              begin
                PC_LD = 1'B1;
                PC_MUX_SEL = 2'B01;
                SCR_ADDR_SEL = 2'B10;
//                SCR_WE = 1'B1;
//                SCR_DATA_SEL = 1'B1;
                SP_INCR = 1'B1;
                C_LD = 1'B1;
                Z_LD = 1'B1;
                I_SET = 1'B1;
                FLG_LD_SEL = 1'B1;
              end
              7'B0110110:   //RETID
              begin
                PC_LD = 1'B1;
                PC_MUX_SEL = 2'B01;
                SCR_ADDR_SEL = 2'B10;
//                SCR_WE = 1'B1;
//                SCR_DATA_SEL = 1'B1;
                SP_INCR = 1'B1;
                C_LD = 1'B1;
                Z_LD = 1'B1;
                I_CLR = 1'B1;
                FLG_LD_SEL = 1'B1;
              end
              7'B0110100:   //SEI
              begin
                I_SET = 1'B1;
              end
              7'B0110101:   //CLI
              begin
                I_CLR = 1'B1;
              end
              default
                NS = ST_FET_STATE;
            endcase
                if (INTV == 1)
                    NS = ST_INT_STATE;
                else
                    NS = ST_FET_STATE;
                
          end
//          ST_INT_STATE:
//            begin
//                NS = ST_FET_STATE;
//                PC_LD = 1'B1;
//                PC_MUX_SEL = 2'B10;
//                SCR_WE = 1'B1;
//                SCR_DATA_SEL = 1'B1;
//                SCR_ADDR_SEL = 2'B11;
//                SP_DECR = 1'B1;
//                FLG_SHAD_LD = 1'B1;
//                I_CLR = 1'B1;
//            end
       default 
        NS = ST_IN_STATE;
     endcase
   end
endmodule
