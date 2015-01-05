/*
 * Filename: numOfDigits.s
 * Author: Gurkirat Singh
 * Description: This assembly routine counts the number of base digits in
 *		its argument.
 */

 MIN_BASE = 2
 MAX_BASE = 36

 	.global numOfDigits

	.section ".text"

/*
 * Function name: numOfDigits()
 * Function prototype: int numOfDigits(long num, int base)
 * Description: This function counts the number of digits that can be in the
 *		given base number. You first call checkRange to see if the
 *		number of within the defined Range.
 * Parameters:
 *	arg 1: long num -- number that we need to count the digits of
 *	arg 2: int base -- inputted base that we need to check arg1 against
 * 
 * Side Effects: It can miss the case and loop overflow since it doesn't do
 *		input validation
 * Error conditions: Checks if a zero value is entered, then simply return 1
 *			Base value can be out of range. Use checkRange()
 *
 * Return Value: returns the number of digits in arg1 found
 *
 * Registers Used:
 * 	%i0 - arg 1 -- number that we need to check digits of
 *	%i1 - arg 2 -- the base value of arg1
 *	
 *	%o0 - used to store input paramters before a calculation or function
 *		call
 *	%o1 - stores input paramters before making a function call or doing
 *		a calculation
 */

numOfDigits:
	save	%sp, -96, %sp		!save caller's window

	cmp	%i0, 0			!return with value 1 if the argument
	be	zeroValue		!num is 0
	nop				!delay slot

	mov	%i1, %o0
	mov	MIN_BASE, %o1		!put the minimum range value in output
					!register
	mov 	MAX_BASE, %o2		!put max range value in output register

	call	checkRange		!check if base is out of range
	nop

	cmp	%o0, 0
	be	outOfRange		!Base is out of range, return -1
	nop

	clr	%l0			!clear local register 0
	mov	%i0, %o0		!num value
	mov	%i1, %o1		!base value

generalLoop:

	inc	%l0			!increment counter value
	
	call	.div			!divide num by base
	nop				!delay slot

	cmp	%o0, 0
	be	sendResult		!check if num is 0, otherwise keeping
	nop				!dividing by looping

	ba	generalLoop
	nop

outOfRange:
	mov	-1, %i0			!Base value is out of range, return
	ba	returnValue		!-1 immediately
	nop

zeroValue:
	mov	1,%i0			!arg1 was number 0, send back value 1
	ba	returnValue		!as the total number of digits
	nop

sendResult:
	mov	%l0, %i0		!send back the count of how many times
	ba	returnValue		!num was able to be divided by base
	nop

returnValue:	
	ret				!Return from subroutine
	restore				!Restore caller's window

