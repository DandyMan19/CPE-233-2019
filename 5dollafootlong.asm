
.CSEG
.ORG 0x10
;--------------------------------------------------------------------------
;PORT CONSTANTS
;-------------------------------------------------------------------------
.EQU VGA_HADD = 0x90	;port for VGA x
.EQU VGA_LADD = 0x91	;port for VGA y
.EQU VGA_COLOR = 0x92	;port for VGA color OUTPUT
.EQU SSEG = 0x81		;port for display	OUTPUT
.EQU LEDS = 0x40		;port for LEDS 	OUTPUT
.EQU LEDS1 = 0x41
.EQU SWITCH_PORT1 = 0x20	; port for switches INPUT
.EQU RAND_PORT = 0x24	;port for random number	INPUT

;--------------------------------------------------------------------------------------------
;GAME CONSTANTS
;---------------------------------------------------------------------------------------------
.EQU DELAY			= 0xFF 			;delay timer for the user to enter a interrupt.
.EQU BG_COLOR       = 0xFF              ; Background:  white 
.EQU BEAKER_WALLS   = 0x00				; Walls of the beaker
.EQU DIRECTION DOWN = 0x02				; Direction of the added substance
.EQU FLUID_COLOR	= 0x88			    ; Port TBD later for rng number
.EQU NUM_LIVES      = 0x03				; Set of lives until gameover
.EQU STARTING_SCORE = 0x00				; Score for initial points

;-----------------------------------------------------------------------
;- Register Usage
;-----------------------------------------------------------------------
;- GAME
;
;R01: DIRECTION DOWN
;R02: RANDOM NUMBER
;R11: COLOR ADDITION 
;R12: LEVEL
;R03: LIVES
;R14: SCORE

;- UNUSED
;
;- INPUT
;R15: SWITCH ENABLED
;R16: BUTTON
;
;- OUTPUT
;R16: LEDS
;R17: SSEGS
;
;- DRAWING
;
;R18: TEMP COLOR
;R19: TEMP FLUID COLOR
;R20: DRAW LINE ENDING TRACKER
;R21: DRAW BACKGROUND ROW TRACKER
;R22: DRAW DOT 
;R23: KEY UP INFO FLAG
;r6 is used for color
;r7 is used for Y
;r8 is used for X
;---------------------------------------------------------------------
init:
         CALL   draw_background         ; draw using default color
		 MOV	R7, 0x12
		 MOV	R8, 0x00
		 MOV	R6, 0x64
		 CALL	table
		 
	     MOV    R7, 0x09				; Y coordinate for beaker
		 MOV	R8, 0x13				; X coordinate for beaker
		 MOV	R6, 0x00				; sets default color to black
		 CALL   draw_beaker
		 
		 MOV	R1,  0x00				; temporary value for R2
		 MOV 	R2,  0x00				; determines difficulty from switches
		 MOV	R3,  0x00				; lives
		 MOV	R12, 0x00				; actual difficulty
		 MOV	R13, 0x00				; switch for chemical pour
		 MOV	R14, 0x00				; counter for difficulty determination
		 MOV	R15, 0x00				; stores switches value for color
		 MOV	R16, 0x00				; keeps track of progress
		 MOV	R17, 0x00				; keeps track of all difficulty loops
		 MOV	R18, R0					; temporary value for R0
		 MOV	R19, 0x00				; determines if the final bit of R2 has determined difficulty
		 MOV 	R20, 0x10				; just a delay for seconds
		 MOV	R21, 0x00				; keeps track of difficulty
		 MOV	R22, 0x00				; temporary register for progress loop
		 MOV	R23, 0x00				; keeps track of progress loop for LEDs
		 MOV	R24, 0x00				; ensures the LEDs are set to zero
		 MOV	R25, 0x00				; temporary register for the difficulty
		 MOV	R26, 0x00				; keeps track of difficulty loop for LEDs
		 MOV	R27, 0x00				; sets the amount of lives
		 IN		R0,  RAND_PORT
		 SEI

;---------------------------------------------------------------------

;---------------------------------------------------------------------
main:	 
		 IN		R0, RAND_PORT
		 BRN	main
;---------------------------------------------------------------------
		 
