#include "msp430x26x.h"                     ; #define controlled include file

        NAME    main                    ; module name

        PUBLIC  main                    ; make the main label visible

        RSEG    CSTACK                  ; pre-declaration of segment
        RSEG    CODE                    ; place program in 'CODE' segment

RESET   MOV     #SFE(CSTACK), SP        ; set up stack
        CALL    #Setup                  ; call setup function

main    
Mainloop	MOV.b   &P6IN,R15           ; read input from P6 into R15
                AND.b	#BIT1,R15         ; check BIT1 in R15
                
                JZ      ButtonPressed     ; if button is not pressed, jump to ButtonPressed
                
                ; Button is pressed, turn on LED
                MOV.b   #BIT0,&P6OUT     ; turn on LED on P6.0
                JMP     Mainloop          ; repeat the loop
                
ButtonPressed:
                ; Button is not pressed, blink LED
                CALL    #BlinkLED         ; call the blinking function
                JMP     Mainloop          ; repeat the loop

BlinkLED:
                ; Blink pattern: 3 long and 1 short
                MOV.b   #BIT0,&P6OUT      ; turn on LED (long blink)
                CALL    #Delay             ; delay for long blink
                MOV.b   #00h,&P6OUT       ; turn off LED
                CALL    #Delay             ; delay for off period
                
                MOV.b   #BIT0,&P6OUT      ; long blink 2
                CALL    #Delay             
                MOV.b   #00h,&P6OUT       
                CALL    #Delay             

                MOV.b   #BIT0,&P6OUT      ; long blink 3
                CALL    #Delay             
                MOV.b   #00h,&P6OUT       
                CALL    #Delay             

                MOV.b   #BIT0,&P6OUT      ; short blink
                CALL    #ShortDelay        
                MOV.b   #00h,&P6OUT       
                CALL    #Delay             

                RET                        ; return from BlinkLED

Setup:
                MOV     #WDTPW+WDTHOLD,&WDTCTL  ; stop watchdog timer
                MOV.b   #BIT0,&P6DIR      ; set P6.0 as output for LED
                MOV.b   #00h,&P6OUT       ; initialize P6.0 to low (LED off)
                
                EINT                      ; enable global interrupts
		RET                       ; return from setup


; Delay subroutine for long blink (adjust value as needed)
Delay:
                MOV     #50000, R15       ; load delay count (adjust as needed)
DelayLoop:
                DEC     R15               ; decrement counter
                JNZ     DelayLoop          ; loop until counter reaches zero
		RET                        ; return from delay

; Short delay subroutine for short blink (adjust value as needed)
ShortDelay:
                MOV     #20000, R15       ; load shorter delay count (adjust as needed)
ShortDelayLoop:
                DEC     R15               ; decrement counter
                JNZ     ShortDelayLoop     ; loop until counter reaches zero
		RET                        ; return from short delay


            COMMON  INTVEC                  ; define interrupt vector area

            ORG     RESET_VECTOR            ; reset vector address,
                                            ; ext. Reset (power-on reset)
            DW      RESET                   ;
            END                             ;