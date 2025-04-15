

# Conversions

# move $t0, $s0
# add $t0, $s0, $0
# li $t0, 42
# addi $t0, $0, 42
# la $t0, label
# add $t0, $0, label
# bgez $rs, label
# bge $rs, $0, label

.data
strInit: .asciiz "Initial array:\n"
strResult: .asciiz "Sorted array:\n"
strCR: .asciiz "\n"
strCT: .asciiz " "

# Please change the code here to change the array being sorted. Also please put the size of array in n.
arr:    .word 897, 565, 656, 1234, 665, 3434, 897, 565, 656, 1234, 665, 3434, 1126, 554, 3349, 678, 3656, 9989  # Input Array
n:      .word 18                                                                                                # Size of Array

.text
.globl main

# Stores values - $s0: arr[n] start address    $s1: value of n
main:
    # STEP 1 -- Allocate required array
    la $s2, arr
    lw $s3, n                         # store value of n
    
    # STEP 2 -- Print intial array
    la $a1, strInit
    jal print

    # STEP 3 -- Function Call
    addi $v0, $0, 4                   # syscall number 4 -- print string
    la $a0, strCR
    syscall
    jal bubble_sort

    # STEP 4 -- Print the sorted array
    la $a1, strResult
    jal print
    
    # STEP 5 -- exit
    addi $v0, $0, 10                  # Syscall number 10 is to terminate the program
    syscall                           # exit now

# Sorts the array in place by using bubble sort technique
# Uses $s2: Start address of array arr[i], $s3: Length of array
.text
bubble_sort:

    # STEP 1 -- ITERATE OVER THE ARRAY AND SORT
    addi $t0, $0, 0                     # initiate a counter i
    outer:  sub $t1, $s3, $t0           # $t1 = n-i
            addi $t1, $t1, -1           # $t1 = n-i-1
		addi $t2, $0, 0         # initiate a counter j
            sub $s1, $t2, $t1
		slt $s7, $s1, $0
		beq $s7, $0, oend
		bge $s1, $0, oend       # Finish the loop if it should be empty
    inner:  sll $t3, $t2, 2             # $t3 = j*4
            add $t3, $t3, $s2           # Address of arr[j]
            addi $t4, $t3, 4            # Address of arr[j+1]
            lw $t5, 0($t3)              # $t5 = arr[j]
            lw $t6, 0($t4)              # $t6 = arr[j+1]
            sub $s0, $t5, $t6           # $t7 = arr[j] - arr[j+1] 
            slt $s7, $s0, $0
            bne $s7, $0, inend          # branch out if arr[j] <= arr[j+1]
            sw $t5, 0($t4)              # store arr[j] into arr[j+1]
            sw $t6, 0($t3)              # store arr[j+1] into arr[j]
    inend:  addi $t2, $t2, 1            # $t2 = j+1
            bne $t2, $t1, inner         # iterate over the inner loop
    oend:   addi $t0, $t0, 1            # $t0 = i+1
            bne $t0, $s3, outer         # iterate over the outer loop      
            
    # STEP 2 -- Return to main        
    end1:   jr $ra                      # return from the bubble_sort module


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
