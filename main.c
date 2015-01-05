/*
 * Filename: main.c
 * Author: Gurkirat Singh
 * Description: Reads the arguments from command line that define which
 *              characters can be used for printing out output pattern. It
 *              calls strToLong to convert the string to a long int and 
 *              checks if there were any errors found. It performs
 *              validation on each of the arguments and if no errors are
 *              found, it displays the X-pattern output
 */


#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include "strings.h"
#include "pa1.h"

/*
 * Function name: main()
 * Function prototype: int main( int argc, char * argv[] );
 * Description: This is the file that gets called to display the output.
 *              It performs error checking to see if all inputs are valid
 *              and also prints all of the error in a specific order if
 *              a problem is detected. To check if any errors are found,
 *              we check if errorFound variable (which is an int) has been
 *              assigned a value of 1. Otherwise, 0 means no error were
 *              found.
 * Parameters: 
 *     arg 1 -- int argc -- number of arguments provided on command line
 *     arg 2 -- char *argv[] -- contains all of the arguments in array
 *
 * Side Effects: Ouputs the display X-pattern with the provided ASCII values
 *                of the characters
 * Error Conditions: errorFound is set to 1 each time an error is found.
 *                    Each argument must pass input validation before
 *                    displaying the final X-pattern
 * Return Value: 0 indicating successful execution
 */

int main (int argc, char *argv[])
{
    /* Declare variable to see if any errors were found */
    int errorFound = 0;

    /* Argument count was not 5, print the Usage error message and then return
     * immediately
     */
    if (argc != 5){
        (void)fprintf(stderr,STR_USAGE,argv[0],X_SIZE_MIN,X_SIZE_MAX,ASCII_MIN,
			    ASCII_MAX,ASCII_MIN,ASCII_MAX,ASCII_MIN,ASCII_MAX);
        return 0;
    }
  
    errno = 0;

    /* After converting string to long int, put return value in xsize */
    long xsize = strToLong(argv[1],BASE);

    /* indicates that there is no error */
    if(errno == 0){
        
        /* check if the size is in range */
        int range = checkRange(xsize,X_SIZE_MIN, X_SIZE_MAX);
        
        /* size was out of range, print error message */
        if (range == 0){
            (void)fprintf(stderr, STR_ERR_XSIZE_RANGE,xsize,X_SIZE_MIN,
                X_SIZE_MAX);
            errorFound = 1;
        }

        /* size must be even */
        int even = isEven(xsize);

        /* size found out to be odd; error message */
        if (even == 0){
            (void)fprintf(stderr, STR_ERR_XSIZE_EVEN, xsize);
            errorFound = 1;
        }
    }else{

        /* set errorFound 1 indicating an error had occurred */
        errorFound = 1;
    } 

    /* reset errno */
    errno = 0;
    long xchar = strToLong(argv[2],BASE);  /* BASE is 10 */
    
    /* no errors */
    if(errno == 0){
        
        /* check if character ASCII value is in range of the characters
         * we want to print out
         */
        int xcharRange = checkRange(xchar, ASCII_MIN, ASCII_MAX);
        
        /*Out of range; print message */
        if (xcharRange == 0){
            (void)fprintf(stderr, STR_ERR_XCHAR_RANGE, xchar, ASCII_MIN,
                ASCII_MAX);
            errorFound = 1;
        }

    }else{

        errorFound = 1;
    }

    /* reset errno each time before performing input validation */
    errno = 0;

    long fillerChar = strToLong(argv[3], BASE);

    if (errno == 0){
        
        /* check if fillerChar ASCII value is in range */
        int fillerCharCheck = checkRange(fillerChar, ASCII_MIN, ASCII_MAX);
     
        /* ASCII value was out of range; print error message */
        if (fillerCharCheck == 0){
            (void)fprintf(stderr, STR_ERR_FILLERCHAR_RANGE, fillerChar,
                ASCII_MIN, ASCII_MAX);
            errorFound = 1;
        }
        
        /* FillerChar ASCII value cannot be equal to xChar ASCII value.
         * Print Error message if they are equal
         */
        if (fillerChar == xchar){
            (void)fprintf(stderr, STR_ERR_XCHAR_FILLERCHAR_DIFF, xchar,
                fillerChar);
            errorFound = 1;
        }
    }else{
        errorFound = 1;
    }
	  
    /* Reset errno */
    errno = 0;

    /* Convert borderChar string to long int */
    long borderChar = strToLong(argv[4],BASE);

    if(errno == 0){
        int borderCharCheck = checkRange(borderChar, ASCII_MIN, ASCII_MAX);

        /* borderChar is out of Range*/
        if (borderCharCheck == 0){
            (void)fprintf(stderr, STR_ERR_BORDERCHAR_RANGE, borderChar,
                ASCII_MIN, ASCII_MAX);
            errorFound = 1;
        }

        /* borderChar and xChar cannot be equal; print error message if they
         * are equal.
         */
        if (borderChar == xchar){
            (void)fprintf(stderr, STR_ERR_XCHAR_BORDERCHAR_DIFF,xchar,
                borderChar);
            errorFound = 1;
        }
    }else{
        errorFound = 1;
    }

    /* no errors were found, display the output pattern */
    if (errorFound == 0){
        displayX(xsize, xchar, fillerChar, borderChar);
    }

    return 0;
}
