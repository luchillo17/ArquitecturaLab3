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
		add  $t0, $zero, $zero
		# Numero decimal 		
		add  $t1, $zero, $zero
		# Cantidad de numeros decimales actuales 		
		addi $t2, $zero, 0 		
		# Cantidad de numeros decimales maximo 		
		addi $t3, $zero, 2 		 		
		
		# Acumulador
		add $t4, $a0, $zero
		integer: 			
			sge $t5, $t4, $a1 			
			beq $t5, $zero, decimal 
			
			# Substraer y contar
			sub  $t4, $t4, $a1
			addi $t0, $t0, 1		
			
			j integer
			
		decimal:  	
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
			addi $v0, $t0, 0
			jr $ra
