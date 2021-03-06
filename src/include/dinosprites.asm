;*******************************************************************************
;*                                                                             *
;*          Run Dino Run!                                                      *
;*          Game Sprites and Graphics                                          *
;*                                                                             *
;*            v 0.1.0                                                          *
;*            July 30, 2019                                                    *
;*                                                                             *
;*******************************************************************************

moon
            fcb     $FF,$FF,$F7,$FF,$FF
            fcb     $FF,$FF,$F8,$FF,$FF
            fcb     $FF,$FF,$FD,$7F,$FF
            fcb     $FF,$FF,$FD,$9F,$FF
            fcb     $FF,$FF,$FE,$EF,$FF
            fcb     $FF,$FF,$FE,$F7,$FF
            fcb     $FF,$FF,$FF,$7B,$FF
            fcb     $FF,$FF,$FF,$7B,$FF
            fcb     $FF,$FF,$FF,$7D,$FF
            fcb     $FF,$FF,$FF,$7D,$FF
            fcb     $FF,$FF,$FF,$7E,$FF
            fcb     $FF,$FF,$FF,$BE,$FF
            fcb     $FF,$FF,$FF,$7E,$FF
            fcb     $FF,$FF,$FF,$7E,$FF
            fcb     $FF,$FF,$FF,$7E,$FF
            fcb     $FF,$FF,$FF,$7F,$7F
            fcb     $FF,$FF,$FE,$FE,$FF
            fcb     $FF,$FF,$FE,$FE,$FF
            fcb     $FF,$FF,$FE,$FE,$FF
            fcb     $FF,$FF,$FD,$FE,$FF
            fcb     $FF,$FF,$FB,$FD,$FF
            fcb     $FF,$FF,$FB,$FD,$FF
            fcb     $FF,$FF,$F7,$FD,$FF
            fcb     $FF,$FF,$CF,$FB,$FF
            fcb     $FF,$FF,$BF,$F7,$FF
            fcb     $F7,$FC,$7F,$F7,$FF
            fcb     $F8,$43,$FF,$EF,$FF
            fcb     $FD,$BF,$FF,$9F,$FF
            fcb     $FE,$7F,$FF,$7F,$FF
            fcb     $FF,$9F,$F8,$FF,$FF
            fcb     $FF,$E0,$87,$FF,$FF
            fcb     $FF,$FF,$7F,$FF,$FF
            fcb     $00

scoreword
            fcb     $FF,$FF,$FF,$FF,$FF,$FF
            fcb     $C3,$E1,$C1,$81,$81,$FF
            fcb     $99,$CC,$9C,$9C,$9F,$9F
            fcb     $9F,$9F,$9C,$9C,$9F,$9F
            fcb     $C1,$9F,$9C,$98,$81,$FF
            fcb     $FC,$9F,$9C,$83,$9F,$9F
            fcb     $9C,$CC,$9C,$91,$9F,$9F
            fcb     $C1,$E1,$C1,$98,$81,$FF
            fcb     $00
            
pfcredits
            fcb     $F8,$1E,$39,$C9,$FF,$F8,$08,$1C,$3E,$1E,$38,$18,$09,$F9,$F8,$1F
            fcb     $F9,$CC,$99,$C9,$FF,$F9,$FE,$79,$9C,$CC,$99,$C9,$F9,$F9,$FE,$7F
            fcb     $F9,$C9,$C9,$C9,$FF,$F9,$FE,$79,$F9,$F9,$C9,$C9,$F9,$F9,$FE,$7F
            fcb     $F9,$C9,$C9,$C9,$FF,$F8,$1E,$7C,$19,$F9,$C9,$88,$19,$F9,$FE,$7F
            fcb     $F8,$18,$09,$C9,$FF,$F9,$FE,$7F,$C9,$F8,$08,$39,$F9,$F9,$FE,$7F
            fcb     $F9,$F9,$C9,$C9,$FF,$F9,$FE,$79,$CC,$C9,$C9,$99,$F9,$F9,$FE,$7F
            fcb     $F9,$F9,$CC,$18,$1F,$F9,$F8,$1C,$1E,$19,$C9,$C8,$08,$18,$18,$1F
            fcb     $00