;---------------------------------------------------------------------
ISR:	 

		 IN 	R2, SWITCH_PORT1
		 MOV	R1, R2
		 LSR	R1
		 
		 BRCC	ISR
		 CALL	difficulty
		 OUT	R3, SSEG
		 CALL	red_shift
		 MOV	R18, R0
		 CALL	prog_b1
		 MOV	R23, 0x00
		 CALL	prog_check
		 MOV 	R7, 0x0D				; Y coordinate for fluid				
		 MOV	R8, 0x14				; X coordinate for fluid
		 MOV	R6, R0					; moves blue (PUT COLOR FROM WRAPPER LATER)
		 CALL   draw_fluid				; draws the fluid inside the beaker
		 
		 CALL 	init_game
		 CALL 	seconds_divider
		 
		 CALL   draw_background         ; draw using default color

		 MOV	R7, 0x12
		 MOV	R8, 0x00
		 MOV	R6, 0x64
		 CALL	table
	     MOV    R7, 0x09				; Y coordinate for beaker
		 MOV	R8, 0x13				; X coordinate for beaker
		 MOV	R6, 0x00				; sets default color to black
		 CALL   draw_beaker
		 RETIE
		 
;---------------------------------------------------------------------		

;--------------------------------------------------------------------- 
init_game:	 
         CMP    R13, 0x01
		 BREQ 	game
		 IN 	R2, SWITCH_PORT1
		 MOV 	R1, R2
		 LSL 	R1
		 ADDC 	R13, 0x00
		 CLC
		 LSR	R1
		 BRN 	init_game
;---------------------------------------------------------------------

;---------------------------------------------------------------------
game:
		 MOV	R13, 0x00
		 MOV	R7, 0x00
		 MOV	R8, 0x19
		 MOV 	R6, R1
		 MOV	R15, R6
		 CALL 	draw_flow
		 
		 CALL	color_changer
		 
		 MOV	R18, R0
		 CALL	prog_b1
		 CALL	prog_check
		 
		 BRN	guess_check
;---------------------------------------------------------------------

;---------------------------------------------------------------------
game_cnt:		 
		 MOV	R7, 0x00
		 MOV 	R8, 0x19
		 MOV 	R6, 0xFF
		 CALL	draw_flow
		 CALL	diff_check
		 CLC
		 BRN	init_game
;---------------------------------------------------------------------

;---------------------------------------------------------------------
color_changer:
		 EXOR 	R0, R15
		 MOV 	R7, 0x0D
		 MOV	R8, 0x14
		 MOV	R6, R0
		 CALL	draw_fluid
		 RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
prog_b1:
		 LSR 	R18
		 BREQ	cfb
		 BRNE	prog_b2
;---------------------------------------------------------------------

;---------------------------------------------------------------------
cfb:	 CALL 	add_1
;---------------------------------------------------------------------

;---------------------------------------------------------------------
prog_b2:
		 ADD 	R17, 0x01
		 CMP 	R17, 0x02
		 BRNE 	prog_b1
		 MOV 	R17, 0x00
;---------------------------------------------------------------------

;---------------------------------------------------------------------
prog_rg:	
		 LSR 	R18
		 ADDC	R16, 0x00
		 ADD 	R17, 0x01
		 CMP 	R17, 0x05
		 BRNE 	prog_rg
		 MOV	R17, 0x00
		 MOV	R22, R16
		 RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
prog_check:
		 SEC
		 LSL	R23
		 SUB	R22, 0x01
		 CMP	R22, 0x00
		 BRNE	prog_check
		 MOV 	R22, 0x00
		 OUT	R23, LEDS
		 MOV	R23, 0x00
		 RET
		 
;---------------------------------------------------------------------

;---------------------------------------------------------------------
diff_check:
		 SEC
		 LSL 	R26
		 SUB 	R25, 0x01
		 CMP	R25, 0x00
		 BRNE	diff_check
		 MOV	R25, 0x00
		 OUT 	R26, LEDS1
		 MOV	R26, 0x00
		 RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
red_shift:
		 LSL	R0
		 CLC
		 LSR	R0
		 RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
guess_check:
		 CMP 	R16, 0x05
		 BREQ	endgame_win
		 MOV	R16, 0x00
		 MOV	R25, R12
		 SUB 	R12, 0x01
		 CMP 	R12, 0x00
		 BREQ 	lose_life
		 BRNE	game_cnt
