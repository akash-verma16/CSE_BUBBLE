

#include<stdio.h>

int main()
{
    // Ask for the amount of Input
    int n;
    printf("How many numbers do you want to input ?\n");
    scanf("%d",&n);
    
    // Ask for numbers for input
    printf("Enter the numbers one by one.\n");
    int arr[n];
    for(int i=0;i<n;i++) {
        scanf("%d",&arr[i]);
    }

    // Print the array
    printf("The enterred array is:\n");
    for(int i = 0; i < n; i++) {
        printf("%d ",arr[i]);
    }

    return 0;
}
