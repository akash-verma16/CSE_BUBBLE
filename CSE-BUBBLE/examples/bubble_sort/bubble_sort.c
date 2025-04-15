

#include<stdio.h>

void bubble_sort(int arr[],int n) {
    for(int i=0; i<n; i++) {
        for(int j=0; j < n-i-1; j++) {
            if(arr[j] > arr[j+1]) {
                int num = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = num;
            }
        }
    }
    return;
}

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

    // Intial Array Print
    printf("The initial array is:\n");
    for(int i = 0; i < n; i++) {
        printf("%d ",arr[i]);
    }

    // Sorting the array
    bubble_sort(arr,n);

    // Final Sorted Array
    printf("\nThe sorted array is:\n");
    for(int i = 0; i < n; i++) {
        printf("%d ",arr[i]);
    }
    return 0;
}
