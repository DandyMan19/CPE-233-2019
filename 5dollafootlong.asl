

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
(0019)                       255  || .EQU DELAY			= 0xFF 			;delay timer for the user to enter a interrupt.
(0020)                       255  || .EQU BG_COLOR       = 0xFF              ; Background:  white 
(0021)                       000  || .EQU BEAKER_WALLS   = 0x00				; Walls of the beaker
(0022)                            || .EQU DIRECTION DOWN = 0x02				; Direction of the added substance
            syntax error
            syntax error
            syntax error

(0023)                       136  || .EQU FLUID_COLOR	= 0x88			    ; Port TBD later for rng number
(0024)                       003  || .EQU NUM_LIVES      = 0x03				; Set of lives until gameover
(0025)                       000  || .EQU STARTING_SCORE = 0x00				; Score for initial points
(0026)                            || 
(0027)                            || ;-----------------------------------------------------------------------
(0028)                            || ;- Register Usage
(0029)                            || ;-----------------------------------------------------------------------
(0030)                            || ;- GAME
(0031)                            || ;
(0032)                            || ;R01: DIRECTION DOWN
(0033)                            || ;R02: RANDOM NUMBER
(0034)                            || ;R11: COLOR ADDITION 
(0035)                            || ;R12: LEVEL
(0036)                            || ;R03: LIVES
(0037)                            || ;R14: SCORE
(0038)                            || 
(0039)                            || ;- UNUSED
(0040)                            || ;
(0041)                            || ;- INPUT
(0042)                            || ;R15: SWITCH ENABLED
(0043)                            || ;R16: BUTTON
(0044)                            || ;
(0045)                            || ;- OUTPUT
(0046)                            || ;R16: LEDS
(0047)                            || ;R17: SSEGS
(0048)                            || ;
(0049)                            || ;- DRAWING
(0050)                            || ;
(0051)                            || ;R18: TEMP COLOR
(0052)                            || ;R19: TEMP FLUID COLOR
(0053)                            || ;R20: DRAW LINE ENDING TRACKER
(0054)                            || ;R21: DRAW BACKGROUND ROW TRACKER
(0055)                            || ;R22: DRAW DOT 
(0056)                            || ;R23: KEY UP INFO FLAG
(0057)                            || ;r6 is used for color
(0058)                            || ;r7 is used for Y
(0059)                            || ;r8 is used for X
(0060)                            || ;---------------------------------------------------------------------
(0061)                     0x010  || init:
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08080  0x100  ||              BRN     0x10        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0062)  CS-0x010  0x08CC1         ||          CALL   draw_background         ; draw using default color
(0063)  CS-0x011  0x36712         || 		 MOV	R7, 0x12
(0064)  CS-0x012  0x36800         || 		 MOV	R8, 0x00
(0065)  CS-0x013  0x36664         || 		 MOV	R6, 0x64
(0066)  CS-0x014  0x08D11         || 		 CALL	table
(0067)                            || 		 
(0068)  CS-0x015  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0069)  CS-0x016  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0070)  CS-0x017  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0071)  CS-0x018  0x08781         || 		 CALL   draw_beaker
(0072)                            || 		 
(0073)  CS-0x019  0x36100         || 		 MOV	R1,  0x00				; temporary value for R2
(0074)  CS-0x01A  0x36200         || 		 MOV 	R2,  0x00				; determines difficulty from switches
(0075)  CS-0x01B  0x36300         || 		 MOV	R3,  0x00				; lives
(0076)  CS-0x01C  0x36C00         || 		 MOV	R12, 0x00				; actual difficulty
(0077)  CS-0x01D  0x36D00         || 		 MOV	R13, 0x00				; switch for chemical pour
(0078)  CS-0x01E  0x36E00         || 		 MOV	R14, 0x00				; counter for difficulty determination
(0079)  CS-0x01F  0x36F00         || 		 MOV	R15, 0x00				; stores switches value for color
(0080)  CS-0x020  0x37000         || 		 MOV	R16, 0x00				; keeps track of progress
(0081)  CS-0x021  0x37100         || 		 MOV	R17, 0x00				; keeps track of all difficulty loops
(0082)  CS-0x022  0x05201         || 		 MOV	R18, R0					; temporary value for R0
(0083)  CS-0x023  0x37300         || 		 MOV	R19, 0x00				; determines if the final bit of R2 has determined difficulty
(0084)  CS-0x024  0x37410         || 		 MOV 	R20, 0x10				; just a delay for seconds
(0085)  CS-0x025  0x37500         || 		 MOV	R21, 0x00				; keeps track of difficulty
(0086)  CS-0x026  0x37600         || 		 MOV	R22, 0x00				; temporary register for progress loop
(0087)  CS-0x027  0x37700         || 		 MOV	R23, 0x00				; keeps track of progress loop for LEDs
(0088)  CS-0x028  0x37800         || 		 MOV	R24, 0x00				; ensures the LEDs are set to zero
(0089)  CS-0x029  0x37900         || 		 MOV	R25, 0x00				; temporary register for the difficulty
(0090)  CS-0x02A  0x37A00         || 		 MOV	R26, 0x00				; keeps track of difficulty loop for LEDs
(0091)  CS-0x02B  0x37B00         || 		 MOV	R27, 0x00				; sets the amount of lives
(0092)  CS-0x02C  0x32024         || 		 IN		R0,  RAND_PORT
(0093)  CS-0x02D  0x1A000         || 		 SEI
(0094)                            || 
(0095)                            || ;---------------------------------------------------------------------
(0096)                            || 
(0097)                            || ;---------------------------------------------------------------------
(0098)                     0x02E  || main:	 
(0099)  CS-0x02E  0x32024         || 		 IN		R0, RAND_PORT
(0100)  CS-0x02F  0x08170         || 		 BRN	main
(0101)                            || ;---------------------------------------------------------------------
(0102)                            || 		 
(0103)                            || ;---------------------------------------------------------------------
(0104)                     0x030  || ISR:	 
(0105)                            || 
(0106)  CS-0x030  0x32220         || 		 IN 	R2, SWITCH_PORT1
(0107)  CS-0x031  0x04111         || 		 MOV	R1, R2
(0108)  CS-0x032  0x10101         || 		 LSR	R1
(0109)                            || 		 
(0110)  CS-0x033  0x0A181         || 		 BRCC	ISR
(0111)  CS-0x034  0x08509         || 		 CALL	difficulty
(0112)  CS-0x035  0x34381         || 		 OUT	R3, SSEG
(0113)  CS-0x036  0x08471         || 		 CALL	red_shift
(0114)  CS-0x037  0x05201         || 		 MOV	R18, R0
(0115)  CS-0x038  0x08361         || 		 CALL	prog_b1
(0116)  CS-0x039  0x37700         || 		 MOV	R23, 0x00
(0117)  CS-0x03A  0x083E1         || 		 CALL	prog_check
(0118)  CS-0x03B  0x3670D         || 		 MOV 	R7, 0x0D				; Y coordinate for fluid				
(0119)  CS-0x03C  0x36814         || 		 MOV	R8, 0x14				; X coordinate for fluid
(0120)  CS-0x03D  0x04601         || 		 MOV	R6, R0					; moves blue (PUT COLOR FROM WRAPPER LATER)
(0121)  CS-0x03E  0x087F9         || 		 CALL   draw_fluid				; draws the fluid inside the beaker
(0122)                            || 		 
(0123)  CS-0x03F  0x08259         || 		 CALL 	init_game
(0124)  CS-0x040  0x08D51         || 		 CALL 	seconds_divider
(0125)                            || 		 
(0126)  CS-0x041  0x08CC1         || 		 CALL   draw_background         ; draw using default color
(0127)                            || 
(0128)  CS-0x042  0x36712         || 		 MOV	R7, 0x12
(0129)  CS-0x043  0x36800         || 		 MOV	R8, 0x00
(0130)  CS-0x044  0x36664         || 		 MOV	R6, 0x64
(0131)  CS-0x045  0x08D11         || 		 CALL	table
(0132)  CS-0x046  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0133)  CS-0x047  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0134)  CS-0x048  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0135)  CS-0x049  0x08781         || 		 CALL   draw_beaker
(0136)  CS-0x04A  0x1A003         || 		 RETIE
(0137)                            || 		 
(0138)                            || ;---------------------------------------------------------------------		
(0139)                            || 
(0140)                            || ;--------------------------------------------------------------------- 
(0141)                     0x04B  || init_game:	 
(0142)  CS-0x04B  0x30D01         ||          CMP    R13, 0x01
(0143)  CS-0x04C  0x082A2         || 		 BREQ 	game
(0144)  CS-0x04D  0x32220         || 		 IN 	R2, SWITCH_PORT1
(0145)  CS-0x04E  0x04111         || 		 MOV 	R1, R2
(0146)  CS-0x04F  0x10100         || 		 LSL 	R1
(0147)  CS-0x050  0x2AD00         || 		 ADDC 	R13, 0x00
(0148)  CS-0x051  0x18000         || 		 CLC
(0149)  CS-0x052  0x10101         || 		 LSR	R1
(0150)  CS-0x053  0x08258         || 		 BRN 	init_game
(0151)                            || ;---------------------------------------------------------------------
(0152)                            || 
(0153)                            || ;---------------------------------------------------------------------
(0154)                     0x054  || game:
(0155)  CS-0x054  0x36D00         || 		 MOV	R13, 0x00
(0156)  CS-0x055  0x36700         || 		 MOV	R7, 0x00
(0157)  CS-0x056  0x36819         || 		 MOV	R8, 0x19
(0158)  CS-0x057  0x04609         || 		 MOV 	R6, R1
(0159)  CS-0x058  0x04F31         || 		 MOV	R15, R6
(0160)  CS-0x059  0x08DD1         || 		 CALL 	draw_flow
(0161)                            || 		 
(0162)  CS-0x05A  0x08331         || 		 CALL	color_changer
(0163)                            || 		 
(0164)  CS-0x05B  0x05201         || 		 MOV	R18, R0
(0165)  CS-0x05C  0x08361         || 		 CALL	prog_b1
(0166)  CS-0x05D  0x083E1         || 		 CALL	prog_check
(0167)                            || 		 
(0168)  CS-0x05E  0x08490         || 		 BRN	guess_check
(0169)                            || ;---------------------------------------------------------------------
(0170)                            || 
(0171)                            || ;---------------------------------------------------------------------
(0172)                     0x05F  || game_cnt:		 
(0173)  CS-0x05F  0x36700         || 		 MOV	R7, 0x00
(0174)  CS-0x060  0x36819         || 		 MOV 	R8, 0x19
(0175)  CS-0x061  0x366FF         || 		 MOV 	R6, 0xFF
(0176)  CS-0x062  0x08DD1         || 		 CALL	draw_flow
(0177)  CS-0x063  0x08429         || 		 CALL	diff_check
(0178)  CS-0x064  0x18000         || 		 CLC
(0179)  CS-0x065  0x08258         || 		 BRN	init_game
(0180)                            || ;---------------------------------------------------------------------
(0181)                            || 
(0182)                            || ;---------------------------------------------------------------------
(0183)                     0x066  || color_changer:
(0184)  CS-0x066  0x0007A         || 		 EXOR 	R0, R15
(0185)  CS-0x067  0x3670D         || 		 MOV 	R7, 0x0D
(0186)  CS-0x068  0x36814         || 		 MOV	R8, 0x14
(0187)  CS-0x069  0x04601         || 		 MOV	R6, R0
(0188)  CS-0x06A  0x087F9         || 		 CALL	draw_fluid
(0189)  CS-0x06B  0x18002         || 		 RET
(0190)                            || ;---------------------------------------------------------------------
(0191)                            || 
(0192)                            || ;---------------------------------------------------------------------
(0193)                     0x06C  || prog_b1:
(0194)  CS-0x06C  0x11201         || 		 LSR 	R18
(0195)  CS-0x06D  0x0837A         || 		 BREQ	cfb
(0196)  CS-0x06E  0x08383         || 		 BRNE	prog_b2
(0197)                            || ;---------------------------------------------------------------------
(0198)                            || 
(0199)                            || ;---------------------------------------------------------------------
(0200)  CS-0x06F  0x08561  0x06F  || cfb:	 CALL 	add_1
(0201)                            || ;---------------------------------------------------------------------
(0202)                            || 
(0203)                            || ;---------------------------------------------------------------------
(0204)                     0x070  || prog_b2:
(0205)  CS-0x070  0x29101         || 		 ADD 	R17, 0x01
(0206)  CS-0x071  0x31102         || 		 CMP 	R17, 0x02
(0207)  CS-0x072  0x08363         || 		 BRNE 	prog_b1
(0208)  CS-0x073  0x37100         || 		 MOV 	R17, 0x00
(0209)                            || ;---------------------------------------------------------------------
(0210)                            || 
(0211)                            || ;---------------------------------------------------------------------
(0212)                     0x074  || prog_rg:	
(0213)  CS-0x074  0x11201         || 		 LSR 	R18
(0214)  CS-0x075  0x2B000         || 		 ADDC	R16, 0x00
(0215)  CS-0x076  0x29101         || 		 ADD 	R17, 0x01
(0216)  CS-0x077  0x31105         || 		 CMP 	R17, 0x05
(0217)  CS-0x078  0x083A3         || 		 BRNE 	prog_rg
(0218)  CS-0x079  0x37100         || 		 MOV	R17, 0x00
(0219)  CS-0x07A  0x05681         || 		 MOV	R22, R16
(0220)  CS-0x07B  0x18002         || 		 RET
(0221)                            || ;---------------------------------------------------------------------
(0222)                            || 
(0223)                            || ;---------------------------------------------------------------------
(0224)                     0x07C  || prog_check:
(0225)  CS-0x07C  0x18001         || 		 SEC
(0226)  CS-0x07D  0x11700         || 		 LSL	R23
(0227)  CS-0x07E  0x2D601         || 		 SUB	R22, 0x01
(0228)  CS-0x07F  0x31600         || 		 CMP	R22, 0x00
(0229)  CS-0x080  0x083E3         || 		 BRNE	prog_check
(0230)  CS-0x081  0x37600         || 		 MOV 	R22, 0x00
(0231)  CS-0x082  0x35740         || 		 OUT	R23, LEDS
(0232)  CS-0x083  0x37700         || 		 MOV	R23, 0x00
(0233)  CS-0x084  0x18002         || 		 RET
(0234)                            || 		 
(0235)                            || ;---------------------------------------------------------------------
(0236)                            || 
(0237)                            || ;---------------------------------------------------------------------
(0238)                     0x085  || diff_check:
(0239)  CS-0x085  0x18001         || 		 SEC
(0240)  CS-0x086  0x11A00         || 		 LSL 	R26
(0241)  CS-0x087  0x2D901         || 		 SUB 	R25, 0x01
(0242)  CS-0x088  0x31900         || 		 CMP	R25, 0x00
(0243)  CS-0x089  0x0842B         || 		 BRNE	diff_check
(0244)  CS-0x08A  0x37900         || 		 MOV	R25, 0x00
(0245)  CS-0x08B  0x35A41         || 		 OUT 	R26, LEDS1
(0246)  CS-0x08C  0x37A00         || 		 MOV	R26, 0x00
(0247)  CS-0x08D  0x18002         || 		 RET
(0248)                            || ;---------------------------------------------------------------------
(0249)                            || 
(0250)                            || ;---------------------------------------------------------------------
(0251)                     0x08E  || red_shift:
(0252)  CS-0x08E  0x10000         || 		 LSL	R0
(0253)  CS-0x08F  0x18000         || 		 CLC
(0254)  CS-0x090  0x10001         || 		 LSR	R0
(0255)  CS-0x091  0x18002         || 		 RET
(0256)                            || ;---------------------------------------------------------------------
(0257)                            || 
(0258)                            || ;---------------------------------------------------------------------
(0259)                     0x092  || guess_check:
(0260)  CS-0x092  0x31005         || 		 CMP 	R16, 0x05
(0261)  CS-0x093  0x08572         || 		 BREQ	endgame_win
(0262)  CS-0x094  0x37000         || 		 MOV	R16, 0x00
(0263)  CS-0x095  0x05961         || 		 MOV	R25, R12
(0264)  CS-0x096  0x2CC01         || 		 SUB 	R12, 0x01
(0265)  CS-0x097  0x30C00         || 		 CMP 	R12, 0x00
(0266)  CS-0x098  0x084D2         || 		 BREQ 	lose_life
(0267)  CS-0x099  0x082FB         || 		 BRNE	game_cnt
(0268)                            || ;---------------------------------------------------------------------	 
(0269)                     0x09A  || lose_life:
(0270)  CS-0x09A  0x04CA9         || 		 MOV	R12, R21
(0271)  CS-0x09B  0x04091         || 		 MOV	R0, R18
(0272)  CS-0x09C  0x2C301         || 		 SUB	R3, 0x01
(0273)  CS-0x09D  0x34381         || 		 OUT	R3, SSEG
(0274)  CS-0x09E  0x30300         || 		 CMP	R3, 0x00
(0275)  CS-0x09F  0x082FB         || 		 BRNE	game_cnt
(0276)  CS-0x0A0  0x08642         || 		 BREQ	endgame_lose
(0277)                            || ;---------------------------------------------------------------------
(0278)                     0x0A1  || difficulty: 
(0279)  CS-0x0A1  0x10101         || 		 LSR 	R1
(0280)  CS-0x0A2  0x2AC00         || 		 ADDC 	R12, 0x00
(0281)  CS-0x0A3  0x28E01         || 		 ADD 	R14, 0x01
(0282)  CS-0x0A4  0x30E06         || 		 CMP 	R14, 0x06
(0283)  CS-0x0A5  0x0850B         || 		 BRNE 	difficulty
(0284)  CS-0x0A6  0x28C01         || 		 ADD	R12, 0x01
(0285)  CS-0x0A7  0x34C41         || 		 OUT	R12, LEDS1
(0286)  CS-0x0A8  0x05561         || 		 MOV	R21, R12
(0287)  CS-0x0A9  0x04361         || 		 MOV	R3, R12
(0288)  CS-0x0AA  0x34381         || 		 OUT	R3, SSEG
(0289)  CS-0x0AB  0x18002         || 		 RET
(0290)                            || ;---------------------------------------------------------------------
(0291)                            || 
(0292)                            || ;---------------------------------------------------------------------
(0293)  CS-0x0AC  0x29001  0x0AC  || add_1:	 ADD	R16, 0x01
(0294)  CS-0x0AD  0x18002         || 		 RET
(0295)                            || ;---------------------------------------------------------------------
(0296)                            || 
(0297)                            || ;---------------------------------------------------------------------	
(0298)                     0x0AE  || endgame_win:
(0299)  CS-0x0AE  0x36702         || 		 MOV	R7, 0x02
(0300)  CS-0x0AF  0x36808         || 		 MOV	R8, 0x08
(0301)  CS-0x0B0  0x366FC         || 		 MOV	R6, 0xFC
(0302)  CS-0x0B1  0x08851         || 		 CALL   win						; draw "win"
(0303)  CS-0x0B2  0x3670D         || 		 MOV	R7, 0x0D
(0304)  CS-0x0B3  0x36814         || 		 MOV	R8, 0x14
(0305)  CS-0x0B4  0x366FF         || 		 MOV	R6, 0xFF
(0306)  CS-0x0B5  0x087F9         || 		 CALL	draw_fluid
(0307)  CS-0x0B6  0x36700         || 		 MOV	R7, 0x00
(0308)  CS-0x0B7  0x36819         || 		 MOV	R8, 0x19
(0309)  CS-0x0B8  0x366FF         || 		 MOV 	R6, 0xFF
(0310)  CS-0x0B9  0x08DD1         || 		 CALL	draw_flow
(0311)  CS-0x0BA  0x36712         || 		 MOV	R7, 0x12
(0312)  CS-0x0BB  0x36800         || 		 MOV	R8, 0x00
(0313)  CS-0x0BC  0x36664         || 		 MOV	R6, 0x64
(0314)  CS-0x0BD  0x08D11         || 		 CALL	table
(0315)  CS-0x0BE  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0316)  CS-0x0BF  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0317)  CS-0x0C0  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0318)  CS-0x0C1  0x08781         || 		 CALL   draw_beaker
(0319)  CS-0x0C2  0x36304         || 		 MOV	R3, 0x04
(0320)  CS-0x0C3  0x35840         || 		 OUT	R24, LEDS
(0321)  CS-0x0C4  0x35841         || 		 OUT	R24, LEDS1
(0322)  CS-0x0C5  0x36C00         || 		 MOV	R12, 0x00
(0323)  CS-0x0C6  0x36E00         || 		 MOV	R14, 0x00
(0324)  CS-0x0C7  0x18002         || 		 RET
(0325)                            || ;---------------------------------------------------------------------
(0326)                            || 		 		 
(0327)                     0x0C8  || endgame_lose:
(0328)  CS-0x0C8  0x36702         || 		 MOV	R7, 0x02				; Y coordinate for "lose"
(0329)  CS-0x0C9  0x36808         || 		 MOV 	R8, 0x08				; X coordinate for "lose"
(0330)  CS-0x0CA  0x36603         || 		 MOV 	R6, 0x03				; sets default color to blue
(0331)  CS-0x0CB  0x08A71         || 		 CALL   lose					; draw "lose"
(0332)  CS-0x0CC  0x3670D         || 		 MOV	R7, 0x0D
(0333)  CS-0x0CD  0x36814         || 		 MOV	R8, 0x14
(0334)  CS-0x0CE  0x366FF         || 		 MOV	R6, 0xFF
(0335)  CS-0x0CF  0x087F9         || 		 CALL	draw_fluid
(0336)  CS-0x0D0  0x36712         || 		 MOV	R7, 0x12
(0337)  CS-0x0D1  0x36800         || 		 MOV	R8, 0x00
(0338)  CS-0x0D2  0x36664         || 		 MOV	R6, 0x64
(0339)  CS-0x0D3  0x08D11         || 		 CALL	table
(0340)  CS-0x0D4  0x36709         || 	     MOV    R7, 0x09				; Y coordinate for beaker
(0341)  CS-0x0D5  0x36813         || 		 MOV	R8, 0x13				; X coordinate for beaker
(0342)  CS-0x0D6  0x36600         || 		 MOV	R6, 0x00				; sets default color to black
(0343)  CS-0x0D7  0x08781         || 		 CALL   draw_beaker
(0344)  CS-0x0D8  0x36700         || 		 MOV	R7, 0x00
(0345)  CS-0x0D9  0x36819         || 		 MOV	R8, 0x19
(0346)  CS-0x0DA  0x366FF         || 		 MOV 	R6, 0xFF
(0347)  CS-0x0DB  0x08DD1         || 		 CALL	draw_flow
(0348)  CS-0x0DC  0x36304         || 		 MOV	R3, 0x04
(0349)  CS-0x0DD  0x35840         || 		 OUT	R24, LEDS
(0350)  CS-0x0DE  0x35841         || 		 OUT	R24, LEDS1
(0351)  CS-0x0DF  0x36C00         || 		 MOV	R12, 0x00
(0352)  CS-0x0E0  0x36E00         || 		 MOV	R14, 0x00
(0353)  CS-0x0E1  0x18002         || 		 RET
(0354)                            ||       
(0355)  CS-0x0E2  0x00B58  0x0E2  || end:     AND    r11, r11                ; nop
(0356)  CS-0x0E3  0x08710         ||          BRN    end                     ; continuous loop
(0357)                            || ;--------------------------------------------------------------------
(0358)                            || 
(0359)                            || ;--------------------------------------------------------------------
(0360)                            || ;-  Subroutine: draw_horizontal_line
(0361)                            || ;-
(0362)                            || ;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6
(0363)                            || ;-
(0364)                            || ;-  Parameters:
(0365)                            || ;-   r8  = starting x-coordinate
(0366)                            || ;-   r7  = y-coordinate
(0367)                            || ;-   r9  = ending x-coordinate
(0368)                            || ;-   r6  = color used for line
(0369)                            || ;-
(0370)                            || ;- Tweaked registers: r8,r9
(0371)                            || ;--------------------------------------------------------------------
(0372)                     0x0E4  || draw_horizontal_line:
(0373)  CS-0x0E4  0x28901         ||          ADD    r9,0x01          ; go from r8 to r15 inclusive
(0374)                            || 
(0375)                     0x0E5  || draw_horiz1:
(0376)  CS-0x0E5  0x08E11         ||          CALL   draw_dot         ;draws a bunch of dots which will paint the line.
(0377)  CS-0x0E6  0x28801         ||          ADD    r8,0x01
(0378)  CS-0x0E7  0x04848         ||          CMP  	r8,r9
(0379)  CS-0x0E8  0x0872B         ||          BRNE   draw_horiz1
(0380)  CS-0x0E9  0x18002         ||          RET
(0381)                            || ;--------------------------------------------------------------------
(0382)                            || 
(0383)                            || ;---------------------------------------------------------------------
(0384)                            || ;-  Subroutine: draw_vertical_line
(0385)                            || ;-
(0386)                            || ;-  Draws a vertical line from (r8,r7) to (r8,r9) using color in r6
(0387)                            || ;-
(0388)                            || ;-  Parameters:
(0389)                            || ;-   r8  = x-coordinate
(0390)                            || ;-   r7  = starting y-coordinate
(0391)                            || ;-   r9  = ending y-coordinate
(0392)                            || ;-   r6  = color used for line
(0393)                            || ;-
(0394)                            || ;- Tweaked registers: r7,r9
(0395)                            || ;--------------------------------------------------------------------
(0396)                     0x0EA  || draw_vertical_line:
(0397)  CS-0x0EA  0x28901         ||          ADD    r9,0x01
(0398)                            || 
(0399)                     0x0EB  || draw_vert1:
(0400)  CS-0x0EB  0x08E11         ||          CALL   draw_dot
(0401)  CS-0x0EC  0x28701         ||          ADD    r7,0x01
(0402)  CS-0x0ED  0x04748         ||          CMP    r7,R9
(0403)  CS-0x0EE  0x0875B         ||          BRNE   draw_vert1
(0404)  CS-0x0EF  0x18002         ||          RET
(0405)                            || ;--------------------------------------------------------------------
(0406)                            || 
(0407)                            || ;---------------------------------------------------------------------
(0408)                            || 
(0409)                     0x0F0  || draw_beaker:
(0410)  CS-0x0F0  0x04439         || 		MOV R4, R7
(0411)  CS-0x0F1  0x04539         || 		MOV R5, R7
(0412)                            || 		
(0413)                     0x0F2  || beaker_vert_1:
(0414)  CS-0x0F2  0x08E11         || 		CALL draw_dot
(0415)  CS-0x0F3  0x28701         || 		ADD R7, 0x01
(0416)  CS-0x0F4  0x30717         || 		CMP R7, 0x17
(0417)  CS-0x0F5  0x08793         || 		BRNE beaker_vert_1
(0418)                            || 		
(0419)                     0x0F6  || beaker_horiz:
(0420)  CS-0x0F6  0x08E11         || 		CALL draw_dot
(0421)  CS-0x0F7  0x28801         || 		ADD R8, 0x01
(0422)  CS-0x0F8  0x3081D         || 		CMP R8, 0x1D
(0423)  CS-0x0F9  0x087B3         || 		BRNE beaker_horiz
(0424)                            || 		
(0425)                     0x0FA  || beaker_vert_2:
(0426)  CS-0x0FA  0x08E11         || 		CALL draw_dot
(0427)  CS-0x0FB  0x2C701         || 		SUB R7, 0x01
(0428)  CS-0x0FC  0x30708         || 		CMP R7, 0x08
(0429)  CS-0x0FD  0x087D3         || 		BRNE beaker_vert_2
(0430)  CS-0x0FE  0x18002         || 		RET
(0431)                            || 		
(0432)                            || ;---------------------------------------------------------------------
(0433)                            || 
(0434)                            || ;---------------------------------------------------------------------
(0435)                            || 		
(0436)                     0x0FF  || draw_fluid:
(0437)  CS-0x0FF  0x04439         || 		MOV R4, R7
(0438)  CS-0x100  0x04541         || 		MOV R5, R8
(0439)                            || 		
(0440)                     0x101  || fluid_horiz:
(0441)  CS-0x101  0x08E11         || 		CALL draw_dot
(0442)  CS-0x102  0x28801         || 		ADD R8, 0x01
(0443)  CS-0x103  0x3081D         || 		CMP R8, 0x1D
(0444)  CS-0x104  0x0880B         || 		BRNE fluid_horiz
(0445)                            || 		
(0446)                     0x105  || fluid_vert:
(0447)  CS-0x105  0x36814         || 		MOV R8, 0x14
(0448)  CS-0x106  0x28701         || 		ADD R7, 0x01
(0449)  CS-0x107  0x30717         || 		CMP R7, 0x17
(0450)  CS-0x108  0x0880B         || 		BRNE fluid_horiz
(0451)  CS-0x109  0x18002         || 		RET
(0452)                            || ;---------------------------------------------------------------------
(0453)                            || 
(0454)                            || ;---------------------------------------------------------------------
(0455)                            || 		
(0456)                     0x10A  || win:
(0457)  CS-0x10A  0x36702         || 		MOV	R7, 0x02				; Y coordinate for "win"
(0458)  CS-0x10B  0x36808         || 		MOV	R8, 0x08				; X coordinate for "win"
(0459)  CS-0x10C  0x366E0         || 		MOV	R6, 0xE0				; sets default color to red
(0460)  CS-0x10D  0x04439         || 		MOV R4, R7
(0461)  CS-0x10E  0x04541         || 		MOV R5, R8
(0462)                            || 		
(0463)                     0x10F  || w_vert_1:
(0464)  CS-0x10F  0x08E11         || 		CALL draw_dot
(0465)  CS-0x110  0x28701         || 		ADD R7, 0x01
(0466)  CS-0x111  0x30706         || 		CMP R7, 0x06
(0467)  CS-0x112  0x0887B         || 		BRNE w_vert_1
(0468)                            || 		
(0469)                     0x113  || w_horiz_1:
(0470)  CS-0x113  0x08E11         || 		CALL draw_dot
(0471)  CS-0x114  0x28801         || 		ADD R8, 0x01
(0472)  CS-0x115  0x3080A         || 		CMP R8, 0x0A
(0473)  CS-0x116  0x0889B         || 		BRNE w_horiz_1
(0474)                            || 		
(0475)                     0x117  || w_vert_2:
(0476)  CS-0x117  0x08E11         || 		CALL draw_dot
(0477)  CS-0x118  0x2C701         || 		SUB R7, 0x01
(0478)  CS-0x119  0x30701         || 		CMP R7, 0x01
(0479)  CS-0x11A  0x088BB         || 		BRNE w_vert_2
(0480)  CS-0x11B  0x36706         || 		MOV R7, 0x06
(0481)                            || 		
(0482)                     0x11C  || w_horiz_2:
(0483)  CS-0x11C  0x08E11         || 		CALL draw_dot
(0484)  CS-0x11D  0x28801         || 		ADD R8, 0x01
(0485)  CS-0x11E  0x3080C         || 		CMP R8, 0x0C
(0486)  CS-0x11F  0x088E3         || 		BRNE w_horiz_2
(0487)                            || 		
(0488)                     0x120  || w_vert_3:
(0489)  CS-0x120  0x08E11         || 		CALL draw_dot
(0490)  CS-0x121  0x2C701         || 		SUB R7, 0x01
(0491)  CS-0x122  0x30701         || 		CMP R7, 0x01
(0492)  CS-0x123  0x08903         || 		BRNE w_vert_3
(0493)  CS-0x124  0x3680E         || 		MOV R8, 0x0E
(0494)  CS-0x125  0x36702         || 		MOV R7, 0x02
(0495)                            || 		
(0496)                     0x126  || i_horiz_1:
(0497)  CS-0x126  0x08E11         || 		CALL draw_dot
(0498)  CS-0x127  0x28801         || 		ADD R8, 0x01
(0499)  CS-0x128  0x30813         || 		CMP R8, 0x13
(0500)  CS-0x129  0x08933         || 		BRNE i_horiz_1
(0501)  CS-0x12A  0x36810         || 		MOV R8, 0x10
(0502)                            || 		
(0503)                     0x12B  || i_vert:
(0504)  CS-0x12B  0x08E11         || 		CALL draw_dot
(0505)  CS-0x12C  0x28701         || 		ADD R7, 0x01
(0506)  CS-0x12D  0x30706         || 		CMP R7, 0x06
(0507)  CS-0x12E  0x0895B         || 		BRNE i_vert
(0508)  CS-0x12F  0x3680E         || 		MOV R8, 0x0E
(0509)  CS-0x130  0x36706         || 		MOV R7, 0x06
(0510)                            || 		
(0511)                     0x131  || i_horiz_2:
(0512)  CS-0x131  0x08E11         || 		CALL draw_dot
(0513)  CS-0x132  0x28801         || 		ADD R8, 0x01
(0514)  CS-0x133  0x30813         || 		CMP R8, 0x13
(0515)  CS-0x134  0x0898B         || 		BRNE i_horiz_2
(0516)  CS-0x135  0x36814         || 		MOV R8, 0x14
(0517)  CS-0x136  0x36702         || 		MOV R7, 0x02
(0518)                            || 		
(0519)                     0x137  || n_vert_1:
(0520)  CS-0x137  0x08E11         || 		CALL draw_dot
(0521)  CS-0x138  0x28701         || 		ADD R7, 0x01
(0522)  CS-0x139  0x30707         || 		CMP R7, 0x07
(0523)  CS-0x13A  0x089BB         || 		BRNE n_vert_1
(0524)  CS-0x13B  0x36702         || 		MOV R7, 0x02
(0525)  CS-0x13C  0x28801         || 		ADD R8, 0x01
(0526)  CS-0x13D  0x08E11         || 		CALL draw_dot
(0527)  CS-0x13E  0x28801         || 		ADD R8, 0x01
(0528)  CS-0x13F  0x36703         || 		MOV R7, 0x03
(0529)                            || 		
(0530)                            || 
(0531)                     0x140  || n_vert_2:
(0532)  CS-0x140  0x08E11         || 		CALL draw_dot
(0533)  CS-0x141  0x28701         || 		ADD R7, 0x01
(0534)  CS-0x142  0x30706         || 		CMP R7, 0x06
(0535)  CS-0x143  0x08A03         || 		BRNE n_vert_2
(0536)  CS-0x144  0x36706         || 		MOV R7, 0x06
(0537)  CS-0x145  0x28801         || 		ADD R8, 0x01
(0538)  CS-0x146  0x08E11         || 		CALL draw_dot
(0539)  CS-0x147  0x36702         || 		MOV R7, 0x02
(0540)  CS-0x148  0x28801         || 		ADD R8, 0x01
(0541)                            || 		
(0542)                     0x149  || n_vert_3:
(0543)  CS-0x149  0x08E11         || 		CALL draw_dot
(0544)  CS-0x14A  0x28701         || 		ADD R7, 0x01
(0545)  CS-0x14B  0x30707         || 		CMP R7, 0x07
(0546)  CS-0x14C  0x08A4B         || 		BRNE n_vert_3
(0547)  CS-0x14D  0x18002         || 		RET
(0548)                            || 		
(0549)                            || ;---------------------------------------------------------------------
(0550)                            || 
(0551)                            || ;---------------------------------------------------------------------
(0552)                            || 
(0553)                     0x14E  || lose:
(0554)  CS-0x14E  0x04439         || 		MOV R4, R7
(0555)  CS-0x14F  0x04541         || 		MOV R5, R8
(0556)                            || 		
(0557)                     0x150  || l_vert:
(0558)  CS-0x150  0x08E11         || 		CALL draw_dot
(0559)  CS-0x151  0x28701         || 		ADD R7, 0x01
(0560)  CS-0x152  0x30706         || 		CMP R7, 0x06
(0561)  CS-0x153  0x08A83         || 		BRNE l_vert
(0562)                            || 		
(0563)                     0x154  || l_horiz:
(0564)  CS-0x154  0x08E11         || 		CALL draw_dot
(0565)  CS-0x155  0x28801         || 		ADD R8, 0x01
(0566)  CS-0x156  0x3080D         || 		CMP R8, 0x0D
(0567)  CS-0x157  0x08AA3         || 		BRNE l_horiz
(0568)  CS-0x158  0x36702         || 		MOV R7, 0x02
(0569)  CS-0x159  0x3680E         || 		MOV R8, 0x0E
(0570)                            || 		
(0571)                     0x15A  || o_vert_1:
(0572)  CS-0x15A  0x08E11         || 		CALL draw_dot
(0573)  CS-0x15B  0x28701         || 		ADD R7, 0x01
(0574)  CS-0x15C  0x30706         || 		CMP R7, 0x06
(0575)  CS-0x15D  0x08AD3         || 		BRNE o_vert_1
(0576)                            || 
(0577)                     0x15E  || o_horiz_1:
(0578)  CS-0x15E  0x08E11         || 		CALL draw_dot
(0579)  CS-0x15F  0x28801         || 		ADD R8, 0x01
(0580)  CS-0x160  0x30812         || 		CMP R8, 0x12
(0581)  CS-0x161  0x08AF3         || 		BRNE o_horiz_1
(0582)                            || 
(0583)                     0x162  || o_vert_2:
(0584)  CS-0x162  0x08E11         || 		CALL draw_dot
(0585)  CS-0x163  0x2C701         || 		SUB R7, 0x01
(0586)  CS-0x164  0x30702         || 		CMP R7, 0x02
(0587)  CS-0x165  0x08B13         || 		BRNE o_vert_2
(0588)                            || 		
(0589)                     0x166  || o_horiz_2:
(0590)  CS-0x166  0x08E11         || 		CALL draw_dot
(0591)  CS-0x167  0x2C801         || 		SUB R8, 0x01
(0592)  CS-0x168  0x3080E         || 		CMP R8, 0x0E
(0593)  CS-0x169  0x08B33         || 		BRNE o_horiz_2	
(0594)  CS-0x16A  0x36814         || 		MOV R8, 0x14
(0595)  CS-0x16B  0x36702         || 		MOV R7, 0x02
(0596)                            || 		
(0597)                     0x16C  || s_horiz_1:
(0598)  CS-0x16C  0x08E11         || 		CALL draw_dot
(0599)  CS-0x16D  0x28801         || 		ADD R8, 0x01
(0600)  CS-0x16E  0x30819         || 		CMP R8, 0x19
(0601)  CS-0x16F  0x08B63         || 		BRNE s_horiz_1
(0602)  CS-0x170  0x36814         || 		MOV R8, 0x14
(0603)  CS-0x171  0x28701         || 		ADD R7, 0x01
(0604)  CS-0x172  0x08E11         || 		CALL draw_dot
(0605)  CS-0x173  0x28701         || 		ADD R7, 0x01
(0606)                            || 		
(0607)                     0x174  || s_horiz_2:
(0608)  CS-0x174  0x08E11         || 		CALL draw_dot
(0609)  CS-0x175  0x28801         || 		ADD R8, 0x01
(0610)  CS-0x176  0x30819         || 		CMP R8, 0x19
(0611)  CS-0x177  0x08BA3         || 		BRNE s_horiz_2
(0612)  CS-0x178  0x36818         || 		MOV R8, 0x18
(0613)  CS-0x179  0x28701         || 		ADD R7, 0x01
(0614)  CS-0x17A  0x08E11         || 		CALL draw_dot
(0615)  CS-0x17B  0x36814         || 		MOV R8, 0x14
(0616)  CS-0x17C  0x28701         || 		ADD R7, 0x01
(0617)                            || 		
(0618)                     0x17D  || s_horiz_3:
(0619)  CS-0x17D  0x08E11         || 		CALL draw_dot
(0620)  CS-0x17E  0x28801         || 		ADD R8, 0x01
(0621)  CS-0x17F  0x30819         || 		CMP R8, 0x19
(0622)  CS-0x180  0x08BEB         || 		BRNE s_horiz_3
(0623)  CS-0x181  0x3681A         || 		MOV R8, 0x1A
(0624)  CS-0x182  0x36702         || 		MOV R7, 0x02
(0625)                            || 
(0626)                     0x183  || e_horiz_1:
(0627)  CS-0x183  0x08E11         || 		CALL draw_dot
(0628)  CS-0x184  0x28801         || 		ADD R8, 0x01
(0629)  CS-0x185  0x3081E         || 		CMP R8, 0x1E
(0630)  CS-0x186  0x08C1B         || 		BRNE e_horiz_1
(0631)  CS-0x187  0x3681A         || 		MOV R8, 0x1A
(0632)  CS-0x188  0x28701         || 		ADD R7, 0x01
(0633)  CS-0x189  0x08E11         || 		CALL draw_dot
(0634)  CS-0x18A  0x28701         || 		ADD R7, 0x01
(0635)                            || 		
(0636)                     0x18B  || e_horiz_2:
(0637)  CS-0x18B  0x08E11         || 		CALL draw_dot
(0638)  CS-0x18C  0x28801         || 		ADD R8, 0x01
(0639)  CS-0x18D  0x3081E         || 		CMP R8, 0x1E
(0640)  CS-0x18E  0x08C5B         || 		BRNE e_horiz_2
(0641)  CS-0x18F  0x3681A         || 		MOV R8, 0x1A
(0642)  CS-0x190  0x28701         || 		ADD R7, 0x01
(0643)  CS-0x191  0x08E11         || 		CALL draw_dot
(0644)  CS-0x192  0x28701         || 		ADD R7, 0x01
(0645)                            || 		
(0646)                     0x193  || e_horiz_3:
(0647)  CS-0x193  0x08E11         || 		CALL draw_dot
(0648)  CS-0x194  0x28801         || 		ADD R8, 0x01
(0649)  CS-0x195  0x3081E         || 		CMP R8, 0x1E
(0650)  CS-0x196  0x08C9B         || 		BRNE e_horiz_3
(0651)  CS-0x197  0x18002         || 		RET
(0652)                            || ;---------------------------------------------------------------------
(0653)                            || 
(0654)                            || ;---------------------------------------------------------------------
(0655)                            || ;-  Subroutine: draw_background
(0656)                            || ;-
(0657)                            || ;-  Fills the 40x30 grid with one color using successive calls to
(0658)                            || ;-  draw_horizontal_line subroutine.
(0659)                            || ;-
(0660)                            || ;-  Tweaked registers: r10,r7,r8,r9
(0661)                            || ;----------------------------------------------------------------------
(0662)                     0x198  || draw_background:
(0663)  CS-0x198  0x366FF         ||          MOV   r6,BG_COLOR              ; use default color
(0664)  CS-0x199  0x36A00         ||          MOV   r10,0x00                 ; r10 keeps track of rows
(0665)  CS-0x19A  0x04751  0x19A  || start:   MOV   r7,r10                   ; load current row count
(0666)  CS-0x19B  0x36800         ||          MOV   r8,0x00                  ; restart x coordinates
(0667)  CS-0x19C  0x36927         ||          MOV   r9,0x27
(0668)                            ||  
(0669)  CS-0x19D  0x08721         ||          CALL  draw_horizontal_line
(0670)  CS-0x19E  0x28A01         ||          ADD   r10,0x01                 ; increment row count
(0671)  CS-0x19F  0x30A1E         ||          CMP   r10,0x1E                 ; see if more rows to draw
(0672)  CS-0x1A0  0x08CD3         ||          BRNE  start                    ; branch to draw more rows
(0673)  CS-0x1A1  0x18002         ||          RET
(0674)                            || ;---------------------------------------------------------------------
(0675)                     0x1A2  || table:
(0676)  CS-0x1A2  0x08E11         || 		 CALL 	draw_dot
(0677)  CS-0x1A3  0x28801         || 		 ADD 	R8, 0x01
(0678)  CS-0x1A4  0x30828         || 		 CMP	R8, 0x28
(0679)  CS-0x1A5  0x08D13         || 		 BRNE	table
(0680)                            || 		 
(0681)                     0x1A6  || table_y:
(0682)  CS-0x1A6  0x28701         || 		 ADD	R7, 0x01
(0683)  CS-0x1A7  0x3071E         || 		 CMP	R7, 0x1E
(0684)  CS-0x1A8  0x08D13         || 		 BRNE 	table
(0685)  CS-0x1A9  0x18002         || 		 RET
(0686)                            || ;---------------------------------------------------------------------
(0687)                            || 
(0688)                            || ;---------------------------------------------------------------------
(0689)                     0x1AA  || seconds_divider:
(0690)  CS-0x1AA  0x08D81         || 		 CALL	seconds
(0691)  CS-0x1AB  0x2D401         || 		 SUB 	R20, 0x01
(0692)  CS-0x1AC  0x31400         || 		 CMP	R20, 0x00
(0693)  CS-0x1AD  0x08D53         || 		 BRNE	seconds_divider
(0694)  CS-0x1AE  0x37410         || 		 MOV 	R20, 0x10
(0695)  CS-0x1AF  0x18002         || 		 ret
(0696)                            || 
(0697)                            || ;---------------------------------------------------------------------
(0698)                            || 
(0699)                            || ;---------------------------------------------------------------------
(0700)                     0x1B0  || seconds:
(0701)  CS-0x1B0  0x37DEF         || 		 MOV	R29, 0xEF        ;Moves 0xE7 into register R29. This is
(0702)                            ||                                  ;25 values away from 0x00
(0703)                     0x1B1  || seconds_init_2:
(0704)  CS-0x1B1  0x37E06         || 		 MOV 	R30, 0x06        ;Moves 0x06 into register R30. This is 
(0705)                            ||                                  ;250 values away from 0x00
(0706)                     0x1B2  || seconds_init_3:
(0707)  CS-0x1B2  0x37F06         || 		 MOV 	R31, 0x06        ;Moves 0x06 into register R31. This is               
(0708)                            || 								 ;250 values away from 0x00
(0709)                     0x1B3  || seconds_init_4:
(0710)  CS-0x1B3  0x29F01         || 		 ADD 	R31, 0x01        ;Adds 0x01 to R1 in the loop 250 times 
(0711)                            || 								 ;per loop
(0712)                            || 
(0713)  CS-0x1B4  0x08D9B         || 	 	 BRNE 	seconds_init_4   ;Loops back to seconds_init
(0714)                            || 								 ;until the value in R1 is 0
(0715)                            || 
(0716)  CS-0x1B5  0x29E01         || 		 ADD 	R30, 0x01        ;Adds 0x01 to R2 in the loop 250 times 
(0717)                            || 								 ;per loop
(0718)                            || 
(0719)  CS-0x1B6  0x08D93         || 		 BRNE 	seconds_init_3   ;Loops back to the line seconds_init  
(0720)                            || 								 ;to reset the value stored into R1 back 
(0721)                            || 								 ;to 0x06 for the next loop until the  
(0722)                            || 								 ;value  in R2 is 0x00
(0723)                            || 
(0724)                            || 		 
(0725)  CS-0x1B7  0x29D01         || 		 ADD 	R29, 0x01        ;Adds 0x01 into R3 in the loop 25 times 
(0726)                            || 								 ;per loop
(0727)                            || 
(0728)  CS-0x1B8  0x08D8B         || 		 BRNE 	seconds_init_2   ;Loops back to the line “MOV R2, 0x06” 
(0729)                            || 								 ;in order to reset both R1 and R2 to 
(0730)                            || 								 ;0x06 for the next loop until the value 
(0731)                            || 								 ;of R3 is 0x00
(0732)                            || 		 
(0733)  CS-0x1B9  0x18002         || 		  RET
(0734)                            || ;---------------------------------------------------------------------
(0735)                            || 
(0736)                     0x1BA  || draw_flow:
(0737)  CS-0x1BA  0x04439         || 		 MOV R4, R7
(0738)  CS-0x1BB  0x04541         || 		 MOV R5, R8
(0739)                            || 		 
(0740)                     0x1BC  || draw_flow_start:
(0741)  CS-0x1BC  0x08D81         || 		 CALL seconds
(0742)  CS-0x1BD  0x08E11         || 		 CALL draw_dot
(0743)                            || 
(0744)  CS-0x1BE  0x28701         || 		 ADD R7, 0x01
(0745)                            || 
(0746)  CS-0x1BF  0x3070D         || 		 CMP R7, 0x0D
(0747)  CS-0x1C0  0x0ADE0         || 		 BRCS draw_flow_start
(0748)  CS-0x1C1  0x18002         || 		 RET
(0749)                            || 			
(0750)                            || ;---------------------------------------------------------------------
(0751)                            || ;- Subrountine: draw_dot
(0752)                            || ;-
(0753)                            || ;- This subroutine draws a dot on the display the given coordinates:
(0754)                            || ;-
(0755)                            || ;- (X,Y) = (r8,r7)  with a color stored in r6
(0756)                            || ;-
(0757)                            || ;- Tweaked registers: r4,r5
(0758)                            || ;---------------------------------------------------------------------
(0759)                     0x1C2  || draw_dot:
(0760)  CS-0x1C2  0x04439         ||            MOV   r4,r7         ; copy Y coordinate
(0761)  CS-0x1C3  0x04541         ||            MOV   r5,r8         ; copy X coordinate
(0762)                            || 
(0763)  CS-0x1C4  0x2053F         ||            AND   r5,0x3F       ; make sure top 2 bits cleared, has to be a number within 6 bits so don't need all 8 for the columns.
(0764)  CS-0x1C5  0x2041F         ||            AND   r4,0x1F       ; make sure top 3 bits cleared, has to be a number within 5 bits for the rows.
(0765)  CS-0x1C6  0x10401         ||            LSR   r4             ; need to get the bot 2 bits of r4 into sA
(0766)  CS-0x1C7  0x0AE70         ||            BRCS  dd_add40
(0767)  CS-0x1C8  0x10401  0x1C8  || t1:        LSR   r4
(0768)  CS-0x1C9  0x0AE88         ||            BRCS  dd_add80
(0769)                            || 
(0770)  CS-0x1CA  0x34591  0x1CA  || dd_out:    OUT   r5,VGA_LADD   ; write bot 8 address bits to register
(0771)  CS-0x1CB  0x34490         ||            OUT   r4,VGA_HADD   ; write top 3 address bits to register
(0772)  CS-0x1CC  0x34692         ||            OUT   r6,VGA_COLOR  ; write data to frame buffer, combining x and y corrd to produce 11 bit address.
(0773)  CS-0x1CD  0x18002         ||            RET
(0774)                            || 
(0775)  CS-0x1CE  0x22540  0x1CE  || dd_add40:  OR    r5,0x40       ; set bit if needed
(0776)  CS-0x1CF  0x18000         ||            CLC                 ; freshen bit
(0777)  CS-0x1D0  0x08E40         ||            BRN   t1
(0778)                            || 
(0779)  CS-0x1D1  0x22580  0x1D1  || dd_add80:  OR    r5,0x80       ; set bit if needed
(0780)  CS-0x1D2  0x08E50         ||            BRN   dd_out
(0781)                            || ; --------------------------------------------------------------------
(0782)                            || 
(0783)                            || .CSEG
(0784)                       1023  || .ORG 0x3FF
(0785)  CS-0x3FF  0x08180         || BRN ISR





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
ADD_1          0x0AC   (0293)  ||  0200 
BEAKER_HORIZ   0x0F6   (0419)  ||  0423 
BEAKER_VERT_1  0x0F2   (0413)  ||  0417 
BEAKER_VERT_2  0x0FA   (0425)  ||  0429 
CFB            0x06F   (0200)  ||  0195 
COLOR_CHANGER  0x066   (0183)  ||  0162 
DD_ADD40       0x1CE   (0775)  ||  0766 
DD_ADD80       0x1D1   (0779)  ||  0768 
DD_OUT         0x1CA   (0770)  ||  0780 
DIFFICULTY     0x0A1   (0278)  ||  0111 0283 
DIFF_CHECK     0x085   (0238)  ||  0177 0243 
DRAW_BACKGROUND 0x198   (0662)  ||  0062 0126 
DRAW_BEAKER    0x0F0   (0409)  ||  0071 0135 0318 0343 
DRAW_DOT       0x1C2   (0759)  ||  0376 0400 0414 0420 0426 0441 0464 0470 0476 0483 
                               ||  0489 0497 0504 0512 0520 0526 0532 0538 0543 0558 
                               ||  0564 0572 0578 0584 0590 0598 0604 0608 0614 0619 
                               ||  0627 0633 0637 0643 0647 0676 0742 
