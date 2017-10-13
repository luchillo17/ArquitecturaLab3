.data 
	questionMessage: .asciiz "Seleccionar operacion: (0) Promedio pares, (1) Remplaza impares de V2 en pares de V1:\n"
	divErrorMessage: .asciiz "Error division por cero.\n"
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
		# Initialize average & counter through stack
		addi $t2, $zero, 0
		addi $t3, $zero, 0
	
		# Get initial vec0
		la $t0, vec0($zero)
		loop:
			# Compare with flag then send to exitLoop
			lw $t1, ($t0)
			beq $t1, -9999, exitLoop
			
			# If not pair go to isNotPair
			addi $a0, $t1, 0
			addi $a1, $zero, 2
			
			jal divide
			
			bnez $v1, continue
			
		# Calculate pair amount & summation
			add $t2, $t2, $t1
			addi $t3, $zero, 1
			
		continue:
			
			addi $t0, $t0, 4
			j loop

		exitLoop:
		# Divide summation by amount
			addi $a0, $t2, 0
			addi $a1, $t3, 0			

			jal divide
		
		# Insert average at end of array
			sw $v0, 0($t0)
			addi $t3, $zero, -9999
			sw $t3, 1($t0)
		
			# Print array			
			la $a0, vec0($zero)
			jal printVector
	
	# To this point the program is done
	li $v0, 10
	syscall
	
	replacePairsByOdds:
		# Move vec0 1 ahead
		
		# Loop through vec0 & replace with vec1
		
		addi $a0, $zero, 1
		addi $v0, $zero, 1
		syscall
	
	# To this point the program is done
	li $v0, 10
	syscall
	
	divide: 		
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
			beq $t5, $zero, decimal 
			
			# Substraer y contar
			sub  $t4, $t4, $a1
			addi $t0, $t0, 1		
			
			j integer
			
		decimal:  	
			addi $v1, $t4, 0 # Modulo
			mul $t4, $t4, 10
			
		float:
			
			sge $t5, $t4, $a1 			
			beq $t5, $zero, divEnd 
			
			# Substraer y contar
			sub $t4, $t4, $a1
			addi $t1, $t1, 1
				
			j float
						 				 		
		divEnd: 
			sge $t0, $t1, 5
			beq $t0, $zero, divReturn
			
			addi $t0, $t0, 1
			
		divReturn:
			# Use flag to calculate sign of result
			mul $t0, $t0, $t6
			
			# Output
			addi $v0, $t0, 0
			jr $ra
