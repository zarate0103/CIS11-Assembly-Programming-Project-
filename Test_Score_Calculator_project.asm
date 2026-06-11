;CIS 11: Test Score Calculator 
;Ashley Gallegos 
;Ernesto Zarate
;6/4/26

.ORIG x3000

MAIN
	LD R6, INIT_STACK		; stack pointer 
	LD R4, ARR_BASE			;R4 points to SCORE 
	AND R5, R5, #0			;R5 is cleared, counts the sum
	LD R3, COUNT			;R3 is the loop counter up to 5 for the test scores 

INPUT_LOOP
	AND R3, R3, R3			;condition code set
	BRz INPUT_END			;If COUNT is equal to 0 exit loop 
	LEA R0, MSG_PROMPT		;loads the address of the string message
	PUTS 					;prints the string message
	JSR ASCII_TO_INT		;reads the 2 digits and converts to integers
	STR R0, R4, #0			;stores the score to array pointer
	ADD R4, R4, #1			;pointer moves to next array
	ADD R5, R5, R0			;sum is added to score
	ST R5, SUM				;stores current sum to memory
	ADD R3, R3, #-1			;
	BRnzp INPUT_LOOP		;unconditional loop

INPUT_END	
	JSR FIND_MAX_MIN		;1st subroutine, finds the minimun and maximum score
	JSR CAL_AVG				;2nd subroutine, calculates the average of the 5 test scores
	JSR SHOW_RES			;3rd subroutine, shows the results 
	HALT

ASCII_TO_INT				
	ADD R6, R6, #-1			
	STR R7, R6, #0			;PUSH R7
	ADD R6, R6, #-1			; 
	STR R1, R6, #0			;PUSH R1
	ADD R6, R6, #-1			;
	STR R2, R6, #0			;PUSH R2
	ADD R6, R6, #-1 		;
	STR R3, R6, #0			;PUSH R3
	GETC 					
	OUT 					;---
	LD R1, ASCII_NEG		;R1 is -48 
	ADD R2, R0, R1			;R2 is the tens integer, if entering 32, 3 is the ten integer
	AND R0, R0, #0			;R0 is accumulator which is equal to 0
	AND R3, R3, #0			;R3 is cleared
	ADD R3, R3, #10			;R3 equals 10

MULT_TEN
	AND R3, R3, R3			;condition code set for R3 when branching
	BRz END_MULT			;if counter is 0 ends multiplication of tens
	ADD R0, R0, R2 			;accummulator adds the tens digit
	ADD R3, R3, #-1			;decrement counter
	BRnzp MULT_TEN			;loops back 

END_MULT
	ST R0, TEN_VAL			;stores value of TEN_VAL to memory
	GETC 					
	OUT						
	LD R1, ASCII_NEG		
	ADD R1, R0, R1			
	LD R0, TEN_VAL			
	ADD R0, R0, R1			;R0 is equal to TEN_VAL + single digit

	LDR R3, R6, #0			
	ADD R6, R6, #1			;POP R3
	LDR R2, R6, #0			
	ADD R6, R6, #1			;POP R2
	LDR R1, R6, #0			
	ADD R6, R6, #1			;POP R1
	LDR R7, R6, #0			
	ADD R6, R6, #1			;POP R7
	RET

FIND_MAX_MIN	
	ADD R6, R6, #-1			
	STR R7, R6, #0			;PUSH return address 
	ADD R6, R6, #-1			
	STR R4, R6, #0			;PUSH R4
	ADD R6, R6, #-1			
	STR R1, R6, #0			;PUSH R1
	LD R4, ARR_BASE			;resets pointer to start of array
	LDR R0, R4, #0			;seeds value by having R0 = SCORE[0]
	ST R0, MAX				
	ST R0, MIN 				
	AND R1, R1, #0			
	ADD R1, R1, #5			;R1 is loop counter 

MAX_MIN_LOOP
	AND R1, R1, R1			;condition code set 
	BRz MAX_MIN_LP_END		;if loop counter is 0 exits 
	LDR R0, R4, #0			;loads the current score through pointer
	ADD R4, R4, #1			;moves pointer to next score
	LD R2, MIN				
	NOT R2, R2				
	ADD R2, R2, #1			
	ADD R2, R0, R2 			
	BRzp CHECK_MAX			;if ≥ 0 doesn't update 
	ST R0, MIN				;updates MIN

CHECK_MAX
	LD R2, MAX				
	NOT R2, R2				
	ADD R2, R2, #1			
	ADD R2, R2, R0			
	BRn MAX_MIN_MOVE		
	ST R0, MAX				;updates MAX

MAX_MIN_MOVE
	ADD R1, R1, #-1			
	BRnzp MAX_MIN_LOOP		

MAX_MIN_LP_END
	LDR R1, R6, #0			
	ADD R6, R6, #1			
	LDR R4, R6, #0			
	ADD R6, R6, #1			
	LDR R7, R6, #0			
	ADD R6, R6, #1			
	RET

CAL_AVG
	ADD R6, R6, #-1			
	STR  R7, R6, #0 		
	ADD R6, R6, #-1			
	STR R0, R6, #0			
	LD R0, SUM				;loads total sum to R0
	AND R2, R2, #0			

