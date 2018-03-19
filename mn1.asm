.data
Pattern: .space 256
Table: .space 1024
Prompt: .asciiz "Text: "
Text: .asciiz "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n"
Prompt2: .asciiz "Enter Pattern: "
newLine: .asciiz "\n"
notFound: .asciiz "Not found\n"

.text
# main procedure
# Variables: n=$s0, sum=$s1, i=$s2
j main 

strlen:
	move $t5,$zero # initialize the count to zero
	lenloop:
		lb $t6, 0($a0) # load the next character into t1
		beq $t6, '\n',lenexit # check for the null character
		addi $a0, $a0, 1 # increment the string pointer
		addi $t5, $t5, 1 # increment the count
		j lenloop # return to the top of the loop
	lenexit:
	add $v0, $zero, $t5
	jr $ra

main:
	la $a0, Prompt 			#show Prompt
	syscall
	li $v0, 4
	la $a0, Text
	syscall
	addi $a1 , $zero , 256	
	add $t1, $a0, $zero		#load text to t1

	li $v0, 4
	la $a0, Prompt2			#show Prompt2
	syscall
	li $v0, 8
	la $a0, Pattern	
    addi $a1, $zero, 256				
    add $t2 , $a0 , $zero	#get pattern from user			
    syscall 

	add $s0, $zero, $zero	#skip = 0 // this is found position 

	add $a0, $t1, $zero		#get length from t1 (Text)
	jal strlen
	add $t3,$zero,$v0		# t3 = t1.length()

	add $a0, $t2, $zero		#get length from t2 (Pattern)
	jal strlen
	add $t4,$zero,$v0		# t4 = t2.length()

	sub $t8,$t4,$t3 		#Pattern - Text
	slt $t8, $t8, $zero
	beq $t8, $zero, notfound

	#lb $a0, 0($t2)		#show Prompt2
	#li $v0, 1
	#syscall
	la $s1,Table
	#sw $t4,0($s1)
	#sw $t4,4($s1)
	move $t8,$zero			#initial i = 0
	sloop1:
		sll $t9,$t8,2
		add $t9,$s1,$t9
		sw $t4,0($t9)		#t5 store value of shift table
		bgt $t8,255,esloop1
		addi $t8,$t8,1
		j sloop1
	esloop1:

	move $t8,$zero			#initial i = 0
	addi $t9,$t4,-1
	sloop2:
		bgt $t8,$t9,esloop2
		addi $t8,$t8,1
	esloop2:


	

	j exit

notfound:	
	addi $v0 $zero, 4
	la $a0,notFound			#show notfound
	syscall
	j exit

	


exit:




