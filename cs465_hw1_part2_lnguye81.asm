#Luan Nguyen 01299044
#Algorithm of the program, especially the gcd function.
#The gcd function begins by creating space on the stack for the return address and saving the main function's return address in the stack frame.
#It jumps to the loop label to start the GCD calculation.
#In the loop:
#It checks if b (in register $a1) is equal to 0 using beq $a1, 0, endLoop. If b is 0, it jumps to endLoop to exit the loop.
#It temporarily saves the values of a and b in $t1 and $t2, respectively.
#It calls the rem function to calculate the remainder of a divided by b and stores the result in $v0.
#It updates b with the value in $v0.
#It updates a with the value in $t2, effectively swapping the values of a and b.
#It jumps back to the loop label to continue the loop.
#When b becomes 0 (i.e., the beq $a1, 0, endLoop condition is met), the program proceeds to the endLoop label.
#It moves the result (the GCD) stored in a to $v0.
#It reloads the return address from the stack into $ra.
#It deallocates the stack space.
#Finally, it returns to the caller by executing jr $ra.



.data
prompt1:  .asciiz "Enter the first integer: "
prompt2:  .asciiz "Enter the second integer: "
result_str: .asciiz "GCD of the two numbers is: "

.text
main:
    # Print prompt for the first number
    li $v0, 4
    la $a0, prompt1
    syscall

    # Read first integer
    li $v0, 5
    syscall
    move $s0, $v0

    # Print prompt for the second number
    li $v0, 4
    la $a0, prompt2
    syscall

    # Read second integer
    li $v0, 5
    syscall
    move $a1, $v0
    
    # Restore first integer from temporary location
    move $a0, $s0

    # Call gcd function
    jal gcd
    
    # Save the result from gcd
    move $s0, $v0

    # Print the result
    li $v0, 4
    la $a0, result_str
    syscall

    move $a0, $s0
    li $v0, 1
    syscall

    # Exit
    li $v0, 10
    syscall

# ... (your gcd function here)
#   a0 a, a1 b
gcd:
    addi $sp, $sp, -4	#create stack space 
    sw $ra, 0($sp)	#store main return    
    j loop
loop:			# here is the loop that does most of the work calculating gcd
    beq $a1, 0, endLoop # while b!= 0
    add $t1, $a0, $zero # temp1 = a
    add $t2, $a1, $zero # temp2 = b
    jal rem		# get the remainder temp%b

    add $a1, $v0, $zero # b = temp%b
    add $a0, $t2, $zero # a = b
    j loop
endLoop:
	
    move $v0, $a0
    lw $ra, 0($sp)	#reload $ra that would return to the main caller
    addi $sp, $sp, 4	#deallocate stack
    jr $ra
rem:
    # Compute remainder: $t0 = $a0 % $a1
    rem $t0, $a0, $a1 

    # Return remainder in $v0 and then return to the caller
    move $v0, $t0
    jr $ra