;---------------------------------------------------------------------	 
lose_life:
		 MOV	R12, R21
		 MOV	R0, R18
		 SUB	R3, 0x01
		 OUT	R3, SSEG
		 CMP	R3, 0x00
		 BRNE	game_cnt
		 BREQ	endgame_lose
;---------------------------------------------------------------------
difficulty: 
		 LSR 	R1
		 ADDC 	R12, 0x00
		 ADD 	R14, 0x01
		 CMP 	R14, 0x06
		 BRNE 	difficulty
		 ADD	R12, 0x01
		 OUT	R12, LEDS1
		 MOV	R21, R12
		 MOV	R3, R12
		 OUT	R3, SSEG
		 RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
add_1:	 ADD	R16, 0x01
		 RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------	
endgame_win:
		 MOV	R7, 0x02
		 MOV	R8, 0x08
		 MOV	R6, 0xFC
		 CALL   win						; draw "win"
		 MOV	R7, 0x0D
		 MOV	R8, 0x14
		 MOV	R6, 0xFF
		 CALL	draw_fluid
		 MOV	R7, 0x00
		 MOV	R8, 0x19
		 MOV 	R6, 0xFF
		 CALL	draw_flow
		 MOV	R7, 0x12
		 MOV	R8, 0x00
		 MOV	R6, 0x64
		 CALL	table
	     MOV    R7, 0x09				; Y coordinate for beaker
		 MOV	R8, 0x13				; X coordinate for beaker
		 MOV	R6, 0x00				; sets default color to black
		 CALL   draw_beaker
		 MOV	R3, 0x04
		 OUT	R24, LEDS
		 OUT	R24, LEDS1
		 MOV	R12, 0x00
		 MOV	R14, 0x00
		 RET
;---------------------------------------------------------------------
		 		 
endgame_lose:
		 MOV	R7, 0x02				; Y coordinate for "lose"
		 MOV 	R8, 0x08				; X coordinate for "lose"
		 MOV 	R6, 0x03				; sets default color to blue
		 CALL   lose					; draw "lose"
		 MOV	R7, 0x0D
		 MOV	R8, 0x14
		 MOV	R6, 0xFF
		 CALL	draw_fluid
		 MOV	R7, 0x12
		 MOV	R8, 0x00
		 MOV	R6, 0x64
		 CALL	table
	     MOV    R7, 0x09				; Y coordinate for beaker
		 MOV	R8, 0x13				; X coordinate for beaker
		 MOV	R6, 0x00				; sets default color to black
		 CALL   draw_beaker
		 MOV	R7, 0x00
		 MOV	R8, 0x19
		 MOV 	R6, 0xFF
		 CALL	draw_flow
		 MOV	R3, 0x04
		 OUT	R24, LEDS
		 OUT	R24, LEDS1
		 MOV	R12, 0x00
		 MOV	R14, 0x00
		 RET
      
end:     AND    r11, r11                ; nop
         BRN    end                     ; continuous loop
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;-  Subroutine: draw_horizontal_line
;-
;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6
;-
;-  Parameters:
;-   r8  = starting x-coordinate
;-   r7  = y-coordinate
;-   r9  = ending x-coordinate
;-   r6  = color used for line
;-
;- Tweaked registers: r8,r9
;--------------------------------------------------------------------
draw_horizontal_line:
         ADD    r9,0x01          ; go from r8 to r15 inclusive

draw_horiz1:
         CALL   draw_dot         ;draws a bunch of dots which will paint the line.
         ADD    r8,0x01
         CMP  	r8,r9
         BRNE   draw_horiz1
         RET
;--------------------------------------------------------------------

;---------------------------------------------------------------------
;-  Subroutine: draw_vertical_line
;-
;-  Draws a vertical line from (r8,r7) to (r8,r9) using color in r6
;-
;-  Parameters:
;-   r8  = x-coordinate
;-   r7  = starting y-coordinate
;-   r9  = ending y-coordinate
;-   r6  = color used for line
;-
;- Tweaked registers: r7,r9
;--------------------------------------------------------------------
draw_vertical_line:
         ADD    r9,0x01

draw_vert1:
         CALL   draw_dot
         ADD    r7,0x01
         CMP    r7,R9
         BRNE   draw_vert1
         RET
;--------------------------------------------------------------------

;---------------------------------------------------------------------

draw_beaker:
		MOV R4, R7
		MOV R5, R7
		
