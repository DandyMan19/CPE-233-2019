;---------------------------------------------------------------------
; An expanded "draw_dot" program that includes subrountines to draw
; vertical lines, horizontal lines, and a full background.
;
; As written, this programs does the following:
;   1) draws a the background blue (draws all the tiles)
;   2) draws a red dot
;   3) draws a red horizontal lines
;   4) draws a red vertical line
;
; Author: Bridget Benson
; Modifications: bryan mealy, Paul Hummel
;---------------------------------------------------------------------

.CSEG
.ORG 0x10

.EQU VGA_HADD = 0x90
.EQU VGA_LADD = 0x91
.EQU VGA_COLOR = 0x92
.EQU SSEG = 0x81
.EQU LEDS = 0x40

.EQU BG_COLOR       = 0xFF             ; Background:  blue


;r6 is used for color
;r7 is used for Y
;r8 is used for X

;---------------------------------------------------------------------
init:
         CALL   draw_background         ; draw using default color

		 
	     MOV    R7, 0x09				; Y coordinate for beaker
		 MOV	R8, 0x13				; X coordinate for beaker
		 MOV	R6, 0x00				; sets default color to black
		 CALL   draw_beaker
		 
		 MOV 	R7, 0x0D				; Y coordinate for fluid				
		 MOV	R8, 0x14				; X coordinate for fluid
		 MOV	R6, 0x03				; moves blue (PUT COLOR FROM WRAPPER LATER)
		 CALL   draw_fluid				; draws the fluid inside the beaker
		 
		 MOV	R7, 0x02				; Y coordinate for "win"
		 MOV	R8, 0x08				; X coordinate for "win"
		 MOV	R6, 0xE0				; sets default color to red
		 CALL   win						; draw "win"
		 
		 MOV	R7, 0x02				; Y coordinate for "lose"
		 MOV 	R8, 0x08				; X coordinate for "lose"
		 MOV 	R6, 0x03				; sets default color to blue
		 CALL   lose					; draw "lose"
		 
;         MOV    r7, 0x0F                ; generic Y coordinate
;         MOV    r8, 0x14                ; generic X coordinate
;         MOV    r6, 0xE0                ; color
;         CALL   draw_dot                ; draw red pixel

;         MOV    r8,0x01                 ; starting x coordinate
;         MOV    r7,0x12                 ; start y coordinate
;         MOV    r9,0x26                 ; ending x coordinate
;         CALL   draw_horizontal_line

;         MOV    r8,0x08                 ; starting x coordinate
;         MOV    r7,0x04                 ; start y coordinate
;         MOV    r9,0x17                 ; ending x coordinate
;         CALL   draw_vertical_line
      
end:     AND    r0, r0                  ; nop
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
        CMP    r8,r9
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
		CMP R8, 0x0C
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
		CMP R8, 0x18
		BRNE s_horiz_1
		MOV R8, 0x14
		ADD R7, 0x01
		CALL draw_dot
		ADD R7, 0x01
		
s_horiz_2:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x18
		BRNE s_horiz_2
		ADD R7, 0x01
		CALL draw_dot
		MOV R8, 0x14
		ADD R7, 0x01
		
s_horiz_3:
		CALL draw_dot
		ADD R8, 0x01
		CMP R8, 0x18
		BRNE s_horiz_2
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
           CLC                  ; freshen bit
           BRN   t1

dd_add80:  OR    r5,0x80       ; set bit if needed
           BRN   dd_out
; --------------------------------------------------------------------