andcredits
            fcb     $FE,$39,$C8,$3F
            fcb     $FC,$98,$C9,$9F
            fcb     $F9,$C8,$49,$CF
            fcb     $F9,$C8,$09,$CF
            fcb     $F8,$09,$09,$CF
            fcb     $F9,$C9,$89,$9F
            fcb     $F9,$C9,$C8,$3F
            fcb     $00
            
dinostandi
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$1F,$E0
            fcb     $00,$37,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3E,$00
            fcb     $00,$3F,$C0
            fcb     $80,$7C,$00
            fcb     $C1,$FC,$00
            fcb     $C3,$FF,$00
            fcb     $E7,$FD,$00
            fcb     $FF,$FC,$00
            fcb     $FF,$FC,$00
            fcb     $7F,$FC,$00
            fcb     $3F,$F8,$00
            fcb     $1F,$F0,$00
            fcb     $0F,$E0,$00
            fcb     $07,$60,$00
            fcb     $06,$20,$00
            fcb     $04,$20,$00
            fcb     $06,$30,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $AA

dinodeadji
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$1F,$E0
            fcb     $00,$31,$F0
            fcb     $00,$35,$F0
            fcb     $00,$31,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$C0
            fcb     $80,$7C,$00
            fcb     $C1,$FC,$00
            fcb     $C3,$FF,$00
            fcb     $E7,$FD,$00
            fcb     $FF,$FC,$00
            fcb     $FF,$FC,$00
            fcb     $7F,$FC,$00
            fcb     $3F,$F8,$00
            fcb     $1F,$F0,$00
            fcb     $0F,$E0,$00
            fcb     $07,$60,$00
            fcb     $06,$20,$00
            fcb     $04,$20,$00
            fcb     $06,$30,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $AA
            
dinodeadi
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$1F,$E0
            fcb     $00,$31,$F0
            fcb     $00,$35,$F0
            fcb     $00,$31,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$C0
            fcb     $80,$7C,$00
            fcb     $C1,$FC,$00
            fcb     $C3,$FF,$00
            fcb     $E7,$FD,$00
            fcb     $FF,$FC,$00
            fcb     $FF,$FC,$00
            fcb     $7F,$FC,$00
            fcb     $3F,$F8,$00
            fcb     $1F,$F0,$00
            fcb     $0F,$E0,$00
            fcb     $07,$60,$00
            fcb     $06,$20,$00
            fcb     $04,$20,$00
            fcb     $06,$30,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            fcb     $AA
            
dinorun1i
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$1F,$E0
            fcb     $00,$37,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3E,$00
            fcb     $00,$3F,$C0
            fcb     $80,$7C,$00
            fcb     $C1,$FC,$00
            fcb     $C3,$FF,$00
            fcb     $E7,$FD,$00
            fcb     $FF,$FC,$00
            fcb     $FF,$FC,$00
            fcb     $7F,$FC,$00
            fcb     $3F,$F8,$00
            fcb     $1F,$F0,$00
            fcb     $0F,$E0,$00
            fcb     $07,$30,$00
            fcb     $06,$00,$00
            fcb     $04,$00,$00
            fcb     $06,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            fcb     $AA
            
dinorun2i
            ;fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$1F,$E0
            fcb     $00,$37,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3F,$F0
            fcb     $00,$3E,$00
            fcb     $00,$3F,$C0
            fcb     $80,$7C,$00
            fcb     $C1,$FC,$00
            fcb     $C3,$FF,$00
            fcb     $E7,$FD,$00
            fcb     $FF,$FC,$00
            fcb     $FF,$FC,$00
            fcb     $7F,$FC,$00
            fcb     $3F,$F8,$00
            fcb     $1F,$F0,$00
            fcb     $0F,$E0,$00
            fcb     $06,$60,$00
            fcb     $03,$20,$00
            fcb     $00,$20,$00
            fcb     $00,$30,$00
            fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            fcb     $AA