beaker_vert_1:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x17
		BRNE beaker_vert_1
		
beaker_horiz:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x1D
		BRNE beaker_horiz
		
beaker_vert_2:
		CALL draw_dot
		SUB R7, 0x01
		CMP R7, 0x08
		BRNE beaker_vert_2
		RET
		
;---------------------------------------------------------------------

;---------------------------------------------------------------------
		
draw_fluid:
		MOV R4, R7
		MOV R5, R8
		
fluid_horiz:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x1D
		BRNE fluid_horiz
		
fluid_vert:
		MOV R8, 0x14
		ADD R7, 0x01
		CMP R7, 0x17
		BRNE fluid_horiz
		RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
		
win:
		MOV	R7, 0x02				; Y coordinate for "win"
		MOV	R8, 0x08				; X coordinate for "win"
		MOV	R6, 0xE0				; sets default color to red
		MOV R4, R7
		MOV R5, R8
		
w_vert_1:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x06
		BRNE w_vert_1
		
w_horiz_1:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x0A
		BRNE w_horiz_1
		
w_vert_2:
		CALL draw_dot
		SUB R7, 0x01
		CMP R7, 0x01
		BRNE w_vert_2
		MOV R7, 0x06
		
w_horiz_2:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x0C
		BRNE w_horiz_2
		
w_vert_3:
		CALL draw_dot
		SUB R7, 0x01
		CMP R7, 0x01
		BRNE w_vert_3
		MOV R8, 0x0E
		MOV R7, 0x02
		
i_horiz_1:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x13
		BRNE i_horiz_1
		MOV R8, 0x10
		
i_vert:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x06
		BRNE i_vert
		MOV R8, 0x0E
		MOV R7, 0x06
		
i_horiz_2:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x13
		BRNE i_horiz_2
		MOV R8, 0x14
		MOV R7, 0x02
		
n_vert_1:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x07
		BRNE n_vert_1
		MOV R7, 0x02
		ADD R8, 0x01
		CALL draw_dot
		ADD R8, 0x01
		MOV R7, 0x03
		

n_vert_2:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x06
		BRNE n_vert_2
		MOV R7, 0x06
		ADD R8, 0x01
		CALL draw_dot
		MOV R7, 0x02
		ADD R8, 0x01
		
n_vert_3:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x07
		BRNE n_vert_3
		RET
		
;---------------------------------------------------------------------

;---------------------------------------------------------------------

lose:
		MOV R4, R7
		MOV R5, R8
		
l_vert:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x06
		BRNE l_vert
		
l_horiz:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x0D
		BRNE l_horiz
		MOV R7, 0x02
		MOV R8, 0x0E
		
o_vert_1:
		CALL draw_dot
		ADD R7, 0x01
		CMP R7, 0x06
		BRNE o_vert_1

o_horiz_1:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x12
		BRNE o_horiz_1

o_vert_2:
		CALL draw_dot
		SUB R7, 0x01
		CMP R7, 0x02
		BRNE o_vert_2
		
o_horiz_2:
		CALL draw_dot
		SUB R8, 0x01
		CMP R8, 0x0E
		BRNE o_horiz_2	
		MOV R8, 0x14
		MOV R7, 0x02
		
s_horiz_1:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x19
		BRNE s_horiz_1
		MOV R8, 0x14
		ADD R7, 0x01
		CALL draw_dot
		ADD R7, 0x01
		
s_horiz_2:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x19
		BRNE s_horiz_2
		MOV R8, 0x18
		ADD R7, 0x01
		CALL draw_dot
		MOV R8, 0x14
		ADD R7, 0x01
		
s_horiz_3:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x19
		BRNE s_horiz_3
		MOV R8, 0x1A
		MOV R7, 0x02

e_horiz_1:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x1E
		BRNE e_horiz_1
		MOV R8, 0x1A
		ADD R7, 0x01
		CALL draw_dot
		ADD R7, 0x01
		
e_horiz_2:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x1E
		BRNE e_horiz_2
		MOV R8, 0x1A
		ADD R7, 0x01
		CALL draw_dot
		ADD R7, 0x01
		
e_horiz_3:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x1E
		BRNE e_horiz_3
		RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
