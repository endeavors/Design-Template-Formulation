/*
 * Filename: strToLong.c
 * Author: Gurkirat Singh
 * Description: This file converts the inputted string from the main program
                file and then converts it to a long integer. It performs
                all the error checking and reporting of whether the string
                is a valid input or not using the errno C library.
 */


#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include "strings.h"
#include "pa1.h"

/*
 * Function name: strToLong()
 * Function prototype: long strToLong(char *str, int base)
 * Description: This function takes in a char pointer, which is basically
 *              our string, and then it converts it to the base that we
 *              provide. It keeps track of any errors and also reports
 *              back which character caused the problem, which is why
 *              we pass the address of a char* endptr.
 * Paramters: char pointer, which is our string that needs to be parsed
 *            integer base that we want the string to convert to
 * Side Effects: The string might not be a valid input
 * Error Conditions: String is not an integer
 * Return Value: return the actual long integer if the string is successfully
 *               converted to a long int.
 */

long strToLong(char *str, int base)
{
    errno = 0;                 /*reset errno everytime this function is called*/
    char *endptr;              /*keep track which character caused a problem*/
    long converted_num = 0;    /* actual long int that will be returned*/
	  char output_char[BUFSIZ];  /* char pointer that will be buffered */
	
    converted_num = strtol(str,&endptr, base); /* run strtol to get a long int*/
	
    /* There was no error*/
    if (errno != 0){

        /*
         * print a message that the string is converted to long int. It will
         * construct a string with the specifying string that the error along
         * with the base.
         */
        (void)snprintf(output_char,BUFSIZ,STR_STRTOLONG_CONVERTING,str,base);
        perror(output_char);
     }
	
    /*
     * Check if a string was valid input. Return an error saying the string
     * was not valid
     */
    if (*endptr != '\0'){
        
        /*print 'not an integer' error */
        (void)fprintf(stderr,STR_STRTOLONG_NOTINT,str);
        
        /*reset to errno to a non-zero value*/
        errno = 1; 
       
    }

    /*return the long int back to main function*/
    return converted_num;
}
