

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;---------------------------------------------------------------------
(0002)                            || ; An expanded "draw_dot" program that includes subrountines to draw
(0003)                            || ; vertical lines, horizontal lines, and a full background.
(0004)                            || ;
(0005)                            || ; As written, this programs does the following:
(0006)                            || ;   1) draws a the background blue (draws all the tiles)
(0007)                            || ;   2) draws a red dot
(0008)                            || ;   3) draws a red horizontal lines
(0009)                            || ;   4) draws a red vertical line
(0010)                            || ;
(0011)                            || ; Author: Bridget Benson
(0012)                            || ; Modifications: bryan mealy, Paul Hummel
(0013)                            || ;---------------------------------------------------------------------
(0014)                            || 
(0015)                            || .CSEG
(0016)                       016  || .ORG 0x10
(0017)                            || 
(0018)                       144  || .EQU VGA_HADD = 0x90
(0019)                       145  || .EQU VGA_LADD = 0x91
(0020)                       146  || .EQU VGA_COLOR = 0x92
(0021)                       129  || .EQU SSEG = 0x81
(0022)                       064  || .EQU LEDS = 0x40
(0023)                            || 
(0024)                       255  || .EQU BG_COLOR       = 0xFF             ; Background:  blue
(0025)                            || 
(0026)                            || 
(0027)                            || ;r6 is used for color
(0028)                            || ;r7 is used for Y
(0029)                            || ;r8 is used for X
(0030)                            || 
(0031)                            || ;---------------------------------------------------------------------
(0032)                     0x010  || init:
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08080  0x100  ||              BRN     0x10        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0033)  CS-0x010  0x08699         ||          CALL   draw_background         ; draw using default color
(0034)                            || 
(0035)                            || 		 
(0036)  CS-0x011  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0037)  CS-0x012  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0038)  CS-0x013  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0039)  CS-0x014  0x08179         || 		 CALL   draw_beaker
(0040)                            || 		 
(0041)  CS-0x015  0x3670D         || 		 MOV 	R7, 0x0D				; Y coordinate for fluid				
(0042)  CS-0x016  0x36814         || 		 MOV	R8, 0x14				; X coordinate for fluid
(0043)  CS-0x017  0x36603         || 		 MOV	R6, 0x03				; moves blue (PUT COLOR FROM WRAPPER LATER)
(0044)  CS-0x018  0x081F1         || 		 CALL   draw_fluid				; draws the fluid inside the beaker
(0045)                            || 		 
(0046)  CS-0x019  0x36702         || 		 MOV	R7, 0x02				; Y coordinate for "win"
(0047)  CS-0x01A  0x36808         || 		 MOV	R8, 0x08				; X coordinate for "win"
(0048)  CS-0x01B  0x366E0         || 		 MOV	R6, 0xE0				; sets default color to red
(0049)  CS-0x01C  0x08249         || 		 CALL   win						; draw "win"
(0050)                            || 		 
(0051)  CS-0x01D  0x36702         || 		 MOV	R7, 0x02				; Y coordinate for "lose"
(0052)  CS-0x01E  0x36808         || 		 MOV 	R8, 0x08				; X coordinate for "lose"
(0053)  CS-0x01F  0x36603         || 		 MOV 	R6, 0x03				; sets default color to blue
(0054)  CS-0x020  0x08451         || 		 CALL   lose					; draw "lose"
(0055)                            || 		 
(0056)                            || ;         MOV    r7, 0x0F                ; generic Y coordinate
(0057)                            || ;         MOV    r8, 0x14                ; generic X coordinate
(0058)                            || ;         MOV    r6, 0xE0                ; color
(0059)                            || ;         CALL   draw_dot                ; draw red pixel
(0060)                            || 
(0061)                            || ;         MOV    r8,0x01                 ; starting x coordinate
(0062)                            || ;         MOV    r7,0x12                 ; start y coordinate
(0063)                            || ;         MOV    r9,0x26                 ; ending x coordinate
(0064)                            || ;         CALL   draw_horizontal_line
(0065)                            || 
(0066)                            || ;         MOV    r8,0x08                 ; starting x coordinate
(0067)                            || ;         MOV    r7,0x04                 ; start y coordinate
(0068)                            || ;         MOV    r9,0x17                 ; ending x coordinate
(0069)                            || ;         CALL   draw_vertical_line
(0070)                            ||       
(0071)  CS-0x021  0x00000  0x021  || end:     AND    r0, r0                  ; nop
(0072)  CS-0x022  0x08108         ||          BRN    end                     ; continuous loop
(0073)                            || ;--------------------------------------------------------------------
(0074)                            || 
(0075)                            ||    
(0076)                            || ;--------------------------------------------------------------------
(0077)                            || ;-  Subroutine: draw_horizontal_line
(0078)                            || ;-
(0079)                            || ;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6
(0080)                            || ;-
(0081)                            || ;-  Parameters:
(0082)                            || ;-   r8  = starting x-coordinate
(0083)                            || ;-   r7  = y-coordinate
(0084)                            || ;-   r9  = ending x-coordinate
(0085)                            || ;-   r6  = color used for line
(0086)                            || ;-
(0087)                            || ;- Tweaked registers: r8,r9
(0088)                            || ;--------------------------------------------------------------------
(0089)                     0x023  || draw_horizontal_line:
(0090)  CS-0x023  0x28901         ||         ADD    r9,0x01          ; go from r8 to r15 inclusive
(0091)                            || 
(0092)                     0x024  || draw_horiz1:
(0093)  CS-0x024  0x086E9         ||         CALL   draw_dot         ;draws a bunch of dots which will paint the line.
(0094)  CS-0x025  0x28801         ||         ADD    r8,0x01
(0095)  CS-0x026  0x04848         ||         CMP    r8,r9
(0096)  CS-0x027  0x08123         ||         BRNE   draw_horiz1
(0097)  CS-0x028  0x18002         ||         RET
(0098)                            || ;--------------------------------------------------------------------
(0099)                            || 
(0100)                            || 
(0101)                            || ;---------------------------------------------------------------------
(0102)                            || ;-  Subroutine: draw_vertical_line
(0103)                            || ;-
(0104)                            || ;-  Draws a vertical line from (r8,r7) to (r8,r9) using color in r6
(0105)                            || ;-
(0106)                            || ;-  Parameters:
(0107)                            || ;-   r8  = x-coordinate
(0108)                            || ;-   r7  = starting y-coordinate
(0109)                            || ;-   r9  = ending y-coordinate
(0110)                            || ;-   r6  = color used for line
(0111)                            || ;-
(0112)                            || ;- Tweaked registers: r7,r9
(0113)                            || ;--------------------------------------------------------------------
(0114)                     0x029  || draw_vertical_line:
(0115)  CS-0x029  0x28901         ||          ADD    r9,0x01
(0116)                            || 
(0117)                     0x02A  || draw_vert1:
(0118)  CS-0x02A  0x086E9         ||          CALL   draw_dot
(0119)  CS-0x02B  0x28701         ||          ADD    r7,0x01
(0120)  CS-0x02C  0x04748         ||          CMP    r7,R9
(0121)  CS-0x02D  0x08153         ||          BRNE   draw_vert1
(0122)  CS-0x02E  0x18002         ||          RET
(0123)                            || ;--------------------------------------------------------------------
(0124)                            || 
(0125)                            || ;---------------------------------------------------------------------
(0126)                            || 
(0127)                     0x02F  || draw_beaker:
(0128)  CS-0x02F  0x04439         || 		MOV R4, R7
(0129)  CS-0x030  0x04539         || 		MOV R5, R7
(0130)                            || 		
(0131)                     0x031  || beaker_vert_1:
(0132)  CS-0x031  0x086E9         || 		CALL draw_dot
(0133)  CS-0x032  0x28701         || 		ADD R7, 0x01
(0134)  CS-0x033  0x30717         || 		CMP R7, 0x17
(0135)  CS-0x034  0x0818B         || 		BRNE beaker_vert_1
(0136)                            || 		
(0137)                     0x035  || beaker_horiz:
(0138)  CS-0x035  0x086E9         || 		CALL draw_dot
(0139)  CS-0x036  0x28801         || 		ADD R8, 0x01
(0140)  CS-0x037  0x3081D         || 		CMP R8, 0x1D
(0141)  CS-0x038  0x081AB         || 		BRNE beaker_horiz
(0142)                            || 		
(0143)                     0x039  || beaker_vert_2:
(0144)  CS-0x039  0x086E9         || 		CALL draw_dot
(0145)  CS-0x03A  0x2C701         || 		SUB R7, 0x01
(0146)  CS-0x03B  0x30708         || 		CMP R7, 0x08
(0147)  CS-0x03C  0x081CB         || 		BRNE beaker_vert_2
(0148)  CS-0x03D  0x18002         || 		RET
(0149)                            || 		
(0150)                            || ;---------------------------------------------------------------------
(0151)                            || 
(0152)                            || ;---------------------------------------------------------------------
(0153)                            || 		
(0154)                     0x03E  || draw_fluid:
(0155)  CS-0x03E  0x04439         || 		MOV R4, R7
(0156)  CS-0x03F  0x04541         || 		MOV R5, R8
(0157)                            || 		
(0158)                     0x040  || fluid_horiz:
(0159)  CS-0x040  0x086E9         || 		CALL draw_dot
(0160)  CS-0x041  0x28801         || 		ADD R8, 0x01
(0161)  CS-0x042  0x3081D         || 		CMP R8, 0x1D
(0162)  CS-0x043  0x08203         || 		BRNE fluid_horiz
(0163)                            || 		
(0164)                     0x044  || fluid_vert:
(0165)  CS-0x044  0x36814         || 		MOV R8, 0x14
(0166)  CS-0x045  0x28701         || 		ADD R7, 0x01
(0167)  CS-0x046  0x30717         || 		CMP R7, 0x17
(0168)  CS-0x047  0x08203         || 		BRNE fluid_horiz
(0169)  CS-0x048  0x18002         || 		RET
(0170)                            || ;---------------------------------------------------------------------
(0171)                            || 
(0172)                            || ;---------------------------------------------------------------------
(0173)                            || 		
(0174)                     0x049  || win:
(0175)  CS-0x049  0x04439         || 		MOV R4, R7
(0176)  CS-0x04A  0x04541         || 		MOV R5, R8
(0177)                            || 		
(0178)                     0x04B  || w_vert_1:
(0179)  CS-0x04B  0x086E9         || 		CALL draw_dot
(0180)  CS-0x04C  0x28701         || 		ADD R7, 0x01
(0181)  CS-0x04D  0x30706         || 		CMP R7, 0x06
(0182)  CS-0x04E  0x0825B         || 		BRNE w_vert_1
(0183)                            || 		
(0184)                     0x04F  || w_horiz_1:
(0185)  CS-0x04F  0x086E9         || 		CALL draw_dot
(0186)  CS-0x050  0x28801         || 		ADD R8, 0x01
(0187)  CS-0x051  0x3080A         || 		CMP R8, 0x0A
(0188)  CS-0x052  0x0827B         || 		BRNE w_horiz_1
(0189)                            || 		
(0190)                     0x053  || w_vert_2:
(0191)  CS-0x053  0x086E9         || 		CALL draw_dot
(0192)  CS-0x054  0x2C701         || 		SUB R7, 0x01
(0193)  CS-0x055  0x30701         || 		CMP R7, 0x01
(0194)  CS-0x056  0x0829B         || 		BRNE w_vert_2
(0195)  CS-0x057  0x36706         || 		MOV R7, 0x06
(0196)                            || 		
(0197)                     0x058  || w_horiz_2:
(0198)  CS-0x058  0x086E9         || 		CALL draw_dot
(0199)  CS-0x059  0x28801         || 		ADD R8, 0x01
(0200)  CS-0x05A  0x3080C         || 		CMP R8, 0x0C
(0201)  CS-0x05B  0x082C3         || 		BRNE w_horiz_2
(0202)                            || 		
(0203)                     0x05C  || w_vert_3:
(0204)  CS-0x05C  0x086E9         || 		CALL draw_dot
(0205)  CS-0x05D  0x2C701         || 		SUB R7, 0x01
(0206)  CS-0x05E  0x30701         || 		CMP R7, 0x01
(0207)  CS-0x05F  0x082E3         || 		BRNE w_vert_3
(0208)  CS-0x060  0x3680E         || 		MOV R8, 0x0E
(0209)  CS-0x061  0x36702         || 		MOV R7, 0x02
(0210)                            || 		
(0211)                     0x062  || i_horiz_1:
(0212)  CS-0x062  0x086E9         || 		CALL draw_dot
(0213)  CS-0x063  0x28801         || 		ADD R8, 0x01
(0214)  CS-0x064  0x30813         || 		CMP R8, 0x13
(0215)  CS-0x065  0x08313         || 		BRNE i_horiz_1
(0216)  CS-0x066  0x36810         || 		MOV R8, 0x10
(0217)                            || 		
(0218)                     0x067  || i_vert:
(0219)  CS-0x067  0x086E9         || 		CALL draw_dot
(0220)  CS-0x068  0x28701         || 		ADD R7, 0x01
(0221)  CS-0x069  0x30706         || 		CMP R7, 0x06
(0222)  CS-0x06A  0x0833B         || 		BRNE i_vert
(0223)  CS-0x06B  0x3680E         || 		MOV R8, 0x0E
(0224)  CS-0x06C  0x36706         || 		MOV R7, 0x06
(0225)                            || 		
(0226)                     0x06D  || i_horiz_2:
(0227)  CS-0x06D  0x086E9         || 		CALL draw_dot
(0228)  CS-0x06E  0x28801         || 		ADD R8, 0x01
(0229)  CS-0x06F  0x30813         || 		CMP R8, 0x13
(0230)  CS-0x070  0x0836B         || 		BRNE i_horiz_2
(0231)  CS-0x071  0x36814         || 		MOV R8, 0x14
(0232)  CS-0x072  0x36702         || 		MOV R7, 0x02
(0233)                            || 		
(0234)                     0x073  || n_vert_1:
(0235)  CS-0x073  0x086E9         || 		CALL draw_dot
(0236)  CS-0x074  0x28701         || 		ADD R7, 0x01
(0237)  CS-0x075  0x30707         || 		CMP R7, 0x07
(0238)  CS-0x076  0x0839B         || 		BRNE n_vert_1
(0239)  CS-0x077  0x36702         || 		MOV R7, 0x02
(0240)  CS-0x078  0x28801         || 		ADD R8, 0x01
(0241)  CS-0x079  0x086E9         || 		CALL draw_dot
(0242)  CS-0x07A  0x28801         || 		ADD R8, 0x01
(0243)  CS-0x07B  0x36703         || 		MOV R7, 0x03
(0244)                            || 		
(0245)                            || 
(0246)                     0x07C  || n_vert_2:
(0247)  CS-0x07C  0x086E9         || 		CALL draw_dot
(0248)  CS-0x07D  0x28701         || 		ADD R7, 0x01
(0249)  CS-0x07E  0x30706         || 		CMP R7, 0x06
(0250)  CS-0x07F  0x083E3         || 		BRNE n_vert_2
(0251)  CS-0x080  0x36706         || 		MOV R7, 0x06
(0252)  CS-0x081  0x28801         || 		ADD R8, 0x01
(0253)  CS-0x082  0x086E9         || 		CALL draw_dot
(0254)  CS-0x083  0x36702         || 		MOV R7, 0x02
(0255)  CS-0x084  0x28801         || 		ADD R8, 0x01
(0256)                            || 		
(0257)                     0x085  || n_vert_3:
(0258)  CS-0x085  0x086E9         || 		CALL draw_dot
(0259)  CS-0x086  0x28701         || 		ADD R7, 0x01
(0260)  CS-0x087  0x30707         || 		CMP R7, 0x07
(0261)  CS-0x088  0x0842B         || 		BRNE n_vert_3
(0262)  CS-0x089  0x18002         || 		RET
(0263)                            || 		
(0264)                            || ;---------------------------------------------------------------------
(0265)                            || 
(0266)                            || ;---------------------------------------------------------------------
(0267)                            || 
(0268)                     0x08A  || lose:
(0269)  CS-0x08A  0x04439         || 		MOV R4, R7
(0270)  CS-0x08B  0x04541         || 		MOV R5, R8
(0271)                            || 		
(0272)                     0x08C  || l_vert:
(0273)  CS-0x08C  0x086E9         || 		CALL draw_dot
(0274)  CS-0x08D  0x28701         || 		ADD R7, 0x01
(0275)  CS-0x08E  0x30706         || 		CMP R7, 0x06
(0276)  CS-0x08F  0x08463         || 		BRNE l_vert
(0277)                            || 		
(0278)                     0x090  || l_horiz:
(0279)  CS-0x090  0x086E9         || 		CALL draw_dot
(0280)  CS-0x091  0x28801         || 		ADD R8, 0x01
(0281)  CS-0x092  0x3080C         || 		CMP R8, 0x0C
(0282)  CS-0x093  0x08483         || 		BRNE l_horiz
(0283)  CS-0x094  0x36702         || 		MOV R7, 0x02
(0284)  CS-0x095  0x3680E         || 		MOV R8, 0x0E
(0285)                            || 		
(0286)                     0x096  || o_vert_1:
(0287)  CS-0x096  0x086E9         || 		CALL draw_dot
(0288)  CS-0x097  0x28701         || 		ADD R7, 0x01
(0289)  CS-0x098  0x30706         || 		CMP R7, 0x06
(0290)  CS-0x099  0x084B3         || 		BRNE o_vert_1
(0291)                            || 
(0292)                     0x09A  || o_horiz_1:
(0293)  CS-0x09A  0x086E9         || 		CALL draw_dot
(0294)  CS-0x09B  0x28801         || 		ADD R8, 0x01
(0295)  CS-0x09C  0x30812         || 		CMP R8, 0x12
(0296)  CS-0x09D  0x084D3         || 		BRNE o_horiz_1
(0297)                            || 
(0298)                     0x09E  || o_vert_2:
(0299)  CS-0x09E  0x086E9         || 		CALL draw_dot
(0300)  CS-0x09F  0x2C701         || 		SUB R7, 0x01
(0301)  CS-0x0A0  0x30702         || 		CMP R7, 0x02
(0302)  CS-0x0A1  0x084F3         || 		BRNE o_vert_2
(0303)                            || 		
(0304)                     0x0A2  || o_horiz_2:
(0305)  CS-0x0A2  0x086E9         || 		CALL draw_dot
(0306)  CS-0x0A3  0x2C801         || 		SUB R8, 0x01
(0307)  CS-0x0A4  0x3080E         || 		CMP R8, 0x0E
(0308)  CS-0x0A5  0x08513         || 		BRNE o_horiz_2	
(0309)  CS-0x0A6  0x36814         || 		MOV R8, 0x14
(0310)  CS-0x0A7  0x36702         || 		MOV R7, 0x02
(0311)                            || 		
(0312)                     0x0A8  || s_horiz_1:
(0313)  CS-0x0A8  0x086E9         || 		CALL draw_dot
(0314)  CS-0x0A9  0x28801         || 		ADD R8, 0x01
(0315)  CS-0x0AA  0x30818         || 		CMP R8, 0x18
(0316)  CS-0x0AB  0x08543         || 		BRNE s_horiz_1
(0317)  CS-0x0AC  0x36814         || 		MOV R8, 0x14
(0318)  CS-0x0AD  0x28701         || 		ADD R7, 0x01
(0319)  CS-0x0AE  0x086E9         || 		CALL draw_dot
(0320)  CS-0x0AF  0x28701         || 		ADD R7, 0x01
(0321)                            || 		
(0322)                     0x0B0  || s_horiz_2:
(0323)  CS-0x0B0  0x086E9         || 		CALL draw_dot
(0324)  CS-0x0B1  0x28801         || 		ADD R8, 0x01
(0325)  CS-0x0B2  0x30818         || 		CMP R8, 0x18
(0326)  CS-0x0B3  0x08583         || 		BRNE s_horiz_2
(0327)  CS-0x0B4  0x28701         || 		ADD R7, 0x01
(0328)  CS-0x0B5  0x086E9         || 		CALL draw_dot
(0329)  CS-0x0B6  0x36814         || 		MOV R8, 0x14
(0330)  CS-0x0B7  0x28701         || 		ADD R7, 0x01
(0331)                            || 		
(0332)                     0x0B8  || s_horiz_3:
(0333)  CS-0x0B8  0x086E9         || 		CALL draw_dot
(0334)  CS-0x0B9  0x28801         || 		ADD R8, 0x01
(0335)  CS-0x0BA  0x30818         || 		CMP R8, 0x18
(0336)  CS-0x0BB  0x08583         || 		BRNE s_horiz_2
(0337)  CS-0x0BC  0x3681A         || 		MOV R8, 0x1A
(0338)  CS-0x0BD  0x36702         || 		MOV R7, 0x02
(0339)                            || 
(0340)                     0x0BE  || e_horiz_1:
(0341)  CS-0x0BE  0x086E9         || 		CALL draw_dot
(0342)  CS-0x0BF  0x28801         || 		ADD R8, 0x01
(0343)  CS-0x0C0  0x3081E         || 		CMP R8, 0x1E
(0344)  CS-0x0C1  0x085F3         || 		BRNE e_horiz_1
(0345)  CS-0x0C2  0x3681A         || 		MOV R8, 0x1A
(0346)  CS-0x0C3  0x28701         || 		ADD R7, 0x01
(0347)  CS-0x0C4  0x086E9         || 		CALL draw_dot
(0348)  CS-0x0C5  0x28701         || 		ADD R7, 0x01
(0349)                            || 		
(0350)                     0x0C6  || e_horiz_2:
(0351)  CS-0x0C6  0x086E9         || 		CALL draw_dot
(0352)  CS-0x0C7  0x28801         || 		ADD R8, 0x01
(0353)  CS-0x0C8  0x3081E         || 		CMP R8, 0x1E
(0354)  CS-0x0C9  0x08633         || 		BRNE e_horiz_2
(0355)  CS-0x0CA  0x3681A         || 		MOV R8, 0x1A
(0356)  CS-0x0CB  0x28701         || 		ADD R7, 0x01
(0357)  CS-0x0CC  0x086E9         || 		CALL draw_dot
(0358)  CS-0x0CD  0x28701         || 		ADD R7, 0x01
(0359)                            || 		
(0360)                     0x0CE  || e_horiz_3:
(0361)  CS-0x0CE  0x086E9         || 		CALL draw_dot
(0362)  CS-0x0CF  0x28801         || 		ADD R8, 0x01
(0363)  CS-0x0D0  0x3081E         || 		CMP R8, 0x1E
(0364)  CS-0x0D1  0x08673         || 		BRNE e_horiz_3
(0365)  CS-0x0D2  0x18002         || 		RET
(0366)                            || ;---------------------------------------------------------------------
(0367)                            || 
(0368)                            || ;---------------------------------------------------------------------
(0369)                            || ;-  Subroutine: draw_background
(0370)                            || ;-
(0371)                            || ;-  Fills the 40x30 grid with one color using successive calls to
(0372)                            || ;-  draw_horizontal_line subroutine.
(0373)                            || ;-
(0374)                            || ;-  Tweaked registers: r10,r7,r8,r9
(0375)                            || ;----------------------------------------------------------------------
(0376)                     0x0D3  || draw_background:
(0377)  CS-0x0D3  0x366FF         ||          MOV   r6,BG_COLOR              ; use default color
(0378)  CS-0x0D4  0x36A00         ||          MOV   r10,0x00                 ; r10 keeps track of rows
(0379)  CS-0x0D5  0x04751  0x0D5  || start:   MOV   r7,r10                   ; load current row count
(0380)  CS-0x0D6  0x36800         ||          MOV   r8,0x00                  ; restart x coordinates
(0381)  CS-0x0D7  0x36927         ||          MOV   r9,0x27
(0382)                            ||  
(0383)  CS-0x0D8  0x08119         ||          CALL  draw_horizontal_line
(0384)  CS-0x0D9  0x28A01         ||          ADD   r10,0x01                 ; increment row count
(0385)  CS-0x0DA  0x30A1E         ||          CMP   r10,0x1E                 ; see if more rows to draw
(0386)  CS-0x0DB  0x086AB         ||          BRNE  start                    ; branch to draw more rows
(0387)  CS-0x0DC  0x18002         ||          RET
(0388)                            || ;---------------------------------------------------------------------
(0389)                            ||     
(0390)                            || ;---------------------------------------------------------------------
(0391)                            || ;- Subrountine: draw_dot
(0392)                            || ;-
(0393)                            || ;- This subroutine draws a dot on the display the given coordinates:
(0394)                            || ;-
(0395)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6
(0396)                            || ;-
(0397)                            || ;- Tweaked registers: r4,r5
(0398)                            || ;---------------------------------------------------------------------
(0399)                     0x0DD  || draw_dot:
(0400)  CS-0x0DD  0x04439         ||            MOV   r4,r7         ; copy Y coordinate
(0401)  CS-0x0DE  0x04541         ||            MOV   r5,r8         ; copy X coordinate
(0402)                            || 
(0403)  CS-0x0DF  0x2053F         ||            AND   r5,0x3F       ; make sure top 2 bits cleared, has to be a number within 6 bits so don't need all 8 for the columns.
(0404)  CS-0x0E0  0x2041F         ||            AND   r4,0x1F       ; make sure top 3 bits cleared, has to be a number within 5 bits for the rows.
(0405)  CS-0x0E1  0x10401         ||            LSR   r4             ; need to get the bot 2 bits of r4 into sA
(0406)  CS-0x0E2  0x0A748         ||            BRCS  dd_add40
(0407)  CS-0x0E3  0x10401  0x0E3  || t1:        LSR   r4
(0408)  CS-0x0E4  0x0A760         ||            BRCS  dd_add80
(0409)                            || 
(0410)  CS-0x0E5  0x34591  0x0E5  || dd_out:    OUT   r5,VGA_LADD   ; write bot 8 address bits to register
(0411)  CS-0x0E6  0x34490         ||            OUT   r4,VGA_HADD   ; write top 3 address bits to register
(0412)  CS-0x0E7  0x34692         ||            OUT   r6,VGA_COLOR  ; write data to frame buffer, combining x and y corrd to produce 11 bit address.
(0413)  CS-0x0E8  0x18002         ||            RET
(0414)                            || 
(0415)  CS-0x0E9  0x22540  0x0E9  || dd_add40:  OR    r5,0x40       ; set bit if needed
(0416)  CS-0x0EA  0x18000         ||            CLC                  ; freshen bit
(0417)  CS-0x0EB  0x08718         ||            BRN   t1
(0418)                            || 
(0419)  CS-0x0EC  0x22580  0x0EC  || dd_add80:  OR    r5,0x80       ; set bit if needed
(0420)  CS-0x0ED  0x08728         ||            BRN   dd_out
(0421)                            || ; --------------------------------------------------------------------
(0422)                            || 





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
BEAKER_HORIZ   0x035   (0137)  ||  0141 
BEAKER_VERT_1  0x031   (0131)  ||  0135 
BEAKER_VERT_2  0x039   (0143)  ||  0147 
DD_ADD40       0x0E9   (0415)  ||  0406 
DD_ADD80       0x0EC   (0419)  ||  0408 
DD_OUT         0x0E5   (0410)  ||  0420 
DRAW_BACKGROUND 0x0D3   (0376)  ||  0033 
DRAW_BEAKER    0x02F   (0127)  ||  0039 
DRAW_DOT       0x0DD   (0399)  ||  0093 0118 0132 0138 0144 0159 0179 0185 0191 0198 
                               ||  0204 0212 0219 0227 0235 0241 0247 0253 0258 0273 
                               ||  0279 0287 0293 0299 0305 0313 0319 0323 0328 0333 
                               ||  0341 0347 0351 0357 0361 
