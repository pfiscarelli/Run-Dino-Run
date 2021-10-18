;*******************************************************************************
;*                                                                             *
;*          Run Dino Run!                                                      *
;*                                                                             *
;*            written by                                                       *
;*            Paul Fiscarelli and Simon Jonassen                               *
;*                                                                             *
;*            v1.2.1                                                           *
;*            October 17, 2021                                                 *
;*                                                                             *
;*******************************************************************************


;*******************************************************************************
;*                                                                             *
;*          Hack close vector for autostart                                    *
;*                                                                             *
;*******************************************************************************
            org     $176
            jmp     Start		


;*******************************************************************************
;*                                                                             *
;*          Include text screen for loader                                     *
;*                                                                             *
;*******************************************************************************
            org     $400
            includebin ".\include\dinorun\screen.bin"

            
;*******************************************************************************
;*                                                                             *
;*          Reserve space for DP variables                                     *
;*                                                                             *
;*******************************************************************************
            org     VID_START+$2500         ; set start of DP variables
            opt     6809            
            opt     cd
            
;{
cactusani                                   ; initialize obstacle pointers
            fdb     obstacle01
            fdb     obstacle02
            fdb     obstacle03
            fdb     obstacle04
            fdb     obstacle05
            fdb     obstacle06
            fdb     obstacle07
            fdb     obstacle08
            fdb     obstacle09
            fdb     obstacle10
            fdb     obstacle11
            fdb     obstacle12
            fdb     obstacle13
            fdb     obstacle14
            fdb     obstacle15
            fdb     obstacle16            
            
vars        equ     *                       ; start of variable space

ButtonFlag  zmb     1                       ; Joy button state
InputFlag   zmb     1                       ; Input flag
JumpState   zmb     1                       ; Dino jump state
DuckState   zmb     1                       ; Dino duck state
ScrUnit     zmb     1                       ; Scoreboard - units value
ScrTen      zmb     1                       ; Scoreboard - tens value
ScrHund     zmb     1                       ; Scoreboard - hundreds value
ScrThou     zmb     1                       ; Scoreboard - thousandths value
ScrTenTh    zmb     1                       ; Scoreboard - ten-thousandths value
ScoreTemp   zmb     1                       ; Score temp value
TempByte    zmb     2                       ; Temp byte storage
MusicFlag   zmb     1                       ; Music on/off flag
CollFlag    zmb     1                       ; Collision detection flag
KeyFlag     zmb     1                       ; Keystroke in buffer flag
PteroFlag   zmb     1                       ; Ptero in sky flag
PteroFlap   zmb     1                       ; Ptero flap flag
PteroHPos   zmb     1                       ; Pterodactyl horizontal position
PteroVPos   zmb     1                       ; Pterodactyl vertical position
TotDist     zmb     2                       ; Total distance traveled
Timer       zmb     2                       ; Simple 2-byte timer (0-65535)
DinoYPos    zmb     2                       ; Dino Y-position on screen
GameLevel   zmb     1                       ; Current Game Level (0-7)
FirstGame   zmb     1                       ; First Game Flag
PauseState  zmb     1                       ; Game pause status
DemoMode    zmb     1                       ; Demo Mode flag
DinoFeet    zmb     2                       ; Offset for Dino's feet from top of sprite
DinoIsGod   zmb     1                       ; Dino is God
DinoBot     zmb     1                       ; Dino Bot Mode
cipher      zmb     2                       ; Cipher for Easter Eggs
curobst1    zmb     1                       ; Obstacle 1 tracker
curobst2    zmb     1                       ; Obstacle 2 tracker
curobst3    zmb     1                       ; Obstacle 3 tracker
curobst4    zmb     1                       ; Obstacle 4 tracker
cheatenable zmb     1                       ; Player activate cheat?

musicframe  fcb     MUSC_CYCLE
cyclegame   fcb     GAME_CYCLE
cyclescroll fcb     SCRL_CYCLE
cyclecactus fcb     CACT_CYCLE
cycleptero  fcb     PTER_CYCLE
cyclemount  fcb     MONT_CYCLE
cyclescore  fcb     SCOR_CYCLE
dinoframe   fcb     DINO_CYCLE
obstaclespd fcb     OBST_SPEED
obstaclechk fcb     OBST_CHCK
repeatnote  fcb     NOTE_REPEAT
obstclrows  fcb     OBST_HEIGHT
cactusdist  fcb     MINDIS_CACT
pterodist   fcb     MINDIS_PTER
obstcldist  fcb     MINDIS_OBST
groundcount fcb     GRND_CONT

newobheight fcb     OBST_HEIGHT
newmntspeed fcb     MONT_CYCLE

noterepeat  fcb     3
duckframe   fcb     2
scoredigits fcb     5
tuneselect  fcb     3

jumpheight  fcb     0,28,23,19,15,12,9,7,5,4,3,2,1,0,0,0,1,2,3,4,5,7,9,12,15,19,23,28
;}


;*******************************************************************************
;*                                                                             *
;*          Multi-voice Note Mixer (located in DP for speed)                   *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,d                                                      *
;*                                                                             *
;*******************************************************************************
;{
note        std     <saved+1
sum         ldd     #$0000 
freq        addd    #$0000 
            std     <sum+1
sum2        ldd     #$0000
freq2       addd    #$0000
            std     <sum2+1 
sum3        ldd     #$0000 
freq3       addd    #$0000 
            std     <sum3+1
            adda    <sum+1
            rora
            adda    <sum2+1
            rora
            sta     $ff20                   ; DAC mixedsa
            lda     $ff93
saved       ldd     #0000
            rti
;}


;*******************************************************************************
;*                                                                             *
;*          Tune Player                                                        *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          doSound
doSound
poll        lda     <MusicFlag
            beq     DoMusic
            rts
DoMusic     dec     <musicframe
            bne     poll
            lda     #MUSC_CYCLE
            sta     <musicframe
