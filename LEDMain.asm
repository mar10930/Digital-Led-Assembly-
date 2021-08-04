
.text
  jal InitializeLED
  loop:
    jal TurnOnLED	# Turn On
    li $v0, 32          # Syscall for a delay
    li $a0, 1000        # 1000 milliseconds
    syscall
    jal TurnOffLED      # Turn Off
    li $v0, 32 # Syscall for a delay
    li $a0, 1000 # 1000 milliseconds
    syscall
    jal ToggleLED       # Should Turn On
    li $v0, 32 # Syscall for a delay
    li $a0, 1000 # 1000 milliseconds
    syscall
    jal ToggleLED	# Should Turn Off
    li $v0, 32 # Syscall for a delay
    li $a0, 1000 # 1000 milliseconds
    syscall
    jal ToggleLED	# Should Turn On
    li $v0, 32 # Syscall for a delay
    li $a0, 1000 # 1000 milliseconds
    syscall
    jal TurnOnLED	# Should do nothing
    li $v0, 32 # Syscall for a delay
    li $a0, 1000 # 1000 milliseconds
    syscall
    jal TurnOffLED	# Should Turn Off
    li $v0, 32 # Syscall for a delay
    li $a0, 1000 # 1000 milliseconds
    b loop
    
    li $v0, 10
    syscall

.include "LED.asm"

