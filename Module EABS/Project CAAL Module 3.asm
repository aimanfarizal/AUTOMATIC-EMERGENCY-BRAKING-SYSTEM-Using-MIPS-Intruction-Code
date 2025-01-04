.data

CarState: .word 1           # Car state (1 = on, 0 = off)
WelcomeMsg:		.asciiz "\nWelcome to Proton, Car is Starting, Have a Nice Journey!!\n"
ExitMsg:	.asciiz "\nGood Byee!"
CheckCarStateMsg: .asciiz "\nEnter 1 to Continue the Car, Enter 0 to Stop/End the Car: "

.text
main:
    # Print Welcome prompt
    li $v0, 4               # syscall code for print_string
    la $a0, WelcomeMsg          # load address of the prompt
    syscall

    lw $t0, CarState       # Load car state, automatically 1 as system start means car is starting.
    beq $t0, $zero, exit # If car is off, exit
    
check_car_state:
    # Print Input Current State of Car prompt
    li $v0, 4               # syscall code for print_string
    la $a0, CheckCarStateMsg           # load address of the prompt
    syscall
    
    # Input current state of car
    li $v0, 5            # Read integer syscall
    syscall
    move $t0, $v0        # Store user input in $t0
    
    sw $t0, CarState       # Load car state
    beq $t0, $zero, exit # If car is off, go to exit function
    beq $t0, 1, main  #Meaning car is still turn on, repeate the cycle from scan obstacle


exit:
# Print Exit Message
    li $v0, 4               # syscall code for print_string
    la $a0, ExitMsg          # load address of the prompt
    syscall
    
    # End program
    li $v0, 10           # Exit syscall / End Program
    syscall