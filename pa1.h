/*
 * Filename: pa1.h
 * Author: Gurkirat Singh
 * Description: function prototypes and defines for PA1; written in assembly
 *              or C.
 */


#ifndef PA1_H
#define PA1_H

/* Function prototypes */
long strToLong( char * str, int base);
int checkRange (long value, long minRange, long maxRange );
void displayX( long size, long xChar, long fillerchar, long borderChar);
int isEven ( long num);

#define BASE 10
#define X_SIZE_MIN 4
#define X_SIZE_MAX 5000

/* ASCII values */
#define ASCII_MIN 32     /* ' ' */
#define ASCII_MAX 126    /* '-' */

/*
 * void printChar( char ch);
 * int numOfDigits( long num, int base);
 *
 * Only called from Assembly routine. Not needed in any C routine.
 * Would get a lint message about function declared but not used.
 */

#endif /* PA1_H */