dinoduck1clear
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$FE
            fcb     $80,$7F,$BF
            fcb     $C3,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$C0
            fcb     $7F,$FC,$FC
            fcb     $3F,$FC,$00
            fcb     $1F,$F6,$00
            fcb     $0F,$E0,$00
            fcb     $06,$60,$00
            fcb     $03,$20,$00
            fcb     $00,$20,$00
            fcb     $00,$30,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $AA
            
dinoduck1i
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$FE
            fcb     $80,$7F,$BF
            fcb     $C3,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$C0
            fcb     $7F,$FC,$FC
            fcb     $3F,$FC,$00
            fcb     $1F,$F6,$00
            fcb     $0F,$E0,$00
            fcb     $06,$60,$00
            fcb     $03,$20,$00
            fcb     $00,$30,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $AA

dinoduck2i

            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            ;fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$FE
            fcb     $80,$7F,$BF
            fcb     $C3,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$C0
            fcb     $7F,$FC,$FC
            fcb     $3F,$FC,$00
            fcb     $1F,$F3,$00
            fcb     $0F,$E0,$00
            fcb     $06,$30,$00
            fcb     $04,$00,$00
            fcb     $06,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $00,$00,$00
            fcb     $AA



obstacle01                          ; small boulder
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $F0,$0F,$FF
            fcb     $C7,$E7,$FF
            fcb     $9C,$F3,$FF
            fcb     $79,$F9,$FF
            fcb     $7B,$FC,$FF
            fcb     $7B,$EE,$FF
            fcb     $7F,$E6,$FF
            fcb     $9E,$7E,$FF
            fcb     $CF,$3D,$FF
            fcb     $F0,$03,$FF
            fcb     $FF,$FF,$FF
            fcb     $00

obstacle02                          ; short single cactus
            fcb     $FF,$FF,$FF 
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF 
            fcb     $E7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E6,$FF,$FF
            fcb     $64,$FF,$FF
            fcb     $24,$FF,$FF
            fcb     $24,$FF,$FF
            fcb     $24,$FF,$FF
            fcb     $20,$FF,$FF
            fcb     $01,$FF,$FF
            fcb     $87,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $00

obstacle03                          ; short double cactus
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF             
            fcb     $F7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E6,$FF,$FF
            fcb     $64,$FF,$FF
            fcb     $24,$EF,$FF
            fcb     $24,$E7,$FF
            fcb     $24,$A7,$FF
            fcb     $20,$A5,$FF
            fcb     $01,$A5,$FF
            fcb     $83,$A5,$FF
            fcb     $C7,$85,$FF
            fcb     $E7,$C1,$FF
            fcb     $E7,$E3,$FF
            fcb     $E7,$E7,$FF
            fcb     $E7,$E7,$FF
            fcb     $E7,$E7,$FF
            fcb     $00

obstacle04                          ; short double cactus2
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF 
            fcb     $FF,$EF,$FF
            fcb     $FF,$E7,$FF
            fcb     $FF,$E7,$FF
            fcb     $FF,$65,$FF
            fcb     $EF,$24,$FF
            fcb     $E7,$24,$FF
            fcb     $E7,$24,$FF
            fcb     $E5,$24,$FF
            fcb     $A5,$04,$FF
            fcb     $A5,$84,$FF
            fcb     $81,$C0,$FF
            fcb     $83,$E1,$FF
            fcb     $C3,$E3,$FF
            fcb     $C7,$E7,$FF
            fcb     $E7,$E7,$FF
            fcb     $E7,$E7,$FF
            fcb     $00


obstacle05                          ; short-wide cactus
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FE,$FF,$FF
            fcb     $DC,$7F,$FF
            fcb     $8E,$7F,$FF
            fcb     $8C,$77,$FF
            fcb     $9C,$63,$FF
            fcb     $8D,$6B,$FF
            fcb     $CC,$63,$FF
            fcb     $8C,$E7,$FF
            fcb     $94,$63,$FF
            fcb     $C0,$6B,$FF
            fcb     $E2,$63,$FF
            fcb     $FC,$43,$FF
            fcb     $FC,$97,$FF
            fcb     $FC,$0F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $00

