.define lastpos $0000
.define lastinput $0001
.org $8000

clear_zero_page:
LDX #0
LDA #0 ; this is the value to write
_clear_zero_page_loop:
STA $0200, X
INX
BNE _clear_zero_page_loop
RTS


start:
JSR clear_zero_page
LDA #$02 ; green
STA $0277 ; center screen
LDY #$77
;STY Y -> M
STY lastpos
loop:
JSR readinput
newandoldinputarethesame:
BRK
JSR checkmovement
JMP loop
JMP start

checkmovement:
CPY lastpos
BNE move
RTS

move:
LDA #0 ; this is the value to write
LDX lastpos
STA $0200, X
LDA #$02 ; green
STA $0200, Y
STY lastpos
RTS

readinput:
LDA $4000 ; read input
CMP lastinput
STA lastinput ; save current input to last input
BEQ newandoldinputarethesame
CMP #$01 ; up
BEQ up
CMP #$02 ; down
BEQ down
CMP #$08 ; right
BEQ right
CMP #$04 ; left
BEQ left
RTS




up:
TYA
ADC #$EF
TAY
RTS

down:
TYA
ADC #$0F
TAY
RTS

right:
INY
RTS

left:
DEY
RTS

.goto $FFFA
.dw start ; non maskable
.dw start ; reset
.dw start ; interrupt