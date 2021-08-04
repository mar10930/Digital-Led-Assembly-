#Name: Mario Luja
#Date: May/14/2021
#Purpose: The purpose of the assignment is to assign
#values to the heap in order to produce an LED
#light.
#Colors used for light 
#Gray: 757171
#Dark red(off): a32e2e
#Light Red (On): fc0000
.eqv	GRAY	0x00757171
.eqv	OFFRED	0x00a32e2e
.eqv	ONRED	0x00fc0000

#Subprogram Name: InitializeLED
# Author: Mario Luja
# purpose: Allocates memory in the heap
# input: none
# returns: The base address of the heap ($v0)
# side effects: None
.data
BASEADRESS:	.word	0x10040000
STATE:	.word	1
.text
InitializeLED:
	addi $sp, $sp, -4	#Make room in the stack using stack pointer
 	 sw $ra, 0($sp)		# Store the return address in the stack

 	#Memory allocation to heap
  	li $a0, 4096		# Allocate 4096 bytes of the heap
  	li $v0, 9		    # Allocates the memory into the heap
  	syscall         # End instruction

  	sw $v0, BASEADRESS #we are storing $v0 into BaseAddress

	# Epilogue
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


#Subprogram Name: TurnOnLED
# Author: Mario Luja
# purpose: Allocates ONRED color onto each specified 
#location in the heap
# input: none
# returns: None
# side effects: Updates the state to 0 (off)
.text
TurnOnLED:
	addi $sp, $sp, -4	#Make room in the stack using stack pointer
	sw $ra, 0($sp)	#Store the return address in the stack
	
	lw $a1,BASEADRESS	#Load base address of heap in $a1
	li $s1,OFFRED	#Load the hex value for OFFRED in $s1
	li $s2,GRAY	#Load hex value for GRAY in $s2
	li $s3,ONRED	#Load hex value for ONRED in $s3
	addi $t2,$a1,1388	#Position in heap where color placement will start

	
	li $t0,0	#Load $t0 with 0 as a counter
	sw $s3,0($t2)	#Loads the specified location with ONRED color
	
	#Loop to place top portion of LED with ONRED
	upperOn:
		slti $t1,$t0,9	#If $t0 <9 then $t1 = 1 
		beqz $t1,endUpperOn	#If $t1 =0 then branch to endUpperOn
		addi $t2,$t2,4	#Add 4 bytes to the the position in heap to traverse
		sw $s3,0($t2)	#Store ONRED color in new loaction in heap
		addi $t0,$t0,1	#Add 1 to the loop counter
		b upperOn	#Branch back to upperOn loop
	
   	endUpperOn:
        	addi $t2,$a1,1640	#Position in heap where color placement will start (next row)
		li $t3,0	#Load $t0 with 0 as a counter
		li $t5,0	#$t5 is assigned value of 0 
		
   	#Assigns rest of heap in order to produce an ON LED image
   	onLED:	
		slti $t4,$t3,25	#Check if $t3 < 25, then $t4 =1
		beqz $t4,endOn	#If $t4 = 0, then branch to endOn
		addi $t3,$t3,1	#Add 1 to $t3 (loop counter)
		add $t2,$t2,$t5	#Add heap address by $t5 to move onto the next row
		li $t5,208	#Add $t5 by 208 to move heap onto next row
		li $t0,0	#Assign 0 to $t0 to use as loop counter for restOn
		restOn:
			slti $t1,$t0,12	#Check if $t0 <12, then $t1 =1
			beqz $t1,onLED	#If $t1 =0, branch to onLed
			sw $s3,0($t2)	#Store ONRED color onto baseadress of heap
			addi $t2,$t2,4	#Add 4 to move through heap
			addi $t0,$t0,1	#Add 1 to $t0, the program counter
			b restOn	#Branch to restOn
	endOn:
		addi $t2,$t2,220	#End LED bulb and go to next row
		sw $s2,0($t2)	#Store GRAY onto the heap location stored in $t2
		addi $t2,$t2,16	#Store another Gray 4 pixels apart
		sw $s2,0($t2)	#Store GRAY in current heap location	
	
		li $t3 0	#Set loop counter $t3 to 0
		
	#Creates the pin image of the LED
	plugLoopOn:
		slti $t4,$t3,20	# Set $t4 = 1 if $t3 < 20
		beqz $t4,endPlugOn	#If $t4= 0, branch to endPlugOn
		addi $t2,$t2,240	#Add 243 to heap base address to move to next row
		sw $s2,0($t2)	#Store GRAY color onto the base address of heap
		addi $t2,$t2,16	#Move 4 pixels
		sw $s2,0($t2)	# Place the other GRAY pixel in the same row
		addi $t3,$t3,1	#Increment loop counter by 1
		b plugLoopOn	#Branch back to plugLoopOn
			
	endPlugOn:
		li $t1,1
		sw $t1, STATE # update state 
		#Return the space in the stack to how it was	
		lw $ra, 0($sp)
     		addi $sp, $sp, 4	
		jr $ra	#Return $ra