obstacle06                          ; triple cactus
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $F7,$FF,$FF
            fcb     $E7,$FF,$FF
            fcb     $E6,$FF,$BF
            fcb     $64,$FF,$9F
            fcb     $24,$ED,$9F
            fcb     $24,$CC,$97
            fcb     $24,$CC,$93
            fcb     $20,$CC,$93
            fcb     $01,$CA,$13
            fcb     $83,$4A,$03
            fcb     $C7,$43,$07
            fcb     $E7,$03,$8F
            fcb     $E7,$07,$9F
            fcb     $E7,$8F,$9F
            fcb     $E7,$CF,$9F
            fcb     $E7,$CF,$9F
            fcb     $00

obstacle07                          ; triple boulder
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$C1,$FF
            fcb     $FF,$1C,$FF
            fcb     $FE,$7E,$7F
            fcb     $FE,$E7,$7F
            fcb     $FE,$EF,$7F
            fcb     $FE,$FF,$7F
            fcb     $F8,$1E,$7F
            fcb     $F3,$CC,$01
            fcb     $C7,$F1,$FC
            fcb     $9F,$E7,$BE
            fcb     $BD,$CE,$7E
            fcb     $39,$DE,$FE
            fcb     $79,$DF,$DE
            fcb     $3D,$CF,$DC
            fcb     $9F,$8F,$F9
            fcb     $C0,$30,$03
            fcb     $00
            
obstacle08                          ; double small boulder
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $F0,$0F,$FF
            fcb     $C7,$E6,$07
            fcb     $9C,$F0,$F1
            fcb     $79,$F9,$FC
            fcb     $7B,$FC,$CE
            fcb     $7B,$EE,$9E
            fcb     $7F,$E6,$FE
            fcb     $9E,$7E,$FE
            fcb     $CF,$3C,$FC
            fcb     $F0,$03,$01
            fcb     $00            
            
obstacle09                          ; stacked boulders
            fcb     $FF,$FF,$FF         
            fcb     $FC,$0F,$FF
            fcb     $F9,$E7,$FF
            fcb     $F3,$37,$FF
            fcb     $F6,$77,$FF
            fcb     $F2,$F7,$FF
            fcb     $F9,$CF,$FF
            fcb     $FC,$1F,$FF
            fcb     $F8,$0F,$FF
            fcb     $F3,$F7,$FF
            fcb     $CF,$FB,$FF
            fcb     $DE,$3D,$FF
            fcb     $9C,$7D,$FF
            fcb     $B9,$FD,$FF
            fcb     $3B,$FC,$FF
            fcb     $73,$FE,$FF
            fcb     $77,$FE,$FF
            fcb     $37,$9E,$FF
            fcb     $B7,$BC,$FF
            fcb     $B7,$3D,$FF
            fcb     $9F,$79,$FF
            fcb     $CF,$FB,$FF
            fcb     $E7,$F3,$FF
            fcb     $F8,$07,$FF
            fcb     $00
            
obstacle10                          ; tall wide cactus (shear top)
            fcb     $FF,$FF,$FF
            fcb     $FE,$FF,$FF
            fcb     $FC,$7F,$FF
            fcb     $FE,$7F,$FF
            fcb     $FC,$FF,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FD,$7F,$FF
            fcb     $DE,$FF,$FF
            fcb     $8C,$7F,$FF
            fcb     $AC,$77,$FF
            fcb     $8C,$6B,$FF
            fcb     $9C,$63,$FF
            fcb     $8D,$43,$FF
            fcb     $CC,$17,$FF
            fcb     $8C,$8F,$FF
            fcb     $94,$7F,$FF
            fcb     $C0,$7F,$FF
            fcb     $E2,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$FF,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $00            
                        
obstacle11                          ; tall wide cactus2 (shear top)
            fcb     $FF,$FF,$FF
            fcb     $FE,$FF,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$FF,$FF
            fcb     $FE,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FD,$7F,$FF
            fcb     $FE,$F7,$FF
            fcb     $FC,$63,$FF
            fcb     $DC,$63,$FF
            fcb     $8C,$6B,$FF
            fcb     $AC,$63,$FF
            fcb     $8D,$43,$FF
            fcb     $CC,$17,$FF
            fcb     $8C,$8F,$FF
            fcb     $94,$7F,$FF
            fcb     $C0,$7F,$FF
            fcb     $E2,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$FF,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $FC,$7F,$FF
            fcb     $00
            
