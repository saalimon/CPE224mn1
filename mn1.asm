.data
Pattern: .space 256
Text: .space 256
Table: .space 1024
Prompt: .asciiz "Text: "
#Text: .asciiz "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n"
Prompt2: .asciiz "Enter Pattern: "
newLine: .asciiz "\n"
notFound: .asciiz "Not found\n"
Found: .asciiz "Found at "

.text
# main procedure
# Variables: $t1 = text $t2 = pattern $s0 = skip $t3 = $t1.length() $t4 = $t2.length() $s1 = Table
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
	add $v0, $zero, $t5 #set v0 to t5 for return address
	jr $ra

main:
	li $v0, 4
	la $a0, Prompt 			#show Prompt
	syscall
	li $v0, 8				
	la $a0, Text
	addi $a1 , $zero , 256	
	add $t1, $a0, $zero		#load text to t1
	syscall

	li $v0, 4				#print string
	la $a0, Prompt2			#show Prompt2
	syscall
	li $v0, 8				#read string
	la $a0, Pattern	
    addi $a1, $zero, 256				
    add $t2 , $a0 , $zero	#get pattern from user to t2			
    syscall 

	add $s0, $zero, $zero	#skip = 0 // this is found position 

	add $a0, $t1, $zero		#get length from t1 (Text)
	jal strlen
	add $t3,$zero,$v0		# t3 = t1.length() 

	add $a0, $t2, $zero		#get length from t2 (Pattern)
	jal strlen
	add $t4, $zero, $v0		# t4 = t2.length()

	sub $t8, $t4, $t3 		#Pattern - Text
	slt $t8, $t8, $zero
	beq $t8, $zero, notfound

	#lb $a0, 0($t2)		#show Prompt2
	#li $v0, 1
	#syscall
	la $s1,Table
	move $t8,$zero			#initial i = 0
	sloop1:
		sll $t9, $t8, 2		#because 1 integer = 1 word = 4byte -> shift 2 for 1 integer
		add $t9, $s1, $t9	#change base address to Table[i]
		sw $t4, 0($t9)		#t4 store value of shift table T[i]=P.length()
		bgt $t8, 255, esloop1 #if i > size-1 then end loop
		addi $t8, $t8, 1 # i = i+1
		j sloop1 # loop again
	esloop1:


	move $t8,$zero
	addi $t7, $t4, -1			#P.length() -1
	add $t9, $t2, $zero
	sloop2:
		beq $t8, $t7, esloop2	#if i == P.length()-1 then exit
		lb $t6, 0($t9)			# load byte character from pattern P[i]
		sll $t6, $t6, 2			# shift byte 2 = P[i]*4
		add $t6, $t6, $s1		# t9 = Table[P[i]]
		sub $t5, $t7, $t8		# P.length()-1-i
		sw $t5, 0($t6)			# table[P[i]] = P.length()-1-i
		addi $t8, $t8, 1		# i++
		addi $t9, $t9, 1 		# move to next character of string
		j sloop2
	esloop2:

	move $s3,$zero				#found = 0
	loopwhile:
		sub $t5, $t3, $s0			# $t5 = text.length()-skip	
		blt $t5, $t4, eloopwhile 	# if text.length()-skip >= P.length(), end while loop 
		addi $t8, $t4, -1         	# i = P.length() - 1

		sloopwhile:
			add $t6,$s0,$t8
			add $t6,$t1,$t6			# address text[skip+i]
			add $t7,$t8,$t2			# address P[i]
			lb $t6,0($t6)			# text[skip+i]
			lb $t7,0($t7)			# P[i]
			bne $t6,$t7,esloopwhile	# if true exit loop
			beq $t8, $zero, addfound	# if i == 0 branch
			addi $t8,$t8,-1			# i = i - 1
			j sloopwhile
		esloopwhile:
		add $t0,$s0,$t4
		addi $t0,$t0,-1
		add $t0,$t1,$t0
		lb $t0,0($t0)				# this is 1 character then it dont need to mul with 4
		sll $t0,$t0,2				# integer store in one word the it need to mul with 4
		add $t0,$s1,$t0
		lw $t0,0($t0)
		add $s0,$s0,$t0
		j loopwhile
	eloopwhile:
	j result
	
addfound:
	addi $s3,$s3,1			#add found = found + 1
	j esloopwhile			#break from sloopwhile
notfound:	
	addi $v0 $zero, 4
	la $a0,notFound			#show notfound
	syscall
	j exit

	
result:
	beq $s3,$zero,notfound
	li $v0,4
	la $a0,Found
	syscall
	li $v0,1
	move $a0,$s3
	syscall
	j exit
exit:
	li $v0,10			#full exit
	syscall




