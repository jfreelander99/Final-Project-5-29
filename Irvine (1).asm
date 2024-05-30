COMMENT !
Things to Consider Working on:
	-Do we want users to enter decimal values for balance (option 2)
	-Option3:
		-Making sure user can't enter anything they can't (x<1 or x>10)
		-Decimal numbers?
		-A better system for playing the game instead of entering 1 to continue playing?
	-A new game mode??
	-Colors?
	-General clean up of programs and more concise/understandable comments
!





;------------------------------------------------------------
; CMPR 154 - Spring 2024
; 
; Team Name: Avengers Assembly
;
; Team Name Members: Matias Aguirre, Jacob Fitzgerald, Eduardo Guerra, Hugo Huerta
;
; Creation Date: June 6, 2024
;
; Collaboration:
;	Professor Alweheiby Lecture Notes
;----------------------------------------------------------

INCLUDE IRVINE32.INC

.data		; (insert variables here)
teamName BYTE "Avengers Assembly" ,0dh,0ah,0dh,0ah,0dh,0ah ,0
MAX EQU 15
playerName BYTE MAX+1 DUP(?)
menu BYTE " *** MAIN MENU ***" ,0dh,0ah,0dh,0ah
     BYTE "Please Select one of the following: " ,0dh,0ah,0dh,0ah
	 BYTE "   1: Display my available credit" ,0dh,0ah
	 BYTE "   2: Add credits to my account" ,0dh,0ah
	 BYTE "   3: Play the guessing game" ,0dh,0ah
	 BYTE "   4: Display my statistics" ,0dh,0ah
	 BYTE "   5: To exit",0dh,0ah,0dh,0ah
	 BYTE "Enter your choice: ",0
playerNameStr BYTE "Player Name: ",0
availableCreditStr BYTE "Avaliable Credit: ",0
gamesPlayedStr BYTE "Games Played: ",0
correctGuessesStr BYTE "Correct Guesses: ",0
missedGuessesStr BYTE "Missed Guesses: ",0
moneyWonStr BYTE "Money Won: $",0
moneyLostStr BYTE "Money Lost: $",0
goodbyeMsg BYTE "Thank you for playing. Ending Program.",0


; ERROR MESSAGES
tooManyCredits BYTE "=> Error: Maximum allowable credits is $20.00. Please enter a different amount and try again. ",0dh,0ah,0
notEnoughCredits BYTE "=> Error: Not enough credits. You need at least $1.00 to play the game.",0dh,0ah,0
invalidOption BYTE "=> Error: Invalid menu option. Please enter a correct menu option.",0dh,0ah,0
negativeNumber BYTE "=> Error: Entered value can not be below 0.",0dh,0ah,0



; VARIABLES FOR PROMPTING
promptPlayerName BYTE "=> Please enter your name: ",0
availableBalance BYTE "=> Your available balance is: $",0
promptBalance BYTE "=> Please enter the amount you would like to add: ",0
promptIntInput BYTE "=> Please enter a random integer 1-10 (Any other number to go back to Menu): ",0
promptPlayAgain BYTE "=> Would you like to play again (1 for yes, any other decimal number for no): ",0


; VARIABLES FOR PLAYING GAME (OPTION 3)
correctGuess BYTE "=> You correctly guessed the random number! Adding $2 to your balance.", 0
incorrectGuess BYTE "=> You incorrectly guessed the random number. The correct number was: ",0

; NUMBER VARIABLES
userChoice BYTE ?
balance WORD 0			; stores the avaliable credit
MAX_ALLOWED EQU 20		; maximum amount of credits to be added
amount WORD	0			; amount of credit entered by user
randomInt BYTE 0		; stores random number generates in option 3
userInt SBYTE 0			; stores user's inputted number
correctGuesses WORD 0   ; number of times user guessed number correctly
missedGuesses WORD 0	; number of times user guessed number incorrectly
gamesPlayed WORD 0		; number of times user has played the game
moneyWon WORD 0			; stores number of money won from playing game
moneyLost WORD 0		; stores number of money lost from playing game


.code		; (insert executable instructions here)
;---------------------------------------------------------------
; createRandomNumber: generates a random number between 1-10.
; Receives: Nothing
; Returns: eax = randNum, randomInt = randNum
; Requires: Nothing
;---------------------------------------------------------------
createRandomNumber PROC
	MOV eax, 10							; to generate a random number
	CALL RandomRange					; generates random number in eax from 0-9
	INC eax								; so that its 1-10
	MOV randomInt, al					; randomInt stores the random number in al
	RET