obstacle12                          ; double tall wide cactus (shear top)
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FC,$FF,$FF
            fcb     $F9,$7F,$FF
            fcb     $F8,$7F,$FF
            fcb     $F8,$77,$FF
            fcb     $FA,$63,$FF
            fcb     $F8,$63,$FF
            fcb     $FC,$F7,$EF
            fcb     $F8,$63,$C7
            fcb     $B8,$63,$C5
            fcb     $18,$E3,$64
            fcb     $1A,$6A,$44
            fcb     $98,$02,$4D
            fcb     $18,$23,$44
            fcb     $20,$06,$40
            fcb     $09,$3E,$11
            fcb     $80,$7F,$03
            fcb     $F0,$7F,$87
            fcb     $F8,$7F,$CF
            fcb     $F9,$7F,$C7
            fcb     $FC,$7F,$C7
            fcb     $F8,$7F,$E7
            fcb     $F8,$7F,$C7
            fcb     $00

obstacle13                          ; small arrow - low
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $EF,$E3,$FF
            fcb     $C0,$07,$FF
            fcb     $EF,$E3,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $00 

obstacle14                          ; small arrow
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $EF,$E3,$FF
            fcb     $C0,$07,$FF
            fcb     $EF,$E3,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $00

obstacle15                          ; flying spear - low
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF           
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $9F,$FF,$AB
            fcb     $40,$00,$07
            fcb     $9F,$FF,$AB
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $00            
            
obstacle16                          ; flying spear
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF           
            fcb     $9F,$FF,$AB
            fcb     $40,$00,$07
            fcb     $9F,$FF,$AB
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $00
            
pterodactyl1
            fcb     $F9,$0F,$FF
            fcb     $F1,$87,$FF
            fcb     $E0,$83,$FF
            fcb     $C0,$81,$FF
            fcb     $80,$01,$FF
            fcb     $FE,$00,$FF
            fcb     $FF,$00,$03
            fcb     $FF,$80,$1F
            fcb     $FF,$C0,$07
            fcb     $FF,$E0,$3F
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            ;fcb     $FF,$FF,$FF
            ;fcb     $FF,$FF,$FF
            ;fcb     $FF,$FF,$FF
            fcb     $00

pterodactyl2
            fcb     $F9,$FF,$FF
            fcb     $F1,$FF,$FF
            fcb     $E0,$FF,$FF
            fcb     $C0,$FF,$FF
            fcb     $80,$01,$FF
            fcb     $FE,$00,$FF
            fcb     $FF,$00,$03
            fcb     $FF,$80,$1F
            fcb     $FF,$80,$07
            fcb     $FF,$80,$3F
            fcb     $FF,$87,$FF
            fcb     $FF,$8F,$FF
            fcb     $FF,$9F,$FF
;            fcb     $FF,$9F,$FF
;            fcb     $FF,$BF,$FF
            fcb     $FF,$FF,$FF            
            fcb     $00

coco6809                            ; CoCo (6809 Score)
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF
            fcb     $FF,$FF,$FF            
            fcb     $FF,$FF,$FF
            fcb     $E1,$55,$43
            fcb     $DF,$FF,$FD
            fcb     $D9,$9C,$CD
            fcb     $D7,$6B,$B5
            fcb     $D7,$6B,$B5
            fcb     $D7,$6B,$B5
            fcb     $D7,$6B,$B5
            fcb     $D9,$9C,$CD
            fcb     $DF,$FF,$FD
            fcb     $C1,$55,$41
            fcb     $9F,$FF,$F9
            fcb     $75,$55,$56
            fcb     $6A,$AA,$AA
            fcb     $7F,$FF,$FE
            fcb     $7F,$80,$FE
            fcb     $80,$FF,$81
            fcb     $00
            