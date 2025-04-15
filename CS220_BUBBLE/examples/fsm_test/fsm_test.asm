

.data
strCT: .asciiz "Printed Values\n"
strCR: .asciiz "\n"

# Please change the code here to change the data inputs in the program being sorted.
num1:   .word 10  # First number to be used in program
num2:   .word -6   # Second number to be used in program
num3:   .word 13  # Third number to be used in program

.text
.globl main

main:
    # STEP 1 -- Load the values into memory
    la $t4, num1           # Load the address of num1 in $t4
    la $t5, num2           # Load the address of num2 in $t5
    la $t6, num3           # Load the address of num3 in $t6
    lw $t0, 0($t4)         # store value of num1 in $t0
    lw $t1, 0($t5)         # store value of num1 in $t1
    lw $t2, 0($t6)         # store value of num1 in $t2
    addi $v0, $0, 4        # syscall number 4 -- print string
    la $a0, strCT
    syscall 
    
    # STEP 2 -- Run the loop and print output
    add $t4, $t2, $t1            # $t4 = $t2 + $t1
    loopp1: addi $v0, $0, 1      # syscall number 1 -- print an integer
            addi $a0, $t4, 0     # put in $a0 the values for printing
            syscall              # actually print the integer
            li $v0, 4            # syscall number 4 -- print string
            la $a0, strCR        # Location of string loaded in$a0
            syscall              # actually print the string
            addi $t4, $t4, 1     # increase $t4 to the next value
            bne $t4, $t0, loopp1 # iterate over the loop
    
    # STEP 3 -- exit
    addi $v0, $0, 10  # Syscall number 10 is to terminate the program
    syscall           # exit now
