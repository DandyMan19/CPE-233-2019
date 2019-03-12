

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


(0001)                            || 
(0002)                            || .CSEG
(0003)                       016  || .ORG 0x10
(0004)                            || ;--------------------------------------------------------------------------
(0005)                            || ;PORT CONSTANTS
(0006)                            || ;-------------------------------------------------------------------------
(0007)                       144  || .EQU VGA_HADD = 0x90	;port for VGA x
(0008)                       145  || .EQU VGA_LADD = 0x91	;port for VGA y
(0009)                       146  || .EQU VGA_COLOR = 0x92	;port for VGA color OUTPUT
(0010)                       129  || .EQU SSEG = 0x81		;port for display	OUTPUT
(0011)                       064  || .EQU LEDS = 0x40		;port for LEDS 	OUTPUT
(0012)                       032  || .EQU SWITCH_PORT1 = 0x20	; port for switches INPUT
(0013)                       052  || .EQU SWITCH_PORT2 = 0x34
(0014)                       036  || .EQU RAND_PORT = 0x24	;port for random number	INPUT
(0015)                            || 
(0016)                            || ;--------------------------------------------------------------------------------------------
(0017)                            || ;GAME CONSTANTS
(0018)                            || ;---------------------------------------------------------------------------------------------
(0019)                       255  || .EQU DELAY	=	0xFF 	;delay timer for the user to enter a interrupt.
(0020)                            || 
(0021)                       255  || .EQU BG_COLOR       = 0xFF              ; Background:  white
(0022)                       000  || .EQU BEAKER_WALLS   = 0x00				; Walls of the beaker
            syntax error

(0023)                            || .EQU DIRECTION DOWN = 0x02				; Direction of the added substance
            syntax error
            syntax error
            syntax error

