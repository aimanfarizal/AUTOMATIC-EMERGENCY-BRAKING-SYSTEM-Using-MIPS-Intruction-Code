.data
speed: .word 90           # Current speed
distance: .word 50        # Distance to obstacle
CurrentSpeedDisplay: .asciiz "\nCurrent Speed (Km/h): "
DistanceDisplay: .asciiz "\nDistance Between Obstacle (meter): "
BrakeAlertMsg: .asciiz "\nHazard Alert on Dashboard: Obstacle detected. Manual brake required.\n"
EmergencyBrakeMsg: .asciiz "\nBrake: Automatic Emergency Brake is Triggered!"

.text
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

    # Assuming braking is safe if distance > speed
    lw $t4, distance
    lw $t5, speed
    sub $t6, $t4, $t5
    blez $t6, emergency_brake
    
    # Safe to brake
    bgez $t6, alert_driver
    
alert_driver:
    # Alert driver (manual braking required)
    li $v0, 4
    la $a0, BrakeAlertMsg
    syscall
    
    # End program
    li $v0, 10           # Exit syscall
    syscall

emergency_brake:
    # Trigger emergency braking
    li $v0, 4
    la $a0, EmergencyBrakeMsg
    syscall
    
    # End program
    li $v0, 10           # Exit syscall
    syscall
    
    
