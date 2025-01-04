.data
obstacle: .word 0        # Obstacle flag (0 = no obstacle, 1 = obstacle detected)
speed: .word 0           # Current speed
distance: .word 0        # Distance to obstacle
speedinms: .word         # Current speed in m/s
TTCValue:      .word 0          # Time-to-collision (TTC) variable
CarState: .word 1           # Car state (1 = on, 0 = off)
WelcomeMsg:		.asciiz "Welcome to Proton, Car is Starting, Have a Nice Journey!!\n"
ExitMsg:	.asciiz "\nGood Byee!"
ObstaclePrompt:	.asciiz  "\nRadar/Camera: Enter 1 If There is Obstacle in Front, if None Enter 0: "
DistancePrompt: .asciiz  "\n\nRadar: Input distance between obstacle in meter: "
SpeedPrompt: .asciiz "\nWheel Speed Sensor: Input speed in Km/h: "
SpeedinmsPrompt: .asciiz "Dashboard Indicator: Current Speed in m/s: "
BrakeAlertMsg: .asciiz "\nHazard Alert on Dashboard: Obstacle detected. Manual brake required.\n"
EmergencyBrakeMsg: .asciiz "\nBrake: Automatic Emergency Brake is Triggered!"
RearLightMsg:	.asciiz "\nRear Light: Braking Light is Triggered\n"
CheckCarStateMsg: .asciiz "\nEnter 1 to Continue the Car, Enter 0 to Stop/End the Car: "
TTCMsg:      .asciiz "\nTime to Collision (second) : "  # Message to display

.text
main:
    # Print Welcome prompt
    li $v0, 4               # syscall code for print_string
    la $a0, WelcomeMsg          # load address of the prompt
    syscall

    lw $t0, CarState       # Load car state, automatically 1 as system start means car is starting.
    beq $t0, $zero, exit # If car is off, exit

scan_obstacle:
    # Print Obstacle prompt
    li $v0, 4               # syscall code for print_string
    la $a0, ObstaclePrompt          # load address of the prompt
    syscall
    
    # Input obstacle presence (1 = obstacle, 0 = no obstacle)
    li $v0, 5            # Read integer syscall
    syscall
    move $t1, $v0        # Store user input in $t1
    sw $t1, obstacle     # Save the value to 'obstacle'
    beq $t1, $zero, scan_obstacle # If no obstacle, keep scanning

    # Obstacle detected
    jal scan_speed       # Call speed scanning function
    jal scan_distance    # Call distance scanning fuction
    jal calculate_brake  # Call brake calculation function

alert_driver:
    # Alert driver (manual braking required)
    li $v0, 4
    la $a0, BrakeAlertMsg	#Printing BrakeAlertMsg, Simulating Dashboard indicator 
    syscall
    j check_car_state               # Go to loop check Function

emergency_brake:
    # Trigger emergency braking
    li $v0, 4
    la $a0, EmergencyBrakeMsg	#Printing EmergencyBrakeMsg, Simulating Brake is being used Automatically
    syscall
    
    # Trigger emergency braking rear light
    li $v0, 4
    la $a0, RearLightMsg	#Printing RearLightMsg, Simulating Rear Lighr is On as Brake is on Proccess
    syscall
    
    j check_car_state               # Go to loop check Function

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
    beq $t0, 1, scan_obstacle  #Meaning car is still turn on, repeate the cycle from scan obstacle


exit:
# Print Exit Message
    li $v0, 4               # syscall code for print_string
    la $a0, ExitMsg          # load address of the prompt
    syscall
    
    # End program
    li $v0, 10           # Exit syscall / End Program
    syscall

# Subroutine: Scan Speed
scan_speed:
    # Print Speed prompt
    li $v0, 4               # syscall code for print_string
    la $a0, SpeedPrompt          # load address of the prompt
    syscall
    
    # Input current speed
    li $v0, 5            # Read integer syscall
    syscall
    move $t2, $v0        # Store user input in $t2
    sw $t2, speed        # Save the value to 'speed'
    
    # Load speed
    lw $t5, speed            # $t5 = speed
    
    # Multiply speed by 1000
    li $t1, 1000              # $t1 = 1000
    mul $t6, $t5, $t1       # $t6 = speed * 1000
    
    # Divide by 3600
    li $t1, 3600              # $t1 = 36
    div $t7, $t6, $t1            # $t7 = (speed * 1000) / 3600
    
    # Store result in speedinms
    sw $t7, speedinms       # Store m/s value in memory
    
    # Print Speed prompt
    li $v0, 4               # syscall code for print_string
    la $a0, SpeedinmsPrompt          # load address of the prompt
    syscall
    
    #Print Speed in m/s
    lw $a0, speedinms              # Load the value of 'num' into $a0 (argument register)
    li $v0, 1                # Load the syscall code for print integer (1) into $v0
    syscall                  # Perform the system call
    jr $ra

# Subroutine: Scan Distance
scan_distance:
# Print Distance prompt
    li $v0, 4               # syscall code for print_string
    la $a0, DistancePrompt          # load address of the prompt
    syscall
    
    # Input distance to obstacle
    li $v0, 5            # Read integer syscall
    syscall
    move $t2, $v0        # Store user input in $t2
    sw $t2, distance     # Save the value to 'distance'
    jr $ra

# Subroutine: Calculate Safe Braking
calculate_brake:
    # Placeholder for safe braking calculation
    # Load distance and speed
    lw $t4, distance         # $t4 = distance
    lw $t5, speedinms            # $t5 = speed

    # Calculate Time-to-Collision (TTC)
    div $t7, $t4, $t5        # $t7 = distance / speedinms
    sw $t7, TTCValue              # Store result in TTC variable

    # Display "TTC: "
    li $v0, 4                # Syscall for printing string
    la $a0, TTCMsg              # Load address of message
    syscall

    # Display TTC value
    lw $a0, TTCValue              # Load TTC value into $a0
    li $v0, 1                # Syscall for printing integer
    syscall

    # Compare with threshold
    li $t8, 2                # Set threshold to 2 (approx 1.5)
    ble $t7, $t8, emergency_brake  # If TTC <= 2, trigger emergency brake
    
    bgez $t6, alert_driver   # Safe to brake, alert driver
