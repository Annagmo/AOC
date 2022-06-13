.data
			bemVindo: .asciiz "\t\t\t\t***INSTRUCÕES***\n"  
	        	instrucoes: .asciiz "           Você deve completar o tabuleiro em todo lugar que haja o número 0.\n   Será perguntado qual número você quer por em seu lugar, o índice da linha e o da coluna.\n             Lembre-se que os índices das linhas e colunas começam em 0.\n\t\t\t\t **Boa sorte**\n"
	        	iniciaJogo: .asciiz "Digite 1 para jogar:\n"
	        	nv_linha: .asciiz "|\n"
	        	marcador_fundo_topo: .asciiz " ------------------------------------\n"
	        	separador_linha: .asciiz " | "
	        	errou: .asciiz "Você errou!  \\(° - ° )/ \n"
	        	acertou: .asciiz "Você acertou!  \\(°V°)/ \n"
	        	nr: .asciiz "Qual número você deseja adicionar?\n"
	        	linha: .asciiz "índice da linha:\n"
        	 	col: .asciiz "índice da coluna:\n"
  
jogo:       
        	 	.byte     0, 0, 5, 0, 1, 9, 7, 0, 0    # 3  2  5  4  1  9  7  6  8
        	 	.byte     0, 0, 6, 3, 0, 0, 0, 0, 0    # 1  7  6  3  2  8  5  4  9
        	 	.byte     0, 9, 0, 0, 0, 6, 0, 2, 3    # 8  9  4  7  5  6  1  2  3
        	 	.byte     0, 3, 0, 0, 7, 4, 0, 8, 0    # 9  1  3  5  7  4  2  8  6
        	 	.byte     2, 0, 0, 6, 0, 0, 0, 0, 1    # 2  5  7  6  8  3  9  4  1
        	 	.byte     4, 0, 0, 0, 0, 1, 0, 5, 7    # 4  6  8  2  9  1  3  5  7 
        	 	.byte     0, 0, 1, 0, 3, 5, 0, 0, 0    # 6  4  1  9  3  5  8  7  2
        	 	.byte     7, 0, 0, 8, 0, 0, 6, 0, 5    # 7  3  9  8  4  2  6  1  5 
        	 	.byte     0, 8, 0, 0, 0, 0, 9, 0, 4    # 5  8  2  1  6  7  9  3  4
            
.text
        	 	li $v0,4 
        	 	la $a0,bemVindo #carrega e imprime a mensagem de bem-vindo
        	 	syscall 
			
	         	li $v0,4 
        	 	la $a0,instrucoes #carrega e imprime as instruções
        	 	syscall 
			
        	 	li $v0,4 
        	 	la $a0,iniciaJogo #carrega e imprime o :  "Digite 1 para jogar:\n"
        	 	syscall
	
        	 	li $v0,5 #lê o que o usuário digitou: [0,1]
        	 	syscall 
			
        	 	beq $v0,1,JOGAR #se ele clica 1 vai para o ramo JOGAR
			beq $v0,0,FIMDEJOGO #se ele clica 0 vai para o ramo FIMDEJOGO e encerra o programa
			
        	 	j FIMDEJOGO
	
JOGAR:
	         	la $a0,jogo #carrega o tebuleiro
	         	jal atualiza_pilha #salva as nossas vaiáveis na pilha
	         	la $a0,jogo #carrega o tabuleiro novamente em uma lista 2d para saber a posição na lista que o user vai botar o nr
	         	jal chute #vai para o ramo chute
	
	         	j FIMDEJOGO
	
FIMDEJOGO:
         		li $v0,10 #10 é o código de saída do SPIM
         		syscall
      