AVG_LOOP
	AND R1, R1, #0			;clears R1
	ADD R1, R1, #5			;R1 = 5 as divisor
	NOT R1, R1 				
	ADD R1, R1, #1			;twos complement (-5)
	ADD R0, R0, R1			
	BRn AVG_LOOP_END		;exits loop if avg is negative
	ADD R2, R2, #1			
	BRnzp AVG_LOOP			;loops unconditionally 

AVG_LOOP_END	
	ST R2, AVG				
	LDR R0, R6, #0			;POP R0
	ADD R6, R6, #1			
	LDR R7, R6, #0			;POP R7 (return address)
	ADD R6, R6, #1			
	RET 					

SHOW_RES	
	ADD R6, R6, #-1			
	STR R7, R6, #0			;PUSH R7, JSR is called inside 
	LEA R0, MSG_MIN			
	PUTS 					;prints the message for min
	LD R0, MIN				
	JSR PRINT_NUM 			 
	LEA R0, MSG_MAX			
	PUTS 					;prints the message for max
	LD R0, MAX				
	JSR PRINT_NUM			 
	LEA R0, MSG_AVG			
	PUTS 					;prints the message for average
	LD R0, AVG				
	JSR PRINT_NUM 			
	LD R0, AVG				
	JSR PRINT_GRD			;prints the overall grade by comparing the letter grades
	LDR R7, R6, #0			
	ADD R6, R6, #1			
	RET

PRINT_NUM
	ADD R6, R6, #-1			
	STR R7, R6, #0			
	ADD R6, R6, #-1			
	STR R1, R6, #0
	ADD R6, R6, #-1	
	STR R2, R6, #0	
	ADD R6, R6, #-1
	STR R3, R6, #0	
	AND R1, R1, #0			
	AND R2, R2, #0			
	ADD R2, R2, #10			;R2 is the divisor 

PRINT_NUM_LOOP
	NOT R3, R2				
	ADD R3, R3, #1			;twos complement (-10)
	ADD R0, R0, R3			
	BRn PRINT_NUM_END		;exits if R0 is negative
	ADD R1, R1, #1			
	BRnzp PRINT_NUM_LOOP	

PRINT_NUM_END
	ADD R0, R0, R2			
	LD R3, ASCII_POS		
	ADD R1, R1, R3		;converts the tens digit to ASCII 	
	ADD R0, R0, R3		;converts the single digit to ASCII
	STR R0, R6, #-1		;saves the single digits
	AND R0, R1, R1			
	OUT					;prints out tens digit
	LDR R0, R6, #-1	
	OUT					;prints out the single digit
	LDR R3, R6, #0
	ADD R6, R6, #1
	LDR R2, R6, #0
	ADD R6, R6, #1
	LDR R1, R6, #0
	ADD R6, R6, #1
	LDR R7, R6, #0
	ADD R6, R6, #1
	RET 

PRINT_GRD					;compares the AVG by looking at the min of each letter grade (A ≥ 90, B ≥ 80, etc)
	ADD R6, R6, #-1
	STR R7, R6, #0
	LEA R0, MSG_GRD			
	PUTS 					;prints grade message
	LD R0, AVG
	LD R1, A_MIN			
	NOT R2, R1				
	ADD R2, R2, #1			
	ADD R2, R0, R2			
	BRzp GRD_A				
	LD R1, B_MIN			
	NOT R2, R1
	ADD R2, R2, #1			
	ADD R2, R0, R2
	BRzp GRD_B				
	LD R1, C_MIN			
	NOT R2, R1
	ADD R2, R2, #1			
	ADD R2, R0, R2
	BRzp GRD_C
	LD R1, D_MIN			
	NOT R2, R1
	ADD R2, R2, #1			
	ADD R2, R0, R2
	BRzp GRD_D

GRD_F
	LD R0, CHAR_F
	OUT
	BRnzp GRD_END
GRD_D
	LD R0, CHAR_D
	OUT
	BRnzp GRD_END
GRD_C
	LD R0, CHAR_C
	OUT
	BRnzp GRD_END
GRD_B
	LD R0, CHAR_B
	OUT
	BRnzp GRD_END
GRD_A
	LD R0, CHAR_A
	OUT

GRD_END	
	LDR R7, R6, #0
	ADD R6, R6, #1
	RET

MIN			.FILL #0
MAX			.FILL #0
AVG			.FILL #0
SUM			.FILL #0
COUNT		.FILL #5		;number of scores user enters
TEN_VAL 	.FILL #0

SCORE 		.BLKW #5		;5 word storage allocation

ARR_BASE	.FILL SCORE		;A pointer to array
INIT_STACK 	.FILL x30EE		

BLOCK_STACK .BLKW #20

ASCII_POS	.FILL #48
ASCII_NEG 	.FILL xFFD0		

A_MIN .FILL #90
B_MIN .FILL #80
C_MIN .FILL #70
D_MIN .FILL #60

CHAR_A .FILL #65
CHAR_B .FILL #66
CHAR_C .FILL #67
CHAR_D .FILL #68
CHAR_F .FILL #70

MSG_PROMPT	.stringz "\nPlease enter test score: \n"
MSG_MIN		.stringz "\nMin score: \n"
MSG_MAX		.stringz "\nMax score: \n"
MSG_AVG		.stringz "\nAverage score: \n"
MSG_GRD		.stringz "\nThe overall grade is: \n"


.END
