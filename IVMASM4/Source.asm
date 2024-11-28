; ------------------------------------------------------------

; CMPR 154 - Guessing Game

; Team Name: Scientist DUP(4)

; Team Members Names: Riley T, Adam Millord, Nicholas Barkero

; Creation Date: November 27th, 2024

; Collaboration: None

; ----------------------------------------------------------

INCLUDE Irvine32.inc

.data

addName BYTE "     Please enter your name: ",0

welcomeUser BYTE "Welcome, ",0

mainMenuText BYTE "*** Scientist DUP(4) ***", 0Ah, 10, 10
		 BYTE "*** Main Menu ***", 0Ah, 10
		 BYTE "Please Select one of the following: ", 0Ah, 10
		 BYTE "    1. Display my available credit", 0Ah
		 BYTE "    2. Add credits to my account", 0Ah
		 BYTE "    3. Play the guessing game", 0Ah
		 BYTE "    4. Display my statistics", 0Ah
		 BYTE "    5. To exit", 0Ah, 10
		 BYTE "    Option: ", 0

invalidOptionText BYTE "Invalid Input. Please Try Again.", 0

maxFundText BYTE "Available Credits are at the limit. Please Select Another Option.", 0

availableBalanceText BYTE "=> Your available balance is $", 0

addBalanceText BYTE "=> Please enter the amount you would like to add (0 - 20): ", 0

subBalanceTextError BYTE "Invalid Value. User cannot input negative credits.", 0Ah
					BYTE "Available Credits: ", 0

addBalanceTextError BYTE "Invalid Value. User cannot add more than 20 credits.", 0Ah
					BYTE "Available Credits: ", 0

notEnoughCreditsToPlayText BYTE "You do not any credits to play with.", 0

addBalanceConfirmation BYTE " credits have been added to your account", 0

askToChooseNumberText BYTE "Pick a number from 1 - 10: ", 0

winnerText BYTE "Congrats! You have guessed correctly", 0

loserText BYTE "Uh Oh, You have not guessed correctly", 0

theGeneratedNum BYTE "The right answer is ", 0

playAgainText BYTE "Would you like to play again? (y/n): ", 0

statsTextHeader BYTE "----------------Stats Page----------------", 0
statsTextFooter BYTE "------------------------------------------", 0

statTextName BYTE "     User Name: ", 0
statTextAvailableCredit BYTE "     Available Credit: ", 0
statTextGamesPlayed BYTE "     Games Played: ", 0
statTextCorrectGuesses BYTE "     Correct Guesses: ", 0
statTextMissedGuesses BYTE "     Missed Guesses: ", 0
statTextMoneyWon BYTE "     Money Won: ", 0
statTextMoneyLost BYTE "     Money Lost: ", 0

;----------------------------------User Variables-----------------------------------
userName BYTE 15 DUP(0)					; Players name

userBalance DWORD 0						; Stores the available balance
MAX_BALANCE_ALLOWED equ 20				; Max balance allowed
MIN_BALANCE_ALLOWED equ 0				; Min balance allowed
creditAmount DWORD 0					; Amount of credits added to account

gamesPlayed DWORD 0						; Total games played 

correctGuesses DWORD 0					; Stores total correct guesses
missedGuesses DWORD 0					; Stores total wrong guesses

moneyWon DWORD 0						; Total credits won
moneyLost DWORD 0						; Total credits lost

randomNumber DWORD 0					; Holds the random number
;-----------------------------------------------------------------------------------

.code
main proc

;---------------Name Prompt---------------
call Crlf
mov edx, OFFSET addName   ;prompt for name
call WriteString

mov edx, OFFSET userName
mov ecx, lengthof userName
call readString

;-----------------------------------------
	
