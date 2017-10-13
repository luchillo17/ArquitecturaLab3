.data 
	
.text
	main:
	
		addi $a0, $zero, 50
		addi $a1, $zero, 75
		
		jal divide
		
		addi $a0, $v0, 0
		
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