;{

            
;*******************************************************************************
;*                                                                             *
;*          Note Sequencer                                                     *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,d,x,u                                                *
;*                                                                             *
;*******************************************************************************
;{          play2
play2 

curnote     ldx     #dinotune1
            ldd     ,x++                    ; load 2 notes from pattern
            bpl     play                    ; go play if positive
            jsr     GetTune                 ; go get new tune
play        asla                            ; times 2 for note freq lookup
            aslb                            
            sta     <v1+2 
            stb     <v2+2
            lda     ,x+
            asla                            ; times 2 for note freq lookup
            sta     <v3+2

v1          ldu     freqtab                 ; get the right freq
            stu     <freq+1                 ; store it
v2          ldu     freqtab                 ; get the right freq2
            stu     <freq2+1                ; store it
v3          ldu     freqtab                 ; get the right freq3
            stu     <freq3+1                ; store it
            dec     repeatnote              ; check for note repeat
            beq     DonePlay                ; at zero? done playing
            rts
            
DonePlay    stx     <curnote+1              ; remember current note
            lda     #NOTE_REPEAT            ; get repeat pointer
            lda     noterepeat              ; get repeat count
            sta     <repeatnote             ; store it
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Equate Values (constants)                                          *
;*                                                                             *
;*******************************************************************************
;{
POLCAT      equ     $A000                   ; Keyboard polling ROM routine
JOYIN       equ     $A00A                   ; Joystick polling ROM routine

RGB_PALETTE equ     $E5FA                   ; Set RGB palette ROM routine

VID_START   equ     $0400                   ; Start of video memory
VID_END     equ     VID_START+$1AFF         ; End of video memory
SCORE_START equ     VID_START+$0242         ; Scoreboard location
HIGH_SCORE  equ     VID_START+$0125         ; High Score Location
DINO_START  equ     VID_START+$1300         ; Start position of Dino on graphics page
CACTUS_ROW  equ     VID_START+$1300         ; Start position of Cactus
PTERO_ROW   equ     VID_START+$1300         ; Start position of Pterodactyl
OBST_ROW    equ     VID_START+$1300         ; Bottom row of obstacle band
MOUNT_LOC   equ     VID_START+$0700         ; Start position of Mountains
MOON_POS    equ     VID_START+$0259         ; Moon position
GRND_POS    equ     VID_START+$15C0         ; Ground position

GAME_CYCLE  equ     2                       ; How many cycles per frame (main loop frames)
CACT_CYCLE  equ     100                     ; Initial cactus on screen frame
PTER_CYCLE  equ     50                      ; Initial pterodactyl on screen frame
SCRL_CYCLE  equ     2                       ; How often to we cycle obstacle scroll
SCOR_CYCLE  equ     3                       ; How often to update scoreboard
DINO_CYCLE  equ     3                       ; How often to cycle Dino frames
DUCK_FRAME  equ     3                       ; How many duck frames for Dino
MONT_CYCLE  equ     12                      ; Mountains scroll cycle
MUSC_CYCLE  equ     2                       ; Music cycle rate
OBST_CHCK   equ     0                       ; Obstacle check - obstacle levels
DINO_XOFST  equ     5                       ; Dino X-offset (horizontal)
OBST_SPEED  equ     4                       ; How many ROLs per iteration
NOTE_REPEAT equ     3                       ; repeat notes to save space
OBST_HEIGHT equ     30                      ; obstacle band height (bytes) for ROLs
JUMP_FRAMES equ     27                      ; 27-frames in jump animation
JUMP_OFFSET equ     -1152                   ; 36-rows x 32-bytes per row
TROL_OFFSET equ     $4E0                    ; Offset temp space for ROLs
SCRL_OFFSET equ     $4E7                    ; Offset bytes to scroll scratch space
DINO_TEMPOF equ     $0C80                   ; Offest temp space for com'ed Dino
OBST_TEMPOF equ     $0CA4                   ; Offest temp space for com'ed Obstacles
NEWOB_OFFST equ     $0500                   ; Offset temp space for new Obstacles
MINDIS_CACT equ     1                       ; Minimum spacing distance between Cactus
MINDIS_PTER equ     1                       ; Minimum spacing distance between Pterodactyl
MINDIS_OBST equ     1                       ; Minimum spacing distance between any two Obstacles
GRND_CONT   equ     6                       ; Counter for adding new ground
HASH_VALUE  equ     $FA58                   ; Easter Egg 1
DINO_GOD    equ     $7E82                   ; Easter Egg 2
DINO_BOT    equ     $1815                   ; Easter Egg 3
LEVEL_1     equ     200                     ; Set value to finish level 1
LEVEL_2     equ     400                     ; Set value to finish level 2
LEVEL_3     equ     800                     ; Set value to finish level 3
LEVEL_4     equ     1200                    ; Set value to finish level 4
LEVEL_5     equ     1500                    ; Set value to finish level 5
LEVEL_6     equ     1600                    ; Set value to finish level 6
LEVEL_7     equ     2000                    ; Set value to finish level 7
COCO_SCORE  equ     6809                    ; Set value to hit secret level
;}


;*******************************************************************************
;*                                                                             *
;*          Game Setup                                                         *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,d,dp,cc                                                *
;*                                                                             *
;*******************************************************************************
;{ 
            org     VID_START+$2600         ; start of excecutable code

Start       clr     $FF40                   ; stop drives from spinning
    
            jsr     RGB_PALETTE             ; RGB palette
            orcc    #$50

            lda     #$55                    ; warm restart at reset or exit
            sta     $71

            ldd     #start2
            std     $72

start2      nop 		
            lda     #vars/256               ; fix DP register for variable space
            tfr     a,dp                    ; store DP
           		
            setdp   $29                     ; set DP

            sta     $ffd7                   ; high-speed
            sta     $ffd9                   ; high-speed

            lda     #$d8
            sta     $ff90                   ; CoCo 1/2 mode, GIME FIRQ enabled
            lda     #32
            sta     $ff91                   ; 269.365 ns clock, MMU FFA0-FFA7
            sta     $ff93                   ; FIRQ enabled, keyboard FIRQ
            
            ldd     #460                    ; timer value (12bit) (8Khz)
            std     $ff94                   ; 1/7800 -> / 0.000000279 = 460
;}            
            
;*******************************************************************************
;*          Initiate DP at JMP vector                                          *
;*******************************************************************************       
;{
            lda	    #$0e                    ; DP JMP instruction
            ldb	    #note&$ff               ; address of player
            std	    >$fef4                  ; IRQ JUMP VECTOR 
;}

;*******************************************************************************
;           Enable  FIRQ                                                       *
;*******************************************************************************
            andcc   #$bf


;*******************************************************************************
;*                                                                             *
;*          Main Routine                                                       *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          Init
Init        nop                             ; no-operation for reset vector
            jsr     InitRandom              ; go handle RND initialize

Graphics    lda     #$F0                    ; Pmode 4 (G6R) - Color Set 1
            sta     $FF22
            sta     $FFC3
            sta     $FFC5

            sta     $FFC9                   ; set video start at $0400

ShowTitle            
            jsr     HandleTitle             ; go draw title screen
NewGame            
            jsr     StageGame               ; go stage game content
            jsr     StartGame               ; go initialize game
Main
            jsr     HandleTime              ; go handle time
            dec     cyclegame               ; cycle game counter
            bne     More                    ; not zero? go do more
            lda     #GAME_CYCLE             ; reset game counter
            sta     cyclegame               ; store game counter

            jsr     ScoreHandle             ; go handle score
            lda     DinoBot                 ; check bot mode
            beq     DoControls              ; not bot mode? go do controls
            jsr     DemoControls            ; use demo mode
            bra     MainCont                ; always go to main continue
DoControls                                  
            jsr     ChckButton              ; go check buttons
            jsr     ChckKeybd               ; go check keyboard
MainCont            
            jsr     doDino                  ; go animate Dino
            jsr     HandleCollision         ; go handle collisions
            jsr     OtherKeys               ; go check other keys (POLCAT)
            dec     cyclemount              ; cycle mountain counter
            bne     Main                    ; at zero? no - loop to Main
            lda     newmntspeed             ; get mountain speed
            sta     cyclemount              ; reset mountain counter
            jsr     doMonts                 ; go do mountains
More        
            
            jsr     doSound                 ; go handle sound
            jsr     doGround                ; go handle ground
            jsr     doObstacle              ; go handle obstacles
            
Done        bra     Main                    ; always loop Main
;}


;*******************************************************************************
;*                                                                             *
;*          Clear Graphics Memory                                              *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : d,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          ClearGraphics
ClearGraphics            
            ldd     #$FFFF
            ldx     #VID_START              ; beginning of video space
GraphicCLR  std     ,x++                    ; store 2-bytes
            cmpx    #VID_END                ; clear $2800-$2C80 for temp space
            blo     GraphicCLR              ; are we there yet? no - go for more
            
            ldd     #$0000                  ; clear temp space
            ldx     #VID_START+$1B00        ; offset from video space
GraphicCLR2 
            std     ,x++                    ; store 2-bytes
            cmpx    #VID_START+$24FF        ; clear through $28FF for temp space
            blo     GraphicCLR2             ; are we done? no - go do more

            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Get New Tune for synth                                             *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,d,x                                                    *
;*                                                                             *
;*******************************************************************************
;{          GetTune
GetTune
            dec     tuneselect              ; decrement tune counter        
            beq     playTune1               ; at zero? yes - go play first tune
            lda     tuneselect              ; load tune number
            cmpa    #02                     ; set to tune-2?
            beq     playTune2               ; yes? go play tune-2
playTune3   ldx     #dinotune3              ; default to tune-3
            stx     <curnote+1              ; store notes in our pointer (self-modifying)
            ldd     ,x++                    ; get beginning 2 notes from pattern - cont            
            rts
playTune2   ldx     #dinotune2              ; set index to tune-2
            stx     <curnote+1              ; store notes in our pointer (self-modifying)
            ldd     ,x++                    ; get beginning 2 notes from pattern - cont
            rts
playTune1   lda     #03                     ; reset tune counter
            sta     tuneselect              ; store it
            ldx     #dinotune1              ; set index to tune-1
            stx     <curnote+1              ; store notes in our pointer (self-modifying)
            ldd     ,x++                    ; get beginning 2 notes from pattern - cont
            rts
;}            


;*******************************************************************************
;*                                                                             *
;*          Draw Mountains                                                     *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,d,x,y,u                                                *
;*                                                                             *
;*******************************************************************************
;{          doMonts
doMonts
            ldx     #MOUNT_LOC              ; grab mountain column location
ddd         ldu     #pic+32                 ; load our bitmap pointer
            ldy     #$3b		            ; one less line (black definition line)
mloop       ldd     1,x                     ; do a full scan line
            std     ,x
            ldd     3,x
            std     2,x
            ldd     5,x
            std     4,x
            ldd     7,x
            std     6,x
            ldd     9,x
            std     8,x
            ldd     11,x
            std     10,x
            ldd     13,x
            std     12,x
            ldd     15,x
            std     14,x
            ldd     17,x
            std     16,x
            ldd     19,x
            std     18,x
            ldd     21,x
            std     20,x
            ldd     23,x
            std     22,x
            ldd     25,x
            std     24,x
            ldd     27,x
            std     26,x
            ldd     29,x
            std     28,x
            lda     31,x
            sta     30,x

            lda     ,u
            sta     31,x

            leau    64,u	
            leax    32,x
            leay    -1,y
            bne     mloop                   ; done? no - go do more

            lda     ddd+2
            inca
            anda    #63
            sta     ddd+2
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Draw Mountains                                                     *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x,y,u                                                  *
;*                                                                             *
;*******************************************************************************
;{          NewMonts
NewMonts    
            lda     #$3c                    ; load mountain height (scan lines)

picptr      ldx     #pic                    ; grab mountain column location
            ldy     #MOUNT_LOC              ; grab screen location to put bytes
next        ldu     ,x                      ; get mountain bytes
            stu     ,y                      ; do a whole scan line
            ldu     2,x
            stu     2,y
            ldu     4,x
            stu     4,y
            ldu     6,x
            stu     6,y
            ldu     8,x
            stu     8,y
            ldu     10,x
            stu     10,y
            ldu     12,x
            stu     12,y
            ldu     14,x
            stu     14,y
            ldu     16,x
            stu     16,y
            ldu     18,x
            stu     18,y
            ldu     20,x
            stu     20,y
            ldu     22,x
            stu     22,y
            ldu     24,x
            stu     24,y
            ldu     26,x
            stu     26,y
            ldu     28,x
            stu     28,y
            ldu     30,x
            stu     30,y
            leax    64,x
            leay    32,y
            deca                            ; decrement scan line count
            bne     next                    ; done? no - go do some more

stor        inc     picptr+2                ; increment our pointer (self-modifying)
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Run in demo mode                                                   *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          doDemo
doDemo
            jsr     StageGame
DemoMain
            jsr     HandleTime
            jsr     CheckInput
            lda     InputFlag
            beq     DemoCont
            clr     InputFlag
            clr     DemoMode
            jsr     InitVars
            jmp     NewGame
DemoCont            
            dec     cyclegame
            bne     DemoMore
            lda     #GAME_CYCLE
            sta     cyclegame
            jsr     ScoreHandle
            jsr     DemoControls
            jsr     doDino
            jsr     HandleCollision
            dec     cyclemount
            bne     DemoMain
            lda     newmntspeed
            sta     cyclemount
            jsr     doMonts
DemoMore
            jsr     doGround
            jsr     doObstacle
            
DemoDone    bra     DemoMain
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Demo Handler                                                       *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          DemoControls
DemoControls
            lda     JumpState
            bne     DoneDemoH
            
            lda     curobst1
            beq     ChckOB2
            jsr     DemoJump1
            lda     JumpState
            bne     DoneDemoH
ChckOB2
            lda     curobst2
            beq     ChckOB3
            jsr     DemoJump1
            lda     JumpState
            bne     DoneDemoH            
ChckOB3
            lda     curobst3
            beq     ChckOB4
            jsr     DemoJump1
            lda     JumpState
            bne     DoneDemoH
ChckOB4
            lda     curobst3
            beq     PteroDemo
            jsr     DemoJump1
            lda     JumpState
            bne     DoneDemoH
            bra     PteroDemo
            
DemoJump1
            cmpa    #$3F
            bhi     DoneDemoH
            cmpa    #$30
            blo     DoneDemoH
            lda     DinoBot
            bne     DoJump
            jsr     GetRandom               ; randomly forget to jump
            anda    #%00000111
            bne     DoJump
            clr     curobst2
DoJump
            lda     #JUMP_FRAMES            ; 15-frames in jump animation
            sta     JumpState 
            rts
            
PteroDemo    
            lda     PteroFlag
            beq     DoneDemoH
            lda     JumpState
            bne     DoneDemoH
JumpStart   
            lda     PteroVPos
            bne     DemoJump2
DemoDuck     
            lda     DuckState
            bne     DoneDemoH
            lda     PteroHPos
            cmpa    #$40
            bhi     DoneDemoH
            cmpa    #$30
            blo     DoneDemoH
            lda     #35
            sta     DuckState           
            bra     DoneDemoH
DemoJump2     
            lda     PteroHPos
            cmpa    #$40
            bhi     DoneDemoH
            cmpa    #$30
            blo     DoneDemoH
            lda     #JUMP_FRAMES            ; 15-frames in jump animation
            sta     JumpState
DoneDemoH
            lda     DuckState
            bne     ReallyDone
            lda     #4
            sta     duckframe
ReallyDone            
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Stage game                                                         *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          StageGame
StageGame            
            jsr     ClearGraphics           ; go clear graphic screen
            jsr     doMoon                  ; go draw moon
            jsr     ResetScore              ; go reset score
            lda     FirstGame               ; grab first game played flag
            beq     SkipHigh                ; first game? no high score to display
            jsr     ShowHigh                ; go handle high score
SkipHigh            
            jsr     NewMonts                ; go do new mountains
            jsr     NewGround               ; go draw new ground
            jsr     dinoBegEnd              ; go draw new Dino

            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Start new game                                                     *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          StartGame
StartGame
            jsr     GetRandom               ; go get a random value
            anda    #%00000011              ; value between 0-3
            inca                            ; increment it (now 1-4)
            sta     tuneselect              ; store it in tune select (random tune)
            jsr     GetTune                 ; go get new tune
            
            lda     HScrUnit                ; grab units-place of high score
            bne     SkipInternet            ; not zero? skip internet message
            
            ldx     #nointernet             ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$16D4        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text

SkipInternet
            jsr     WaitForInput            ; go wait for user input
            
            ldx     #blank                  ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$16C0        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; Go print text

            lda     #JUMP_FRAMES            ; get jump frames count
            sta     JumpState               ; store it in jump state
            lda     MusicFlag               ; get music enabled flag
            bne     ReturnMain              ; currently enabled? no - go return to main
            lda     $FF23                   ; re-enable sound
            ora     #%00001000
            sta     $FF23
ReturnMain
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Draw New Ground                                                    *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          NewGround
NewGround    
            ldx     #GRND_POS               ; set index of ground scan line

loopGround
            jsr     GetRandom               ; go get random value
            ora     #%00111100              ; create more regular pattern
            sta     32,x                    ; store it next scan line down
            coma                            ; invert it
            sta     ,x+                     ; store at current scan line, index to next byte column
            
            cmpx    #GRND_POS+DINO_XOFST    ; put some ground in temp space
            blo     ContGround              
            cmpx    #GRND_POS+DINO_XOFST+2
            bhi     ContGround
            sta     SCRL_OFFSET+56,x       
            sta     OBST_TEMPOF+64,x
            coma
            sta     SCRL_OFFSET+24,x
            sta     OBST_TEMPOF+32,x
ContGround            
            cmpx    #GRND_POS+32
            bne     loopGround
            
            sta     VID_START+$1AC0         ; put ground offscreen for rols
            sta     VID_START+$1AE1
            coma
            sta     VID_START+$1AE0
            sta     VID_START+$1AC1
            
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Draw Ground                                                        *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          doGround
doGround
            dec     groundcount             ; cycle ground byte counter
            bne     doneGround              ; ready to add ground? no - go bail
            lda     #GRND_CONT              ; reset ground cycles
            sta     groundcount             ; store it
            jsr     GetRandom               ; source random bits
            ora     #%00111100              ; create pattern
            sta     VID_START+$1AC0         ; place off screen
            sta     VID_START+$1AE1         ; place in temp space
            sta     VID_START+$1AC2         ; place off screen
            coma                            ; flip all bits
            sta     VID_START+$1AE0         ; place in temp space
            sta     VID_START+$1AC1         ; place off screen
            sta     VID_START+$1AE2         ; place in temp space
doneGround  
            rts
;}
            

;*******************************************************************************
;*                                                                             *
;*          Handle Obstacles                                                   *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          doObstacle
doObstacle  
            dec     obstcldist              ; check min distance between obstacles
            bne     GoScroll

            inc     obstcldist
            
            dec     cactusdist
            bne     TryPtero
            inc     cactusdist
            dec     cyclecactus
            bne     GoScroll
            jsr     GetRandom
            anda    #%00111111
            ora     #%00000001
            sta     cyclecactus
            lda     MINDIS_OBST
            sta     obstcldist
AddCactus   
            jsr     doCactus
            
            ldx     TotDist
            cmpx    #100
            blo     GoCycle
            lda     DemoMode
            bne     GoCycle
            lda     DinoBot
            beq     GoScroll
GoCycle            
            jsr     CycleObst
           
            bra     GoScroll
TryPtero    
            lda     GameLevel               ; Pteros only level-2 and above
            cmpa    #$02
            blo     GoScroll
            dec     pterodist
            bne     GoScroll
            inc     pterodist
            dec     cycleptero
            bne     GoScroll
            jsr     GetRandom
            anda    #%00111111
            ora     #%00000001
            sta     cycleptero
            lda     MINDIS_OBST
            sta     obstcldist
AddPtero    
            jsr     doPtero            
GoScroll    
            jsr     ScrollObst
            rts
;}            


;*******************************************************************************
;*                                                                             *
;*          Cycle Obstacles (demo mode)                                        *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          CycleObst
CycleObst    
            lda     curobst1
            bne     OBcheck2
            lda     #$FF
            sta     curobst1
            rts
OBcheck2
            lda     curobst2
            bne     OBcheck3
            lda     #$FF
            sta     curobst2
            rts
OBcheck3
            lda     curobst3
            bne     OBcheck4
            lda     #$FF
            sta     curobst3
            rts
OBcheck4
            lda     curobst4
            beq     Set4
            rts
Set4
            lda     #$FF
            sta     curobst4
            rts
;}
 