#Subprogram Name: TurnOffLED
# Author: Mario Luja
# purpose: Allocates OFFRED color onto each specified 
#location in the heap
# input: none
# returns: None
# side effects: None		
.text
TurnOffLED:
	addi $sp, $sp, -4	#Make room in the stack using stack pointer
	sw $ra, 0($sp)	#Store the return address in the stack
	
	lw $a1,BASEADRESS	#Load base address of heap in $a1
	li $s1,OFFRED	#Load the hex value for OFFRED in $s1
	li $s2,GRAY	#Load hex value for GRAY in $s2
	li $s3,ONRED	#Load hex value for ONRED in $s3
	addi $t2,$a1,1388	#Position in heap where color placement will start
		
	li $t0,0	#Load $t0 with 0 as a counter
	sw $s1,0($t2)	#Loads the specified location with ONRED color
	#Loop to place top portion of LED with OFFRED
	upperLED:
		slti $t1,$t0,9	#If $t0 <9 then $t1 = 1 
		beqz $t1,endUpperLED	#If $t1 =0 then branch to endUpperLED
		addi $t2,$t2,4	#Add 4 bytes to the the position in heap to traverse
		sw $s1,0($t2)	#Store OFFRED color in new loaction in heap
		addi $t0,$t0,1	#Add 1 to the loop counter($t0)
		b upperLED	#Branch back to upperLED
	
   	endUpperLED:	
        	addi $t2,$a1,1640	#Position in heap where color placement will start (next row)
		li $t3,0	#Load $t0 with 0 as a counter
		li $t5,0	#$t5 is assigned value of 0 
   	offLED:	
		slti $t4,$t3,25	#Check if $t3 < 25, then $t4 =1
		beqz $t4,endOff	#If $t4 = 0, then branch to endOff
		addi $t3,$t3,1	#Add 1 to $t3 (loop counter)
		add $t2,$t2,$t5	#Add heap address by $t5 to move onto the next row
		li $t5,208	#Add $t5 by 208 to move heap onto next row
		li $t0,0	#Assign 0 to $t0 to use as loop counter for restOff
		
		restOff:
			slti $t1,$t0,12	#Check if $t0 <12, then $t1 =1
			beqz $t1,offLED	#If $t1 =0, branch to offLED
			sw $s1,0($t2)	#Store OFFRED color onto baseadress of heap
			addi $t2,$t2,4	#Add 4 to move through heap
			addi $t0,$t0,1	#Add 1 to $t0, the program counter
			b restOff	#Branch to restOff
	endOff:
		addi $t2,$t2,220	#End LED bulb and go to next row
		sw $s2,0($t2)	#Store GRAY onto the heap location stored in $t2
		addi $t2,$t2,16	#Store another Gray 4 pixels apart
		sw $s2,0($t2)	#Store GRAY in current heap location
		li $t3 0	#Set loop counter $t3 to 0	

	plugLoopOff:
		slti $t4,$t3,20	# Set $t4 = 1 if $t3 < 20
		beqz $t4,endPlugOff	#If $t4 = 0, then branch to endOn
		addi $t2,$t2,240	#Add 243 to heap base address to move to next row
		sw $s2,0($t2)	#Store GRAY color onto the base address of heap
		addi $t2,$t2,16	#Move 4 pixels
		sw $s2,0($t2)	# Place the other GRAY pixel in the same row
		addi $t3,$t3,1	#Increment loop counter by 1
		b plugLoopOff	#Branch back to plugLoopOff
		
	endPlugOff:
		li $t1,0
		sw $t1, STATE	#Change the state to 0
		#Return the space in the stack to how it was	
		lw $ra, 0($sp)
     		addi $sp, $sp, 4
		jr $ra	#Return $ra

#Subprogram Name: ToggleLED
# Author: Mario Luja
# purpose: Changes if the LED will turn off or on based on state.
# input: none
# returns: None
# side effects: Updates the state to 1 (on)
.text
ToggleLED:
	addi $sp, $sp, -4	#Make room in the stack
	sw $ra, 0($sp)	#Place $ra in the stack
	
	lw $t0,STATE	#Load the state in $t0
	beq $t0, 1, TurnOffLED	#If $t1 = 1, branch to TurnOffLED
	beq $t0, 0, TurnOnLED	#branch to TurnOnLED if $t1 =0
	
	lw $ra, 0($sp)	#Load $ra out of the stack
     	addi $sp, $sp, 4	#Return stack to how it was
	jr $ra	#Return $ra
	