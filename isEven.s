/*
 * Filename: isEven.s
 * Author: Gurkirat Singh
 * Description: This assembly routine checks if the the passed in argument
 		is even or not. Even the argument is even, it returns 0 and
		if it is odd, it returns a non-zero value to show that it is
		true.
 */
 
 NUMBERTWO = 2	!used as divisor to check if a number is even

 	.global isEven		!Declare symbol globally so we can call it
				!from the C module
	.section ".text"	!Everything below this is stored in the text
				!section of memory

/*
 * Function name: isEven()
 * Function prototype: int isEven( long num );
 * Description: Checks if the number is even or not.
 * Parameters:
 *	arg 1: long num -- number to check if it is even
 *
 * Side Effects: None
 * Error Conditions: None
 * Return Value: 0 if number is not even, non-zero if it is even
 *
 * Registers Used:
 * 	%i0 - arg 1 -- First argument that will be checked if it is
 *			even or not; it is also used to return the result back
 *	%o1 -- used for storing the return value of a function or of a 
 *		calculation
 */

 isEven:
 	save	%sp, -96, %sp	!Save caller's window
	mov	%i0, %o0	!store the input parameter to output register
	mov	NUMBERTWO, %o1	!store the number 2 in output register so we
				!can use it to divide by the parater later

	call	.rem		!use the modulus to find the remainder
	nop			!delay slot

	xor	%o0,1,%o0	!xor the remainder by 1, so we will know that
				!xor result will be 0 for odd values
	
	cmp	%o0,0		!compare the xor result by 0
	ble	negativeNum	!if the comparison shows a negative number,
				!branch to another label to store 0 in
				!output register
	nop			

	mov	%o0, %i0	!if number is not negative, then store the
				!value in the input register

	ba	sendResult	!branch to send the result back
	nop

negativeNum:
	mov	0,%i0		!since number was negative and not even,store
				!store 0 in the input register so we know
				!that it is odd
 	ba	sendResult	!return the result by branching
	nop

sendResult:
	ret			!Return from subroutine
	restore			!Restore caller's window; in "ret" delay slot