(0024)                       136  || .EQU FLUID_COLOR	= 0x88			    ; Port TBD later for rng number
(0025)                       003  || .EQU NUM_LIVES      = 0x03				; Set of lives until gameover
(0026)                       000  || .EQU STARTING_SCORE = 0x00				; Score for initial points
(0027)                            || 
(0028)                            || ;-----------------------------------------------------------------------
(0029)                            || ;- Register Usage
(0030)                            || ;-----------------------------------------------------------------------
(0031)                            || ;- GAME
(0032)                            || ;
(0033)                            || ;R01: DIRECTION DOWN
(0034)                            || ;R02: RANDOM NUMBER
(0035)                            || ;R11: COLOR ADDITION 
(0036)                            || ;R12: LEVEL
(0037)                            || ;R03: LIVES
(0038)                            || ;R14: SCORE
(0039)                            || 
(0040)                            || ;- UNUSED
(0041)                            || ;
(0042)                            || ;- INPUT
(0043)                            || ;R15: SWITCH ENABLED
(0044)                            || ;R16: BUTTON
(0045)                            || ;
(0046)                            || ;- OUTPUT
(0047)                            || ;R16: LEDS
(0048)                            || ;R17: SSEGS
(0049)                            || ;
(0050)                            || ;- DRAWING
(0051)                            || ;
(0052)                            || ;R18: TEMP COLOR
(0053)                            || ;R19: TEMP FLUID COLOR
(0054)                            || ;R20: DRAW LINE ENDING TRACKER
(0055)                            || ;R21: DRAW BACKGROUND ROW TRACKER
(0056)                            || ;R22: DRAW DOT 
(0057)                            || ;R23: KEY UP INFO FLAG
(0058)                            || ;r6 is used for color
(0059)                            || ;r7 is used for Y
(0060)                            || ;r8 is used for X
(0061)                            || ;---------------------------------------------------------------------
(0062)                     0x010  || init:
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08080  0x100  ||              BRN     0x10        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0063)  CS-0x010  0x08979         ||          CALL   draw_background         ; draw using default color
(0064)                            || 
(0065)                            || 		 
(0066)  CS-0x011  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0067)  CS-0x012  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0068)  CS-0x013  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0069)  CS-0x014  0x08439         || 		 CALL   draw_beaker
(0070)                            || 		 
(0071)  CS-0x015  0x3670D         || 		 MOV 	R7, 0x0D				; Y coordinate for fluid				
(0072)  CS-0x016  0x36814         || 		 MOV	R8, 0x14				; X coordinate for fluid
(0073)  CS-0x017  0x36603         || 		 MOV	R6, 0x03				; moves blue (PUT COLOR FROM WRAPPER LATER)
(0074)  CS-0x018  0x084B1         || 		 CALL   draw_fluid				; draws the fluid inside the beaker
(0075)                            || 
(0076)  CS-0x019  0x36200         || 		 MOV 	R2,  0x00				; determines difficulty from switches
(0077)  CS-0x01A  0x36304         || 		 MOV	R3,  0x04				; lives
(0078)  CS-0x01B  0x36C00         || 		 MOV	R12, 0x00				; actual difficulty
(0079)  CS-0x01C  0x36D00         || 		 MOV	R13, 0x00				; switch for chemical pour
(0080)  CS-0x01D  0x36E00         || 		 MOV	R14, 0x00				; counter for difficulty determination
(0081)  CS-0x01E  0x36F00         || 		 MOV	R15, 0x00				; stores switches value for color
(0082)  CS-0x01F  0x37000         || 		 MOV	R16, 0x00				; keeps track of progress
(0083)  CS-0x020  0x37100         || 		 MOV	R17, 0x00				; keeps track of all difficulty loops
(0084)  CS-0x021  0x05201         || 		 MOV	R18, R0					; temporary value for R0
(0085)  CS-0x022  0x32024         || 		 IN		R0,  RAND_PORT
(0086)  CS-0x023  0x1A000         || 		 SEI
(0087)                            || 
(0088)                            || ;---------------------------------------------------------------------
(0089)                            || 
(0090)                            || ;---------------------------------------------------------------------
(0091)                     0x024  || init_prog_rg:	
(0092)  CS-0x024  0x11201         || 		 LSR 	R18
(0093)  CS-0x025  0x2B000         || 		 ADDC	R16, 0x00
(0094)  CS-0x026  0x29101         || 		 ADD 	R17, 0x01
(0095)  CS-0x027  0x31106         || 		 CMP 	R17, 0x06
(0096)  CS-0x028  0x08123         || 		 BRNE 	init_prog_rg
(0097)  CS-0x029  0x37100         || 		 MOV	R17, 0x00
(0098)  CS-0x02A  0x18002         || 		 RET
(0099)                            || ;---------------------------------------------------------------------
(0100)                            || 		 
(0101)                            || ;---------------------------------------------------------------------
(0102)                     0x02B  || main:	 
(0103)  CS-0x02B  0x32024         || 		 IN		R0, RAND_PORT
(0104)  CS-0x02C  0x08158         || 		 BRN	main
(0105)                            || ;---------------------------------------------------------------------
(0106)                            || 		 
(0107)                            || ;---------------------------------------------------------------------
(0108)                     0x02D  || ISR:	 
(0109)  CS-0x02D  0x32120         || 		 IN 	R1, SWITCH_PORT1
(0110)  CS-0x02E  0x32234         || 		 IN		R2, SWITCH_PORT2
(0111)                            || 		 
(0112)  CS-0x02F  0x08269         || 		 CALL	prog_b1
(0113)  CS-0x030  0x30200         || 		 CMP	R2, 0x00
(0114)  CS-0x031  0x0830A         || 		 BREQ   difficulty_zero
(0115)  CS-0x032  0x30280         || 		 CMP	R2, 0x80
(0116)  CS-0x033  0x0830A         || 		 BREQ   difficulty_zero
(0117)  CS-0x034  0x0832B         || 		 BRNE	difficulty
(0118)                            || ;---------------------------------------------------------------------		
(0119)                            || 
(0120)                            || ;--------------------------------------------------------------------- 
(0121)                     0x035  || init_game:	 
(0122)  CS-0x035  0x30D01         ||          CMP    R13, 0x01
(0123)  CS-0x036  0x081DA         || 		 BREQ 	game
(0124)  CS-0x037  0x32234         || 		 IN 	R2, SWITCH_PORT2
(0125)  CS-0x038  0x10200         || 		 LSL 	R2
(0126)  CS-0x039  0x2AD00         || 		 ADDC 	R13, 0x00
(0127)  CS-0x03A  0x081A8         || 		 BRN 	init_game
(0128)                            || ;---------------------------------------------------------------------
(0129)                            || 
(0130)                            || ;---------------------------------------------------------------------
(0131)                     0x03B  || game:
(0132)  CS-0x03B  0x36700         || 		 MOV	R7, 0x00
(0133)  CS-0x03C  0x36818         || 		 MOV	R8, 0x18
(0134)  CS-0x03D  0x36620         || 		 MOV 	R6, SWITCH_PORT1
(0135)  CS-0x03E  0x04F31         || 		 MOV	R15, R6
(0136)  CS-0x03F  0x08A19         || 		 CALL 	draw_flow
(0137)                            || 		 
(0138)  CS-0x040  0x08239         || 		 CALL	color_changer
(0139)                            || 		 
(0140)  CS-0x041  0x08269         || 		 CALL	prog_b1
(0141)                            || 		 
(0142)  CS-0x042  0x082E1         || 		 CALL	guess_check
(0143)                            || 		 
(0144)  CS-0x043  0x36700         || 		 MOV	R7, 0x00
(0145)  CS-0x044  0x36818         || 		 MOV 	R8, 0x18
(0146)  CS-0x045  0x366FF         || 		 MOV 	R6, 0xFF
(0147)  CS-0x046  0x08A19         || 		 CALL	draw_flow
(0148)                            || ;---------------------------------------------------------------------
(0149)                            || 
(0150)                            || ;---------------------------------------------------------------------
(0151)                     0x047  || color_changer:
(0152)  CS-0x047  0x0007A         || 		 EXOR 	R0, R15
(0153)  CS-0x048  0x3670D         || 		 MOV 	R7, 0x0D
(0154)  CS-0x049  0x36814         || 		 MOV	R8, 0x14
(0155)  CS-0x04A  0x04601         || 		 MOV	R6, R0
(0156)  CS-0x04B  0x084B1         || 		 CALL	draw_fluid
(0157)  CS-0x04C  0x18002         || 		 RET
(0158)                            || ;---------------------------------------------------------------------
(0159)                            || 
(0160)                            || ;---------------------------------------------------------------------
(0161)                     0x04D  || prog_b1:
(0162)  CS-0x04D  0x11201         || 		 LSR 	R18
(0163)  CS-0x04E  0x08282         || 		 BREQ	cfb
(0164)  CS-0x04F  0x0828B         || 		 BRNE	prog_b2
(0165)                            || ;---------------------------------------------------------------------
(0166)                            || 
(0167)                            || ;---------------------------------------------------------------------
(0168)  CS-0x050  0x08369  0x050  || cfb:	 CALL 	add_1
(0169)                            || ;---------------------------------------------------------------------
(0170)                            || 
(0171)                            || ;---------------------------------------------------------------------
(0172)                     0x051  || prog_b2:
(0173)  CS-0x051  0x29101         || 		 ADD 	R17, 0x01
(0174)  CS-0x052  0x31102         || 		 CMP 	R17, 0x02
(0175)  CS-0x053  0x0826B         || 		 BRNE 	prog_b1
(0176)  CS-0x054  0x37100         || 		 MOV 	R17, 0x00
(0177)                            || ;---------------------------------------------------------------------
(0178)                            || 
(0179)                            || ;---------------------------------------------------------------------
(0180)                     0x055  || prog_rg:	
(0181)  CS-0x055  0x11201         || 		 LSR 	R18
(0182)  CS-0x056  0x2B000         || 		 ADDC	R16, 0x00
(0183)  CS-0x057  0x29101         || 		 ADD 	R17, 0x01
(0184)  CS-0x058  0x31106         || 		 CMP 	R17, 0x06
(0185)  CS-0x059  0x082AB         || 		 BRNE 	prog_rg
(0186)  CS-0x05A  0x37100         || 		 MOV	R17, 0x00
(0187)  CS-0x05B  0x18002         || 		 RET
(0188)                            || ;---------------------------------------------------------------------
(0189)                            || 
(0190)                            || ;---------------------------------------------------------------------
(0191)                     0x05C  || guess_check:
(0192)  CS-0x05C  0x31108         || 		 CMP 	R17, 0x08
(0193)  CS-0x05D  0x0837A         || 		 BREQ 	endgame_win
(0194)  CS-0x05E  0x2CC01         || 		 SUB 	R12, 0x01
(0195)  CS-0x05F  0x30C00         || 		 CMP 	R12, 0x00
(0196)  CS-0x060  0x083A2         || 		 BREQ 	endgame_lose
(0197)                            || ;---------------------------------------------------------------------
(0198)                            || 
(0199)                            || ;---------------------------------------------------------------------
(0200)                     0x061  || difficulty_zero:
(0201)  CS-0x061  0x36C01         || 		 MOV 	R12, 0x01
(0202)  CS-0x062  0x10200         || 		 LSL 	R2
(0203)  CS-0x063  0x2AD00         || 		 ADDC 	R13, 0x00
(0204)  CS-0x064  0x081A8         || 		 BRN 	init_game
(0205)                            || ;---------------------------------------------------------------------
(0206)                            || 
(0207)                            || ;---------------------------------------------------------------------
(0208)                     0x065  || difficulty: 
(0209)  CS-0x065  0x10201         || 		 LSR 	R2
(0210)  CS-0x066  0x2AC00         || 		 ADDC 	R12, 0x00
(0211)  CS-0x067  0x28E01         || 		 ADD 	R14, 0x01
(0212)  CS-0x068  0x30E07         || 		 CMP 	R14, 0x07
(0213)  CS-0x069  0x0832B         || 		 BRNE 	difficulty
(0214)  CS-0x06A  0x10201         || 		 LSR 	R2
(0215)  CS-0x06B  0x2AD00         || 		 ADDC 	R13, 0x00
(0216)  CS-0x06C  0x081A8         || 		 BRN 	init_game
(0217)                            || ;---------------------------------------------------------------------
(0218)                            || 
(0219)                            || ;---------------------------------------------------------------------
(0220)  CS-0x06D  0x29001  0x06D  || add_1:	 ADD	R16, 0x01
(0221)  CS-0x06E  0x18002         || 		 RET
(0222)                            || ;---------------------------------------------------------------------
(0223)                            || 
(0224)                            || ;---------------------------------------------------------------------	
(0225)                     0x06F  || endgame_win:
(0226)  CS-0x06F  0x36702         || 		 MOV	R7, 0x02
(0227)  CS-0x070  0x36808         || 		 MOV	R8, 0x08
(0228)  CS-0x071  0x366FC         || 		 MOV	R6, 0xFC
(0229)  CS-0x072  0x08509         || 		 CALL   win						; draw "win"
(0230)  CS-0x073  0x1A003         || 		 RETIE
(0231)                            || ;---------------------------------------------------------------------
(0232)                            || 		 		 
(0233)                     0x074  || endgame_lose:
(0234)  CS-0x074  0x36702         || 		 MOV	R7, 0x02				; Y coordinate for "lose"
(0235)  CS-0x075  0x36808         || 		 MOV 	R8, 0x08				; X coordinate for "lose"
(0236)  CS-0x076  0x36603         || 		 MOV 	R6, 0x03				; sets default color to blue
(0237)  CS-0x077  0x08729         || 		 CALL   lose					; draw "lose"
(0238)  CS-0x078  0x1A003         || 		 RETIE
(0239)                            ||       
(0240)  CS-0x079  0x00B58  0x079  || end:     AND    r11, r11                  ; nop
(0241)  CS-0x07A  0x083C8         ||          BRN    end                     ; continuous loop
(0242)                            || ;--------------------------------------------------------------------
(0243)                            || 
(0244)                            || ;--------------------------------------------------------------------
(0245)                            || ;-  Subroutine: draw_horizontal_line
(0246)                            || ;-
(0247)                            || ;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6
(0248)                            || ;-
(0249)                            || ;-  Parameters:
(0250)                            || ;-   r8  = starting x-coordinate
(0251)                            || ;-   r7  = y-coordinate
(0252)                            || ;-   r9  = ending x-coordinate
(0253)                            || ;-   r6  = color used for line
(0254)                            || ;-
(0255)                            || ;- Tweaked registers: r8,r9
(0256)                            || ;--------------------------------------------------------------------
(0257)                     0x07B  || draw_horizontal_line:
(0258)  CS-0x07B  0x28901         ||          ADD    r9,0x01          ; go from r8 to r15 inclusive
(0259)                            || 
(0260)                     0x07C  || draw_horiz1:
(0261)  CS-0x07C  0x08A59         ||          CALL   draw_dot         ;draws a bunch of dots which will paint the line.
(0262)  CS-0x07D  0x28801         ||          ADD    r8,0x01
(0263)  CS-0x07E  0x04848         ||          CMP  	r8,r9
(0264)  CS-0x07F  0x083E3         ||          BRNE   draw_horiz1
(0265)  CS-0x080  0x18002         ||          RET
(0266)                            || ;--------------------------------------------------------------------
(0267)                            || 
(0268)                            || ;---------------------------------------------------------------------
(0269)                            || ;-  Subroutine: draw_vertical_line
(0270)                            || ;-
(0271)                            || ;-  Draws a vertical line from (r8,r7) to (r8,r9) using color in r6
(0272)                            || ;-
(0273)                            || ;-  Parameters:
(0274)                            || ;-   r8  = x-coordinate
(0275)                            || ;-   r7  = starting y-coordinate
(0276)                            || ;-   r9  = ending y-coordinate
(0277)                            || ;-   r6  = color used for line
(0278)                            || ;-
(0279)                            || ;- Tweaked registers: r7,r9
(0280)                            || ;--------------------------------------------------------------------
(0281)                     0x081  || draw_vertical_line:
(0282)  CS-0x081  0x28901         ||          ADD    r9,0x01
(0283)                            || 
(0284)                     0x082  || draw_vert1:
(0285)  CS-0x082  0x08A59         ||          CALL   draw_dot
(0286)  CS-0x083  0x28701         ||          ADD    r7,0x01
(0287)  CS-0x084  0x04748         ||          CMP    r7,R9
(0288)  CS-0x085  0x08413         ||          BRNE   draw_vert1
(0289)  CS-0x086  0x18002         ||          RET
(0290)                            || ;--------------------------------------------------------------------
(0291)                            || 
(0292)                            || ;---------------------------------------------------------------------
(0293)                            || 
(0294)                     0x087  || draw_beaker:
(0295)  CS-0x087  0x04439         || 		MOV R4, R7
(0296)  CS-0x088  0x04539         || 		MOV R5, R7
(0297)                            || 		
(0298)                     0x089  || beaker_vert_1:
(0299)  CS-0x089  0x08A59         || 		CALL draw_dot
(0300)  CS-0x08A  0x28701         || 		ADD R7, 0x01
(0301)  CS-0x08B  0x30717         || 		CMP R7, 0x17
(0302)  CS-0x08C  0x0844B         || 		BRNE beaker_vert_1
(0303)                            || 		
(0304)                     0x08D  || beaker_horiz:
(0305)  CS-0x08D  0x08A59         || 		CALL draw_dot
(0306)  CS-0x08E  0x28801         || 		ADD R8, 0x01
(0307)  CS-0x08F  0x3081D         || 		CMP R8, 0x1D
(0308)  CS-0x090  0x0846B         || 		BRNE beaker_horiz
(0309)                            || 		
(0310)                     0x091  || beaker_vert_2:
(0311)  CS-0x091  0x08A59         || 		CALL draw_dot
(0312)  CS-0x092  0x2C701         || 		SUB R7, 0x01
(0313)  CS-0x093  0x30708         || 		CMP R7, 0x08
(0314)  CS-0x094  0x0848B         || 		BRNE beaker_vert_2
(0315)  CS-0x095  0x18002         || 		RET
(0316)                            || 		
(0317)                            || ;---------------------------------------------------------------------
(0318)                            || 
(0319)                            || ;---------------------------------------------------------------------
(0320)                            || 		
(0321)                     0x096  || draw_fluid:
(0322)  CS-0x096  0x04439         || 		MOV R4, R7
(0323)  CS-0x097  0x04541         || 		MOV R5, R8
(0324)                            || 		
(0325)                     0x098  || fluid_horiz:
(0326)  CS-0x098  0x08A59         || 		CALL draw_dot
(0327)  CS-0x099  0x28801         || 		ADD R8, 0x01
(0328)  CS-0x09A  0x3081D         || 		CMP R8, 0x1D
(0329)  CS-0x09B  0x084C3         || 		BRNE fluid_horiz
(0330)                            || 		
(0331)                     0x09C  || fluid_vert:
(0332)  CS-0x09C  0x36814         || 		MOV R8, 0x14
(0333)  CS-0x09D  0x28701         || 		ADD R7, 0x01
(0334)  CS-0x09E  0x30717         || 		CMP R7, 0x17
(0335)  CS-0x09F  0x084C3         || 		BRNE fluid_horiz
(0336)  CS-0x0A0  0x18002         || 		RET
(0337)                            || ;---------------------------------------------------------------------
(0338)                            || 
(0339)                            || ;---------------------------------------------------------------------
(0340)                            || 		
(0341)                     0x0A1  || win:
(0342)  CS-0x0A1  0x36702         || 		MOV	R7, 0x02				; Y coordinate for "win"
(0343)  CS-0x0A2  0x36808         || 		MOV	R8, 0x08				; X coordinate for "win"
(0344)  CS-0x0A3  0x366E0         || 		MOV	R6, 0xE0				; sets default color to red
(0345)  CS-0x0A4  0x04439         || 		MOV R4, R7
(0346)  CS-0x0A5  0x04541         || 		MOV R5, R8
(0347)                            || 		
(0348)                     0x0A6  || w_vert_1:
(0349)  CS-0x0A6  0x08A59         || 		CALL draw_dot
(0350)  CS-0x0A7  0x28701         || 		ADD R7, 0x01
(0351)  CS-0x0A8  0x30706         || 		CMP R7, 0x06
(0352)  CS-0x0A9  0x08533         || 		BRNE w_vert_1
(0353)                            || 		
(0354)                     0x0AA  || w_horiz_1:
(0355)  CS-0x0AA  0x08A59         || 		CALL draw_dot
(0356)  CS-0x0AB  0x28801         || 		ADD R8, 0x01
(0357)  CS-0x0AC  0x3080A         || 		CMP R8, 0x0A
(0358)  CS-0x0AD  0x08553         || 		BRNE w_horiz_1
(0359)                            || 		
(0360)                     0x0AE  || w_vert_2:
(0361)  CS-0x0AE  0x08A59         || 		CALL draw_dot
(0362)  CS-0x0AF  0x2C701         || 		SUB R7, 0x01
(0363)  CS-0x0B0  0x30701         || 		CMP R7, 0x01
(0364)  CS-0x0B1  0x08573         || 		BRNE w_vert_2
(0365)  CS-0x0B2  0x36706         || 		MOV R7, 0x06
(0366)                            || 		
(0367)                     0x0B3  || w_horiz_2:
(0368)  CS-0x0B3  0x08A59         || 		CALL draw_dot
(0369)  CS-0x0B4  0x28801         || 		ADD R8, 0x01
(0370)  CS-0x0B5  0x3080C         || 		CMP R8, 0x0C
(0371)  CS-0x0B6  0x0859B         || 		BRNE w_horiz_2
(0372)                            || 		
(0373)                     0x0B7  || w_vert_3:
(0374)  CS-0x0B7  0x08A59         || 		CALL draw_dot
(0375)  CS-0x0B8  0x2C701         || 		SUB R7, 0x01
(0376)  CS-0x0B9  0x30701         || 		CMP R7, 0x01
(0377)  CS-0x0BA  0x085BB         || 		BRNE w_vert_3
(0378)  CS-0x0BB  0x3680E         || 		MOV R8, 0x0E
(0379)  CS-0x0BC  0x36702         || 		MOV R7, 0x02
(0380)                            || 		
(0381)                     0x0BD  || i_horiz_1:
(0382)  CS-0x0BD  0x08A59         || 		CALL draw_dot
(0383)  CS-0x0BE  0x28801         || 		ADD R8, 0x01
(0384)  CS-0x0BF  0x30813         || 		CMP R8, 0x13
(0385)  CS-0x0C0  0x085EB         || 		BRNE i_horiz_1
(0386)  CS-0x0C1  0x36810         || 		MOV R8, 0x10
(0387)                            || 		
(0388)                     0x0C2  || i_vert:
(0389)  CS-0x0C2  0x08A59         || 		CALL draw_dot
(0390)  CS-0x0C3  0x28701         || 		ADD R7, 0x01
(0391)  CS-0x0C4  0x30706         || 		CMP R7, 0x06
(0392)  CS-0x0C5  0x08613         || 		BRNE i_vert
(0393)  CS-0x0C6  0x3680E         || 		MOV R8, 0x0E
(0394)  CS-0x0C7  0x36706         || 		MOV R7, 0x06
(0395)                            || 		
(0396)                     0x0C8  || i_horiz_2:
(0397)  CS-0x0C8  0x08A59         || 		CALL draw_dot
(0398)  CS-0x0C9  0x28801         || 		ADD R8, 0x01
(0399)  CS-0x0CA  0x30813         || 		CMP R8, 0x13
(0400)  CS-0x0CB  0x08643         || 		BRNE i_horiz_2
(0401)  CS-0x0CC  0x36814         || 		MOV R8, 0x14
(0402)  CS-0x0CD  0x36702         || 		MOV R7, 0x02
(0403)                            || 		
(0404)                     0x0CE  || n_vert_1:
(0405)  CS-0x0CE  0x08A59         || 		CALL draw_dot
(0406)  CS-0x0CF  0x28701         || 		ADD R7, 0x01
(0407)  CS-0x0D0  0x30707         || 		CMP R7, 0x07
(0408)  CS-0x0D1  0x08673         || 		BRNE n_vert_1
(0409)  CS-0x0D2  0x36702         || 		MOV R7, 0x02
(0410)  CS-0x0D3  0x28801         || 		ADD R8, 0x01
(0411)  CS-0x0D4  0x08A59         || 		CALL draw_dot
(0412)  CS-0x0D5  0x28801         || 		ADD R8, 0x01
(0413)  CS-0x0D6  0x36703         || 		MOV R7, 0x03
(0414)                            || 		
(0415)                            || 
(0416)                     0x0D7  || n_vert_2:
(0417)  CS-0x0D7  0x08A59         || 		CALL draw_dot
(0418)  CS-0x0D8  0x28701         || 		ADD R7, 0x01
(0419)  CS-0x0D9  0x30706         || 		CMP R7, 0x06
(0420)  CS-0x0DA  0x086BB         || 		BRNE n_vert_2
(0421)  CS-0x0DB  0x36706         || 		MOV R7, 0x06
(0422)  CS-0x0DC  0x28801         || 		ADD R8, 0x01
(0423)  CS-0x0DD  0x08A59         || 		CALL draw_dot
(0424)  CS-0x0DE  0x36702         || 		MOV R7, 0x02
(0425)  CS-0x0DF  0x28801         || 		ADD R8, 0x01
(0426)                            || 		
(0427)                     0x0E0  || n_vert_3:
(0428)  CS-0x0E0  0x08A59         || 		CALL draw_dot
(0429)  CS-0x0E1  0x28701         || 		ADD R7, 0x01
(0430)  CS-0x0E2  0x30707         || 		CMP R7, 0x07
(0431)  CS-0x0E3  0x08703         || 		BRNE n_vert_3
(0432)  CS-0x0E4  0x18002         || 		RET
(0433)                            || 		
(0434)                            || ;---------------------------------------------------------------------
(0435)                            || 
(0436)                            || ;---------------------------------------------------------------------
(0437)                            || 
(0438)                     0x0E5  || lose:
(0439)  CS-0x0E5  0x04439         || 		MOV R4, R7
(0440)  CS-0x0E6  0x04541         || 		MOV R5, R8
(0441)                            || 		
(0442)                     0x0E7  || l_vert:
(0443)  CS-0x0E7  0x08A59         || 		CALL draw_dot
(0444)  CS-0x0E8  0x28701         || 		ADD R7, 0x01
(0445)  CS-0x0E9  0x30706         || 		CMP R7, 0x06
(0446)  CS-0x0EA  0x0873B         || 		BRNE l_vert
(0447)                            || 		
(0448)                     0x0EB  || l_horiz:
(0449)  CS-0x0EB  0x08A59         || 		CALL draw_dot
(0450)  CS-0x0EC  0x28801         || 		ADD R8, 0x01
(0451)  CS-0x0ED  0x3080D         || 		CMP R8, 0x0D
(0452)  CS-0x0EE  0x0875B         || 		BRNE l_horiz
(0453)  CS-0x0EF  0x36702         || 		MOV R7, 0x02
(0454)  CS-0x0F0  0x3680E         || 		MOV R8, 0x0E
(0455)                            || 		
(0456)                     0x0F1  || o_vert_1:
(0457)  CS-0x0F1  0x08A59         || 		CALL draw_dot
(0458)  CS-0x0F2  0x28701         || 		ADD R7, 0x01
(0459)  CS-0x0F3  0x30706         || 		CMP R7, 0x06
(0460)  CS-0x0F4  0x0878B         || 		BRNE o_vert_1
(0461)                            || 
(0462)                     0x0F5  || o_horiz_1:
(0463)  CS-0x0F5  0x08A59         || 		CALL draw_dot
(0464)  CS-0x0F6  0x28801         || 		ADD R8, 0x01
(0465)  CS-0x0F7  0x30812         || 		CMP R8, 0x12
(0466)  CS-0x0F8  0x087AB         || 		BRNE o_horiz_1
(0467)                            || 
(0468)                     0x0F9  || o_vert_2:
(0469)  CS-0x0F9  0x08A59         || 		CALL draw_dot
(0470)  CS-0x0FA  0x2C701         || 		SUB R7, 0x01
(0471)  CS-0x0FB  0x30702         || 		CMP R7, 0x02
(0472)  CS-0x0FC  0x087CB         || 		BRNE o_vert_2
(0473)                            || 		
(0474)                     0x0FD  || o_horiz_2:
(0475)  CS-0x0FD  0x08A59         || 		CALL draw_dot
(0476)  CS-0x0FE  0x2C801         || 		SUB R8, 0x01
(0477)  CS-0x0FF  0x3080E         || 		CMP R8, 0x0E
(0478)  CS-0x100  0x087EB         || 		BRNE o_horiz_2	
(0479)  CS-0x101  0x36814         || 		MOV R8, 0x14
(0480)  CS-0x102  0x36702         || 		MOV R7, 0x02
(0481)                            || 		
(0482)                     0x103  || s_horiz_1:
(0483)  CS-0x103  0x08A59         || 		CALL draw_dot
(0484)  CS-0x104  0x28801         || 		ADD R8, 0x01
(0485)  CS-0x105  0x30819         || 		CMP R8, 0x19
(0486)  CS-0x106  0x0881B         || 		BRNE s_horiz_1
(0487)  CS-0x107  0x36814         || 		MOV R8, 0x14
(0488)  CS-0x108  0x28701         || 		ADD R7, 0x01
(0489)  CS-0x109  0x08A59         || 		CALL draw_dot
(0490)  CS-0x10A  0x28701         || 		ADD R7, 0x01
(0491)                            || 		
(0492)                     0x10B  || s_horiz_2:
(0493)  CS-0x10B  0x08A59         || 		CALL draw_dot
(0494)  CS-0x10C  0x28801         || 		ADD R8, 0x01
(0495)  CS-0x10D  0x30819         || 		CMP R8, 0x19
(0496)  CS-0x10E  0x0885B         || 		BRNE s_horiz_2
(0497)  CS-0x10F  0x36818         || 		MOV R8, 0x18
(0498)  CS-0x110  0x28701         || 		ADD R7, 0x01
(0499)  CS-0x111  0x08A59         || 		CALL draw_dot
(0500)  CS-0x112  0x36814         || 		MOV R8, 0x14
(0501)  CS-0x113  0x28701         || 		ADD R7, 0x01
(0502)                            || 		
(0503)                     0x114  || s_horiz_3:
(0504)  CS-0x114  0x08A59         || 		CALL draw_dot
(0505)  CS-0x115  0x28801         || 		ADD R8, 0x01
(0506)  CS-0x116  0x30819         || 		CMP R8, 0x19
(0507)  CS-0x117  0x088A3         || 		BRNE s_horiz_3
(0508)  CS-0x118  0x3681A         || 		MOV R8, 0x1A
(0509)  CS-0x119  0x36702         || 		MOV R7, 0x02
(0510)                            || 
(0511)                     0x11A  || e_horiz_1:
(0512)  CS-0x11A  0x08A59         || 		CALL draw_dot
(0513)  CS-0x11B  0x28801         || 		ADD R8, 0x01
(0514)  CS-0x11C  0x3081E         || 		CMP R8, 0x1E
(0515)  CS-0x11D  0x088D3         || 		BRNE e_horiz_1
(0516)  CS-0x11E  0x3681A         || 		MOV R8, 0x1A
(0517)  CS-0x11F  0x28701         || 		ADD R7, 0x01
(0518)  CS-0x120  0x08A59         || 		CALL draw_dot
(0519)  CS-0x121  0x28701         || 		ADD R7, 0x01
(0520)                            || 		
(0521)                     0x122  || e_horiz_2:
(0522)  CS-0x122  0x08A59         || 		CALL draw_dot
(0523)  CS-0x123  0x28801         || 		ADD R8, 0x01
(0524)  CS-0x124  0x3081E         || 		CMP R8, 0x1E
(0525)  CS-0x125  0x08913         || 		BRNE e_horiz_2
(0526)  CS-0x126  0x3681A         || 		MOV R8, 0x1A
(0527)  CS-0x127  0x28701         || 		ADD R7, 0x01
(0528)  CS-0x128  0x08A59         || 		CALL draw_dot
(0529)  CS-0x129  0x28701         || 		ADD R7, 0x01
(0530)                            || 		
(0531)                     0x12A  || e_horiz_3:
(0532)  CS-0x12A  0x08A59         || 		CALL draw_dot
(0533)  CS-0x12B  0x28801         || 		ADD R8, 0x01
(0534)  CS-0x12C  0x3081E         || 		CMP R8, 0x1E
(0535)  CS-0x12D  0x08953         || 		BRNE e_horiz_3
(0536)  CS-0x12E  0x18002         || 		RET
(0537)                            || ;---------------------------------------------------------------------
(0538)                            || 
(0539)                            || ;---------------------------------------------------------------------
(0540)                            || ;-  Subroutine: draw_background
(0541)                            || ;-
(0542)                            || ;-  Fills the 40x30 grid with one color using successive calls to
(0543)                            || ;-  draw_horizontal_line subroutine.
(0544)                            || ;-
(0545)                            || ;-  Tweaked registers: r10,r7,r8,r9
(0546)                            || ;----------------------------------------------------------------------
(0547)                     0x12F  || draw_background:
(0548)  CS-0x12F  0x366FF         ||          MOV   r6,BG_COLOR              ; use default color
(0549)  CS-0x130  0x36A00         ||          MOV   r10,0x00                 ; r10 keeps track of rows
(0550)  CS-0x131  0x04751  0x131  || start:   MOV   r7,r10                   ; load current row count
(0551)  CS-0x132  0x36800         ||          MOV   r8,0x00                  ; restart x coordinates
(0552)  CS-0x133  0x36927         ||          MOV   r9,0x27
(0553)                            ||  
(0554)  CS-0x134  0x083D9         ||          CALL  draw_horizontal_line
(0555)  CS-0x135  0x28A01         ||          ADD   r10,0x01                 ; increment row count
(0556)  CS-0x136  0x30A1E         ||          CMP   r10,0x1E                 ; see if more rows to draw
(0557)  CS-0x137  0x0898B         ||          BRNE  start                    ; branch to draw more rows
(0558)  CS-0x138  0x18002         ||          RET
(0559)                            || ;---------------------------------------------------------------------
(0560)                            || 
(0561)                            || ;---------------------------------------------------------------------
(0562)                     0x139  || seconds:
(0563)  CS-0x139  0x37DD9         || 		 MOV R29, 0xD9           ;Moves 0xE7 into register R29. This is
(0564)                            ||                                  ;25 values away from 0x00
(0565)                     0x13A  || seconds_init_2:
(0566)  CS-0x13A  0x37E06         || 		 MOV R30, 0x06           ;Moves 0x06 into register R30. This is 
(0567)                            ||                                  ;250 values away from 0x00
(0568)                     0x13B  || seconds_init_3:
(0569)  CS-0x13B  0x37F06         || 		 MOV R31, 0x06           ;Moves 0x06 into register R31. This is               
(0570)                            || 								 ;250 values away from 0x00
(0571)                     0x13C  || seconds_init_4:
(0572)  CS-0x13C  0x29F01         || 		 ADD R31, 0x01           ;Adds 0x01 to R1 in the loop 250 times 
(0573)                            || 								 ;per loop
(0574)                            || 
(0575)  CS-0x13D  0x089E3         || 	 	 BRNE seconds_init_4     ;Loops back to seconds_init
(0576)                            || 								 ;until the value in R1 is 0
(0577)                            || 
(0578)  CS-0x13E  0x29E01         || 		 ADD R30, 0x01            ;Adds 0x01 to R2 in the loop 250 times 
(0579)                            || 								 ;per loop
(0580)                            || 
(0581)  CS-0x13F  0x089DB         || 		 BRNE seconds_init_3      ;Loops back to the line seconds_init  
(0582)                            || 								 ;to reset the value stored into R1 back 
(0583)                            || 								 ;to 0x06 for the next loop until the  
(0584)                            || 								 ;value  in R2 is 0x00
(0585)                            || 
(0586)                            || 		 
(0587)  CS-0x140  0x29D01         || 		 ADD R29, 0x01            ;Adds 0x01 into R3 in the loop 25 times 
(0588)                            || 								 ;per loop
(0589)                            || 
(0590)  CS-0x141  0x089D3         || 		 BRNE seconds_init_2       ;Loops back to the line “MOV R2, 0x06” 
(0591)                            || 								 ;in order to reset both R1 and R2 to 
(0592)                            || 								 ;0x06 for the next loop until the value 
(0593)                            || 								 ;of R3 is 0x00
(0594)                            || 		 
(0595)  CS-0x142  0x18002         || 		  RET
(0596)                            || ;---------------------------------------------------------------------
(0597)                            || 
(0598)                     0x143  || draw_flow:
(0599)  CS-0x143  0x04439         || 		 MOV R4, R7
(0600)  CS-0x144  0x04541         || 		 MOV R5, R8
(0601)                            || 		 
(0602)                     0x145  || draw_flow_start:
(0603)  CS-0x145  0x089C9         || 		 CALL seconds
(0604)  CS-0x146  0x08A59         || 		 CALL draw_dot
(0605)                            || 
(0606)  CS-0x147  0x28701         || 		 ADD R7, 0x01
(0607)                            || 
(0608)  CS-0x148  0x3070D         || 		 CMP R7, 0x0D
(0609)  CS-0x149  0x0AA28         || 		 BRCS draw_flow_start
(0610)  CS-0x14A  0x18002         || 		 RET
(0611)                            || 			
(0612)                            || ;---------------------------------------------------------------------
(0613)                            || ;- Subrountine: draw_dot
(0614)                            || ;-
(0615)                            || ;- This subroutine draws a dot on the display the given coordinates:
(0616)                            || ;-
(0617)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6
(0618)                            || ;-
(0619)                            || ;- Tweaked registers: r4,r5
(0620)                            || ;---------------------------------------------------------------------
(0621)                     0x14B  || draw_dot:
(0622)  CS-0x14B  0x04439         ||            MOV   r4,r7         ; copy Y coordinate
(0623)  CS-0x14C  0x04541         ||            MOV   r5,r8         ; copy X coordinate
(0624)                            || 
(0625)  CS-0x14D  0x2053F         ||            AND   r5,0x3F       ; make sure top 2 bits cleared, has to be a number within 6 bits so don't need all 8 for the columns.
(0626)  CS-0x14E  0x2041F         ||            AND   r4,0x1F       ; make sure top 3 bits cleared, has to be a number within 5 bits for the rows.
(0627)  CS-0x14F  0x10401         ||            LSR   r4             ; need to get the bot 2 bits of r4 into sA
(0628)  CS-0x150  0x0AAB8         ||            BRCS  dd_add40
(0629)  CS-0x151  0x10401  0x151  || t1:        LSR   r4
(0630)  CS-0x152  0x0AAD0         ||            BRCS  dd_add80
(0631)                            || 
(0632)  CS-0x153  0x34591  0x153  || dd_out:    OUT   r5,VGA_LADD   ; write bot 8 address bits to register
(0633)  CS-0x154  0x34490         ||            OUT   r4,VGA_HADD   ; write top 3 address bits to register
(0634)  CS-0x155  0x34692         ||            OUT   r6,VGA_COLOR  ; write data to frame buffer, combining x and y corrd to produce 11 bit address.
(0635)  CS-0x156  0x18002         ||            RET
(0636)                            || 
(0637)  CS-0x157  0x22540  0x157  || dd_add40:  OR    r5,0x40       ; set bit if needed
(0638)  CS-0x158  0x18000         ||            CLC                 ; freshen bit
(0639)  CS-0x159  0x08A88         ||            BRN   t1
(0640)                            || 
(0641)  CS-0x15A  0x22580  0x15A  || dd_add80:  OR    r5,0x80       ; set bit if needed
(0642)  CS-0x15B  0x08A98         ||            BRN   dd_out
(0643)                            || ; --------------------------------------------------------------------
(0644)                            || 
(0645)                            || .CSEG
(0646)                       1023  || .ORG 0x3FF
(0647)                            || ;IN R13, BUTTON_PORT1	;interrupt will stop what its doing to access the ISR what will this button do?
(0648)                            || ;switches will be compared to see if certain switches went high and others low which will be compared to the random seed
(0649)                            || ;IN R14, BUTTON_PORT2
(0650)  CS-0x3FF  0x08168         || BRN ISR





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
ADD_1          0x06D   (0220)  ||  0168 
BEAKER_HORIZ   0x08D   (0304)  ||  0308 
BEAKER_VERT_1  0x089   (0298)  ||  0302 
BEAKER_VERT_2  0x091   (0310)  ||  0314 
CFB            0x050   (0168)  ||  0163 
COLOR_CHANGER  0x047   (0151)  ||  0138 
DD_ADD40       0x157   (0637)  ||  0628 
DD_ADD80       0x15A   (0641)  ||  0630 
DD_OUT         0x153   (0632)  ||  0642 
DIFFICULTY     0x065   (0208)  ||  0117 0213 
DIFFICULTY_ZERO 0x061   (0200)  ||  0114 0116 
DRAW_BACKGROUND 0x12F   (0547)  ||  0063 
DRAW_BEAKER    0x087   (0294)  ||  0069 
DRAW_DOT       0x14B   (0621)  ||  0261 0285 0299 0305 0311 0326 0349 0355 0361 0368 
                               ||  0374 0382 0389 0397 0405 0411 0417 0423 0428 0443 
                               ||  0449 0457 0463 0469 0475 0483 0489 0493 0499 0504 
                               ||  0512 0518 0522 0528 0532 0604 