atualiza_pilha:	
             	 	# vamos criar uma pilha
			
         		sub $sp, $sp, 16 
			
			# sp vai ser o nosso registrador pilha, e nele nós valos alocar 4 coisas:
         		# a gente preenche/atualiza a pilha do último elemento pro primeiro lá na base da pilha.
			
	         	sw $ra, 12($sp) # Save the return address
			
			# nos últimos 4 bytes da pilha nós armazenamos o endereço de retorno. 
	        	# como a jal "atualiza_pilha" vai sobrescrever o nosso endereço de retorno da pilha $ra <- PC+4 nós precisamos 
	        	# restaurar o endereço de retorno que tínhamos antes. E nós vamos restaurar este endereço no "jr $ra" só depois de 
	        	# imprimir o tabuleiro
			
	         	sw $s2, 8($sp) # Save the $s2 register
         		sw $s1, 4($sp) # Save the $s1 register
         		sw $s0, 0($sp) # Save the $s0 register
         	
			# inicializa os registradores
         		move $s0,$a0 # em "la $a0,jogo" nós colocamos todas as nossas linhas do tabuleiro em $a0, e agora passamos pra $s0
         		#que vai guardando na pilha o nosso tabuleiro atualizado com a jogada do usuário.
         		move $s1, $zero # $s1 marca a linha que nós estamos no tabuleiro
         		move $s2, $zero # $s1 marca a coluna que nós estamos no tabuleiro
	         	
            	 	la $a0, marcador_fundo_topo # imprime o topo do tabuleiro " ------------------------------------\n"
	         	li $v0, 4
	         	syscall
  
imprime_linha:	         	
			#eu tinha falado que nós só vamos restaurar o endereço de retorno da pilha só depois de imprimir o tabuleiro
			# neste ramo nós vamos imprimer linha por linha, nr por nr e depois de tudo, vamos restaurar o endereço de retorno
			#com o "jr $ra"	
			
			# antes de cada linha e depois de cada linha vamos imprimir um | para ficar visual.
	         	la $a0, separador_linha 
	         	li $v0, 4 #imprime o |
	         	syscall
	         	
			#vamos imprimir nr por nr em cada uma das 9 linhas/ células do nosso tabuleiro
	         	lb $a0, ($s0) #lembra que nós guardamos todas as células/linhas na pilha? agora imprime elas
	         	li $v0, 1 #imprime o primeiro nr da primeira linha
         		syscall
			
			addi $s0, $s0, 1 #aponta para a póxima linha/célula
	         	addi $s2, $s2, 1 # aumenta o registrador que está contando as colunas
	         	blt $s2, 9, imprime_linha  # vai iterando no mesmo ramo até acabarem todas as 4 colunas
	         	#já imprimiu 1 nr coluna 0⁰, proxima iteração: imprime 1 nr 1⁰ coluna...E assim vai 1 nr 2⁰ coluna, 1 nr 3⁰ coluna.
	         	#parabéns, você imprimiu uma linha.
	         	
            	 	#imprime um \n pra próxioma linha, assim como um | pra fechar aquela linha
	         	la $a0, nv_linha #imprime o | \n
	         	li $v0, 4
	         	syscall 
			
	         	move $s2, $zero #resetamos o contador de colunas
	         	addi $s1, $s1, 1 # aumentamos no contador de linhas
         		
             	 	# vamos imprimir a próxima linha
	         	blt $s1,9, imprime_linha # não continua até que tenha impresso todas as 4 linhas
			
			# retorna a pilha para o que ela era no início, pq vamos precisar imprimir ela toda vez que o usuário for chutar
	         	lw $s0, 0($sp) # retorna o registrador que armazena a linha que estávamos imprimindo no momento para o que era
	         	lw $s1, 4($sp) #  retorna o contador de linhas para o que era
	         	lw $s2, 8($sp) #  retorna o contador de colunas para o que era
	         	lw $ra, 12($sp) #  retorna o endereço de retorno da pilha
         		addi $sp, $sp, 16 # limpa a pilha
	
	         	# imprime fundo do tabuleiro 
	         	la $a0, marcador_fundo_topo 
	         	li $v0, 4 # " ------------------------------------\n"
	         	syscall 
	
	         	jr $ra # Retorna o ra para o endereço de retorno que tinhamos antes, uma vez que por causa 
	         	#do "jal atualiza_pilha" tivemos "ra<- PC+4 "
            