;-  Subroutine: draw_background
;-
;-  Fills the 40x30 grid with one color using successive calls to
;-  draw_horizontal_line subroutine.
;-
;-  Tweaked registers: r10,r7,r8,r9
;----------------------------------------------------------------------
draw_background:
         MOV   r6,BG_COLOR              ; use default color
         MOV   r10,0x00                 ; r10 keeps track of rows
start:   MOV   r7,r10                   ; load current row count
         MOV   r8,0x00                  ; restart x coordinates
         MOV   r9,0x27
 
         CALL  draw_horizontal_line
         ADD   r10,0x01                 ; increment row count
         CMP   r10,0x1E                 ; see if more rows to draw
         BRNE  start                    ; branch to draw more rows
         RET
;---------------------------------------------------------------------
table:
		 CALL 	draw_dot
		 ADD 	R8, 0x01
		 CMP	R8, 0x28
		 BRNE	table
		 
table_y:
		 ADD	R7, 0x01
		 CMP	R7, 0x1E
		 BRNE 	table
		 RET
;---------------------------------------------------------------------

;---------------------------------------------------------------------
seconds_divider:
		 CALL	seconds
		 SUB 	R20, 0x01
		 CMP	R20, 0x00
		 BRNE	seconds_divider
		 MOV 	R20, 0x10
		 ret

;---------------------------------------------------------------------

;---------------------------------------------------------------------
seconds:
		 MOV	R29, 0xEF        ;Moves 0xE7 into register R29. This is
                                 ;25 values away from 0x00
seconds_init_2:
		 MOV 	R30, 0x06        ;Moves 0x06 into register R30. This is 
                                 ;250 values away from 0x00
seconds_init_3:
		 MOV 	R31, 0x06        ;Moves 0x06 into register R31. This is               
								 ;250 values away from 0x00
seconds_init_4:
		 ADD 	R31, 0x01        ;Adds 0x01 to R1 in the loop 250 times 
								 ;per loop

	 	 BRNE 	seconds_init_4   ;Loops back to seconds_init
								 ;until the value in R1 is 0

		 ADD 	R30, 0x01        ;Adds 0x01 to R2 in the loop 250 times 
								 ;per loop

		 BRNE 	seconds_init_3   ;Loops back to the line seconds_init  
								 ;to reset the value stored into R1 back 
								 ;to 0x06 for the next loop until the  
								 ;value  in R2 is 0x00

		 
		 ADD 	R29, 0x01        ;Adds 0x01 into R3 in the loop 25 times 
								 ;per loop

		 BRNE 	seconds_init_2   ;Loops back to the line �MOV R2, 0x06� 
								 ;in order to reset both R1 and R2 to 
								 ;0x06 for the next loop until the value 
								 ;of R3 is 0x00
		 
		  RET
;---------------------------------------------------------------------

draw_flow:
		 MOV R4, R7
		 MOV R5, R8
		 
draw_flow_start:
		 CALL seconds
		 CALL draw_dot

		 ADD R7, 0x01

		 CMP R7, 0x0D
		 BRCS draw_flow_start
		 RET
			
;---------------------------------------------------------------------
;- Subrountine: draw_dot
;-
;- This subroutine draws a dot on the display the given coordinates:
;-
;- (X,Y) = (r8,r7)  with a color stored in r6
;-
;- Tweaked registers: r4,r5
;---------------------------------------------------------------------
draw_dot:
           MOV   r4,r7         ; copy Y coordinate
           MOV   r5,r8         ; copy X coordinate

           AND   r5,0x3F       ; make sure top 2 bits cleared, has to be a number within 6 bits so don't need all 8 for the columns.
           AND   r4,0x1F       ; make sure top 3 bits cleared, has to be a number within 5 bits for the rows.
           LSR   r4             ; need to get the bot 2 bits of r4 into sA
           BRCS  dd_add40
t1:        LSR   r4
           BRCS  dd_add80

dd_out:    OUT   r5,VGA_LADD   ; write bot 8 address bits to register
           OUT   r4,VGA_HADD   ; write top 3 address bits to register
           OUT   r6,VGA_COLOR  ; write data to frame buffer, combining x and y corrd to produce 11 bit address.
           RET

dd_add40:  OR    r5,0x40       ; set bit if needed
           CLC                 ; freshen bit
           BRN   t1

dd_add80:  OR    r5,0x80       ; set bit if needed
           BRN   dd_out
; --------------------------------------------------------------------

.CSEG
.ORG 0x3FF
BRN ISR
