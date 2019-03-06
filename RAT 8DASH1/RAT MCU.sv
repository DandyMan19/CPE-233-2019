`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2019 10:36:37 AM
// Design Name: 
// Module Name: Jasons RAT MCU
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


module RAT_MCU(
        input [7:0] IN_PORT,
        input RESET, INTV, clk,
        output wire [7:0] OUT_PORT, PORT_ID,
        output wire IO_STRB
    );
    
wire PC_LD, PC_INC;
wire [1:0] PC_MUX_SEL;
wire [9:0] PC_COUNT, FROM_STACK, FROM_IMMED;
wire RF_WR;
wire [1:0]RF_WR_SEL;
wire ALU_OPY_SEL, ALU_CIN;
wire [3:0] ALU_SEL;
wire SCR_WE, SCR_DATA_SEL;
wire [1:0]SCR_ADDR_SEL;
wire [7:0] SP_DATA_OUT;
wire C_SET, C_CLEAR, C_LD, Z_LD, FLG_LD_SEL, FLG_SHAD_LD;
wire C, Z;
wire [17:0] IR;
wire [7:0] A;                           //Instruction output by the PROG_ROM
wire [7:0] DX_OUT;                        //X output for Register File
wire [7:0] DY_OUT;
wire [4:0] ADRX, ADRY;                        //Y output for Register File
wire [7:0] RESULT;                    //Result output by the ALU
wire [9:0] DATA_OUT;                  //Output Data from Scratch_RAM
wire C_FLAG;                               //C flag output for Flags
wire Z_FLAG;                               //Z flag output for Flags
wire RST;
wire [4:0] OPCODE_HI_5;
wire [1:0] OPCODE_LOW_2;
wire I_SET, I_CLR;
wire SP_LD, SP_INCR, SP_DECR; 
//wire C_CLEAR, C_LD, C_SET, Z_LD;
wire [9:0] PROG_ADDR;
logic I_OUT;

reg [7:0] B_ALU;                           //B input for ALU
reg [7:0] DIN;                             //D input for Register File
reg [7:0] ADDR;                            //Address input for Scratch_RAM
reg [9:0] DATA_IN;                     //DATA_IN input for Scratch_RAM

assign A = DX_OUT;
assign OUT_PORT = DX_OUT; //outputs the result of the calculations
assign FROM_IMMED = IR[12:3];
assign OPCODE_HI_5 = IR[17:13];
assign OPCODE_LOW_2 = IR[1:0];
assign ADRX = IR[12:8];
assign ADRY = IR[7:3];
assign PORT_ID = IR[7:0];
//PORT_ID defines the ouput of where the instruction is defined that being the last 8 bits
 always_comb        
    begin 
       case (RF_WR_SEL)
          2'b00 : DIN = RESULT;
          2'b01 : DIN = DATA_OUT [7:0];
          2'b10 : DIN = SP_DATA_OUT;
          2'b11 : DIN = IN_PORT;
          default DIN = 0;
       endcase
    end
       
 always_comb
    begin
       case (ALU_OPY_SEL)
          1'b0 : B_ALU = DY_OUT;
          1'b1 : B_ALU = IR [7:0];
          default : B_ALU = 8'b00000000;
       endcase
    end

always_comb
   begin
      case (SCR_DATA_SEL)
         1'b0 : DATA_IN = {2'b00, DX_OUT};
         1'b1 : DATA_IN = PC_COUNT;
         default : DATA_IN = 10'b0000000000;
      endcase
   end

always_comb
   begin
      case (SCR_ADDR_SEL)
         2'b00 : ADDR = DY_OUT;
         2'b01 : ADDR = IR [7:0];
         2'b10 : ADDR = SP_DATA_OUT;
         2'b11 : ADDR = {SP_DATA_OUT - 8'b00000001};
         default ADDR = 8'b00000000;
      endcase
   end

Control_Unit CU(
.clk    (clk),
.C_FLAG (C_FLAG),
.Z_FLAG (Z_FLAG),
.INTV   (I_OUT),
.RESET  (RESET),
.OPCODE_HI_5 (OPCODE_HI_5),
.OPCODE_LOW_2(OPCODE_LOW_2),
.RST    (RST),
.I_SET  (I_SET),
.I_CLR  (I_CLR),
.PC_LD  (PC_LD),
.PC_INC (PC_INC),
.PC_MUX_SEL (PC_MUX_SEL),
.ALU_OPY_SEL (ALU_OPY_SEL),
.ALU_SEL    (ALU_SEL),
.RF_WR  (RF_WR),
.RF_WR_SEL (RF_WR_SEL),
.SP_LD  (SP_LD),
.SP_INCR (SP_INCR),
.SP_DECR    (SP_DECR),
.SCR_WE (SCR_WE),
.SCR_DATA_SEL (SCR_DATA_SEL),
.SCR_ADDR_SEL (SCR_ADDR_SEL),
.C_CLEAR (C_CLEAR),
.C_LD   (C_LD),
.C_SET (C_SET),
.Z_LD   (Z_LD),
.FLG_LD_SEL (FLG_LD_SEL),
.FLG_SHAD_LD (FLG_SHAD_LD),
.IO_STRB (IO_STRB)
);

INTERRUPT_WRAPPER   INTERRUPT(
.INTV   (INTV),
.I_SET  (I_SET),
.I_CLR  (I_CLR),
.clk    (clk),
.I_OUT  (I_OUT)
);
  
PROG_COUNTER PC(                          
.clk (clk),
.PC_LD (PC_LD),
.PC_INC (PC_INC),
.RST (RST),
.FROM_IMMED (FROM_IMMED),
.FROM_STACK (DATA_OUT),
.PC_MUX_SEL (PC_MUX_SEL),
.PC_COUNT (PC_COUNT)
);

Prog_Rom ROM (
.PROG_CLK (clk),
.PROG_ADDR (PC_COUNT),
.PROG_IR (IR)
);

Register_File REG_FILE(
.clk (clk),
.DIN (DIN),
.ADRX (ADRX),
.ADRY (ADRY),
.RF_WR (RF_WR),
.DX_OUT (DX_OUT),
.DY_OUT (DY_OUT)
);

ALU ALU(
.CIN (C_FLAG),
.SEL (ALU_SEL),
.A (A),
.B (B_ALU),
.RESULT (RESULT),
.C (C),
.Z (Z)
);

Scratch_RAM SCR_RAM(
.clk (clk),
.DATA_IN (DATA_IN),
.SCR_ADDR (ADDR),
.SCR_WE (SCR_WE),
.DATA_OUT (DATA_OUT)
);

Flags Flag (
.clk (clk),
.C (C),
.C_CLEAR (C_CLEAR),
.C_SET (C_SET),
.C_LD (C_LD),
.C_FLAG (C_FLAG),
.Z_LD (Z_LD),
.Z (Z),
.Z_FLAG (Z_FLAG),
.FLG_LD_SEL (FLG_LD_SEL),
.FLG_SHAD_LD (FLG_SHAD_LD)
);

SP stack(
       .RST (RST),
       .SP_LD (SP_LD),
       .SP_INCR (SP_INCR),
       .SP_DECR  (SP_DECR), 
       .clk (clk),
       .DATA_IN (DX_OUT), 
       .SP_DATA_OUT (SP_DATA_OUT)
       );
       
endmodule