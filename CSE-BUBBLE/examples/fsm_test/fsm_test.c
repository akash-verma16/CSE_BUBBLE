//! CS220 Assignment 7
//! Devansh Kumar Jha 200318
//! Shivang Pandey 200941

#include<stdio.h>

int main()
{
    // Enter the Input numbers
    int num1=10,num2=-6,num3=13;
    
    // Loop and print the output
    int num4=num2+num3;
    do {
        printf("%d\n",num4);
        num4++;
    }while(num4<num1);

    // Exit the program
    return 0;
}
