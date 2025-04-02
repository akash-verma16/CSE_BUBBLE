# CS220 Assignment 7
# Devansh Kumar Jha 200318
# Shivang Pandey 200941

.data
strResult: .asciiz "The array:\n"
strCR: .asciiz "\n"
strCT: .asciiz " "
buffer: .space 2

# Please change the code here to change the array to be printed. Also please put the size of array in n.
arr:    .word 897, 565, 656, 1234, 665, 3434, 897, 565, 656, 1234, 665, 3434, 1126, 554, 3349, 678, 3656, 9989  # Input Array
n:      .word 18 # size of array

.text
.globl main

# Stores values - $s0: arr[n] start address    $s1: value of n
main:
    # STEP 1 -- Allocate required array
    lw $s3, n              # store value of n
    la $s2, arr            # store start address of arr[n]

    # STEP 2 -- Print the array
    la $a1, strResult
    jal print
    
    # STEP 3 -- exit
    li $v0, 10  # Syscall number 10 is to terminate the program
    syscall     # exit now


# Prints the current array which is being stored at the location
# Uses $s2: Start address of array arr[i], $s3: Length of array
# Uses the value in $a1: String to be printed with the array
.text
print:
    
    # STEP 1 -- First print the string prelude  
    addi $v0, $0, 4                   # syscall number 4 -- print string
    addi $a0, $a1, 0
    syscall                           # actually print the string
    
    # STEP 2 -- Then print the sorted array
    addi $t1, $0, 0                   # counter for the loop
    addi $t0, $s2, 0                  # get the start address of arr[n]
    loop2:  addi $v0, $0, 1           # syscall number 1 -- print integer
            lw $a0, 0($t0)            # load values and put in $a0 for print
            syscall                   # actually print the integer
            addi $v0, $0, 4           # syscall number 4 -- print string
            la $a0, strCR
            syscall
            addi $t1, $t1, 1          # increase the counter by 1
            addi $t0, $t0, 4          # increase address to the next value
            bne $t1, $s3, loop2       # iterate over the loop
      
    # STEP 3 -- Return to main        
    end2:   jr $ra                    # return from the print module
