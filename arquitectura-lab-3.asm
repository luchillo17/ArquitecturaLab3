.data 
	questionMessage: .asciiz "Seleccionar operacion: (0) Promedio pares, (1) Remplaza impares de V2 en pares de V1:\n"
	errorMessage: .asciiz "Error, ingrese 0 o 1.\n"
	vec1: .word 3, 1, 2, 4, 7, 6, -9999
	
	vec2: .word 9, 4, 7, 5, 3, 2, 8, 6, -9999
	
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
		# Calculate pair amount & summation
		
		# Divide summation by amount
		
		# Insert average at end of array
		
		addi $a0, $zero, 0
		addi $v0, $zero, 1
		syscall
	
	# To this point the program is done
	li $v0, 10
	syscall
	
	replacePairsByOdds:
		# Move vec1 1 ahead
		
		# Loop through vec1 & replace with vec2
		
		addi $a0, $zero, 1
		addi $v0, $zero, 1
		syscall
	
	# To this point the program is done
	li $v0, 10
	syscall
	
	divide: 		
		# Numero entero 		
		add  $s0, $zero, $zero
		# Numero decimal 		
		add  $s1, $zero, $zero
		# Cantidad de numeros decimales actuales 		
		addi $s2, $zero, 0 		
		# Cantidad de numeros decimales maximo 		
		addi $s3, $zero, 2 		 		
		
		# Acumulador
		add $s4, $a0, $zero
		integer: 			
			sge $t0, $s4, $a1 			
			beq $t0, $zero, decimal 
			
			# Substraer y contar
			sub  $s4, $s4, $a1
			addi $s0, $s0, 1		
			
			j integer
			
		decimal:  	
			mul $s4, $s4, 10
			
			j float
			
		float:
			
			sge $t0, $s4, $a1 			
			beq $t0, $zero, divEnd 
			
			# Substraer y contar
			sub $s4, $s4, $a1
			addi $s1, $s1, 1		
				
			j float
						 				 		
		divEnd: 
			sge $t0, $s1, 5
			beq $t0, $zero, divReturn
			
			addi $s0, $s0, 1
			
		divReturn:
			addi $v0, $s0, 0
			jr $ra
