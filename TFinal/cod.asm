.data
	bemVindo: .asciiz "\t\t\t\t***INSTRUCÕES***\n"  
	instrucoes: .asciiz "   Você deve completar o tabuleiro em todo lugar que haja o número 0.\n   Será perguntado qual número você quer por em seu lugar, o índice da linha e o da coluna.\n\t\t\t\t **Boa sorte**\n"
	easy: .asciiz "1.Easy\n"
	new_row: .asciiz "|\n"
	sep_tab_horiz: .asciiz " ------------------------------------\n"
	sep_tab_vert: .asciiz " | "
	error_msg: .asciiz "Você errou!  \\(° - ° )/ \n"
	corr_msg: .asciiz "Você acertou!  \\(°V°)/ \n"
	nr: .asciiz "Qual número você deseja adicionar?\n"
	linha: .asciiz "índice da linha:\n"
	col: .asciiz "índice da coluna:\n"
	level1: .asciiz "Level 1\n"
easy1:      .byte     0, 0, 8, 3, 0, 9, 1, 0, 0
            .byte     9, 0, 0, 0, 6, 0, 0, 0, 4
            .byte     0, 0, 7, 5, 0, 4, 8, 0, 0
            .byte     0, 3, 6, 0, 0, 0, 5, 4, 0
            .byte     0, 0, 1, 0, 0, 0, 6, 0, 0
            .byte     0, 4, 2, 0, 0, 0, 9, 7, 0
            .byte     0, 0, 5, 9, 0, 7, 3, 0, 0
            .byte     6, 0, 0, 0, 1, 0, 0, 0, 8
            .byte     0, 0, 4, 6, 0, 8, 2, 0, 0
            