;*******************************************************************************
;*                                                                             *
;*          Draw Moon                                                          *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,u                                                  *
;*                                                                             *
;*******************************************************************************
;{          doMoon
doMoon
            ldx     #MOON_POS
            ldu     #moon
bigMoon     ldb     #05
loopMoon    lda     ,u+
            beq     CheckCheat
            sta     ,x+
            decb
            bne     loopMoon
            leax    27,x
            bra     bigMoon
CheckCheat
            lda     cheatenable
            beq     doneMoon
            ldx     #MOON_POS+2
            lda     #$FF
            sta     ,x
            ldx     #MOON_POS+800
            sta     ,x
doneMoon
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Draw Cactus (and other obstacles)                                  *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x                                                    *
;*                                                                             *
;*******************************************************************************
;{          doCactus
doCactus    
            ldx     TotDist
            cmpx    #COCO_SCORE
            blo     OtherObst
            cmpx    #COCO_SCORE+250
            bhi     OtherObst
            ldy     #coco6809
            bra     DrawCactus
OtherObst            
            jsr     GetRandom
            anda    #%00000011              ; get 1-of-4 in lower nibble
            sta     TempByte
            jsr     GetRandom
            anda    obstaclechk             ; grab value based on obstacle level
            ora     TempByte
            asla
            sta     >cactusnum+3
cactusnum   ldy     >cactusani

DrawCactus
            ldx     #CACTUS_ROW
            leax    NEWOB_OFFST,x
            ldb     #30
loopCactus  lda     ,y+
            beq     doneCactus
            sta     ,x+
            lda     ,y+
            sta     ,x+
            lda     ,y+
            sta     ,x
            abx
            bra     loopCactus
doneCactus  
            sta     VID_START+$1AE0
            lda     MINDIS_CACT
            sta     cactusdist
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Draw Pterodactyl                                                   *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,y                                                  *
;*                                                                             *
;*******************************************************************************
;{          doPtero
doPtero     
            lda     PteroFlag               ; grab pterodactyl flag
            bne     skipPtero               ; already on screen? yes - go skip
            lda     GameLevel               ; load game level
            cmpa    #04                     ; at level 4 yet?
            blo     SlowLevel               ; less than? go slow level
            lda     #08                     ; load ptero offset
            bra     StoreLow                ; always go low level
SlowLevel   jsr     GetRandom               ; determine high or low flying
            anda    #%00001000              ; offset may or may not be 8 scan lines
StoreLow    sta     PteroVPos               ; store the position
            ldb     #32                     ; 32-bytes per scan line
            mul                             ; multiply it
            ldx     #PTERO_ROW              ; get index of ptero row
            leax    NEWOB_OFFST,x           ; offset it by new obstacle offset
            leax    d,x                     ; offset by ptero row index
            ldy     #pterodactyl1           ; get index of ptero sprite
loopPtero   lda     ,y+                     ; get bytes
            beq     donePtero               ; at the end of sprite? yes - go to done
            sta     ,x+                     ; store byte on screen, move to next column
            lda     ,y+                     ; get another byte, index sprite pointer
            sta     ,x+                     ; store byte on screen, move to next column
            lda     ,y+                     ; get another byte, index sprite pointer
            sta     ,x                      ; store byte on screen
            leax    30,x                    ; index to next scan line (minus bytes for sprite width)
            bra     loopPtero               ; always loop for more
donePtero   
            coma                            ; reset Dino position counter
            sta     PteroHPos               ; store it
            sta     PteroFlag               ; reset ptero on-screen flag
            lda     MINDIS_PTER             ; get minimum distance for next sprite
            sta     pterodist               ; store it
skipPtero            
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Draw Dino (Start and Dead Position)                                *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,d,x,u                                                *
;*                                                                             *
;*******************************************************************************
;{          dinoBegEnd
dinoBegEnd
            lda     CollFlag                ; grab collision flag
            beq     BeginDino               ; not set? go do begin Dino
DeadDino                                    ; draw dead Dino
            ldx     #DINO_START+DINO_XOFST  ; load index of Dino start
            ldu     #dinodeadi              ; set pointer of dead Dino sprite
            lda     JumpState               ; grab current jump state
            beq     dinoLoop                ; not in jump frame? go to Dino draw loop
            leax    JUMP_OFFSET,x           ; offset scan line by jump position
            ldu     #jumpheight             ; get index current jump height
            lda     a,u                     ; grab byte from that index
            ldb     #32                     ; 32-bytes per scan line
            mul                             ; multiply it
            leax    d,x                     ; set new scan line offset
            dec     JumpState               ; decrement jump state (collision happened before)
            ldu     #dinodeadji             ; grab index of dead Dino jumping sprite
            bra     dinoLoop                ; go to Dino draw loop
BeginDino            
            ldx     #DINO_START+DINO_XOFST-$60 ; set index of starting Dino
            ldu     #dinostandi             ; set pointer of start Dino sprite
dinoLoop
            ldd     ,u++                    ; get two bytes, index sprite pointer
            cmpa    #$AA                    ; at end of sprite?
            beq     dinoDone                ; yes? go to done
            ora     OBST_TEMPOF+32,x        ; need to mesh MSB with obstacle sprite
            orb     OBST_TEMPOF+33,x        ; need to mesh LSB with obstacle sprite
            coma                            ; invert MSB
            comb                            ; invert LSB
            std     ,x                      ; put bytes on screen
            lda     ,u+                     ; get next column byte, index sprite pointer
            ora     OBST_TEMPOF+34,x        ; mesh with obstacle byte
            coma                            ; invert it
            sta     2,x                     ; store it two byte columns over
            leax    32,x                    ; index scan line
            bra     dinoLoop                ; always loop Dino draw
dinoDone            
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Do Dino Frames (animate)                                           *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,d,x,y,u                                              *
;*                                                                             *
;*******************************************************************************
;{          doDino
doDino
            ldx     #DINO_START+DINO_XOFST
            lda     DuckState
            beq     CheckJump
            dec     DuckState
            lda     duckframe
            cmpa    #04                     ; clear ani-frame above duck?
            bne     DinoDuck
            dec     duckframe
            ldu     #dinoduck1clear
            bra     DrawDino
DinoDuck    
            ldy     #DINO_START+$02C0
            sty     DinoFeet
            ldx     #DINO_START+DINO_XOFST+384
            dec     duckframe
            beq     DuckFrame1
DuckFrame2  
            ldu     #dinoduck2i
            bra     DrawDino
DuckFrame1  
            lda     #DUCK_FRAME
            sta     duckframe
            ldu     #dinoduck1i
            bra     DrawDino

CheckJump   
            lda     JumpState
            beq     RunDino
DinoJump    
            ldy     #DINO_START+$0200
            sty     DinoFeet
            leax    JUMP_OFFSET,x
            ldu     #jumpheight
            lda     a,u
            ldb     #32
            mul
            leax    d,x
            dec     JumpState
            ldu     #dinostandi
            bra     DrawDino
            
RunDino     ldy     #DINO_START+$0280
            sty     DinoFeet
            dec     dinoframe
            bne     run_dino1

run_dino2   ldu     #dinorun2i
            ldb     #DINO_CYCLE
            stb     dinoframe
            bra     DrawDino

run_dino1   ldu     #dinorun1i

DrawDino                                    ; Draw Dino on screen and check collisions
            stx     DinoYPos                ; save where we're at
LoopDino    
            ldd     ,u++
            cmpa    #$AA
            beq     doneDino
            std     TempByte
            std     DINO_TEMPOF,x
            ora     OBST_TEMPOF+32,x
            orb     OBST_TEMPOF+33,x
            coma
            comb
            std     ,x+
SkipColl1   
            lda     TempByte+1              ; check for collision
            beq     SkipColl2
            clra
            ora     OBST_TEMPOF+0,x
            beq     SkipColl2
            cmpx    DinoFeet
            bhi     SkipColl2
            inc     CollFlag
            lda     JumpState
            beq     NoJump
            inc     JumpState               ; put Dino back to where he was
NoJump
            bra     HandleCollision
SkipColl2   
            leax    1,x
            lda     ,u+
            sta     TempByte
            sta     DINO_TEMPOF,x
            ora     OBST_TEMPOF+32,x
            coma
            sta     ,x
SkipColl3   
            leax    30,x
            bra     LoopDino
doneDino    
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Collision Handler                                                  *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          HandleCollision
HandleCollision
            lda     DinoIsGod               ; check for Easter Egg
            bne     CollDone                ; enable? done with collision check
            lda     CollFlag                ; already have a collision?
            beq     CollDone                ; no? done with collision check
KillDino    
            jsr     doObstacle              ; go do obstacle (collision detect before obstacle moved)
            lda     JumpState               ; check jump state
            cmpa    #$13                    ; less than middle of jump?
            blo     SkipObst                ; yes - skip another obstacle scroll
            jsr     doObstacle              ; go do another obstacle scroll (collision detect before obstacle moved)
SkipObst            
            jsr     dinoBegEnd              ; go do Dino end (dead) position
            lda     DemoMode                ; check if we were in demo mode
            bne     doDemoOver              ; yes? go do demo over
            bra     doGameOver              ; always go to game over
CollDone    
            clr     CollFlag                ; clear collision flag
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Game Over                                                          *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          doGameOver
doGameOver
            lda     $FF23                   ; turn off music
            anda    #%11110111
            sta     $FF23
            
            ldx     #gameover               ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0F0B        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            
            jsr     HandleHigh
            
            ldx     #$5000                  ; hang tight to clear keys and buttons
DelayLoop   leax    -1,x                    ; decrement index    
            bne     DelayLoop               ; done? no - go loop more
            
            clr     Timer                   ; clear the timer
            
OverInput   jsr     CheckInput              ; go check for input
            jsr     HandleTime              ; go handle timer
            lda     Timer                   ; grab timer value
            cmpa    #$E1                    ; arbitrary value of time passed
            blo     OverInputs              ; not there yet? go check inputs
            bra     ContDemo                ; go continue demo
OverInputs            
            lda     InputFlag               ; grab input flag
            beq     OverInput               ; user input? no - go check again
            
            jsr     InitVars                ; go init vars
            jsr     ClearGraphics           ; go clear graphics
            jsr     ShowHigh                ; go handle high score
            lda     FirstGame               ; check first game played flag
            bne     DoneEnd                 ; was it? no - done with game over
            inc     FirstGame               ; increment first game playe flag
DoneEnd
            jmp     NewGame                 ; go do new game
;}

;*******************************************************************************
;*                                                                             *
;*          Demo Over                                                          *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          doDemoOver
doDemoOver
            clr     Timer                   ; reset timer for timeout
            clr     DemoMode                ; reset demo mode flag
            clr     CollFlag                ; clear collisions
MoreInput   
            jsr     CheckInput              ; go check for input
            jsr     HandleTime              ; go handle timer
            lda     Timer                   ; grab timer value
            cmpa    #$60                    ; arbitrary time passes
            blo     CheckInputs             ; still less? yes - go check inputs
            bra     ContDemo                ; always continue demo
CheckInputs            
            lda     InputFlag               ; grab input flag
            beq     MoreInput               ; no input? go get check again
            
            clr     InputFlag               ; clear input flag
            clr     DemoMode                ; clear demo mode flag
            jsr     InitVars                ; go init vars
            jmp     NewGame                 ; go do new game
ContDemo
            jmp     HandleTitle             ; go handle title screen

;}


;*******************************************************************************
;*                                                                             *
;*          Initialize Variables                                               *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,d,x                                                    *
;*                                                                             *
;*******************************************************************************
;{          InitVars
InitVars
            ldx     #dinotune1              ; set index to first tune
            stx     <curnote+1              ; store notes in pointer (self modifying)
            
            ldx     #pic+32                 ; load bitmap index
            stx     >ddd+1                  ; store in pointer
            
            ldx     #pic                    ; set index to mountain start
            stx     >picptr+1               ; store in pointer
            
            clr     CollFlag                ; clear collisions
            clr     PteroFlag               ; clear Pterodactyl flag
            clr     DuckState               ; clear ducking state
            clr     JumpState               ; clear jump state
            clr     GameLevel               ; reset game level
            clr     PauseState              ; reset pause state
            clr     TotDist                 ; reset MSB distance (score)
            clr     TotDist+1               ; reset LSB distance (score)
            clr     DinoIsGod               ; reset Easter Egg
            clr     curobst1                ; clear obstacle01 pointer (demo mode)
            clr     curobst2                ; clear obstacle01 pointer (demo mode)
            clr     curobst3                ; clear obstacle01 pointer (demo mode)
            clr     curobst4                ; clear obstacle01 pointer (demo mode)
            
            lda     #30                     ; newobheight
            ldb     #12                     ; newmntspeed
            std     newobheight             ; store them as defaults
            clr     obstaclechk             ; cleare obstacle check flag
            rts
;}            


;*******************************************************************************
;*                                                                             *
;*          Check joystick button                                              *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          ChckButton
ChckButton  
            lda     PauseState              ; grab pause state flag
            bne     ChckPause               ; currently paused? yes - go handle it
            lda     KeyFlag                 ; still processing keystroke?
            bne     ButtDone                ; yes? go handle done
            lda     JumpState               ; already in jump cycle?
            bne     ButtDone
            
            lda     #$FF                    ; mask keystrokes
            sta     $FF02                   ; set bits high
            lda     $FF00                   ; load PIA0 state
            anda    #%00000010              ; check left-joystick button-1
            beq     SetJump                 ; button pushed? go set jump
            lda     $FF00                   ; load PIA0 state
            anda    #%00000001              ; check right-joystick button-1
            bne     NextButt
SetJump            
            lda     #JUMP_FRAMES            ; 15-frames in jump animation
            sta     JumpState               ; store it
            bra     ClearDuck               ; go clear ducking status
JmpButtDone            
            rts
NextButt    
            lda     DuckState               ; currently in a duck state?
            bne     ButtDone                ; yes? go handle done
            lda     KeyFlag                 ; grab keyboard flag
            bne     ButtDone                ; something in buffer? go handle done
            
            lda     #$FF                    ; Mask keystrokes
            sta     $FF02                   ; push outputs
            lda     $FF00                   ; grab inputs
            anda    #%00001000              ; check left-joystick button-2
            beq     SetDuck                 ; button pushed? go set it
            lda     $FF00                   ; load PIA0 state
            anda    #%00000100              ; check right-joystick button-2
            bne     ClearDuck               ; button pushed? go clear animation frames
SetDuck            
            lda     #01                     ; set duck state flag
            sta     DuckState               ; setup Dino ducking
            bra     ButtDone                ; always go handle done
ClearDuck           
            lda     #04                     ; need to clear ani-frame above duck
            sta     duckframe               ; store duck frame value
            bra     ButtDone                ; always go handle done
ChckPause
            clr     ButtonFlag              ; clear any buttons
            lda     #$FF                    ; mask keystrokes
            sta     $FF02                   ; push outputs
            lda     $FF00                   ; load PIA0 state
            anda    #%00000010              ; check left-joystick button-1
            beq     GotButt1                ; button pushed? yes - go handle button state
            lda     $FF00                   ; load PIA0 state
            anda    #%00000001              ; check right-joystick button-1
            bne     CheckButt2              ; button pushed? no - go check next button
GotButt1            
            inc     ButtonFlag              ; set button flag
            clr     DuckState               ; clear duck state
            bra     ClearDuck               ; always go clear duck state
CheckButt2  
            lda     #$FF                    ; mask keystrokes
            sta     $FF02                   ; push outputs
            lda     $FF00                   ; load PIA0 state
            anda    #%00001000              ; check left-joystick button-1
            beq     GotButt2                ; button pushed? yes - go handle button state
            lda     $FF00                   ; load PIA0 state
            anda    #%00000100              ; check right-joystick button-2
            bne     ButtDone                ; button pushed? no - go to done
GotButt2            
            inc     ButtonFlag              ; set button flag
ButtDone    
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Check Keyboard (raw matrix switches)                               *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          ChckKeybd
ChckKeybd   
            clr     KeyFlag                 ; clear any keystrokes 
CheckSpace
            lda     #$7F                    ; first check <space> with joy buttons
            sta     $FF02                   ; push outputs
            lda     $FF00                   ; grab inputs
            anda    #%00001000              ; check bit
            coma                            ; invert it
            sta     KeyFlag                 ; store keystroke in key flag
            beq     CheckEnter              ; nothing stored? go check <enter> key
            lda     #$FF                    ; mask off keystrokes (just joy buttons)
            sta     $FF02                   ; push outputs
            lda     $FF00                   ; grab inputs
            anda    #%00001000              ; check bit
            anda    KeyFlag                 ; check against key flag
            beq     CheckEnter              ; nothing? go check <enter> key
            
            lda     JumpState               ; grab jump state
            bne     CheckEnter              ; current jump? yes - go check <enter> key
            lda     #JUMP_FRAMES            ; grab jump frame count
            sta     JumpState               ; set it
            clr     DuckState               ; clear duck state
            clr     <cipher                 ; jump clears cipher MSB
            clr     <cipher+1               ; jump clears cipher LSB
            clr     KeyFlag                 ; clear keyboard flag
            inc     KeyFlag                 ; set keyboard flag to 1
            bra     DoneKeybd               ; always done with keyboard check
ClearDuck2            
            lda     #04                     ; need to clear ani-frame above duck
            sta     duckframe               ; store it
            rts
CheckEnter
            clr     KeyFlag                 ; clear keyboard flag
            lda     DuckState               ; get duck state
            bne     DoneKeybd               ; in duck state? yes - go to done
            lda     JumpState               ; get jump state
            bne     DoneKeybd               ; in jump state? yes - go to done
            lda     #$FE                    ; set mask (<enter> key column-0)
            sta     $FF02                   ; push outputs
            lda     $FF00                   ; grab inputs
            anda    #%01000000              ; check <enter> key row-6
            bne     ClearDuck2              ; not pressed? go clear duck state
            
            lda     #01                     ; set duck flag
            sta     DuckState               ; setup Dino ducking
            inc     KeyFlag                 ; set keyboard flag
DoneKeybd   
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Pause Game (other)                                                 *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          otherPause
otherPause
            lda     $FF23                   ; turn off audio
            anda    #%11110111
            sta     $FF23
            
            inc     PauseState              ; set pause state flag
            
            com     CipherTXT               ; set cipher mode
            
            ldx     #othertxt1              ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0F02        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            
            ldx     #othertxt2              ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$1083        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            
            com     CipherTXT               ; reset cipher mode
            
            jsr     WaitForInput            ; go check for input
            clr     PauseState              ; clear pause state
            
            ldx     #blank                  ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0F00        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            
            ldx     #VID_START+$1080        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; Go print text
            
            lda     MusicFlag               ; was music playing?
            bne     DoneOtherP              ; no? go to done
            
            lda     $FF23                   ; re-enable audio
            ora     #%00001000
            sta     $FF23
DoneOtherP            
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Other Keys (POLCAT with debounce)                                  *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x                                                    *
;*                                                                             *
;*******************************************************************************
;{          OtherKeys
OtherKeys
            lda     KeyFlag
            sta     TempByte
            
            clr     KeyFlag
            jsr     [POLCAT]                ; grab another keystroke
            beq     DoneOther               ; nothing in buffer - let's bail
            clr     DinoBot
            sta     KeyFlag                 ; set keystroke status
            cmpa    #$20                    ; <space> press?
            beq     CheckMkey
            
            ldb     cipher                  ; hmmmmmm
            rolb
            eorb    cipher
            eora    cipher+1
            std     cipher
            ldx     cipher
            cmpx    #HASH_VALUE
            beq     otherPause
            cmpx    #DINO_GOD
            bne     NextKey
            com     DinoIsGod
            inc     cheatenable
            bra     ShowCheat
NextKey     
            cmpx    #DINO_BOT
            bne     CheckKeys
            inc     cheatenable
            com     DinoBot
ShowCheat
            ldx     #MOON_POS+2
            lda     #$FF
            sta     ,x
            ldx     #MOON_POS+800
            sta     ,x
FlashScreen
            lda     #$F8
            sta     $FF22
            ldx     #$AFF
FlashLoop   
            leax    -1,x
            bne     FlashLoop
            lda     #$F0
            sta     $FF22
CheckKeys            
            lda     KeyFlag
CheckMkey
            cmpa    #77                     ; 'M' keystroke
            bne     CheckPkey
            com     MusicFlag
            lda     $FF23
            eora    #%00001000
            sta     $FF23
            rts
CheckPkey            
            cmpa    #80                     ; 'P' keystroke
            beq     doPause
CheckRArr   
            cmpa    #09                     ; 'Right-Arrow' keystroke
            bne     DoneOther
            jsr     GetTune
            rts
DoneOther            
            lda     TempByte
            sta     KeyFlag
            
            rts
;}

            
;*******************************************************************************
;*                                                                             *
;*          Pause Game                                                         *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          doPause
doPause
            lda     $FF23
            anda    #%11110111
            sta     $FF23
            
            inc     PauseState
            
            ldx     #gamepaused             ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0F0A        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            
            jsr     WaitForInput
            clr     PauseState
            
            ldx     #blank                  ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0F00        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            
            lda     MusicFlag
            bne     DonePause
            
            lda     $FF23
            ora     #%00001000
            sta     $FF23
DonePause            
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Time Handler                                                       *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : x                                                        *
;*                                                                             *
;*******************************************************************************
;{          HandleTime
HandleTime
            ldx     Timer
            leax    1,x
            stx     Timer
            rts
;}            


;*******************************************************************************
;*                                                                             *
;*          Check Input (Joystick or Keyboard)                                 *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          CheckInput
CheckInput
            clr     InputFlag
            clr     KeyFlag
            inc     PauseState
            jsr     ChckButton
            clr     PauseState
            lda     ButtonFlag
            bne     SetInput
            jsr     [POLCAT]
            sta     KeyFlag
            beq     DoneInput
SetInput
            inc     InputFlag
            clr     ButtonFlag
            clr     DuckState
DoneInput            
            rts
;}
            

;*******************************************************************************
;*                                                                             *
;*          Wait For Input                                                     *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          WaitForInput
WaitForInput
            lda     PauseState
            bne     GetInput
            inc     PauseState
GetInput            
            jsr     HandleTime
            jsr     GetEntropy
            jsr     CheckInput
            lda     InputFlag
            beq     WaitForInput
DoneWait    
            lda     #04                     ; need to clear ani-frame above duck
            sta     duckframe
            clr     ButtonFlag
            clr     PauseState
            clr     InputFlag
            rts
;}

           
;*******************************************************************************
;*                                                                             *
;*          Score Handler - using a decade counter method                      *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x                                                    *
;*                                                                             *
;*******************************************************************************
;{          ScoreHandle
ScoreHandle
            dec     cyclescore              ; check if we're ready
            bne     ScoreChk
            lda     #SCOR_CYCLE
            sta     cyclescore
            ldb     #1
            ldx     TotDist
            abx
            stx     TotDist
CountScore            
            inc     ScrUnit                 ; handle units place
            ldb     ScrUnit
            stb     ScoreTemp
            lda     #$0A
            bsr     ScoreChange
            ldb     ScrUnit
            cmpb    #$0A
            bne     ScoreChk
            clr     ScrUnit

            inc     ScrTen                  ; handle tens place
            ldb     ScrTen
            stb     ScoreTemp
            lda     #$09
            bsr     ScoreChange
            ldb     ScrTen
            cmpb    #$0A
            bne     ScoreChk
            clr     ScrTen

            inc     ScrHund                 ; handle hundreds place
            ldb     ScrHund
            stb     ScoreTemp
            lda     #$08
            bsr     ScoreChange
            ldb     ScrHund
            cmpb    #$0A
            bne     ScoreChk
            clr     ScrHund

            inc     ScrThou                 ; handle thousandths place
            ldb     ScrThou
            stb     ScoreTemp
            lda     #$07
            bsr     ScoreChange
            ldb     ScrThou
            cmpb    #$0A
            bne     ScoreChk
            clr     ScrThou

            inc     ScrTenTh                ; handle ten-thousandths place
            ldb     ScrTenTh
            stb     ScoreTemp
            lda     #$06
            bsr     ScoreChange
            ldb     ScrTenTh
            cmpb    #$0A
            bne     ScoreChk
            clr     ScrTenTh
ScoreChk                                    ; done with scoreboard update
            bsr     HandleLevel
            rts                     
;}

;*******************************************************************************
;*                                                                             *
;*          Score Change - update scoreboard                                   *
;*           Input  : a (digit to update, offset from SCORE_START)             *
;*           Output : none                                                     *
;*           Used   : a,b,d,x,u                                                *
;*                                                                             *
;*******************************************************************************
;{          ScoreChange
ScoreChange 
            ldu     #SCORE_START            ; get start of scoreboard
            leau    a,u                     ; offset scoreboard position
            ldb     ScoreTemp               ; get temp score value
            cmpb    #$0A                    ; are we at '10'?
            bne     ScoreCont               ; go do the digit
            clrb                            ; reset to zero
ScoreCont   
            lda     #8                      ; 8-bytes per char
            mul                             ; font x8-bytes
            ldx     #numbers                ; get numbers font location
            leax    d,x                     ; store offset location
            lda     #8
MoreFont    
            ldb     ,x+                     ; get font byte, index font pointer
            stb     ,u                      ; store on screen
            leau    32,u                    ; cycle index - next scan line
            deca                            ; decrement char counter
            bne     MoreFont                ; done with char? no - go do more
            rts
;}



;*******************************************************************************
;*                                                                             *
;*          Reset Score                                                        *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,u                                                  *
;*                                                                             *
;*******************************************************************************
;{          ResetScore
ResetScore     
            clr     ScrUnit
            clr     ScrTen
            clr     ScrHund
            clr     ScrThou
            clr     ScrTenTh
            ldx     #SCORE_START
            ldu     #scoreword
bigScore    ldb     #06
loopScore   lda     ,u+
            sta     ,x+
            decb
            bne     loopScore
            leax    26,x
            cmpx    #SCORE_START+$100
            blt     bigScore
            clr     ScoreTemp
ClearScore  
            lda     #$05
            adda    scoredigits
            bsr     ScoreChange
            dec     scoredigits
            bne     ClearScore
            lda     #$05
            sta     scoredigits
doneScore            
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Level Handler                                                      *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,d,x                                                  *
;*                                                                             *
;*******************************************************************************
;{          HandleLevel
HandleLevel
            ldx     TotDist                 ; get total distance (score)

            lda     GameLevel               ; get current game level
            cmpa    #07                     ; already at max?
            beq     doneScore               ; yes? go to done
            cmpa    #06                     ; at level-6?
            beq     Check7                  ; yes? go check for level 7
            cmpa    #05                     ; at level-5?
            beq     Check6                  ; yes? go check for level 6
            cmpa    #04                     ; at level-4?
            beq     Check5                  ; yes? go check for level 5
            cmpa    #03                     ; at level-3?
            beq     Check4                  ; yes? go check for level 4
            cmpa    #02                     ; at level-2?
            beq     Check3                  ; yes? go check for level 3
            cmpa    #01                     ; at level-1?
            beq     Check2                  ; yes? go check for level 2
                                            ; level-0 default check
Check1                                      ; check level-1 done
            cmpx    #LEVEL_1                ; level-2 yet?
            blo     DoneLevel               ; still less? go to done
            inc     GameLevel               ; increment to next level
Handle1
            lda     #30                     ; newobheight
            ldb     #11                     ; newmntspeed
            std     newobheight             ; update both values    
Check2                                      ; check level-2 done
            cmpx    #LEVEL_2                ; level-3 yet?
            blo     DoneLevel               ; still less? go to done
            inc     GameLevel               ; increment to next level
Handle2
            lda     #28                     ; newobheight
            ldb     #10                     ; newmntspeed
            std     newobheight             ; update both values
            lda     #4                      ; new obstacle level
            sta     obstaclechk             ; update it
            rts
Check3                                      ; check level-3 done
            cmpx    #LEVEL_3                ; level-4 yet?
            blo     DoneLevel               ; still less? go to done
            inc     GameLevel               ; increment to next level
Handle3
            lda     #26                     ; newobheight
            ldb     #9                      ; newmntspeed
            std     newobheight             ; update both values
            lda     #8                      ; new obstacle level
            sta     obstaclechk             ; update it
            rts
Check4                                      ; check level-4 done
            cmpx    #LEVEL_4                ; level-5 yet?
            blo     DoneLevel               ; still less? go to done
            inc     GameLevel               ; increment to next level
Handle4 
            lda     #24                     ; newobheight
            ldb     #8                      ; newmntspeed
            std     newobheight             ; update both values
            rts
Check5                                      ; check level-5 done
            cmpx    #LEVEL_5                ; level-6 yet?
            blo     DoneLevel               ; still less? go to done
            inc     GameLevel               ; increment to next level
Handle5
            lda     #24                     ; newobheight
            ldb     #7                      ; newmntspeed
            std     newobheight             ; update both values
            lda     #4                      ; new obstacle level
            sta     obstaclechk             ; update it
            rts
Check6                                      ; check level-6 done
            cmpx    #LEVEL_6                ; level-7 yet?    
            blo     DoneLevel               ; still less? go to done
            inc     GameLevel               ; increment to next level
Handle6
            lda     #20                     ; newobheight
            ldb     #6                      ; newmntspeed
            std     newobheight             ; update both values
            rts             
Check7                                      ; check level-7 done
            cmpx    #LEVEL_7                ; max level yet?
            blo     DoneLevel               ; still less? go to done
            inc     GameLevel               ; increment to next level
Handle7
            lda     #16                     ; newobheight
            ldb     #4                      ; newmntspeed
            std     newobheight             ; update both values
            lda     #12                     ; new obstacle level
            sta     obstaclechk             ; update it
DoneLevel
            rts           
;}


;*******************************************************************************
;*                                                                             *
;*          Handle High Score                                                  *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          HandleHigh
HandleHigh
            lda     ScrTenTh
            suba    HScrTenTh
            blo     DoneHScore
            bne     NewHigh
            
            lda     ScrThou
            suba    HScrThou
            blo     DoneHScore
            bne     NewHigh
            
            lda     ScrHund
            suba    HScrHund
            blo     DoneHScore
            bne     NewHigh
            
            lda     ScrTen
            suba    HScrTen
            blo     DoneHScore
            bne     NewHigh
            
            lda     ScrUnit
            suba    HScrUnit
            blo     DoneHScore
NewHigh     
            lda     ScrTenTh
            sta     HScrTenTh
            lda     ScrThou
            sta     HScrThou
            lda     ScrHund
            sta     HScrHund
            lda     ScrTen
            sta     HScrTen
            lda     ScrUnit
            sta     HScrUnit
            jsr     ShowHigh
DoneHScore
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Show High Score                                                    *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x                                                    *
;*                                                                             *
;*******************************************************************************
;{          HighScore
ShowHigh
            ldx     #highscore              ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #HIGH_SCORE             ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
   
            lda     #03                     ; handle ten-thousandths digit
            ldb     HScrTenTh               ; get digit value
            jsr     HScoreChange            ; go handle digit update
            
            lda     #04                     ; handle thousandths digit
            ldb     HScrThou                ; get digit value
            jsr     HScoreChange            ; go handle digit update
            
            lda     #05                     ; handle hundreths digit
            ldb     HScrHund                ; get digit value
            jsr     HScoreChange            ; go handle digit update
            
            lda     #06                     ; handle tens digit
            ldb     HScrTen                 ; get digit value
            jsr     HScoreChange            ; go handle digit update
            
            lda     #07                     ; handle units digit
            ldb     HScrUnit                ; get digit value
            jsr     HScoreChange            ; go handle digit update
doneHigh             
            rts
            
;*******************************************************************************
;*                                                                             *
;*          High Score Change - update high scoreboard                         *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,u                                                  *
;*                                                                             *
;*******************************************************************************
;{          HScoreChange
HScoreChange 
            ldu     #HIGH_SCORE             ; get start of scoreboard
            leau    a,u                     ; offset scoreboard position
HScoreCont   
            lda     #8                      ; 8-bytes per char
            mul                             ; font x8-bytes
            ldx     #numbers                ; get numbers font location
            leax    d,x                     ; store offset location
            lda     #8                      ; reset 8-bytes per char
HMoreFont    
            ldb     ,x+                     ; get font byte, index font pointer
            stb     ,u                      ; store on screen
            leau    32,u                    ; cycle index - next scan line
            deca                            ; decrement char counter
            bne     HMoreFont               ; done with char? no - go do more
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Handle Title Page                                                  *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          HandleTitle
HandleTitle
            jsr     TitlePage

            clr     DemoMode            ; make sure demo is clear
            clr     Timer               ; reset timer for timeout
            inc     DemoMode            ; get ready for demo mode
            jsr     InitVars
            
CycleInput  
            jsr     CheckInput
            jsr     HandleTime
            lda     Timer
            cmpa    #$36
            blo     ChckInput
            jsr     HandleInstr
            
            jmp     doDemo
ChckInput            
            lda     InputFlag
            beq     CycleInput
            
            clr     DemoMode
            
            jsr     InitVars
            jmp     NewGame

            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Handle Instruction Page                                            *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          HandleInstr
HandleInstr
            jsr     InstructPage
            clr     Timer
CycleInput2 
            jsr     CheckInput
            jsr     HandleTime
            lda     Timer
            cmpa    #$36
            blo     ChckInput2
            bra     DoneInstr
ChckInput2            
            lda     InputFlag
            beq     CycleInput2
            clr     DemoMode
            
            jsr     InitVars
            jmp     NewGame
DoneInstr
            rts
;}

 
;*******************************************************************************
;*                                                                             *
;*          Title Page                                                         *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : b,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          Title Page
TitlePage   
            jsr     ClearGraphics           ; clear screen first
            ldb     #4			            ; GFX fade speed (frames)
            stb     wvs+1                   ; set plot speed (GFX)
            jsr     TitleGraphic            ; do title graphic
            
            ldb     #45			            ; text plot speed (frames)
            stb     wvs+1                   ; set plot speed (text)
            jsr     wvs                     ; go wait vsyncs

            ldx     #titletext              ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0A0A        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            jsr     wvs                     ; go wait vsyncs

            ldx     #title1                 ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0C0F        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            jsr     wvs                     ; go wait vsyncs
            
            ldx     pfcredits
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$0E08        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     pfWord                  ; go print text
            jsr     wvs                     ; go wait vsyncs
            
            ldx     #title3                 ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$1106        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            jsr     wvs                     ; go wait vsyncs
            
            ldx     andcredits
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$124E        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     andWord                 ; go print text
            jsr     wvs                     ; go wait vsyncs
            
            ldx     #title5                 ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$1347        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
            jsr     wvs                     ; go wait vsyncs
            
            ldx     #title6                 ; get title text memory index
            stx     StringLoc               ; store in string location var
            ldx     #VID_START+$1509        ; location to print on screen
            stx     PrintAtLoc              ; store location to print at
            jsr     PrintAtGr               ; go print text
DoneTitle
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Instructions Page                                                  *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : b,x                                                      *
;*                                                                             *
;*******************************************************************************
;{          InstructPage
InstructPage   
            ldb     #08                 ; Text plot speed (frames)
            stb     wvs+1               ; Store v-sync count
            jsr     wvs                 ; Go print text

            ldx     #blank              ; get blank text
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$0A00    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text

            ldx     #blank              ; get blank text
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$0C00    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            
            ldx     #blank              ; get blank text
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$0E00    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            
            ldx     #blank              ; get blank text
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1100    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            
            ldx     #blank              ; get blank text
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1240    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            
            ldx     #blank              ; get blank text
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1340    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            
            ldx     #blank              ; get blank text
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1500    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text

            ldx     #instruct1          ; get instruction text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$0B0A    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs

            ldx     #headerrow          ; get header text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$0D01    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs            
            
            ldx     #instruct2          ; get instructions text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$0F02    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs

            ldx     #instruct3          ; get instructions text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1002    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs

            ldx     #instruct4          ; get instructions text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1102    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs

            ldx     #instruct5          ; get instructions text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1202    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs

            ldx     #instruct6          ; get instructions text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1302    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs
            
            ldx     #headerrow          ; get header text memory index
            stx     StringLoc           ; store in string location var
            ldx     #VID_START+$1501    ; location to print on screen
            stx     PrintAtLoc          ; store location to print at
            jsr     PrintAtGr           ; Go print text
            jsr     wvs            

DoneInstuct
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Title Graphic                                                      *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,u                                                  *
;*                                                                             *
;*******************************************************************************
;{          TitleGraphic
TitleGraphic
            bsr     wvs                     ; go check for v-sync
            ldx     #dinopic                ; load index of Dino title graphic
            ldu     #VID_START+$0100        ; set index of location on title page
TitleLoop   ldd     ,x++                    ; get two bytes, increment graphic pointer
            ora     xx                      ; graphic effect MSB
            orb     xx                      ; graphic effect LSB

            std     ,u++                    ; put two bytes on title page, increment index
            cmpx    #enddinopic             ; at the end of title graphic?
            blo     TitleLoop               ; still less? go do title loop
            asl     xx                      ; shift our gfx effect byte
            bcs     TitleGraphic            ; carry set (still cycle gfx effect)? yes - go do more
            com     xx                      ; reset gfx effect byte
            ldb     #4                      ; set v-sync counter
            stb     wvs+1                   ; store it
            rts

xx          fcb     %11111111               ; byte for gfx effect
;}


;*******************************************************************************
;                                                                              *
;*          Wait for some V-Syncs                                              *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b                                                      *
;*                                                                             *
;*******************************************************************************
;{          wvs
wvs         
            ldb     #4                      ; set v-sync counter
vs          lda     $ff03                   ; check v-sync status
            bpl     vs                      ; there yet? no - go wait some more
            lda     $ff02                   ; hit our v-sync
            decb                            ; decrement counter
            bne     vs                      ; at zero yet? no - go do another
            rts
;}

;*******************************************************************************
;*                                                                             *
;*          Print Routine - Graphics Screen                                    *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,y,u                                                *
;*                                                                             *
;*******************************************************************************
;{          PrintAtGr
PrintAtGr   
            ldx     PrintAtLoc              ; grab screen location from memory variable
            ldy     StringLoc               ; grab string location from memory variable
PrintLoop            
            lda     ,y+                     ; grab first byte of string
            beq     DonePrint               ; done with string, go to DonePrint
;            inc     lettercount            ; is this still needed?
DoChar                  
            anda    #%00111111              ; subtract 64 from ASCII value
            ldb     CipherTXT               ; check for cipher
            beq     DoText                  ; cipher? no - go do text
            suba    #$0D                    ; modify text
DoText              
            ldb     #08                     ; 8-bytes per character
            mul                             ; get our character index offset
            ldu     #letters                ; memory index of font
            leau    d,u                     ; index font location
            ldb     #08                     ; 8-bytes per character
DoBytes
            lda     ,u+                     ; get character byte
            sta     ,x                      ; put byte on screen
            leax    32,x                    ; index 32-bytes on page (next line)
            decb                            ; decrement byte counter
            bne     DoBytes                 ; go do more bytes
            leax    -255,x                  ; move screen index next char
            bra     PrintLoop               ; go get another character
DonePrint
            rts

;}
;lettercount zmb     1                      ; is this still needed?



;*******************************************************************************
;*                                                                             *
;*          PF Title Word (hack for centering text)                            *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,u                                                  *
;*                                                                             *
;*******************************************************************************
;{          pfWord
pfWord                                      ; hack for center text (plots as graphic object)
            ldx     PrintAtLoc
            ldu     #pfcredits
bigPF       ldb     #16
littlePF    lda     ,u+
            beq     DoneLetters
            sta     ,x+
            decb
            bne     littlePF
            leax    16,x
            bra     bigPF
DoneLetters
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          AND Title Word (hack for centering text)                           *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,u                                                  *
;*                                                                             *
;*******************************************************************************
;{          andWord
andWord                                     ; hack for center text (plots as graphic object)
            ldx     PrintAtLoc
            ldu     #andcredits
bigAND      ldb     #4
littleAND   lda     ,u+
            beq     DoneANDLet
            sta     ,x+
            decb
            bne     littleAND
            leax    28,x
            bra     bigAND
DoneANDLet
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Scroll Obstacles                                                   *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,x,cc                                                   *
;*                                                                             *
;*******************************************************************************
;{          ScrollObst
ScrollObst  dec     cyclescroll             ; cycle our scroll counter
            bne     DonePrint               ; time to reset? no - go to nearest rts to save lbne
            lda     #SCRL_CYCLE             ; reset scroll counter
            sta     cyclescroll             ; store it
ObstLoop                                    ; loop to handle entire band of obstacles (32 bytes/scan-line * obstacle-height)
            ldx     #OBST_ROW               ; grab height of obstacles
            leax    767,x                   ; adjust for offset
            dec     obstaclespd             ; cycle obstacle speed
            lbeq    ObstDone                ; done? yes - go do done routine
DoObstBand                                  ; routine to ROL full scan line
            orcc    #$01                    ; clear CC to not ROL garbage bits
            rol     TROL_OFFSET+3,x         ; ROL temp byte-3
            rol     TROL_OFFSET+2,x         ; ROL temp byte-2
            rol     TROL_OFFSET+1,x         ; ROL temp byte-1
            rol     ,x                      ; ROL on-screen scan line
            rol     -1,x
            rol     -2,x
            rol     -3,x
            rol     -4,x
            rol     -5,x
            rol     -6,x
            rol     -7,x
            rol     -8,x
            rol     -9,x
            rol     -10,x
            rol     -11,x
            rol     -12,x
            rol     -13,x
            rol     -14,x
            rol     -15,x
            rol     -16,x
            rol     -17,x
            rol     -18,x
            rol     -19,x
            rol     -20,x
            rol     -21,x
            rol     -22,x
            rol     -23,x
            rol     SCRL_OFFSET,x           ; skip Dino bounding box - ROL temp space instead
            rol     SCRL_OFFSET-1,x
            rol     SCRL_OFFSET-2,x
            rol     -27,x                   ; contine ROL of on-screen scan line
            rol     -28,x
            rol     -29,x
            rol     -30,x
            rol     -31,x
            
            lda     SCRL_OFFSET,x           ; merge obstacle temp space with Dino bounding box
            coma
            sta     OBST_TEMPOF+8,x
            ora     -24+DINO_TEMPOF,x
            coma
            sta     -24,x
            
            lda     SCRL_OFFSET-1,x
            coma
            sta     OBST_TEMPOF+7,x
            ora     -25+DINO_TEMPOF,x
            coma
            sta     -25,x
            
            lda     SCRL_OFFSET-2,x
            coma
            sta     OBST_TEMPOF+6,x
            ora     -26+DINO_TEMPOF,x
            coma
            sta     -26,x            

            dec     obstclrows              ; decrement row counter
            beq     BandDone                ; are we done? yes - go to done
            leax    -32,x                   ; shift index by full scan line
            jmp     DoObstBand              ; go do obstacle band loop

BandDone                
            jsr     CheckObst               ; go check moving obstacles
            lda     newobheight             ; grab obstacle height
            sta     obstclrows              ; store as rows for ROL'ing
            jmp     ObstLoop                ; go do more looping
ObstDone    
            lda     #OBST_SPEED             ; grab obstacle speed counter
            sta     obstaclespd             ; store it
            rts	
            
            ldx     #PTERO_ROW              ; grab where Pterodactyls start
            leax    1023,x                  ; offset it (32 scan lines minus 1-byte column)
CopyObst    
            dec     obstclrows              ; decrement obstacle rows
            beq     CopyDone                ; done? yes - finish obstacle band
            leax    -32,x                   ; decrement by a single scan line
            bra     CopyObst                ; always loop obstacle copy
CopyDone    
            lda     #OBST_HEIGHT            ; grab obstacle height var
            sta     obstclrows              ; store it
ScrollDone  
            rts
;}


;*******************************************************************************
;*                                                                             *
;*          Check Obstacles - Animation Handler                                *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a,b,x,y                                                  *
;*                                                                             *
;*******************************************************************************
;{          Check Obstacles
CheckObst
            ldx     TotDist
            cmpx    #100
            blo     ObCheck
            
            lda     DemoMode
            bne     ObCheck
            lda     DinoBot
            beq     CheckPtero
ObCheck
            lda     curobst1
            beq     Chck2
            dec     curobst1
Chck2       
            lda     curobst2
            beq     Chck3
            dec     curobst2
Chck3       
            lda     curobst3
            beq     Chck4
            dec     curobst3            
Chck4       
            lda     curobst4
            beq     CheckPtero
            dec     curobst4
CheckPtero            
            lda     PteroFlag
            beq     DoneObChck
            dec     PteroHPos
            bne     FlapPtero
            clr     PteroFlag
            rts
FlapPtero
            lda     PteroHPos
            cmpa    #$F0                    ; Ptero still off screen?
            beq     DoneObChck
            anda    #%00001111              ; Even 2-byte boundary?
            bne     DoneObChck
            ldb     PteroHPos
            rorb                    
            rorb
            rorb
            ldx     #PTERO_ROW-32
            abx
            
            lda     PteroVPos
            ldb     #32
            mul
            leax    d,x
            
            com     PteroFlap
            bne     Flap2
Flap1 
            ldy     #pterodactyl1
            bra     loopPtero2
Flap2       
            ldy     #pterodactyl2
loopPtero2  
            lda     ,y+
            beq     DoneObChck
            sta     ,x+
            lda     ,y+
            sta     ,x+
            lda     ,y+
            sta     ,x
            leax    30,x
            bra     loopPtero2
DoneObChck  
            rts


;*******************************************************************************
;*                                                                             *
;*          Get Entropy - attempt randomness                                   *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          GetEntropy
GetEntropy
            lda     Timer+1                 ; increment timer value
            sta     $0113                   ; store it
            jsr     InitRandom              ; go handle randomness
            rts
;}            
            
;*******************************************************************************
;*                                                                             *
;*          InitRandom                                                         *
;*           Input  : none                                                     *
;*           Output : none                                                     *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          InitRandom
InitRandom  lda     $113                    ; grab RND seed (BASIC timer)
            bne     store_rng               ; check it
            inca                            ; increment value
store_rng   sta     rndx+1                  ; store it in our pointer
            rts
;}

;*******************************************************************************
;*                                                                             *
;*          GetRandom                                                          *
;*           Pseudo-Random Number Generator                                    * 
;*           ------------------------------------------------                  *
;*           Input  : none                                                     *
;*           Output : a (8bit RND)                                             *
;*           Used   : a                                                        *
;*                                                                             *
;*******************************************************************************
;{          GetRandom
GetRandom
rndx		lda     #01                     ; memory pointer for RND value
            inca                            ; increment it
            sta     rndx+1                  ; store it back
rnda		eora    #00                     ; flip some bits in first temp pointer
rndc		eora    #00                     ; flip some bits in third temp pointer
            sta     rnda+1                  ; store back to first temp pointer
rndb        adda    #00                     ; add new value to contents of second temp pointer
            sta     rndb+1                  ; store it back to second temp pointer
            lsra                            ; shift bit left
            adda    rndc+1                  ; add with contents of third temp pointer
            eora    rnda+1                  ; flip bits with contents of first temp pointer
            sta     rndc+1                  ; store value into third temp pointer
            sta     rndx+1                  ; store new value back to our pointer
            rts
;}  


;*******************************************************************************
;*                                                                             *
;*          Variables which do not need to reside in DP                        *
;*                                                                             *
;*******************************************************************************
;{          
CipherTXT   zmb     1                       ; Cipher char
HScrUnit    zmb     1                       ; High Scoreboard - units value
HScrTen     zmb     1                       ; High Scoreboard - tens value
HScrHund    zmb     1                       ; High Scoreboard - hundreds value
HScrThou    zmb     1                       ; High Scoreboard - thousandths value
HScrTenTh   zmb     1                       ; High Scoreboard - ten-thousandths value
PrintAtLoc  zmb     2                       ; Print  Location
StringLoc   zmb     2                       ; String location in memory (Print-At)

nointernet  fcn     'NO INTERNET'            
gameover    fcn     'GAME OVER'
gamepaused  fcn     'GAME PAUSED'
blank       fcn     '                                '
highscore   fcn     'HI:00000'
titletext   fcn     'RUN DINO RUN'
title1      fcn     'BY'
title2      fcn     'PAUL FISCARELLI'
title3      fcn     '3-VOICE MUSIC PLAYER'
title4      fcn     ' AND'
title5      fcn     'ADVISOR OF MADNESS'
title6      fcn     'SIMON JONASSEN'
headerrow   fcn     '*****************************'
instruct1   fcn     'INSTRUCTIONS'
instruct2   fcn     'JUMP....<SPACE> OR BUTTON-1'
instruct3   fcn     'DUCK....<ENTER> OR BUTTON-2'
instruct4   fcn     'SKIP....<R-ARROW> KEY'
instruct5   fcn     'MUTE....<M> KEY'
instruct6   fcn     'PAUSE...<P> KEY'
othertxt1   fcn     '**************************'
othertxt2   fcn     '************************'


            include	    ".\include\dinorun\dinofont.asm"
            include	    ".\include\dinorun\dinosprites.asm"
            
            align   $100
            
pic         includebin  ".\include\dinorun\dinomnt.raw"
endpic      equ     *

dinopic     includebin  ".\include\dinorun\dinorun.raw"
enddinopic  equ     *

;*******************************************************************************
;*                                                                             *
;*          12 note per octave frequency table 8.4Khz                          *
;*                                                                             *
;*******************************************************************************
;{          freqtab
freqtab     align   $100

            fdb     0,70,75,79,83,88,94,99,105,111,118,125
            fdb     133,141,149,158,167,177,188,199,211,223,237,251
            fdb     266,282,298,316,335,355,376,398,422,447,474,502
            fdb     532,563,597,632,670,710,752,796,844,894,947,1003
            fdb     1063,1126,1193,1264,1339,1419,1503,1593,1688,1788,1894,2007
            fdb     2126,2253,2387,2529,2679,2838,3007,3186,3375,3576,3789,4014
            fdb     4252,4505,4773,5057,5358,5676,6014,6371,6750,7152,7577,8028
            fdb     8505,9011,9546,10114,10716,11353,12028,12743,13501,14303,15154,16055
            fdb     17010,18021,19093,20228,21431,22705,24056,25486,27001,28607,30308,32110
;}


dinotune1
            include	    ".\include\dinorun\dinotun1.asm"
dinotune2            
            include	    ".\include\dinorun\dinotun2.asm"
dinotune3            
            include	    ".\include\dinorun\dinotun3.asm"            
            
version     fcn     'v1.2.1 10-17-21'
            
            end     Start
