;*******************************************************************************
;*                                                                             *
;*          Run Dino Run!                                                      *
;*          Game Font                                                          *
;*                                                                             *
;*            v 0.1.0                                                          *
;*            July 30, 2019                                                    *
;*                                                                             *
;*******************************************************************************


letters
            fcb     $FF,$C1,$9C,$94 ; '@'
            fcb     $94,$91,$9F,$C1
            fcb     $FF,$E3,$C9,$9C ; 'A'
            fcb     $9C,$80,$9C,$9C
            fcb     $FF,$81,$9C,$9C ; 'B'
            fcb     $81,$9C,$9C,$81
            fcb     $FF,$E1,$CC,$9F ; 'C'
            fcb     $9F,$9F,$CC,$E1
            fcb     $FF,$83,$99,$9C ; 'D'
            fcb     $9C,$9C,$99,$83
            fcb     $FF,$80,$9F,$9F ; 'E'
            fcb     $81,$9F,$9F,$80
            fcb     $FF,$80,$9F,$9F ; 'F'
            fcb     $81,$9F,$9F,$9F
            fcb     $FF,$E0,$CF,$9F ; 'G'
            fcb     $98,$9C,$CC,$E0
            fcb     $FF,$9C,$9C,$9C ; 'H'
            fcb     $80,$9C,$9C,$9C
            fcb     $FF,$81,$E7,$E7 ; 'I'
            fcb     $E7,$E7,$E7,$81
            fcb     $FF,$FC,$FC,$FC ; 'J'
            fcb     $FC,$FC,$9C,$C1
            fcb     $FF,$9C,$99,$93 ; 'K'
            fcb     $87,$83,$99,$9C
            fcb     $FF,$9F,$9F,$9F ; 'L'
            fcb     $9F,$9F,$9F,$81
            fcb     $FF,$9C,$88,$80 ; 'M'
            fcb     $94,$9C,$9C,$9C
            fcb     $FF,$9C,$8C,$84 ; 'N'
            fcb     $80,$90,$98,$9C
            fcb     $FF,$C1,$9C,$9C ; 'O'
            fcb     $9C,$9C,$9C,$C1
            fcb     $FF,$81,$9C,$9C ; 'P'
            fcb     $9C,$81,$9F,$9F
            fcb     $FF,$C1,$9C,$9C ; 'Q'
            fcb     $9C,$90,$99,$C2
            fcb     $FF,$81,$9C,$9C ; 'R'
            fcb     $98,$83,$99,$9C
            fcb     $FF,$C3,$99,$9F ; 'S'
            fcb     $C1,$FC,$9C,$C1
            fcb     $FF,$C0,$F3,$F3 ; 'T'
            fcb     $F3,$F3,$F3,$F3
            fcb     $FF,$9C,$9C,$9C ; 'U'
            fcb     $9C,$9C,$9C,$C1
            fcb     $FF,$9C,$9C,$9C ; 'V'
            fcb     $88,$C1,$E3,$F7
            fcb     $FF,$9C,$9C,$9C ; 'W'
            fcb     $94,$80,$88,$9C
            fcb     $FF,$9C,$88,$C1 ; 'X'
            fcb     $E3,$C1,$88,$9C
            fcb     $FF,$CC,$CC,$CC ; 'Y'
            fcb     $E1,$F3,$F3,$F3
            fcb     $FF,$80,$F8,$F1 ; 'Z'
            fcb     $E3,$C7,$8F,$80

placeholders
            fcb     $FF,$E3,$D9,$9C ; 'blah' 
            fcb     $9C,$9C,$CD,$E3
            fcb     $FF,$FF,$C9,$80 ; '\'
            fcb     $80,$C1,$E3,$F7
            fcb     $FF,$C1,$9C,$FC ; 'blah' 
            fcb     $E1,$CF,$9F,$80
            fcb     $FF,$C0,$F9,$F3 ; 'blah' 
            fcb     $E1,$FC,$9C,$C1
            fcb     $FF,$F1,$E1,$C9 ; 'blah' 
            fcb     $99,$80,$F9,$F9
            fcb     $FF,$FF,$FF,$FF ; 'SPACE' 
            fcb     $FF,$FF,$FF,$FF
            fcb     $FF,$E1,$CF,$9F ; 'blah' 
            fcb     $81,$9C,$9C,$C1
            fcb     $FF,$80,$8C,$F9 ; 'blah' 
            fcb     $F3,$E7,$E7,$E7
            fcb     $FF,$C3,$9D,$8D ; 'blah' 
            fcb     $C3,$B0,$BC,$C1
            fcb     $FF,$C1,$9C,$9C ; 'blah' 
            fcb     $C0,$FC,$F9,$C3          
            fcb     $FF,$E3,$D9,$9C ; 'blah' 
            fcb     $9C,$9C,$CD,$E3
            fcb     $FF,$C7,$BB,$D7 ; '&'
            fcb     $EF,$D5,$BB,$C4
            fcb     $FF,$C1,$9C,$FC ; 'blah' 
            fcb     $E1,$CF,$9F,$80
            fcb     $FF,$C0,$F9,$F3 ; 'blah' 
            fcb     $E1,$FC,$9C,$C1
            fcb     $FF,$F1,$E1,$C9 ; 'blah' 
            fcb     $99,$80,$F9,$F9
            fcb     $FF,$81,$9F,$81 ; 'blah' 
            fcb     $FC,$FC,$9C,$C1
            fcb     $FF,$E1,$CF,$9F ; 'blah' 
            fcb     $81,$9C,$9C,$C1
            fcb     $FF,$80,$8C,$F9 ; 'blah' 
            fcb     $F3,$E7,$E7,$E7
            fcb     $FF,$FF,$FF,$80 ; '-' 
            fcb     $01,$FF,$FF,$FF
            fcb     $FF,$C1,$9C,$9C ; 'blah' 
            fcb     $C0,$FC,$F9,$C3          
            fcb     $FF,$C1,$9C,$9C ; 'blah' 
            fcb     $C0,$FC,$F9,$C3          
numbers
            fcb     $FF,$E3,$D9,$9C ; '0' 
            fcb     $9C,$9C,$CD,$E3
            fcb     $FF,$E7,$C7,$E7 ; '1'
            fcb     $E7,$E7,$E7,$81
            fcb     $FF,$C1,$9C,$FC ; '2'
            fcb     $E1,$CF,$9F,$80
            fcb     $FF,$C0,$F9,$F3 ; '3'
            fcb     $E1,$FC,$9C,$C1
            fcb     $FF,$F1,$E1,$C9 ; '4'
            fcb     $99,$80,$F9,$F9
            fcb     $FF,$81,$9F,$81 ; '5'
            fcb     $FC,$FC,$9C,$C1
            fcb     $FF,$E1,$CF,$9F ; '6'
            fcb     $81,$9C,$9C,$C1
            fcb     $FF,$80,$8C,$F9 ; '7'
            fcb     $F3,$E7,$E7,$E7
            fcb     $FF,$C3,$9D,$8D ; '8'
            fcb     $C3,$B0,$BC,$C1
            fcb     $FF,$C1,$9C,$9C ; '9'
            fcb     $C0,$FC,$F9,$C3 
            fcb     $FF,$FF,$9F,$9F ; ':' 
            fcb     $FF,$9F,$9F,$FF             
            