.text
	li $v0,4 #Load print_string syscall number in $v0
	la $a0,bemVindo #Load address of string to print
	syscall #Execute the syscall
	li $v0,4 #Load print_string syscall number in $v0
	la $a0,instrucoes #Load address of string to print
	syscall #Execute the syscall
	li $v0,4 #Load print_string syscall number in $v0
	la $a0,easy #Load address of string to print
	syscall #Execute the syscal
	
	li $v0,5#load read_int syscall number in $v0
	syscall #Execute the syscall
	beq $v0,1,EASY #choice==1 ==> easy

	j ENDGAME
	
	EASY:
	#level1:
	li $v0,4 #Load print_string syscall number in $v0
	la $a0,level1 #Load address of string to print
	syscall #Execute the syscall
	la $a0,easy1 #Load address of a 2D array
	jal print_board #jump and link to funtion "print_baord"
	la $a0,easy1 #Load address of a 2D array
	jal guess #jump and link to function "guess"
	
	
	j ENDGAME
	
	ENDGAME:
	li $v0,10 #Syscell number in $v0 for termination
	syscall #Execute the syscall
	print_board:
	# Set up the stack frame
	sub $sp, $sp, 16 # Make room on the stack to save registers
	sw $ra, 12($sp) # Save the return address
	sw $s2, 8($sp) # Save the $s2 register
	sw $s1, 4($sp) # Save the $s1 register
	sw $s0, 0($sp) # Save the $s0 register
	# Initialize registers
	move $s0,$a0 # $s0 points to the cell to print
	move $s1, $zero # $s1 keeps track of the current row
	move $s2, $zero # $s2 keeps track of the current column
	# Print top border
	la $a0, sep_tab_horiz # Load the address of the string to print
	li $v0, 4 # Load print_string syscall number in $v0
	syscall # Execute the syscall
	print_cell:
	# Print the cell's vertical border
	la $a0, sep_tab_vert # Load the address of the string to print
	li $v0, 4 # Load print_string syscall number in $v0
	syscall # Execute the syscall
	# Print the number in the current cell
	lb $a0, ($s0) # Load the address of the number to print
	li $v0, 1 # Load print_int syscall number in $v0
	syscall # Execute the syscall
	addi $s0, $s0, 1 # Point to the next board cell
	addi $s2, $s2, 1 # Increment the column counter
	blt $s2, 9, print_cell # Iterate the loop until the row is completed
	# Row completed: print the rightmost border and a new separator
	la $a0, new_row # Load the address of the string to print
	li $v0, 4 # Load print_string syscall number in $v0
	syscall # Execute the syscall
	move $s2, $zero # Reset the column counter
	addi $s1, $s1, 1 # Increment the row counter
	# Print the next row
	blt $s1,9, print_cell # Restart the loop until the table is cmplete
	# Destroy the stack frame
	lw $s0, 0($sp) # Restore the $s0 register
	lw $s1, 4($sp) # Restore the $s1 register
	lw $s2, 8($sp) # Restore the $s2 register
	lw $ra, 12($sp) # Restore the return address
	addi $sp, $sp, 16 # Clean up the stack
	jr $ra # Return
	guess:
	# Set up the stack frame
	subi $sp, $sp, 16 # Make room on the stack to save registers
	sw $ra, 12($sp) # Save the return address
	sw $s2, 8($sp) # Save the $s2 register
	sw $s1, 4($sp) # Save the $s1 register
	sw $s0, 0($sp) # Save the $s0 register
	# Initialize registers
	
	# imprime fundo do tabuleiro pq se não ficava estranho                //Anna
	la $a0, sep_tab_horiz # Load the address of the string to print
	li $v0, 4 # Load print_string syscall number in $v0
	syscall # Execute the syscall
	
	move $s0,$a0 # $s0 points to the cell
	li $v0,4 #load print_string syscall number in $v0
	la $a0,nr #load sring address to print
	syscall #Execute the syscall
	li $v0,5 #load read_int syscall address in $v0
	syscall #Execute the syscall
	move $t0,$v0 #number entered
	li $v0,4 #load print_string syscall number in $v0
	la $a0,linha #load string address to print
	syscall #execute the syscall
	li $v0,5 #load read_int syscall address in $v0
	syscall #Execute the syscall
	move $t1,$v0 #row index
	li $v0,4 #load print_string syscall number in $v0
	la $a0,col #load string address to print
	syscall #execute the syscall
	li $v0,5 #load read_int syscall number in $v0
	syscall #execute the syscall
	move $t2,$v0 #column index
	move $a0,$s0 #board address
	move $a1,$t0 #number entered
	move $a2,$t1 #row index
	move $a3,$t2 #column index
	move $t5,$s0
	jal check
	beqz $v0,correct
	li $v0,4 #Load print_string syscall number in $v0
	la $a0,error_msg #Load string address to print
	syscall #Execute the syscall
	move $a0,$s0 #board address
	jal guess #guess again...
	correct:
	li $v0,4 #Load print_string syscall number in v0
	la $a0,corr_msg #Load string address to print
	syscall #Execute the syscall
	move $a0,$s0 #board address
	jal FULL
	beqz $v0,notfull
	# Destroy the stack frame
	lw $s0, 0($sp) # Restore the $s0 register
	lw $s1, 4($sp) # Restore the $s1 register
	lw $s2, 8($sp) # Restore the $s2 register
	lw $ra, 12($sp) # Restore the return address
	addi $sp, $sp, 16 # Clean up the stack
	jr $ra # Return
	notfull:
	move $a0,$s0 #board address
	jal guess
	check:
	subi $sp,$sp,4 #make room in the stack
	sw $ra,($sp) #Save $ra register
	move $s0,$a0 #board address
	move $t9,$a1 #number entered
	#Row check
	li $t0,9 #Set counter
	mul $t1,$a2,$t0 #Offset of the first cell in the row
	check_row:
	add $s1,$s0,$t1
	lb $t2,($s1) # Value in the current cell
	beq $t2,$t9,check_ret_fail #Number already present in row
	addi $t1,$t1,1 #Increment the pointer to the current cell
	subi $t0,$t0,1 # Decrement the counter
	bnez $t0,check_row # Check the next cell in the row
	#Column check
	move $t1,$a3 #Offset of the first cell in the column
	check_col:
	add $s1,$s0,$t1
	lb $t2,($s1) # Value of the current cell
	beq $t2,$t9,check_ret_fail # Number already present in column
	addi $t1,$t1,9 # Increment the pointer to the current cell
	ble $t1,81,check_col # Check the next cell in the column
	# 3x3-Box check
	div $t0,$a2,3 #$t0=row/3
	mul $t0,$t0,27 #Offset of the row
	div $t1,$a3,3 #$t3= col / 3
	mul $t1,$t1,3 #Offset of the column
	add $t1,$t0,$t1 # Offset of the first cell in the box
	li  $t0, 3 # Set up the row counter
    	li  $t3, 3 # Set up the column counter
    	check_box:
    	add $s1,$s0,$t1 
    	lb $t6,($s1) # Value of the current cell
    	beq $t9,$t6,check_ret_fail #Number already present in column
    	subi $t3,$t3,1 #Decrement the column counter
    	beqz $t3,end_box_row # Check if end of current box row is reached
    	addi $t1,$t1,1 #Increment the pointer to the current cell
    	j check_box
    	end_box_row:
    	addi $t1,$t1,7 # Increment the pointer to the current cell
    	li $t3,3 #Reset column counter
    	subi $t0,$t0,1 #Decrement the row counter
    	bnez $t0,check_box # Check if end of box is reached
    	li $t8,9
    	mul $t7,$a2,$t8 #9*row_index
    	add $t7,$a3,$t7 #9*row_index+column_index
    	add $s1,$s0,$t7
    	sb $t9,($s1) #store byte
    	move $a0,$s0
    	jal print_board
    	move $v0,$zero #Return code is 0 (success)
    	j check_ret #Jump to the return instrucoes
    	check_ret_fail:
    	li $t8,9
    	mul $t7,$a2,$t8 #9*row_index
    	add $t7,$a3,$t7 #9*row_index+column_index
    	add $s1,$s0,$t7
    	sb $t9,($s1) #store byte
    	move $a0,$s0
    	jal print_board
    	li $v0,1 #Return code is 1 (failure)
    	check_ret:
    	lw $ra,($sp) #Restore $ra register
    	addi $sp,$sp,4 #Clean up the stack frame
    	jr $ra #Return
	FULL:
	move $s0,$a0 #board address
	move $s1,$zero #row counter
	move $s2,$zero #column counter
	move $t0,$s0 #save
	li $t2,9
	for1:
	mul $t1,$s1,$t2
	for2:
	add $t3,$t1,$s2
	add $s0,$s0,$t3
	lb $t4,($s0)
	beqz $t4,NOTFULL
	addi $s2,$s2,1
	beq $s2,9,end2
	j for2
	end2:
	addi $s1,$s1,1
	beq $s1,9,end1
	move $s2,$zero #Reset column counter
	j for1
	end1:
	li $v0,1 #full
	jr $ra
	NOTFULL:
	move $v0,$zero #Not Full
	jr $ra
