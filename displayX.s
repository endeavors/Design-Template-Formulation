/*
 * Filename: displayX.s
 * Description: Assembly module that outputs the pattern based on the entered
 *		height, width,etc. It prints each printer individually by
 *		calling printChar()
 */

NL = '\n'
BASE = 10
NUMBERTWO = 2

 	.global displayX

	.section ".text"

/*
 * Function name: displayX
 * Function prototype: void displayX(long size, long xChar, long fillerChar,
 *			long borderChar);
 * Description: This assembly routine prints the individual characters with
 *		the proper border width, filler char, and other border
 *		chars. It calls numOfDigits to make get how many digits
 *		are in the passed in argument and goes through severl
 *		loops to keep individually printing charcters according
 *		to the function that they have been assigned.
 * Paramters:
 *	arg 1: long size -- long int that tells us how big the X-pattern
 *				is going to be.
 *	arg 2: long xChar -- the ASCII value (character) that forms the
 *				X-pattern of the output
 *	arg 3: long fillerChar -- the ASCII value (character) that forms
 *				the inner part of the output "image"
 *				besides the xChar
 *	arg 4:	long borderChar -- ASCII value (character) that forms
 *				the border of the output image.
 * 
 * Side Effects: Loops over several calculated values that could come
 *		out wrong. This assembly routine doesn't perform
 *		any sort of input validation
 * Error Conditions: None. Besides the fact that it checks if for-loops
 *			need to be "entered" again.
 * Return Value: Calls printChar to output a single character.
 * 
 * Registers Used:
 * 	Input Registers
 *	---------------
 *	%i0 - arg 1 -- size that the output pattern needs to be
 *	%i1 - arg 2 -- ASCII value character that is the x-pattern
 *	%i2 - arg 3 -- ASCII value character that fills in the x-pattern
 *	%i3 - arg 4 -- ASCII value character for the border
 *
 *	Output Registers
 *	----------------
 *	%o0 - This register takes in any value that needs to be used 
 *		to calculate something and then is used to store the 
 *		result back in it.
 *	%o1 - This register is needed to store the value of BASE and the
 *		value of NUMBERTWO
 *
 *	Local Registers
 *	---------------
 *	%l0 - stores the value returned by numOfDigits
 *	%l1 - counter for the rows
 *	%l2 - counter for the columsn
 *	%l3 - stores the value of (numofDigits(size, BASE) * 2 + size)
 *	%l4 - counter for border count
 *	%l5 - flags checker
 */

 displayX:
 	save	%sp, -96, %sp		!save caller's window

	mov	%i0, %o0		
	mov	BASE, %o1
	call	numOfDigits		!check how many digits are in the 
					!input paramter for size
	nop

	mov	%o0, %l0		!copy the num to local register so we
					!don't have to compute it everytime
	
	mov	NUMBERTWO, %o1		!calculate numOfDigits * 2 + size
	call	.mul
	nop

	add	%o0, %i0,%o0
	mov	%o0, %l3		!copy numOfDigits * 2 + size to local
					!register 3
	clr	%l5			!make sure that %l5 is set to 0

bottomBorderOrigin:
	clr	%l1			!local register for row counter

	cmp	%l1, %l0		!exit out if row counter is greater
					!than or equal to the constant
	bge	returnValue		!numOfDigits
	nop

	clr	%l2			!local register for col counter
	
	cmp	%l2, %l3
	bge	topBorderLoop		!start the loop to print the newline
	nop				!character and loop again
	
innerTopBorderLoop:			!row is less than numOfDigits
	
	mov	%i3, %o0		!print the character for the border
	call	printChar
	nop

	inc	%l2			!increment column counter

	cmp	%l2,%l3			!check if column is greater than 
	bl	innerTopBorderLoop	!numOfDigits * 2 + size
	nop
	

topBorderLoop:				!comes here to print newline character,
					!increment, and check if it can loop
					!again
	mov	NL, %o0
	call	printChar
	nop

	inc	%l1			!increment row counter

	clr	%l2			!reset the column counter
	cmp	%l1, %l0		!if row is less than numOfDigits,
	bl	checkInsideLoop		!it can loop again,otherwise go to 
	nop				!next for loop for x-pattern

	cmp	%l5, 1			!return immediately if flag is set
	be	returnValue		!for completed bottom border
	nop

	ba	clrLocalRegisters	!prepate to go to next loop
	nop

checkInsideLoop:
	cmp	%l2, %l3		!check if another loop is possible
	bl	innerTopBorderLoop	!if not, then go back to the most
	nop				!outer loop to print new line
	
	ba	topBorderLoop
	nop

clrLocalRegisters:			!clear row, column, and border count
	clr	%l1			!registers for the next for-loop
	clr	%l2
	clr	%l4

xPatternPreCheck:
	cmp	%l1, %i0		!check if the loop for fillerChar and 
	bl	xPatternBorderLoop	!xChar is possible to start
	nop

	ba	bottomBorder		!Loop is not going to start,skip it,
	nop				!go to next 'for-loop'

xPatternBorderLoop:			
	cmp	%l4, %l0
	bl	innerPatternBorderLoop	!bounder count is less than numOfDigits
	nop

	ba	colPatternLoop		!check xChar and fillerChar for
	nop				!verfication

innerPatternBorderLoop:
	
	mov     %i3, %o0		!print borderChar
	call    printChar
	nop

	inc     %l4			!increment border count counter

	cmp	%l4, %l0
	bl	innerPatternBorderLoop	!it is possible to loop again
	nop
	
	ba	colPatternLoop		!not possible to loop again
	nop

colPatternLoop:
	cmp	%l2, %i0
	bl	colIfStatement		!column counter is less than input size
	nop

	ba	secondBorderCount 	!check for another loop for borderCount
	nop				!char printing

colIfStatement:
	cmp	%l1, %l2		!when row is equal to column
	be	checkTwoEqualValues	!The first condition matches
	nop

	ba	secondConditionalStatement	!first condition doesn't match
	nop
	
secondConditionalStatement:
	sub	%i0, %l2, %o0		!subtract size - col - 1
	sub	%o0, 1 , %o0

	cmp	%l1, %o0
	be	checkTwoEqualValues	!condition matches; they're equal
	nop
	
	mov	%i2, %o0		!print fillerChar; conditions didn't
	call	printChar		!match at all
	nop

	ba	postLoopCheckup		!loop over current loop
	nop

checkTwoEqualValues:
	mov	%i1, %o0		!print xChar when two values are equal
	call	printChar
	nop

postLoopCheckup:
	inc	%l2			!checks if column is less than input
	ba	colPatternLoop		!size
	nop

secondBorderCount:
	clr	%l4
	
	cmp	%l4, %l0		!borderCount loop is possible to 
	bl	secondBorderLoop	!start
	nop

	ba	createNewLine		!skip over the loop, just print
	nop				!new line character

secondBorderLoop:	
	mov	%i3, %o0 		!print borderChar
	call	printChar
	nop

	inc	%l4			!increment border count counter

	cmp	%l4, %l0
	bl	secondBorderLoop	!check if another loop is possible
	nop

createNewLine:
	mov	NL, %o0			!print new line character
	call	printChar
	nop

	clr	%l4			!clear bounder count, and 
	clr	%l2			!column counter 
	
	inc	%l1			!increment row counter

	ba	xPatternPreCheck	!check if another loop is 
	nop				!possible

bottomBorder:
	mov	1, %l5			!set the flag that bottom 
	ba	bottomBorderOrigin	!border is about to be
	nop				!printed, so it can exit out of
					!outer loop 
returnValue:					
	ret				!Return from subroutine
	restore				!Restore caller's window