DRAW_FLOW      0x143   (0598)  ||  0136 0147 
DRAW_FLOW_START 0x145   (0602)  ||  0609 
DRAW_FLUID     0x096   (0321)  ||  0074 0156 
DRAW_HORIZ1    0x07C   (0260)  ||  0264 
DRAW_HORIZONTAL_LINE 0x07B   (0257)  ||  0554 
DRAW_VERT1     0x082   (0284)  ||  0288 
DRAW_VERTICAL_LINE 0x081   (0281)  ||  
END            0x079   (0240)  ||  0241 
ENDGAME_LOSE   0x074   (0233)  ||  0196 
ENDGAME_WIN    0x06F   (0225)  ||  0193 
E_HORIZ_1      0x11A   (0511)  ||  0515 
E_HORIZ_2      0x122   (0521)  ||  0525 
E_HORIZ_3      0x12A   (0531)  ||  0535 
FLUID_HORIZ    0x098   (0325)  ||  0329 0335 
FLUID_VERT     0x09C   (0331)  ||  
GAME           0x03B   (0131)  ||  0123 
GUESS_CHECK    0x05C   (0191)  ||  0142 
INIT           0x010   (0062)  ||  
INIT_GAME      0x035   (0121)  ||  0127 0204 0216 
INIT_PROG_RG   0x024   (0091)  ||  0096 
ISR            0x02D   (0108)  ||  0650 
I_HORIZ_1      0x0BD   (0381)  ||  0385 
I_HORIZ_2      0x0C8   (0396)  ||  0400 
I_VERT         0x0C2   (0388)  ||  0392 
LOSE           0x0E5   (0438)  ||  0237 
L_HORIZ        0x0EB   (0448)  ||  0452 
L_VERT         0x0E7   (0442)  ||  0446 
MAIN           0x02B   (0102)  ||  0104 
N_VERT_1       0x0CE   (0404)  ||  0408 
N_VERT_2       0x0D7   (0416)  ||  0420 
N_VERT_3       0x0E0   (0427)  ||  0431 
O_HORIZ_1      0x0F5   (0462)  ||  0466 
O_HORIZ_2      0x0FD   (0474)  ||  0478 
O_VERT_1       0x0F1   (0456)  ||  0460 
O_VERT_2       0x0F9   (0468)  ||  0472 
PROG_B1        0x04D   (0161)  ||  0112 0140 0175 
PROG_B2        0x051   (0172)  ||  0164 
PROG_RG        0x055   (0180)  ||  0185 
SECONDS        0x139   (0562)  ||  0603 
SECONDS_INIT_2 0x13A   (0565)  ||  0590 
SECONDS_INIT_3 0x13B   (0568)  ||  0581 
SECONDS_INIT_4 0x13C   (0571)  ||  0575 
START          0x131   (0550)  ||  0557 
S_HORIZ_1      0x103   (0482)  ||  0486 
S_HORIZ_2      0x10B   (0492)  ||  0496 
S_HORIZ_3      0x114   (0503)  ||  0507 
T1             0x151   (0629)  ||  0639 
WIN            0x0A1   (0341)  ||  0229 
W_HORIZ_1      0x0AA   (0354)  ||  0358 
W_HORIZ_2      0x0B3   (0367)  ||  0371 
W_VERT_1       0x0A6   (0348)  ||  0352 
W_VERT_2       0x0AE   (0360)  ||  0364 
W_VERT_3       0x0B7   (0373)  ||  0377 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BEAKER_WALLS   0x000   (0022)  ||  
BG_COLOR       0x0FF   (0021)  ||  0548 
DELAY          0x0FF   (0019)  ||  
FLUID_COLOR    0x088   (0024)  ||  
LEDS           0x040   (0011)  ||  
NUM_LIVES      0x003   (0025)  ||  
RAND_PORT      0x024   (0014)  ||  0085 0103 
SSEG           0x081   (0010)  ||  
STARTING_SCORE 0x000   (0026)  ||  
SWITCH_PORT1   0x020   (0012)  ||  0109 0134 
SWITCH_PORT2   0x034   (0013)  ||  0110 0124 
VGA_COLOR      0x092   (0009)  ||  0634 
VGA_HADD       0x090   (0007)  ||  0633 
VGA_LADD       0x091   (0008)  ||  0632 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
