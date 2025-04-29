#include "msp430x26x.h"                     ; #define controlled include file

        NAME    main                    ; module name

        PUBLIC  main                    ; make the main label visible

        RSEG    CSTACK                  ; pre-declaration of segment
        RSEG    CODE                    ; place program in 'CODE' segment

RESET   MOV     #SFE(CSTACK), SP        ; set up stack
        CALL    #Setup                  ; call setup function

main    
                CALL    #InitDelay         ; initialize delay value
Mainloop:
                MOV.b   #BIT0,&P6OUT      ; turn on LED (P6.0)
                CALL    #Delay             ; call delay subroutine
                MOV.b   #00h,&P6OUT       ; turn off LED
                CALL    #Delay             ; call delay subroutine
                
                JMP     Mainloop           ; repeat the loop

Setup:
                MOV     #WDTPW+WDTHOLD,&WDTCTL  ; stop watchdog timer
                MOV.b   #BIT0,&P6DIR      ; set P6.0 as output for LED
                MOV.b   #00h,&P6OUT       ; initialize P6.0 to low (LED off)
                
                EINT                      ; enable global interrupts
		RET                      


; Delay subroutine with decreasing duration
Delay:
                MOV     R15, R12          ; copy current delay value to R12 for modification
                
DelayLoop:
                DEC     R12               ; decrement delay counter
                JZ      EndDelay           ; if zero, end delay
                NOP                         ; do nothing (waste time)
                JMP     DelayLoop          ; repeat until zero
                
EndDelay:
                RET                        ; return from delay


; Initialize the delay value (in milliseconds)
InitDelay:
                MOV     #300000, R15      ; initial delay value (3 seconds)
		RET                      


; Main program loop to decrease the delay over time
DecreaseDelay:
DecreaseLoop:
                CALL    Delay              ; call the delay subroutine
                
                SUB     #30000, R15        ; decrease the delay by 30 ms (adjust as needed)
                
                CMP     #30000, R15        ; check if delay is less than 0.3 seconds (300 ms)
                JGE     DecreaseLoop       ; if greater or equal, continue decreasing
                
                MOV     #300000, R15       ; reset to initial value after reaching minimum
                
		RET                      


            COMMON  INTVEC                  ; define interrupt vector area

            ORG     RESET_VECTOR            ; reset vector address,
                                            ; ext. Reset (power-on reset)
            DW      RESET                   ;
            END                             ;