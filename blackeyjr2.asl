

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
(0012)                       065  || .EQU LEDS1 = 0x41
(0013)                       032  || .EQU SWITCH_PORT1 = 0x20	; port for switches INPUT
(0014)                       036  || .EQU RAND_PORT = 0x24	;port for random number	INPUT
(0015)                            || 
(0016)                            || ;--------------------------------------------------------------------------------------------
(0017)                            || ;GAME CONSTANTS
(0018)                            || ;---------------------------------------------------------------------------------------------
(0019)                       255  || .EQU DELAY	=	0xFF 	;delay timer for the user to enter a interrupt.
(0020)                            || 
(0021)                       255  || .EQU BG_COLOR       = 0xFF              ; Background:  white 
(0022)                       000  || .EQU BEAKER_WALLS   = 0x00				; Walls of the beaker
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
(0063)  CS-0x010  0x08AA1         ||          CALL   draw_background         ; draw using default color
(0064)                            || 
(0065)                            || 		 
(0066)  CS-0x011  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0067)  CS-0x012  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0068)  CS-0x013  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0069)  CS-0x014  0x08561         || 		 CALL   draw_beaker
(0070)                            || 		 
(0071)  CS-0x015  0x36100         || 		 MOV	R1,  0x00				; temporary value for R2
(0072)  CS-0x016  0x36200         || 		 MOV 	R2,  0x00				; determines difficulty from switches
(0073)  CS-0x017  0x36304         || 		 MOV	R3,  0x04				; lives
(0074)  CS-0x018  0x36C00         || 		 MOV	R12, 0x00				; actual difficulty
(0075)  CS-0x019  0x36D00         || 		 MOV	R13, 0x00				; switch for chemical pour
(0076)  CS-0x01A  0x36E00         || 		 MOV	R14, 0x00				; counter for difficulty determination
(0077)  CS-0x01B  0x36F00         || 		 MOV	R15, 0x00				; stores switches value for color
(0078)  CS-0x01C  0x37000         || 		 MOV	R16, 0x00				; keeps track of progress
(0079)  CS-0x01D  0x37100         || 		 MOV	R17, 0x00				; keeps track of all difficulty loops
(0080)  CS-0x01E  0x05201         || 		 MOV	R18, R0					; temporary value for R0
(0081)  CS-0x01F  0x37300         || 		 MOV	R19, 0x00				; determines if the final bit of R2 has determined difficulty
(0082)  CS-0x020  0x37410         || 		 MOV 	R20, 0x10				; just a delay for seconds
(0083)  CS-0x021  0x37500         || 		 MOV	R21, 0x00				; keeps track of difficulty
(0084)  CS-0x022  0x32024         || 		 IN		R0,  RAND_PORT
(0085)  CS-0x023  0x1A000         || 		 SEI
(0086)                            || 
(0087)                            || ;---------------------------------------------------------------------
(0088)                            || 
(0089)                            || ;---------------------------------------------------------------------
(0090)                     0x024  || main:	 
(0091)  CS-0x024  0x32024         || 		 IN		R0, RAND_PORT
(0092)  CS-0x025  0x08120         || 		 BRN	main
(0093)                            || ;---------------------------------------------------------------------
(0094)                            || 		 
(0095)                            || ;---------------------------------------------------------------------
(0096)                     0x026  || ISR:	 
(0097)  CS-0x026  0x32220         || 		 IN 	R2, SWITCH_PORT1
(0098)  CS-0x027  0x04111         || 		 MOV	R1, R2
(0099)  CS-0x028  0x10101         || 		 LSR	R1
(0100)                            || 		 
(0101)  CS-0x029  0x0A131         || 		 BRCC	ISR
(0102)  CS-0x02A  0x083C1         || 		 CALL	difficulty
(0103)                            || 		 
(0104)  CS-0x02B  0x08341         || 		 CALL	red_shift
(0105)  CS-0x02C  0x05201         || 		 MOV	R18, R0
(0106)  CS-0x02D  0x082C9         || 		 CALL	prog_b1
(0107)  CS-0x02E  0x3670D         || 		 MOV 	R7, 0x0D				; Y coordinate for fluid				
(0108)  CS-0x02F  0x36814         || 		 MOV	R8, 0x14				; X coordinate for fluid
(0109)  CS-0x030  0x04601         || 		 MOV	R6, R0					; moves blue (PUT COLOR FROM WRAPPER LATER)
(0110)  CS-0x031  0x085D9         || 		 CALL   draw_fluid				; draws the fluid inside the beaker
(0111)                            || 		 
(0112)  CS-0x032  0x081D1         || 		 CALL init_game
(0113)  CS-0x033  0x08AF1         || 		 CALL seconds_divider
(0114)                            || 		 
(0115)  CS-0x034  0x08AA1         || 		 CALL   draw_background         ; draw using default color
(0116)                            || 
(0117)                            || 		 
(0118)  CS-0x035  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0119)  CS-0x036  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0120)  CS-0x037  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0121)  CS-0x038  0x08561         || 		 CALL   draw_beaker
(0122)  CS-0x039  0x1A003         || 		 RETIE
(0123)                            || 		 
(0124)                            || ;---------------------------------------------------------------------		
(0125)                            || 
(0126)                            || ;--------------------------------------------------------------------- 
(0127)                     0x03A  || init_game:	 
(0128)  CS-0x03A  0x30D01         ||          CMP    R13, 0x01
(0129)  CS-0x03B  0x0821A         || 		 BREQ 	game
(0130)  CS-0x03C  0x32220         || 		 IN 	R2, SWITCH_PORT1
(0131)  CS-0x03D  0x04111         || 		 MOV 	R1, R2
(0132)  CS-0x03E  0x10100         || 		 LSL 	R1
(0133)  CS-0x03F  0x2AD00         || 		 ADDC 	R13, 0x00
(0134)  CS-0x040  0x18000         || 		 CLC
(0135)  CS-0x041  0x10101         || 		 LSR	R1
(0136)  CS-0x042  0x081D0         || 		 BRN 	init_game
(0137)                            || ;---------------------------------------------------------------------
(0138)                            || 
(0139)                            || ;---------------------------------------------------------------------
(0140)                     0x043  || game:
(0141)  CS-0x043  0x36D00         || 		 MOV	R13, 0x00
(0142)  CS-0x044  0x36700         || 		 MOV	R7, 0x00
(0143)  CS-0x045  0x36819         || 		 MOV	R8, 0x19
(0144)  CS-0x046  0x04609         || 		 MOV 	R6, R1
(0145)  CS-0x047  0x04F31         || 		 MOV	R15, R6
(0146)  CS-0x048  0x08B71         || 		 CALL 	draw_flow
(0147)                            || 		 
(0148)  CS-0x049  0x08299         || 		 CALL	color_changer
(0149)                            || 		 
(0150)  CS-0x04A  0x05201         || 		 MOV	R18, R0
(0151)  CS-0x04B  0x082C9         || 		 CALL	prog_b1
(0152)                            || 		 
(0153)  CS-0x04C  0x08360         || 		 BRN	guess_check
(0154)                            || ;---------------------------------------------------------------------
(0155)                            || 
(0156)                            || ;---------------------------------------------------------------------
(0157)                     0x04D  || game_cnt:		 
(0158)  CS-0x04D  0x36700         || 		 MOV	R7, 0x00
(0159)  CS-0x04E  0x36819         || 		 MOV 	R8, 0x19
(0160)  CS-0x04F  0x366FF         || 		 MOV 	R6, 0xFF
(0161)  CS-0x050  0x08B71         || 		 CALL	draw_flow
(0162)  CS-0x051  0x18000         || 		 CLC
(0163)  CS-0x052  0x081D0         || 		 BRN	init_game
(0164)                            || ;---------------------------------------------------------------------
(0165)                            || 
(0166)                            || ;---------------------------------------------------------------------
(0167)                     0x053  || color_changer:
(0168)  CS-0x053  0x0007A         || 		 EXOR 	R0, R15
(0169)  CS-0x054  0x3670D         || 		 MOV 	R7, 0x0D
(0170)  CS-0x055  0x36814         || 		 MOV	R8, 0x14
(0171)  CS-0x056  0x04601         || 		 MOV	R6, R0
(0172)  CS-0x057  0x085D9         || 		 CALL	draw_fluid
(0173)  CS-0x058  0x18002         || 		 RET
(0174)                            || ;---------------------------------------------------------------------
(0175)                            || 
(0176)                            || ;---------------------------------------------------------------------
(0177)                     0x059  || prog_b1:
(0178)  CS-0x059  0x11201         || 		 LSR 	R18
(0179)  CS-0x05A  0x082E2         || 		 BREQ	cfb
(0180)  CS-0x05B  0x082EB         || 		 BRNE	prog_b2
(0181)                            || ;---------------------------------------------------------------------
(0182)                            || 
(0183)                            || ;---------------------------------------------------------------------
(0184)  CS-0x05C  0x08401  0x05C  || cfb:	 CALL 	add_1
(0185)                            || ;---------------------------------------------------------------------
(0186)                            || 
(0187)                            || ;---------------------------------------------------------------------
(0188)                     0x05D  || prog_b2:
(0189)  CS-0x05D  0x29101         || 		 ADD 	R17, 0x01
(0190)  CS-0x05E  0x31102         || 		 CMP 	R17, 0x02
(0191)  CS-0x05F  0x082CB         || 		 BRNE 	prog_b1
(0192)  CS-0x060  0x37100         || 		 MOV 	R17, 0x00
(0193)                            || ;---------------------------------------------------------------------
(0194)                            || 
(0195)                            || ;---------------------------------------------------------------------
(0196)                     0x061  || prog_rg:	
(0197)  CS-0x061  0x11201         || 		 LSR 	R18
(0198)  CS-0x062  0x2B000         || 		 ADDC	R16, 0x00
(0199)  CS-0x063  0x29101         || 		 ADD 	R17, 0x01
(0200)  CS-0x064  0x31105         || 		 CMP 	R17, 0x05
(0201)  CS-0x065  0x0830B         || 		 BRNE 	prog_rg
(0202)  CS-0x066  0x37100         || 		 MOV	R17, 0x00
(0203)  CS-0x067  0x18002         || 		 RET
(0204)                            || ;---------------------------------------------------------------------
(0205)                            || 
(0206)                            || ;---------------------------------------------------------------------
(0207)                     0x068  || red_shift:
(0208)  CS-0x068  0x10000         || 		 LSL	R0
(0209)  CS-0x069  0x18000         || 		 CLC
(0210)  CS-0x06A  0x10001         || 		 LSR	R0
(0211)  CS-0x06B  0x18002         || 		 RET
(0212)                            || ;---------------------------------------------------------------------
(0213)                            || 
(0214)                            || ;---------------------------------------------------------------------
(0215)                     0x06C  || guess_check:
(0216)  CS-0x06C  0x31007         || 		 CMP 	R16, 0x07
(0217)  CS-0x06D  0x08412         || 		 BREQ 	endgame_win
(0218)  CS-0x06E  0x2CC01         || 		 SUB 	R12, 0x01
(0219)  CS-0x06F  0x30C00         || 		 CMP 	R12, 0x00
(0220)  CS-0x070  0x08392         || 		 BREQ 	lose_life
(0221)  CS-0x071  0x0826B         || 		 BRNE	game_cnt
(0222)                            || ;---------------------------------------------------------------------
(0223)                     0x072  || lose_life:
(0224)  CS-0x072  0x04CA9         || 		 MOV	R12, R21
(0225)  CS-0x073  0x04091         || 		 MOV	R0, R18
(0226)  CS-0x074  0x2C301         || 		 SUB	R3, 0x01
(0227)  CS-0x075  0x30300         || 		 CMP	R3, 0x00
(0228)  CS-0x076  0x0826B         || 		 BRNE	game_cnt
(0229)  CS-0x077  0x08482         || 		 BREQ	endgame_lose
(0230)                            || ;---------------------------------------------------------------------
(0231)                     0x078  || difficulty: 
(0232)  CS-0x078  0x10101         || 		 LSR 	R1
(0233)  CS-0x079  0x2AC00         || 		 ADDC 	R12, 0x00
(0234)  CS-0x07A  0x28E01         || 		 ADD 	R14, 0x01
(0235)  CS-0x07B  0x30E06         || 		 CMP 	R14, 0x06
(0236)  CS-0x07C  0x083C3         || 		 BRNE 	difficulty
(0237)  CS-0x07D  0x28C01         || 		 ADD	R12, 0x01
(0238)  CS-0x07E  0x05561         || 		 MOV	R21, R12
(0239)  CS-0x07F  0x18002         || 		 RET
(0240)                            || ;---------------------------------------------------------------------
(0241)                            || 
(0242)                            || ;---------------------------------------------------------------------
(0243)  CS-0x080  0x29001  0x080  || add_1:	 ADD	R16, 0x01
(0244)  CS-0x081  0x18002         || 		 RET
(0245)                            || ;---------------------------------------------------------------------
(0246)                            || 
(0247)                            || ;---------------------------------------------------------------------	
(0248)                     0x082  || endgame_win:
(0249)  CS-0x082  0x36702         || 		 MOV	R7, 0x02
(0250)  CS-0x083  0x36808         || 		 MOV	R8, 0x08
(0251)  CS-0x084  0x366FC         || 		 MOV	R6, 0xFC
(0252)  CS-0x085  0x08631         || 		 CALL   win						; draw "win"
(0253)  CS-0x086  0x3670D         || 		 MOV	R7, 0x0D
(0254)  CS-0x087  0x36814         || 		 MOV	R8, 0x14
(0255)  CS-0x088  0x366FF         || 		 MOV	R6, 0xFF
(0256)  CS-0x089  0x085D9         || 		 CALL	draw_fluid
(0257)  CS-0x08A  0x36700         || 		 MOV	R7, 0x00
(0258)  CS-0x08B  0x36819         || 		 MOV	R8, 0x19
(0259)  CS-0x08C  0x366FF         || 		 MOV 	R6, 0xFF
(0260)  CS-0x08D  0x08B71         || 		 CALL	draw_flow
(0261)  CS-0x08E  0x36304         || 		 MOV	R3, 0x04
(0262)  CS-0x08F  0x18002         || 		 RET
(0263)                            || ;---------------------------------------------------------------------
(0264)                            || 		 		 
(0265)                     0x090  || endgame_lose:
(0266)  CS-0x090  0x36702         || 		 MOV	R7, 0x02				; Y coordinate for "lose"
(0267)  CS-0x091  0x36808         || 		 MOV 	R8, 0x08				; X coordinate for "lose"
(0268)  CS-0x092  0x36603         || 		 MOV 	R6, 0x03				; sets default color to blue
(0269)  CS-0x093  0x08851         || 		 CALL   lose					; draw "lose"
(0270)  CS-0x094  0x3670D         || 		 MOV	R7, 0x0D
(0271)  CS-0x095  0x36814         || 		 MOV	R8, 0x14
(0272)  CS-0x096  0x366FF         || 		 MOV	R6, 0xFF
(0273)  CS-0x097  0x085D9         || 		 CALL	draw_fluid
(0274)  CS-0x098  0x36700         || 		 MOV	R7, 0x00
(0275)  CS-0x099  0x36819         || 		 MOV	R8, 0x19
(0276)  CS-0x09A  0x366FF         || 		 MOV 	R6, 0xFF
(0277)  CS-0x09B  0x08B71         || 		 CALL	draw_flow
(0278)  CS-0x09C  0x36304         || 		 MOV	R3, 0x04
(0279)  CS-0x09D  0x18002         || 		 RET
(0280)                            ||       
(0281)  CS-0x09E  0x00B58  0x09E  || end:     AND    r11, r11                ; nop
(0282)  CS-0x09F  0x084F0         ||          BRN    end                     ; continuous loop
(0283)                            || ;--------------------------------------------------------------------
(0284)                            || 
(0285)                            || ;--------------------------------------------------------------------
(0286)                            || ;-  Subroutine: draw_horizontal_line
(0287)                            || ;-
(0288)                            || ;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6
(0289)                            || ;-
(0290)                            || ;-  Parameters:
(0291)                            || ;-   r8  = starting x-coordinate
(0292)                            || ;-   r7  = y-coordinate
(0293)                            || ;-   r9  = ending x-coordinate
(0294)                            || ;-   r6  = color used for line
(0295)                            || ;-
(0296)                            || ;- Tweaked registers: r8,r9
(0297)                            || ;--------------------------------------------------------------------
(0298)                     0x0A0  || draw_horizontal_line:
(0299)  CS-0x0A0  0x28901         ||          ADD    r9,0x01          ; go from r8 to r15 inclusive
(0300)                            || 
(0301)                     0x0A1  || draw_horiz1:
(0302)  CS-0x0A1  0x08BB1         ||          CALL   draw_dot         ;draws a bunch of dots which will paint the line.
(0303)  CS-0x0A2  0x28801         ||          ADD    r8,0x01
(0304)  CS-0x0A3  0x04848         ||          CMP  	r8,r9
(0305)  CS-0x0A4  0x0850B         ||          BRNE   draw_horiz1
(0306)  CS-0x0A5  0x18002         ||          RET
(0307)                            || ;--------------------------------------------------------------------
(0308)                            || 
(0309)                            || ;---------------------------------------------------------------------
(0310)                            || ;-  Subroutine: draw_vertical_line
(0311)                            || ;-
(0312)                            || ;-  Draws a vertical line from (r8,r7) to (r8,r9) using color in r6
(0313)                            || ;-
(0314)                            || ;-  Parameters:
(0315)                            || ;-   r8  = x-coordinate
(0316)                            || ;-   r7  = starting y-coordinate
(0317)                            || ;-   r9  = ending y-coordinate
(0318)                            || ;-   r6  = color used for line
(0319)                            || ;-
(0320)                            || ;- Tweaked registers: r7,r9
(0321)                            || ;--------------------------------------------------------------------
(0322)                     0x0A6  || draw_vertical_line:
(0323)  CS-0x0A6  0x28901         ||          ADD    r9,0x01
(0324)                            || 
(0325)                     0x0A7  || draw_vert1:
(0326)  CS-0x0A7  0x08BB1         ||          CALL   draw_dot
(0327)  CS-0x0A8  0x28701         ||          ADD    r7,0x01
(0328)  CS-0x0A9  0x04748         ||          CMP    r7,R9
(0329)  CS-0x0AA  0x0853B         ||          BRNE   draw_vert1
(0330)  CS-0x0AB  0x18002         ||          RET
(0331)                            || ;--------------------------------------------------------------------
(0332)                            || 
(0333)                            || ;---------------------------------------------------------------------
(0334)                            || 
(0335)                     0x0AC  || draw_beaker:
(0336)  CS-0x0AC  0x04439         || 		MOV R4, R7
(0337)  CS-0x0AD  0x04539         || 		MOV R5, R7
(0338)                            || 		
(0339)                     0x0AE  || beaker_vert_1:
(0340)  CS-0x0AE  0x08BB1         || 		CALL draw_dot
(0341)  CS-0x0AF  0x28701         || 		ADD R7, 0x01
(0342)  CS-0x0B0  0x30717         || 		CMP R7, 0x17
(0343)  CS-0x0B1  0x08573         || 		BRNE beaker_vert_1
(0344)                            || 		
(0345)                     0x0B2  || beaker_horiz:
(0346)  CS-0x0B2  0x08BB1         || 		CALL draw_dot
(0347)  CS-0x0B3  0x28801         || 		ADD R8, 0x01
(0348)  CS-0x0B4  0x3081D         || 		CMP R8, 0x1D
(0349)  CS-0x0B5  0x08593         || 		BRNE beaker_horiz
(0350)                            || 		
(0351)                     0x0B6  || beaker_vert_2:
(0352)  CS-0x0B6  0x08BB1         || 		CALL draw_dot
(0353)  CS-0x0B7  0x2C701         || 		SUB R7, 0x01
(0354)  CS-0x0B8  0x30708         || 		CMP R7, 0x08
(0355)  CS-0x0B9  0x085B3         || 		BRNE beaker_vert_2
(0356)  CS-0x0BA  0x18002         || 		RET
(0357)                            || 		
(0358)                            || ;---------------------------------------------------------------------
(0359)                            || 
(0360)                            || ;---------------------------------------------------------------------
(0361)                            || 		
(0362)                     0x0BB  || draw_fluid:
(0363)  CS-0x0BB  0x04439         || 		MOV R4, R7
(0364)  CS-0x0BC  0x04541         || 		MOV R5, R8
(0365)                            || 		
(0366)                     0x0BD  || fluid_horiz:
(0367)  CS-0x0BD  0x08BB1         || 		CALL draw_dot
(0368)  CS-0x0BE  0x28801         || 		ADD R8, 0x01
(0369)  CS-0x0BF  0x3081D         || 		CMP R8, 0x1D
(0370)  CS-0x0C0  0x085EB         || 		BRNE fluid_horiz
(0371)                            || 		
(0372)                     0x0C1  || fluid_vert:
(0373)  CS-0x0C1  0x36814         || 		MOV R8, 0x14
(0374)  CS-0x0C2  0x28701         || 		ADD R7, 0x01
(0375)  CS-0x0C3  0x30717         || 		CMP R7, 0x17
(0376)  CS-0x0C4  0x085EB         || 		BRNE fluid_horiz
(0377)  CS-0x0C5  0x18002         || 		RET
(0378)                            || ;---------------------------------------------------------------------
(0379)                            || 
(0380)                            || ;---------------------------------------------------------------------
(0381)                            || 		
(0382)                     0x0C6  || win:
(0383)  CS-0x0C6  0x36702         || 		MOV	R7, 0x02				; Y coordinate for "win"
(0384)  CS-0x0C7  0x36808         || 		MOV	R8, 0x08				; X coordinate for "win"
(0385)  CS-0x0C8  0x366E0         || 		MOV	R6, 0xE0				; sets default color to red
(0386)  CS-0x0C9  0x04439         || 		MOV R4, R7
(0387)  CS-0x0CA  0x04541         || 		MOV R5, R8
(0388)                            || 		
(0389)                     0x0CB  || w_vert_1:
(0390)  CS-0x0CB  0x08BB1         || 		CALL draw_dot
(0391)  CS-0x0CC  0x28701         || 		ADD R7, 0x01
(0392)  CS-0x0CD  0x30706         || 		CMP R7, 0x06
(0393)  CS-0x0CE  0x0865B         || 		BRNE w_vert_1
(0394)                            || 		
(0395)                     0x0CF  || w_horiz_1:
(0396)  CS-0x0CF  0x08BB1         || 		CALL draw_dot
(0397)  CS-0x0D0  0x28801         || 		ADD R8, 0x01
(0398)  CS-0x0D1  0x3080A         || 		CMP R8, 0x0A
(0399)  CS-0x0D2  0x0867B         || 		BRNE w_horiz_1
(0400)                            || 		
(0401)                     0x0D3  || w_vert_2:
(0402)  CS-0x0D3  0x08BB1         || 		CALL draw_dot
(0403)  CS-0x0D4  0x2C701         || 		SUB R7, 0x01
(0404)  CS-0x0D5  0x30701         || 		CMP R7, 0x01
(0405)  CS-0x0D6  0x0869B         || 		BRNE w_vert_2
(0406)  CS-0x0D7  0x36706         || 		MOV R7, 0x06
(0407)                            || 		
(0408)                     0x0D8  || w_horiz_2:
(0409)  CS-0x0D8  0x08BB1         || 		CALL draw_dot
(0410)  CS-0x0D9  0x28801         || 		ADD R8, 0x01
(0411)  CS-0x0DA  0x3080C         || 		CMP R8, 0x0C
(0412)  CS-0x0DB  0x086C3         || 		BRNE w_horiz_2
(0413)                            || 		
(0414)                     0x0DC  || w_vert_3:
(0415)  CS-0x0DC  0x08BB1         || 		CALL draw_dot
(0416)  CS-0x0DD  0x2C701         || 		SUB R7, 0x01
(0417)  CS-0x0DE  0x30701         || 		CMP R7, 0x01
(0418)  CS-0x0DF  0x086E3         || 		BRNE w_vert_3
(0419)  CS-0x0E0  0x3680E         || 		MOV R8, 0x0E
(0420)  CS-0x0E1  0x36702         || 		MOV R7, 0x02
(0421)                            || 		
(0422)                     0x0E2  || i_horiz_1:
(0423)  CS-0x0E2  0x08BB1         || 		CALL draw_dot
(0424)  CS-0x0E3  0x28801         || 		ADD R8, 0x01
(0425)  CS-0x0E4  0x30813         || 		CMP R8, 0x13
(0426)  CS-0x0E5  0x08713         || 		BRNE i_horiz_1
(0427)  CS-0x0E6  0x36810         || 		MOV R8, 0x10
(0428)                            || 		
(0429)                     0x0E7  || i_vert:
(0430)  CS-0x0E7  0x08BB1         || 		CALL draw_dot
(0431)  CS-0x0E8  0x28701         || 		ADD R7, 0x01
(0432)  CS-0x0E9  0x30706         || 		CMP R7, 0x06
(0433)  CS-0x0EA  0x0873B         || 		BRNE i_vert
(0434)  CS-0x0EB  0x3680E         || 		MOV R8, 0x0E
(0435)  CS-0x0EC  0x36706         || 		MOV R7, 0x06
(0436)                            || 		
(0437)                     0x0ED  || i_horiz_2:
(0438)  CS-0x0ED  0x08BB1         || 		CALL draw_dot
(0439)  CS-0x0EE  0x28801         || 		ADD R8, 0x01
(0440)  CS-0x0EF  0x30813         || 		CMP R8, 0x13
(0441)  CS-0x0F0  0x0876B         || 		BRNE i_horiz_2
(0442)  CS-0x0F1  0x36814         || 		MOV R8, 0x14
(0443)  CS-0x0F2  0x36702         || 		MOV R7, 0x02
(0444)                            || 		
(0445)                     0x0F3  || n_vert_1:
(0446)  CS-0x0F3  0x08BB1         || 		CALL draw_dot
(0447)  CS-0x0F4  0x28701         || 		ADD R7, 0x01
(0448)  CS-0x0F5  0x30707         || 		CMP R7, 0x07
(0449)  CS-0x0F6  0x0879B         || 		BRNE n_vert_1
(0450)  CS-0x0F7  0x36702         || 		MOV R7, 0x02
(0451)  CS-0x0F8  0x28801         || 		ADD R8, 0x01
(0452)  CS-0x0F9  0x08BB1         || 		CALL draw_dot
(0453)  CS-0x0FA  0x28801         || 		ADD R8, 0x01
(0454)  CS-0x0FB  0x36703         || 		MOV R7, 0x03
(0455)                            || 		
(0456)                            || 
(0457)                     0x0FC  || n_vert_2:
(0458)  CS-0x0FC  0x08BB1         || 		CALL draw_dot
(0459)  CS-0x0FD  0x28701         || 		ADD R7, 0x01
(0460)  CS-0x0FE  0x30706         || 		CMP R7, 0x06
(0461)  CS-0x0FF  0x087E3         || 		BRNE n_vert_2
(0462)  CS-0x100  0x36706         || 		MOV R7, 0x06
(0463)  CS-0x101  0x28801         || 		ADD R8, 0x01
(0464)  CS-0x102  0x08BB1         || 		CALL draw_dot
(0465)  CS-0x103  0x36702         || 		MOV R7, 0x02
(0466)  CS-0x104  0x28801         || 		ADD R8, 0x01
(0467)                            || 		
(0468)                     0x105  || n_vert_3:
(0469)  CS-0x105  0x08BB1         || 		CALL draw_dot
(0470)  CS-0x106  0x28701         || 		ADD R7, 0x01
(0471)  CS-0x107  0x30707         || 		CMP R7, 0x07
(0472)  CS-0x108  0x0882B         || 		BRNE n_vert_3
(0473)  CS-0x109  0x18002         || 		RET
(0474)                            || 		
(0475)                            || ;---------------------------------------------------------------------
(0476)                            || 
(0477)                            || ;---------------------------------------------------------------------
(0478)                            || 
(0479)                     0x10A  || lose:
(0480)  CS-0x10A  0x04439         || 		MOV R4, R7
(0481)  CS-0x10B  0x04541         || 		MOV R5, R8
(0482)                            || 		
(0483)                     0x10C  || l_vert:
(0484)  CS-0x10C  0x08BB1         || 		CALL draw_dot
(0485)  CS-0x10D  0x28701         || 		ADD R7, 0x01
(0486)  CS-0x10E  0x30706         || 		CMP R7, 0x06
(0487)  CS-0x10F  0x08863         || 		BRNE l_vert
(0488)                            || 		
(0489)                     0x110  || l_horiz:
(0490)  CS-0x110  0x08BB1         || 		CALL draw_dot
(0491)  CS-0x111  0x28801         || 		ADD R8, 0x01
(0492)  CS-0x112  0x3080D         || 		CMP R8, 0x0D
(0493)  CS-0x113  0x08883         || 		BRNE l_horiz
(0494)  CS-0x114  0x36702         || 		MOV R7, 0x02
(0495)  CS-0x115  0x3680E         || 		MOV R8, 0x0E
(0496)                            || 		
(0497)                     0x116  || o_vert_1:
(0498)  CS-0x116  0x08BB1         || 		CALL draw_dot
(0499)  CS-0x117  0x28701         || 		ADD R7, 0x01
(0500)  CS-0x118  0x30706         || 		CMP R7, 0x06
(0501)  CS-0x119  0x088B3         || 		BRNE o_vert_1
(0502)                            || 
(0503)                     0x11A  || o_horiz_1:
(0504)  CS-0x11A  0x08BB1         || 		CALL draw_dot
(0505)  CS-0x11B  0x28801         || 		ADD R8, 0x01
(0506)  CS-0x11C  0x30812         || 		CMP R8, 0x12
(0507)  CS-0x11D  0x088D3         || 		BRNE o_horiz_1
(0508)                            || 
(0509)                     0x11E  || o_vert_2:
(0510)  CS-0x11E  0x08BB1         || 		CALL draw_dot
(0511)  CS-0x11F  0x2C701         || 		SUB R7, 0x01
(0512)  CS-0x120  0x30702         || 		CMP R7, 0x02
(0513)  CS-0x121  0x088F3         || 		BRNE o_vert_2
(0514)                            || 		
(0515)                     0x122  || o_horiz_2:
(0516)  CS-0x122  0x08BB1         || 		CALL draw_dot
(0517)  CS-0x123  0x2C801         || 		SUB R8, 0x01
(0518)  CS-0x124  0x3080E         || 		CMP R8, 0x0E
(0519)  CS-0x125  0x08913         || 		BRNE o_horiz_2	
(0520)  CS-0x126  0x36814         || 		MOV R8, 0x14
(0521)  CS-0x127  0x36702         || 		MOV R7, 0x02
(0522)                            || 		
(0523)                     0x128  || s_horiz_1:
(0524)  CS-0x128  0x08BB1         || 		CALL draw_dot
(0525)  CS-0x129  0x28801         || 		ADD R8, 0x01
(0526)  CS-0x12A  0x30819         || 		CMP R8, 0x19
(0527)  CS-0x12B  0x08943         || 		BRNE s_horiz_1
(0528)  CS-0x12C  0x36814         || 		MOV R8, 0x14
(0529)  CS-0x12D  0x28701         || 		ADD R7, 0x01
(0530)  CS-0x12E  0x08BB1         || 		CALL draw_dot
(0531)  CS-0x12F  0x28701         || 		ADD R7, 0x01
(0532)                            || 		
(0533)                     0x130  || s_horiz_2:
(0534)  CS-0x130  0x08BB1         || 		CALL draw_dot
(0535)  CS-0x131  0x28801         || 		ADD R8, 0x01
(0536)  CS-0x132  0x30819         || 		CMP R8, 0x19
(0537)  CS-0x133  0x08983         || 		BRNE s_horiz_2
(0538)  CS-0x134  0x36818         || 		MOV R8, 0x18
(0539)  CS-0x135  0x28701         || 		ADD R7, 0x01
(0540)  CS-0x136  0x08BB1         || 		CALL draw_dot
(0541)  CS-0x137  0x36814         || 		MOV R8, 0x14
(0542)  CS-0x138  0x28701         || 		ADD R7, 0x01
(0543)                            || 		
(0544)                     0x139  || s_horiz_3:
(0545)  CS-0x139  0x08BB1         || 		CALL draw_dot
(0546)  CS-0x13A  0x28801         || 		ADD R8, 0x01
(0547)  CS-0x13B  0x30819         || 		CMP R8, 0x19
(0548)  CS-0x13C  0x089CB         || 		BRNE s_horiz_3
(0549)  CS-0x13D  0x3681A         || 		MOV R8, 0x1A
(0550)  CS-0x13E  0x36702         || 		MOV R7, 0x02
(0551)                            || 
(0552)                     0x13F  || e_horiz_1:
(0553)  CS-0x13F  0x08BB1         || 		CALL draw_dot
(0554)  CS-0x140  0x28801         || 		ADD R8, 0x01
(0555)  CS-0x141  0x3081E         || 		CMP R8, 0x1E
(0556)  CS-0x142  0x089FB         || 		BRNE e_horiz_1
(0557)  CS-0x143  0x3681A         || 		MOV R8, 0x1A
(0558)  CS-0x144  0x28701         || 		ADD R7, 0x01
(0559)  CS-0x145  0x08BB1         || 		CALL draw_dot
(0560)  CS-0x146  0x28701         || 		ADD R7, 0x01
(0561)                            || 		
(0562)                     0x147  || e_horiz_2:
(0563)  CS-0x147  0x08BB1         || 		CALL draw_dot
(0564)  CS-0x148  0x28801         || 		ADD R8, 0x01
(0565)  CS-0x149  0x3081E         || 		CMP R8, 0x1E
(0566)  CS-0x14A  0x08A3B         || 		BRNE e_horiz_2
(0567)  CS-0x14B  0x3681A         || 		MOV R8, 0x1A
(0568)  CS-0x14C  0x28701         || 		ADD R7, 0x01
(0569)  CS-0x14D  0x08BB1         || 		CALL draw_dot
(0570)  CS-0x14E  0x28701         || 		ADD R7, 0x01
(0571)                            || 		
(0572)                     0x14F  || e_horiz_3:
(0573)  CS-0x14F  0x08BB1         || 		CALL draw_dot
(0574)  CS-0x150  0x28801         || 		ADD R8, 0x01
(0575)  CS-0x151  0x3081E         || 		CMP R8, 0x1E
(0576)  CS-0x152  0x08A7B         || 		BRNE e_horiz_3
(0577)  CS-0x153  0x18002         || 		RET
(0578)                            || ;---------------------------------------------------------------------
(0579)                            || 
(0580)                            || ;---------------------------------------------------------------------
(0581)                            || ;-  Subroutine: draw_background
(0582)                            || ;-
(0583)                            || ;-  Fills the 40x30 grid with one color using successive calls to
(0584)                            || ;-  draw_horizontal_line subroutine.
(0585)                            || ;-
(0586)                            || ;-  Tweaked registers: r10,r7,r8,r9
(0587)                            || ;----------------------------------------------------------------------
(0588)                     0x154  || draw_background:
(0589)  CS-0x154  0x366FF         ||          MOV   r6,BG_COLOR              ; use default color
(0590)  CS-0x155  0x36A00         ||          MOV   r10,0x00                 ; r10 keeps track of rows
(0591)  CS-0x156  0x04751  0x156  || start:   MOV   r7,r10                   ; load current row count
(0592)  CS-0x157  0x36800         ||          MOV   r8,0x00                  ; restart x coordinates
(0593)  CS-0x158  0x36927         ||          MOV   r9,0x27
(0594)                            ||  
(0595)  CS-0x159  0x08501         ||          CALL  draw_horizontal_line
(0596)  CS-0x15A  0x28A01         ||          ADD   r10,0x01                 ; increment row count
(0597)  CS-0x15B  0x30A1E         ||          CMP   r10,0x1E                 ; see if more rows to draw
(0598)  CS-0x15C  0x08AB3         ||          BRNE  start                    ; branch to draw more rows
(0599)  CS-0x15D  0x18002         ||          RET
(0600)                            || ;---------------------------------------------------------------------
(0601)                            || 
(0602)                            || ;---------------------------------------------------------------------
(0603)                     0x15E  || seconds_divider:
(0604)  CS-0x15E  0x08B21         || 		 CALL	seconds
(0605)  CS-0x15F  0x2D401         || 		 SUB 	R20, 0x01
(0606)  CS-0x160  0x31400         || 		 CMP	R20, 0x00
(0607)  CS-0x161  0x08AF3         || 		 BRNE	seconds_divider
(0608)  CS-0x162  0x37410         || 		 MOV 	R20, 0x10
(0609)  CS-0x163  0x18002         || 		 ret
(0610)                            || 
(0611)                            || ;---------------------------------------------------------------------
(0612)                            || 
(0613)                            || ;---------------------------------------------------------------------
(0614)                     0x164  || seconds:
(0615)  CS-0x164  0x37DE9         || 		 MOV	R29, 0xE9        ;Moves 0xE7 into register R29. This is
(0616)                            ||                                  ;25 values away from 0x00
(0617)                     0x165  || seconds_init_2:
(0618)  CS-0x165  0x37E06         || 		 MOV 	R30, 0x06        ;Moves 0x06 into register R30. This is 
(0619)                            ||                                  ;250 values away from 0x00
(0620)                     0x166  || seconds_init_3:
(0621)  CS-0x166  0x37F06         || 		 MOV 	R31, 0x06        ;Moves 0x06 into register R31. This is               
(0622)                            || 								 ;250 values away from 0x00
(0623)                     0x167  || seconds_init_4:
(0624)  CS-0x167  0x29F01         || 		 ADD 	R31, 0x01        ;Adds 0x01 to R1 in the loop 250 times 
(0625)                            || 								 ;per loop
(0626)                            || 
(0627)  CS-0x168  0x08B3B         || 	 	 BRNE 	seconds_init_4   ;Loops back to seconds_init
(0628)                            || 								 ;until the value in R1 is 0
(0629)                            || 
(0630)  CS-0x169  0x29E01         || 		 ADD 	R30, 0x01        ;Adds 0x01 to R2 in the loop 250 times 
(0631)                            || 								 ;per loop
(0632)                            || 
(0633)  CS-0x16A  0x08B33         || 		 BRNE 	seconds_init_3   ;Loops back to the line seconds_init  
(0634)                            || 								 ;to reset the value stored into R1 back 
(0635)                            || 								 ;to 0x06 for the next loop until the  
(0636)                            || 								 ;value  in R2 is 0x00
(0637)                            || 
(0638)                            || 		 
(0639)  CS-0x16B  0x29D01         || 		 ADD 	R29, 0x01        ;Adds 0x01 into R3 in the loop 25 times 
(0640)                            || 								 ;per loop
(0641)                            || 
(0642)  CS-0x16C  0x08B2B         || 		 BRNE 	seconds_init_2   ;Loops back to the line “MOV R2, 0x06” 
(0643)                            || 								 ;in order to reset both R1 and R2 to 
(0644)                            || 								 ;0x06 for the next loop until the value 
(0645)                            || 								 ;of R3 is 0x00
(0646)                            || 		 
(0647)  CS-0x16D  0x18002         || 		  RET
(0648)                            || ;---------------------------------------------------------------------
(0649)                            || 
(0650)                     0x16E  || draw_flow:
(0651)  CS-0x16E  0x04439         || 		 MOV R4, R7
(0652)  CS-0x16F  0x04541         || 		 MOV R5, R8
(0653)                            || 		 
(0654)                     0x170  || draw_flow_start:
(0655)  CS-0x170  0x08B21         || 		 CALL seconds
(0656)  CS-0x171  0x08BB1         || 		 CALL draw_dot
(0657)                            || 
(0658)  CS-0x172  0x28701         || 		 ADD R7, 0x01
(0659)                            || 
(0660)  CS-0x173  0x3070D         || 		 CMP R7, 0x0D
(0661)  CS-0x174  0x0AB80         || 		 BRCS draw_flow_start
(0662)  CS-0x175  0x18002         || 		 RET
(0663)                            || 			
(0664)                            || ;---------------------------------------------------------------------
(0665)                            || ;- Subrountine: draw_dot
(0666)                            || ;-
(0667)                            || ;- This subroutine draws a dot on the display the given coordinates:
(0668)                            || ;-
(0669)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6
(0670)                            || ;-
(0671)                            || ;- Tweaked registers: r4,r5
(0672)                            || ;---------------------------------------------------------------------
(0673)                     0x176  || draw_dot:
(0674)  CS-0x176  0x04439         ||            MOV   r4,r7         ; copy Y coordinate
(0675)  CS-0x177  0x04541         ||            MOV   r5,r8         ; copy X coordinate
(0676)                            || 
(0677)  CS-0x178  0x2053F         ||            AND   r5,0x3F       ; make sure top 2 bits cleared, has to be a number within 6 bits so don't need all 8 for the columns.
(0678)  CS-0x179  0x2041F         ||            AND   r4,0x1F       ; make sure top 3 bits cleared, has to be a number within 5 bits for the rows.
(0679)  CS-0x17A  0x10401         ||            LSR   r4             ; need to get the bot 2 bits of r4 into sA
(0680)  CS-0x17B  0x0AC10         ||            BRCS  dd_add40
(0681)  CS-0x17C  0x10401  0x17C  || t1:        LSR   r4
(0682)  CS-0x17D  0x0AC28         ||            BRCS  dd_add80
(0683)                            || 
(0684)  CS-0x17E  0x34591  0x17E  || dd_out:    OUT   r5,VGA_LADD   ; write bot 8 address bits to register
(0685)  CS-0x17F  0x34490         ||            OUT   r4,VGA_HADD   ; write top 3 address bits to register
(0686)  CS-0x180  0x34692         ||            OUT   r6,VGA_COLOR  ; write data to frame buffer, combining x and y corrd to produce 11 bit address.
(0687)  CS-0x181  0x18002         ||            RET
(0688)                            || 
(0689)  CS-0x182  0x22540  0x182  || dd_add40:  OR    r5,0x40       ; set bit if needed
(0690)  CS-0x183  0x18000         ||            CLC                 ; freshen bit
(0691)  CS-0x184  0x08BE0         ||            BRN   t1
(0692)                            || 
(0693)  CS-0x185  0x22580  0x185  || dd_add80:  OR    r5,0x80       ; set bit if needed
(0694)  CS-0x186  0x08BF0         ||            BRN   dd_out
(0695)                            || ; --------------------------------------------------------------------
(0696)                            || 
(0697)                            || .CSEG
(0698)                       1023  || .ORG 0x3FF
(0699)                            || ;IN R13, BUTTON_PORT1	;interrupt will stop what its doing to access the ISR what will this button do?
(0700)                            || ;switches will be compared to see if certain switches went high and others low which will be compared to the random seed
(0701)                            || ;IN R14, BUTTON_PORT2
(0702)  CS-0x3FF  0x08130         || BRN ISR





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
ADD_1          0x080   (0243)  ||  0184 
BEAKER_HORIZ   0x0B2   (0345)  ||  0349 
BEAKER_VERT_1  0x0AE   (0339)  ||  0343 
BEAKER_VERT_2  0x0B6   (0351)  ||  0355 
CFB            0x05C   (0184)  ||  0179 
COLOR_CHANGER  0x053   (0167)  ||  0148 
DD_ADD40       0x182   (0689)  ||  0680 
DD_ADD80       0x185   (0693)  ||  0682 
DD_OUT         0x17E   (0684)  ||  0694 
DIFFICULTY     0x078   (0231)  ||  0102 0236 
DRAW_BACKGROUND 0x154   (0588)  ||  0063 0115 
DRAW_BEAKER    0x0AC   (0335)  ||  0069 0121 
DRAW_DOT       0x176   (0673)  ||  0302 0326 0340 0346 0352 0367 0390 0396 0402 0409 
                               ||  0415 0423 0430 0438 0446 0452 0458 0464 0469 0484 
                               ||  0490 0498 0504 0510 0516 0524 0530 0534 0540 0545 
                               ||  0553 0559 0563 0569 0573 0656 