createRandomNumber ENDP

;---------------------------------------------------------------
; incrimentWinnings: incriment variables related to winning game
; Receives: Nothing
; Returns: Nothing
; Requires: Nothing
;---------------------------------------------------------------
incrimentWinnings PROC
	INC	balance						; +$2 for winning the game
	INC balance
	INC moneyWon					; +2 to amount of money user has made by playing game
	INC moneyWon
	INC correctGuesses				; +1 to correctGuess to store number of times user guess correct
	RET
incrimentWinnings ENDP

;---------------------------------------------------------------
; incrimentLosses: incriment variables related to losing game
; Receives: Nothing
; Returns: Nothing
; Requires: Nothing
;---------------------------------------------------------------
incrimentLosses PROC
	INC missedGuesses				; +1 to missedGuesses to store number of times user guess incorrect
	INC moneyLost					; -1 to amount of money user has made by playing game
	RET
incrimentLosses ENDP

;---------------------------------------------------------------
; setTextToRed: sets text color to red
; Receives: Nothing
; Returns: Nothing
; Requires: Nothing
;---------------------------------------------------------------
setTextToRed PROC
	MOV eax, red+(black*16)
	CALL SetTextColor
	RET
setTextToRed ENDP

;---------------------------------------------------------------
; setTextToGreen: sets text color to green
; Receives: Nothing
; Returns: Nothing
; Requires: Nothing
;---------------------------------------------------------------
setTextToGreen PROC
	MOV eax, green+(black*16)
	CALL SetTextColor
	RET
setTextToGreen ENDP

;---------------------------------------------------------------
; setTextToWhite: sets text color to white
; Receives: Nothing
; Returns: Nothing
; Requires: Nothing
;---------------------------------------------------------------
setTextToWhite PROC
	MOV eax, white+(black*16)
	CALL SetTextColor
	RET
setTextToWhite ENDP

;---------------------------------------------------------------
; printTwoLines: skips two lines
; Receives: Nothing
; Returns: Nothing
; Requires: Nothing
;---------------------------------------------------------------
printTwoLines PROC
	CALL crlf
	CALL crlf
	RET
printTwoLines ENDP

;---------------------------------------------------------------
; printStringThenInt: print string stat of a category of the game
; Receives: eax (integer value), edx (Offset of string to output)
; Returns: Nothing
; Requires: Nothing
;---------------------------------------------------------------
printStringThenInt PROC
	CALL WriteString
	CALL WriteDec
	CALL crlf
	RET
printStringThenInt ENDP

main proc	; main program
ENTER 0,0

CALL setTextToWhite
MOV edx,OFFSET teamName							;prints Team Name
CALL WriteString	
MOV edx, OFFSET promptPlayerName				;prompt user for a name
call WriteString

MOV ecx, MAX									;length of string (15)
MOV edx, OFFSET playerName						;to store user name
CALL ReadString
CALL crlf

