.data
obstacle: .word 0        # Obstacle flag (0 = no obstacle, 1 = obstacle detected)
speed: .word 0           # Current speed
distance: .word 0        # Distance to obstacle
ObstaclePrompt:	.asciiz  "\nRadar/Camera: Enter 1 If There is Obstacle in Front, if None Enter 0: "
DistancePrompt: .asciiz  "\nRadar: Input distance between obstacle in meter: "
SpeedPrompt: .asciiz "\nWheel Speed Sensor: Input speed in Km/h: "
CurrentSpeedDisplay: .asciiz "\nCurrent Speed (Km/h): "
DistanceDisplay: .asciiz "\nDistance Between Obstacle (meter): "

.text

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
    jal scan_speed       # Call speed scanning
    jal scan_distance    # Call distance scanning
    
    #Print Current Speed
    li $v0, 4               # syscall code for print_string
    la $a0, CurrentSpeedDisplay          # load address of the prompt
    syscall
    lw $a0, speed              # Load the value of 'num' into $a0 (argument register)
    li $v0, 1                # Load the syscall code for print integer (1) into $v0
    syscall                  # Perform the system call
    
    #Print Current Distance with obstacle
    li $v0, 4               # syscall code for print_string
    la $a0, DistanceDisplay          # load address of the prompt
    syscall
    lw $a0, distance              # Load the value of 'num' into $a0 (argument register)
    li $v0, 1                # Load the syscall code for print integer (1) into $v0
    syscall                  # Perform the system call
    
    # End program
    li $v0, 10           # Exit syscall
    syscall
    
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
    jr $ra

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