DRAW_FLOW      0x16E   (0650)  ||  0146 0161 0260 0277 
DRAW_FLOW_START 0x170   (0654)  ||  0661 
DRAW_FLUID     0x0BB   (0362)  ||  0110 0172 0256 0273 
DRAW_HORIZ1    0x0A1   (0301)  ||  0305 
DRAW_HORIZONTAL_LINE 0x0A0   (0298)  ||  0595 
DRAW_VERT1     0x0A7   (0325)  ||  0329 
DRAW_VERTICAL_LINE 0x0A6   (0322)  ||  
END            0x09E   (0281)  ||  0282 
ENDGAME_LOSE   0x090   (0265)  ||  0229 
ENDGAME_WIN    0x082   (0248)  ||  0217 
E_HORIZ_1      0x13F   (0552)  ||  0556 
E_HORIZ_2      0x147   (0562)  ||  0566 
E_HORIZ_3      0x14F   (0572)  ||  0576 
FLUID_HORIZ    0x0BD   (0366)  ||  0370 0376 
FLUID_VERT     0x0C1   (0372)  ||  
GAME           0x043   (0140)  ||  0129 
GAME_CNT       0x04D   (0157)  ||  0221 0228 
GUESS_CHECK    0x06C   (0215)  ||  0153 
INIT           0x010   (0062)  ||  
INIT_GAME      0x03A   (0127)  ||  0112 0136 0163 
ISR            0x026   (0096)  ||  0101 0702 
I_HORIZ_1      0x0E2   (0422)  ||  0426 
I_HORIZ_2      0x0ED   (0437)  ||  0441 
I_VERT         0x0E7   (0429)  ||  0433 
LOSE           0x10A   (0479)  ||  0269 
LOSE_LIFE      0x072   (0223)  ||  0220 
L_HORIZ        0x110   (0489)  ||  0493 
L_VERT         0x10C   (0483)  ||  0487 
MAIN           0x024   (0090)  ||  0092 
N_VERT_1       0x0F3   (0445)  ||  0449 
N_VERT_2       0x0FC   (0457)  ||  0461 
N_VERT_3       0x105   (0468)  ||  0472 
O_HORIZ_1      0x11A   (0503)  ||  0507 
O_HORIZ_2      0x122   (0515)  ||  0519 
O_VERT_1       0x116   (0497)  ||  0501 
O_VERT_2       0x11E   (0509)  ||  0513 
PROG_B1        0x059   (0177)  ||  0106 0151 0191 
PROG_B2        0x05D   (0188)  ||  0180 
PROG_RG        0x061   (0196)  ||  0201 
RED_SHIFT      0x068   (0207)  ||  0104 
SECONDS        0x164   (0614)  ||  0604 0655 
SECONDS_DIVIDER 0x15E   (0603)  ||  0113 0607 
SECONDS_INIT_2 0x165   (0617)  ||  0642 
SECONDS_INIT_3 0x166   (0620)  ||  0633 
SECONDS_INIT_4 0x167   (0623)  ||  0627 
START          0x156   (0591)  ||  0598 
S_HORIZ_1      0x128   (0523)  ||  0527 
S_HORIZ_2      0x130   (0533)  ||  0537 
S_HORIZ_3      0x139   (0544)  ||  0548 
T1             0x17C   (0681)  ||  0691 
WIN            0x0C6   (0382)  ||  0252 
W_HORIZ_1      0x0CF   (0395)  ||  0399 
W_HORIZ_2      0x0D8   (0408)  ||  0412 
W_VERT_1       0x0CB   (0389)  ||  0393 
W_VERT_2       0x0D3   (0401)  ||  0405 
W_VERT_3       0x0DC   (0414)  ||  0418 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BEAKER_WALLS   0x000   (0022)  ||  
BG_COLOR       0x0FF   (0021)  ||  0589 
DELAY          0x0FF   (0019)  ||  
FLUID_COLOR    0x088   (0024)  ||  
LEDS           0x040   (0011)  ||  
LEDS1          0x041   (0012)  ||  
NUM_LIVES      0x003   (0025)  ||  
RAND_PORT      0x024   (0014)  ||  0084 0091 
SSEG           0x081   (0010)  ||  
STARTING_SCORE 0x000   (0026)  ||  
SWITCH_PORT1   0x020   (0013)  ||  0097 0130 
VGA_COLOR      0x092   (0009)  ||  0686 
VGA_HADD       0x090   (0007)  ||  0685 
VGA_LADD       0x091   (0008)  ||  0684 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