DRAW_FLOW      0x1BA   (0736)  ||  0160 0176 0310 0347 
DRAW_FLOW_START 0x1BC   (0740)  ||  0747 
DRAW_FLUID     0x0FF   (0436)  ||  0121 0188 0306 0335 
DRAW_HORIZ1    0x0E5   (0375)  ||  0379 
DRAW_HORIZONTAL_LINE 0x0E4   (0372)  ||  0669 
DRAW_VERT1     0x0EB   (0399)  ||  0403 
DRAW_VERTICAL_LINE 0x0EA   (0396)  ||  
END            0x0E2   (0355)  ||  0356 
ENDGAME_LOSE   0x0C8   (0327)  ||  0276 
ENDGAME_WIN    0x0AE   (0298)  ||  0261 
E_HORIZ_1      0x183   (0626)  ||  0630 
E_HORIZ_2      0x18B   (0636)  ||  0640 
E_HORIZ_3      0x193   (0646)  ||  0650 
FLUID_HORIZ    0x101   (0440)  ||  0444 0450 
FLUID_VERT     0x105   (0446)  ||  
GAME           0x054   (0154)  ||  0143 
GAME_CNT       0x05F   (0172)  ||  0267 0275 
GUESS_CHECK    0x092   (0259)  ||  0168 
INIT           0x010   (0061)  ||  
INIT_GAME      0x04B   (0141)  ||  0123 0150 0179 
ISR            0x030   (0104)  ||  0110 0785 
I_HORIZ_1      0x126   (0496)  ||  0500 
I_HORIZ_2      0x131   (0511)  ||  0515 
I_VERT         0x12B   (0503)  ||  0507 
LOSE           0x14E   (0553)  ||  0331 
LOSE_LIFE      0x09A   (0269)  ||  0266 
L_HORIZ        0x154   (0563)  ||  0567 
L_VERT         0x150   (0557)  ||  0561 
MAIN           0x02E   (0098)  ||  0100 
N_VERT_1       0x137   (0519)  ||  0523 
N_VERT_2       0x140   (0531)  ||  0535 
N_VERT_3       0x149   (0542)  ||  0546 
O_HORIZ_1      0x15E   (0577)  ||  0581 
O_HORIZ_2      0x166   (0589)  ||  0593 
O_VERT_1       0x15A   (0571)  ||  0575 
O_VERT_2       0x162   (0583)  ||  0587 
PROG_B1        0x06C   (0193)  ||  0115 0165 0207 
PROG_B2        0x070   (0204)  ||  0196 
PROG_CHECK     0x07C   (0224)  ||  0117 0166 0229 
PROG_RG        0x074   (0212)  ||  0217 
RED_SHIFT      0x08E   (0251)  ||  0113 
SECONDS        0x1B0   (0700)  ||  0690 0741 
SECONDS_DIVIDER 0x1AA   (0689)  ||  0124 0693 
SECONDS_INIT_2 0x1B1   (0703)  ||  0728 
SECONDS_INIT_3 0x1B2   (0706)  ||  0719 
SECONDS_INIT_4 0x1B3   (0709)  ||  0713 
START          0x19A   (0665)  ||  0672 
S_HORIZ_1      0x16C   (0597)  ||  0601 
S_HORIZ_2      0x174   (0607)  ||  0611 
S_HORIZ_3      0x17D   (0618)  ||  0622 
T1             0x1C8   (0767)  ||  0777 
TABLE          0x1A2   (0675)  ||  0066 0131 0314 0339 0679 0684 
TABLE_Y        0x1A6   (0681)  ||  
WIN            0x10A   (0456)  ||  0302 
W_HORIZ_1      0x113   (0469)  ||  0473 
W_HORIZ_2      0x11C   (0482)  ||  0486 
W_VERT_1       0x10F   (0463)  ||  0467 
W_VERT_2       0x117   (0475)  ||  0479 
W_VERT_3       0x120   (0488)  ||  0492 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
BEAKER_WALLS   0x000   (0021)  ||  
BG_COLOR       0x0FF   (0020)  ||  0663 
DELAY          0x0FF   (0019)  ||  
FLUID_COLOR    0x088   (0023)  ||  
LEDS           0x040   (0011)  ||  0231 0320 0349 
LEDS1          0x041   (0012)  ||  0245 0285 0321 0350 
NUM_LIVES      0x003   (0024)  ||  
RAND_PORT      0x024   (0014)  ||  0092 0099 
SSEG           0x081   (0010)  ||  0112 0273 0288 
STARTING_SCORE 0x000   (0025)  ||  
SWITCH_PORT1   0x020   (0013)  ||  0106 0144 
VGA_COLOR      0x092   (0009)  ||  0772 
VGA_HADD       0x090   (0007)  ||  0771 
VGA_LADD       0x091   (0008)  ||  0770 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
