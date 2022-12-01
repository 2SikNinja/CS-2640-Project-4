#
#	Name:	Nguyen, Peter
#	Project:	4
#	Due:	12/1/2022
#
#	Description:
#		Creates a linked list to store lines of words from a file, traverses it, and prints it out.


	.data
head:	.word	0
input:	.space	64
ptfname:	.asciiz	"/Users/peternguyen/Documents/Computer Science/Fall 2022/CS 2640 Assembly/Project 4/enames.dat"
elements:	.asciiz	" elements\n\n"
intro:	.asciiz	"Elements by P. Nguyen \n\n"


	.text

main:
					#uses s3-s7, since getNode use s3, it uses the stack
	la	$a0, ptfname	# open file
	jal	open
	move	$s4, $v0	# save fd in a0

	li	$s3, 0	# used as counter for number of elements
doWhile2:
	move 	$a0, $s4	# read line into input
	la	$a1, input
	jal	fgetln

	la	$s5, input	# s5 = input
	lb	$s7, ($s5)
	beq	$s7, 10, endDoWhile2	# if (input[0] == \n) exit loop
	
	move	$a0, $s5	# strdup(input)
	jal	strdup	# v0 = cpyinput

	move	$a0, $v0	# getnode(cpyinput,head), head contains address of node
	la	$a1, head	
	lw	$a1, ($a1)
	jal	getNode
	la	$s6, head	# head = getnode(cpyinput,head)
	sw	$v0, ($s6)

	add	$s3, 1	# counter++
	b	doWhile2	# while(true)
endDoWhile2:
	li	$v0, 4	# print intro
	la	$a0, intro
	syscall

	li	$v0, 1	# print number of elements
	move	$a0, $s3
	syscall
	li	$v0, 4
	la	$a0, elements
	syscall

	lw	$a0, head	# traverse(head, print), prints all elements in linked list
	la	$a1, print
	jal	traverse

	move	$a0, $s4	#close file
	jal	close

	li	$v0, 10	#exit
	syscall





getNode:
			# a0 = cstring, a1 = address of list
	addiu	$sp, $sp, -4	# push(s3) b/c is used in caller-main
	sw	$s3, ($sp)

	addiu	$sp, $sp, -4	# push(ra)
	sw	$ra, ($sp)

	move	$s3, $a0	# b/c will use a0 when calling malloc
	li	$a0, 8	# 4 byte for addr of cstring, 4 byte for addr of next node
	jal	malloc	
	sw	$s3, ($v0)	# node.data = &cstring s
	sw	$a1, 4($v0)	# node.next = address list

	lw	$ra, ($sp)	# pop(ra)
	addiu	$sp, $sp, 4
	lw	$s3, ($sp)	# pop s3
	addiu	$sp, $sp, 4
	jr	$ra	# return addr of node





traverse:			
			# a0 = address list a1 = address proc
	addiu	$sp, $sp, -4	# push(ra)
	sw	$ra, ($sp)

	beqz	$a0, endif1	# if(list==0) base case, skip

	addiu	$sp, $sp, -4	# push(a0)
	sw	$a0, ($sp)	

	lw	$a0, 4($a0)	# a0 = list.next
	jal	traverse	# traverse(list.next)

	lw	$a0, ($sp)	# pop a0
	addiu	$sp, $sp, 4

	lw	$a0, ($a0)	# a0 = list.data
	jalr	$a1	
	
endif1:
	lw	$ra, ($sp)	# pop ra
	addiu	$sp, $sp, 4
	jr	$ra





print:
			# a0 = cstring
	li	$v0, 4
	syscall
	jr	$ra





malloc:
			# a0 = size
	addiu	$a0, $a0, 3	# a0 = (size + 3)

	srl	$a0, $a0, 2	# set right 2 bits to 0
	sll	$a0, $a0, 2

	li	$v0, 9	# allocates memory with sbrk()
	syscall		# v0 = address of new memory, returns it
	jr	$ra





strlen:
			# a0 = cstring
	li	$v0, 0	# v0 = length
while1:
	lb	$t0, ($a0)	# t0 = cstring[i]
	beq	$t0, 0,endWhile1	# while (cstring[i] != \0)
	add	$v0, 1	# length++
	add	$a0, 1	# cstring[i+1]
	b	while1
endWhile1:
	jr	$ra





strdup:
			# a0 = cs
	addiu	$sp, $sp, -4	# push(ra)
	sw	$ra, 0($sp)	
			
	move	$s0, $a0	# s0 = a0, b/c a0 need to be used 

	jal	strlen	# strlen(cs), v0 = cs.length

	move	$a0, $v0	# malloc(cs.length)
	add	$a0, 1	# make space for \0
	jal	malloc	# v0 = cpycs, used as base address to return when strdup done
	move	$s2, $v0	# $s2 = cpycs[i], used as effective address
doWhile1:
	lb	$s1, ($s0)	# s1 = cs[i]
	sb	$s1, ($s2)	# cpycs[i] = cs[i]
	add	$s0, 1	# cs[i+1]
	add	$s2, 1	# cpycs[i+1]
	bne	$s1, 0, doWhile1	# while(cs[i] != \0)

endDoWhile1:
	lw	$ra, 0($sp)	# pop(), $ra = ra back to main
	addiu	$sp, $sp, 4
	jr	$ra




fgetln:	move	$t0, $a1		# save a1
	li	$a2, 1		# 1 byte at a time
do1:	li	$v0, 14
	syscall
	lb 	$t1, ($a1)
	addiu 	$a1, $a1, 1
	bne 	$t1, '\n', do1
	sb 	$zero, ($a1)	# null byte
	move	$a1, $t0		# restore a1
	jr	$ra





open:	li	$a1, 0
	li	$a2, 0
	li	$v0, 13
	syscall
	jr	$ra





close:
	li 	$v0, 16
	syscall
	jr	$ra



	