chute:
	         	#nós tínhamos uma pilha para a primeira impressão do tabuleiro, agora vamos refazer essa pilha para
			#cada um dos chutes do usuário. Então nunca vamos ter um "jr $ra". Uma vez que, nós já vamos colocar
			# a nova pilha no endereço de retorno da antiga, e, vamos sempre atualizar essa pilha.
			
	         	# vamos refazer a pilha
	         	subi $sp, $sp, 16 # guardar 4 registradores com valores nela
	         	sw $ra, 12($sp) # salvar o endereço de retorno
	         	sw $s2, 8($sp) # marca coluna
	         	sw $s1, 4($sp) # marca linha
         		sw $s0, 0($sp) # linha que vamos imprimir
         	
           	 	# inicializa os registradores
	         	move $s0,$a0 # movemos a linha que vamos imprimir para o a0 para não afetar o armazenamento original s0.
	         	
	         	li $v0,4 # pergunta qual vai ser o chute:
         		la $a0,nr #"Qual número você deseja adicionar?\n"
         		syscall 
			
	         	li $v0,5 #lê o nr digitado
	         	syscall
	         	move $t0,$v0 # movemos para guardar num registrador
			
	         	li $v0,4 # pergunta: "índice da linha:\n"
	         	la $a0,linha 
	         	syscall 
			
	         	li $v0,5 #lê o índice da linha digitado
	         	syscall 	
         		move $t1,$v0 #movemos para guardar o índice da linha num registrador
			
	         	li $v0,4 #pergunta: "índice da coluna:\n"
	         	la $a0,col 
	         	syscall
			
	         	li $v0,5 # lê o índice da coluna
	         	syscall 			
	         	move $t2,$v0 # movemos para guardar o índice da coluna num registrador
			
	         	move $a0,$s0 #board address
	         	move $a1,$t0 #number entered
	         	move $a2,$t1 #row index
	         	move $a3,$t2 #column index
	         	move $t5,$s0
			
			#Checagem do chute:
	         	jal checagem_chute
			
			# se o chute for correto:
	         	beqz $v0,chute_correto
	         	li $v0,4
			
			#se for errado
	         	la $a0,errou #só iprime já que não vai mudar o tabuleiro.
         		syscall
			
         		move $a0,$s0 #move o endereço de retorno da pilha para o a0 para fazermos um novo chute 
  
               		jal chute # novo chute

chute_correto:
	         	li $v0,4 #imprime a mensagem de acerto:
	         	la $a0,acertou # "Você acertou!  \\(°V°)/ \n"
	         	syscall
			
	         	move $a0,$s0 #board address
	         	jal FULL
	         	beqz $v0,notfull
	         	
	         	# exclui a pilha, para quando formos fazer uma nova pilha no ramo chute, 
	         	# quando for ser guardada a linha que objeteve um acerto, ela já vai ser guardada atualizada
	         	lw $s0, 0($sp) #restaura tudo para o que era
	         	lw $s1, 4($sp) 
	         	lw $s2, 8($sp) 
	         	lw $ra, 12($sp)
         		addi $sp, $sp, 16 # apaga a pilha
	         	jr $ra # volta para o endereço de retorno que tava no início para criar uma pilha nova no mesmo endereço

notfull:
	         	move $a0,$s0 #board address
	         	jal chute

checagem_chute:
	         	subi $sp,$sp,4 #make room in the stack
	         	sw $ra,($sp) # salvar o endereço de retorno do ra
	         	move $s0,$a0 ## salvar o endereço do tabuleiro atualizado com o chute
	         	move $t9,$a1 #salva o chute
         	
	         	# checagem de linha por linha pra ver se o chute entra
	         	li $t0,9 #passar pelas 4 linhas
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
    	     	 	jal imprime_linha
    	     	 	move $v0,$zero #Return code is 0 (success)
    	     	 	j check_ret #Jump to the return instrucoes
  
check_ret_fail:
    	     	 	li $t8,9
    	     	 	mul $t7,$a2,$t8 #9*row_index
    	     	 	add $t7,$a3,$t7 #9*row_index+column_index
    	     	 	add $s1,$s0,$t7
    	     	 	sb $t9,($s1) #store byte
    	     	 	move $a0,$s0
    	     	 	jal imprime_linha
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
	        	mul $t1, $s1, $t2
  
for2:
	        	add $t3, $t1, $s2
	        	add $s0, $s0, $t3
	        	lb $t4,($s0)
	        	beqz $t4, NOTFULL
	        	addi $s2, $s2, 1
	        	beq $s2, 9, end2
	        	j for2
  
end2:
	        	addi $s1, $s1, 1
	        	beq $s1, 9, end1
	        	move $s2, $zero #Reset column counter
	        	j for1
  
end1:
	        	li $v0, 1 #full
	        	jr $ra
  
NOTFULL:
	        	move $v0,$zero #Not Full
	        	jr $ra