MainMenu:
	mov eax, white+(blue * 16)
	call SetTextColor
	call Clrscr
	mov edx, OFFSET welcomeUser                  
	call WriteString
	mov edx, OFFSET userName                          
	call WriteString                                    ; Prints a welcome for the user
	call Crlf
	call Crlf
	mov edx, OFFSET mainMenuText						; Print the main menu
	call WriteString	
	

	call ReadInt
	mov ebx, eax

	cmp ebx, 1
	je Option1

	cmp ebx, 2                                          ; Checks if 2 has been pressed
	je additionalCheck

	cmp ebx, 3
	je additionalCheckOp3

	cmp ebx, 4
	je Option4
	
	cmp ebx, 5
	je ExitProgram

	mov edx, OFFSET invalidOptionText
	mov eax, red+(blue * 16)
	call SetTextColor
	call WriteString
	call Crlf
	call WaitMsg
	jmp MainMenu

	additionalCheck:
		mov eax, userBalance                                
		cmp eax, 20                        ; Denies entry if max balanced has been reached
		jl Option2
		jge MaxFunds

	MaxFunds:												; Message to let user know they are at the max limit and cannot add funds
		mov eax, red+(blue * 16)
		call SetTextColor
		mov edx, OFFSET maxFundText
		call WriteString
		call Crlf
		call WaitMsg
		jmp MainMenu

	additionalCheckOp3:
		cmp userBalance, 1                                  ; If balance is less than 1 then shows a message and prevents user from going to option 3
		jge Option3
		mov eax, red+(blue * 16)
		call SetTextColor
		mov edx, OFFSET notEnoughCreditsToPlayText
		call WriteString
		call Crlf
		call WaitMsg
		jmp MainMenu

; Prints the players available balance
Option1:
	call Clrscr
	mov edx, OFFSET availableBalanceText		
	call WriteString
	mov eax, userBalance					
	call WriteDec
	call Crlf
	call Crlf
	call WaitMsg
	jmp MainMenu


; Allows user to add credits to account
Option2:
	call Clrscr
	mov eax, white+(blue * 16)
	call SetTextColor
	mov edx, OFFSET addBalanceText
	call WriteString
	call ReadInt
	mov creditAmount, eax					; Store added ammount into variable
	mov ebx, eax
	cmp ebx, MAX_BALANCE_ALLOWED			; Make sure value is from 0-20
	jg BalanceErrorAbove					; If ebx is greater than 20(Max) then jump
	cmp ebx, MIN_BALANCE_ALLOWED
	jl BalanceErrorBelow					; If ebx is less than 0(Min) then jump
	add ebx, userBalance					; Check to see if user will have more than 20 credits
	cmp ebx, MAX_BALANCE_ALLOWED			; If current + added credits > 20 then jump
	jg BalanceErrorAbove

	add userBalance, eax					; If all good then add credits to account
	
	call Crlf

	mov eax, creditAmount
	call WriteDec
	mov edx, OFFSET addBalanceConfirmation
	call WriteString

	call Crlf
	call Crlf

	call WaitMsg
	jmp MainMenu


	BalanceErrorAbove:
		call Crlf
		mov eax, red+(blue * 16)
		call SetTextColor
		mov edx, OFFSET addBalanceTextError
		call WriteString
		mov eax, userBalance
		call WriteDec
		call Crlf
		call Crlf
		call WaitMsg
		jmp Option2

	BalanceErrorBelow:
		call Crlf
		mov eax, red+(blue * 16)
		call SetTextColor
		mov edx, OFFSET subBalanceTextError
		call WriteString
		mov eax, userBalance
		call WriteDec
		call Crlf
		call Crlf
		call WaitMsg
		jmp Option2


	call Crlf
	call WaitMsg
	jmp MainMenu