programLoop:
	CALL setTextToWhite
	MOV edx,OFFSET menu							;prints menu
	CALL WriteString

	CALL ReadDec								;collects inputed choice
	MOV userChoice, al							;userChoice contains user's input

	MOV al, 1									;switch statement (MOVe into al to compare with userChoice)
	CMP al, userChoice					
	JE option1									;if user inputted 1, take them to option 1
	MOV al, 2
	CMP al, userChoice
	JE option2									;if user inputted 2, take them to option 2
	MOV al, 3
	CMP al, userChoice
	JE option3									;if user inputted 3, take them to option 3
	MOV al, 4
	CMP al, userChoice
	JE option4									;if user inputted 4, take them to option 4
	MOV al, 5							
	CMP al, userChoice
	JE exitOption								;if user inputted 5, take them to exitOption
	JMP option6									;if user inputted an invalid option

	option1:
		MOV edx,OFFSET availableBalance			;print sentence before balance
		CALL WriteString
		CALL setTextToGreen
		MOV ax, balance							;print balance
		CALL WriteDec		
		CALL setTextToWhite
		CALL printTwoLines
		JMP ProgramLoop							;go back to menu
	option2:
		MOV edx,OFFSET promptBalance			;prints sentence asking to insert balance
		CALL WriteString	
		CALL ReadInt							;read console for balance to add
		MOV amount, ax
		CMP	ax, 0					     		;check to see if input < 0
		JL negativeNum							;user inputted a negative number

		ADD ax, balance
		CMP ax, MAX_ALLOWED
		JLE	belowMax							;amount + balance <= 20

		MOV edx,OFFSET tooManyCredits			;amount + balance > 20
		CALL setTextToRed
		CALL WriteString
		CALL setTextToWhite
		JMP option2

		negativeNum:
			MOV edx, OFFSET negativeNumber		;print error statement because user inputted negative number
			CALL setTextToRed
			CALL WriteString
			CALL setTextToWhite
			JMP option2

		belowMax:								;below max so set new balance
			MOV ax, balance
			ADD ax, amount
			MOV balance, ax
			JMP option1		
	option3:
	playAgain:
		MOV ax, balance							; need to make sure have enough money
		CMP eax, 0							
		JLE	noBalance							; if(eax <= 0) -> jump to noBalance
			MOV edx, OFFSET promptIntInput		; prompt user for a random number 1-10
			CALL WriteString
			CALL ReadInt						; eax stores user input
			MOV userInt, al						; userInt stores eax(user input)
			
			CMP userInt, 10						; if above 10, back to menu
			JA backToMenu
			CMP userInt, 1						; if below 0, back to menu
			JB backToMenu

												; after checking conditions are met, continue playing game
			DEC balance							; -$1 do play the game
			INC gamesPlayed						; +1 to number of times user has played the game

			CALL createRandomNumber

			CMP al, userInt						; eax still contains user input
			JNE notEqual						; if(userInt != RandomInt) -> jump to notEqual
			JE equal
			JMP playAgain
			
			equal:
				MOV edx, OFFSET correctGuess	; else(userInt == RandomInt)
				CALL setTextToGreen
				CALL WriteString				; tell user they guessed correctly
				CALL setTextToWhite
				CALL printTwoLines
				CALL incrimentWinnings
				JMP playAgain					; start game again
			
			notEqual:
				MOV edx, OFFSET incorrectGuess		
				CALL setTextToRed
				CALL WriteString				; tell user they guessed incorrectly
				MOV al, randomInt
				CALL WriteDec					; print correct number
				CALL setTextToWhite
				CALL printTwoLines
				CALL incrimentLosses
				JMP playAgain					; start game again

		noBalance:	
			MOV edx, OFFSET notEnoughCredits	; print error message
			CALL setTextToRed
			CALL WriteString
			CALL setTextToWhite
			CALL printTwoLines

		backToMenu:
			CALL crlf
			JMP ProgramLoop						;go back to menu
	option4:
		CALL crlf
		MOV edx, OFFSET playerNameStr			; print player's Name
		CALL WriteString
		MOV edx, OFFSET playerName
		CALL WriteString
		CALL crlf

		MOV edx, OFFSET	availableCreditStr		; print available credit
		MOV ax, balance
		CALL printStringThenInt

		MOV edx, OFFSET	gamesPlayedStr			; print games played
		MOV ax, gamesPlayed
		CALL printStringThenInt

		MOV edx, OFFSET	correctGuessesStr		; print correct guesses
		MOV ax, correctGuesses
		CALL printStringThenInt

		MOV edx, OFFSET	missedGuessesStr		; print missed guesses
		MOV ax, missedGuesses
		CALL printStringThenInt

		MOV edx, OFFSET	moneyWonStr				; print money won
		MOV ax, moneyWon
		CALL printStringThenInt

		MOV edx, OFFSET	moneyLostStr			; print money lost
		MOV ax, moneyLost
		CALL printStringThenInt

		CALL WaitMsg							;waits for user to print enter before continuing
		CALL printTwoLines
		JMP ProgramLoop
	option6:
		MOV edx,OFFSET invalidOption
		CALL setTextToRed
		CALL WriteString
		CALL setTextToWhite
		CALL printTwoLines
		JMP programLoop

exitOption:
MOV edx,OFFSET goodbyeMsg					;exitting messages and program
CALL WriteString
CALL crlf

LEAVE
exit
main endp	; (insert additional procedures here)



end main