DRAW_FLUID     0x03E   (0154)  ||  0044 
DRAW_HORIZ1    0x024   (0092)  ||  0096 
DRAW_HORIZONTAL_LINE 0x023   (0089)  ||  0383 
DRAW_VERT1     0x02A   (0117)  ||  0121 
DRAW_VERTICAL_LINE 0x029   (0114)  ||  
END            0x021   (0071)  ||  0072 
E_HORIZ_1      0x0BE   (0340)  ||  0344 
E_HORIZ_2      0x0C6   (0350)  ||  0354 
E_HORIZ_3      0x0CE   (0360)  ||  0364 
FLUID_HORIZ    0x040   (0158)  ||  0162 0168 
FLUID_VERT     0x044   (0164)  ||  
INIT           0x010   (0032)  ||  
I_HORIZ_1      0x062   (0211)  ||  0215 
I_HORIZ_2      0x06D   (0226)  ||  0230 
I_VERT         0x067   (0218)  ||  0222 
LOSE           0x08A   (0268)  ||  0054 
L_HORIZ        0x090   (0278)  ||  0282 
L_VERT         0x08C   (0272)  ||  0276 
N_VERT_1       0x073   (0234)  ||  0238 
N_VERT_2       0x07C   (0246)  ||  0250 
N_VERT_3       0x085   (0257)  ||  0261 
O_HORIZ_1      0x09A   (0292)  ||  0296 
O_HORIZ_2      0x0A2   (0304)  ||  0308 
O_VERT_1       0x096   (0286)  ||  0290 
O_VERT_2       0x09E   (0298)  ||  0302 
START          0x0D5   (0379)  ||  0386 
S_HORIZ_1      0x0A8   (0312)  ||  0316 
S_HORIZ_2      0x0B0   (0322)  ||  0326 0336 
S_HORIZ_3      0x0B8   (0332)  ||  
T1             0x0E3   (0407)  ||  0417 
WIN            0x049   (0174)  ||  0049 
W_HORIZ_1      0x04F   (0184)  ||  0188 
W_HORIZ_2      0x058   (0197)  ||  0201 
W_VERT_1       0x04B   (0178)  ||  0182 
W_VERT_2       0x053   (0190)  ||  0194 
W_VERT_3       0x05C   (0203)  ||  0207 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BG_COLOR       0x0FF   (0024)  ||  0377 
LEDS           0x040   (0022)  ||  
SSEG           0x081   (0021)  ||  
VGA_COLOR      0x092   (0020)  ||  0412 
VGA_HADD       0x090   (0018)  ||  0411 
VGA_LADD       0x091   (0019)  ||  0410 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
