.data 
	questionMessage: .asciiz "Seleccionar operacion: (0) Promedio pares, (1) Remplaza impares de V2 en pares de V1:\n"
	divErrorMessage: .asciiz "Error division por cero.\n"
	spaceMessage: .asciiz " "
	errorMessage: .asciiz "Error, ingrese 0 o 1.\n"
	vec0: .word 3, 1, 2, 4, 7, 6, -9999
	
	vec1: .word 9, 4, 7, 5, 3, 2, 8, 6, -9999
	
.text
	main:		
		# Print question for user input
		la $a0, questionMessage
		addi $v0, $zero, 4
		syscall
		
		# Get integer from user for operation type
		addi $v0, $zero, 5
		syscall
		
		# Branch by operation
		beqz $v0, averagePairs
		beq $v0, 1, replacePairsByOdds
		
		# Print error before loop to main
		la $a0, errorMessage
		addi $v0, $zero, 4
		syscall
		
		j main
	
	# To this point the program is done
	li $v0, 10
	syscall
	
	averagePairs:
# Conventions:
# 	$t0 -> vec0
# 	$t1 -> vec0 value
# 	$t2 -> pairs sum|average
# 	$t3 -> pairs amount

		# Save in stack the previous values of t(0..3)
		addi $sp, $sp, -16
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		# Initialize average & counter through stack
		addi $t2, $zero, 0
		addi $t3, $zero, 0
	
		# Get initial vec0
		la $t0, vec0($zero)
		
		loopAverage:
			# Compare with flag then send to exitLoop
			lw $t1, 0($t0)
			beq $t1, -9999, exitLoopAverage
			
			# If not pair go to isNotPair
			addi $a0, $t1, 0
			addi $a1, $zero, 2
			
			jal divide
			
			bnez $v1, continueAverage # Module 0 means is pair, so if not continue
			
			# Calculate pair amount & summation
			add $t2, $t2, $t1
			addi $t3, $t3, 1
			
		continueAverage:
			
			addi $t0, $t0, 4
			j loopAverage

		exitLoopAverage:
			# Divide summation by amount
			addi $a0, $t2, 0
			addi $a1, $t3, 0			

			jal divide
			
			# Insert average at end of array
			sw $v0, 0($t0)
			addi $t3, $zero, -9999
			sw $t3, 4($t0)
			
			# Print array			
			la $a0, vec0($zero)
			jal printVector

		# Load previous values of t(0..3) & release stack
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		addi $sp, $sp, 16
	
	# To this point the program is done
	li $v0, 10
	syscall
	
	replacePairsByOdds:
	
		# Save in stack the previous values of t(0..4).
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)
		
		# Get initial vec0 & vec1
		la $t0, vec0($zero)
		la $t1, vec1($zero)
		
		# Move vec0 1 ahead & test vec1 position
		lw $t2, 0($t1)
		beq $t2, -9999, exitReplace
		addi $t1, $t1, 4
		
		addi $t4, $zero, 1
		
		# Loop through vec0 & replace with vec1
		loopReplace:
			lw $t2, 0($t0)
			lw $t3, 0($t1)
			beq $t2, -9999, exitReplace
			beq $t3, -9999, exitReplace
			bne $t4, 1, continueLoop
			
			sw $t3, 0($t0)
			
		continueLoop:
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			mul $t4, $t4, -1
			j loopReplace
			
		exitReplace:
		
			# Print array			
			la $a0, vec0($zero)
			
			jal printVector
			
			# Load previous values of t(0..4) & release stack
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
			lw $t4, 16($sp)
			addi $sp, $sp, 20
			
	# To this point the program is done
	li $v0, 10
	syscall
	
	printVector:
		# Save in stack the previous values of t0
		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $ra, 4($sp)
		
		addi $t0, $a0, 0
		loopPrint:
			# Compare with flag then send to exitLoop
			lw $a0, 0($t0)
			beq $a0, -9999, exitLoopPrint
			
			addi $v0, $zero, 1
			syscall
			
			jal printSpace
			
			addi $t0, $t0, 4
			j loopPrint

		exitLoopPrint:
		
			# Load previous values of t0 & release stack
			lw $t0, 0($sp)
			lw $ra, 4($sp)
			addi $sp, $sp, 8
			
			jr $ra
	
	divide:
		# Save in stack the previous values of t(0..7)
		addi $sp, $sp, -32
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)
		sw $t5, 20($sp)
		sw $t6, 24($sp)
		sw $t7, 28($sp)
		
		# Numero entero 		
		add  $t0, $zero, $zero
		# Numero decimal 		
		add  $t1, $zero, $zero
		# Cantidad de numeros decimales actuales 		
		addi $t2, $zero, 0 		
		# Cantidad de numeros decimales maximo 		
		addi $t3, $zero, 2 		 		
		
		# Acumulador
		add $t4, $a0, $zero
		
		# Negative flag
		addi $t6, $zero, 1
		
		# Invert if arg 1 is negative
		slt $t7, $a0, $zero
		beqz $t7, positive1
		
		mul $a0, $a0, -1
		mul $t6, $t6, -1
		
		positive1:
			# Invert if arg 2 is negative
			slt $t7, $a1, $zero
			beqz $t7, positive2
		
			mul $a1, $a1, -1
			mul $t6, $t6, -1
		
		positive2:
		
		# 0 division error
		bnez $a1, integer
		
		divError:
			addi $v0, $zero, 55
			addi $a1, $zero, 0
			la $a0, divErrorMessage
			syscall
		
		integer: 			
			sge $t5, $t4, $a1 			
			beq $t5, $zero, divEnd 
			
			# Substraer y contar
			sub  $t4, $t4, $a1
			addi $t0, $t0, 1
			
			j integer
						 				 		
		divEnd: 
			addi $v1, $t4, 0 # Modulo
			
			# Use flag to calculate sign of result
			mul $t0, $t0, $t6
			
			# Output
			addi $v0, $t0, 0
			
			# Load previous values of t(0..7) & release stack

			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
			lw $t4, 16($sp)
			lw $t5, 20($sp)
			lw $t6, 24($sp)
			lw $t7, 28($sp)
			addi $sp, $sp, 32
			
			jr $ra
	
	printSpace:
		# Save in stack the previous values of a0
		addi $sp, $sp, -4
		sw $a0, 0($sp)
		
		la $a0, spaceMessage
		addi $v0, $zero, 4
		syscall
		
		# Load previous values of a0 & release stack
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		
		jr $ra