; Play the guessing game
Option3:
	; User pays 1 credit to play
	; Create a random number from 1 - 10
	; Ask user to guess the number
	;
	; For a correct guess (MAKE SURE TO ADJUST THE STATS VARIABLES)
	;      - congrats message is displayed 
	;      - Credit user 2 credits
	;      - Ask if they want to play again
	;      - If yes then play again (jump Option 3)
	;      - If no then go to main menu (jump main menu)
	;
	; For an incorrect guess (MAKE SURE TO ADJUST THE STATS VARIABLES)
	;      - Display the correct number
	;      - Inform user they have lost
	;      - Ask to play again
	;      - If yes then play again
	;      - If no then go to main menu

	call Clrscr														; Clear Screen
	mov eax, white+(blue * 16)
	call SetTextColor
	cmp userBalance, 1												; If balance is less than 1 then go to main menu
	jl NotEnoughCredits

	dec userBalance													; Remove 1 credit
	inc gamesPlayed													; Adds 1 to total games played
	call Randomize													; Sets a random seed
	mov eax, 10														; Sets the range [0, value - 1]
	call RandomRange												; Generates random number and stores in eax
	mov randomNumber, eax											; Store random number in variable
	inc randomNumber												; Makes range from 0-9 to 1-10

	mov edx, OFFSET askToChooseNumberText							; Ask user to pick a number
	call WriteString
	call ReadInt													; Get user input
	cmp eax, randomNumber											; Compare the values
	je WinnerWinner													; If guesses correctly then you win
	jne LoserLoser													; If guesses incorrectly then you lose

	call Crlf
	call Crlf
	call WaitMsg
	jmp MainMenu

	NotEnoughCredits:
		mov edx, OFFSET notEnoughCreditsToPlayText
		call WriteString
		call Crlf
		call WaitMsg
		jmp MainMenu

	WinnerWinner:
		inc correctGuesses										; Add to stats
		add userBalance, 2										; Add 2 to users credit
		add moneyWon, 2											; Add to stats
		mov edx, OFFSET winnerText
		call WriteString
		jmp AskPlayAgain

	LoserLoser:
		inc missedGuesses										; Add to stats
		inc moneyLost											; Add to stats
		mov edx, OFFSET loserText
		call WriteString
		call Crlf
		mov edx, OFFSET theGeneratedNum
		call WriteString
		mov eax, randomNumber
		call WriteDec
		jmp AskPlayAgain

	AskPlayAgain:
		call Crlf
		mov edx, OFFSET playAgainText
		call WriteString
		call ReadChar

		cmp al, 'Y'
		je Option3
		cmp al, 'y'
		je Option3

		cmp al, 'N'
		je MainMenu
		cmp al, 'n'
		je MainMenu
		mov eax, red+(blue * 16)
		call SetTextColor
		jmp AskPlayAgain
		


; Display the players stats
Option4:
	call Clrscr
	call Crlf

	mov edx, OFFSET statsTextHeader										; Prints Stats Header
	call WriteString
	call Crlf
	call Crlf

	mov edx, OFFSET statTextName										; Prints Name
	call WriteString
	mov edx, OFFSET userName
	call WriteString

	call Crlf
	
	mov edx, OFFSET statTextAvailableCredit								; Prints Available Credit
	call WriteString
	mov eax, userBalance					
	call WriteDec

	call Crlf

	mov edx, OFFSET statTextGamesPlayed									; Prints Games Played
	call WriteString
	mov eax, gamesPlayed
	call WriteDec

	call Crlf

	mov edx, OFFSET statTextCorrectGuesses								; Prints Correct Guesses
	call WriteString
	mov eax, correctGuesses
	call WriteDec

	call Crlf

	mov edx, OFFSET statTextMissedGuesses								; Prints Missed Guesses
	call WriteString
	mov eax, missedGuesses
	call WriteDec

	call Crlf

	mov edx, OFFSET statTextMoneyWon									; Prints Money Won
	call WriteString
	mov eax, moneyWon
	call WriteDec
	
	call Crlf

	mov edx, OFFSET statTextMoneyLost									; Prints Money Lost
	call WriteString
	mov eax, moneyLost
	call WriteDec

	call Crlf
	call Crlf

	mov edx, OFFSET statsTextFooter										; Prints Stats Footer
	call WriteString
	call Crlf
	
	call Crlf
	call Crlf
	call WaitMsg
	jmp MainMenu


; Exits the program
ExitProgram:
	exit

main endp
; (insert additional procedures here)
end main