#  Name:   Nguyen, Peter
#  Project:  #4
#  Due:        12/01/2022 
#  Course:  cs-2640-04-f22 
# 
#  Description: 
#    Creates a linked list as well as a file and uses it to store information and traverses it.
	.data
head:	.word	0:2
input:	.space	42
ptfname:	.asciiz	"C:\Users\vn\Downloads\enames.dat"
test:	.asciiz	"test\n"

	.text
main:

	li	$v0, 10
	syscall







# node-address getnode(cstring s, address list) 
#   allocate node (malloc) 
#   node.data = s 
#   node.next = list 
#   return node 
getNode:





print:
			# a0 = cstring
	li	$v0, 4
	syscall
	jr	$ra

# void traverse(address list, address proc) 
#   if (list != 0) { NOT the base case
#     traverse(list.next) 
#     proc(list.data) 
#   } 
traverse:			
			# a0 = address list a1 = address proc
	addiu	$sp, $sp, -4	# push ra
	sw	$ra, ($sp)

	beqz	$a0, endif1	# if(list==0) base case, skip

	addiu	$sp, $sp, -4	# push(a0)
	sw	$a0, ($sp)	

	add	$a0, $a0, 4	# a0 = list.next
	jal	traverse	# traverse(list.next)

	lw	$a0, ($sp)	# peek a0 from stack but don't pop b/c will call a1()
	lw	$a0, ($a0)	# a0 = list.data
	jalr	$a1
	addiu	$sp, $sp, 4	# pop a0

endif1:
	lw	$ra, ($sp)	# pop ra
	addiu	$sp, $sp, 4
	jr	$ra



malloc:
			# $a0 = size
	addiu	$a0, $a0, 3	# $a0 = (size + 3)

	srl	$a0, $a0, 2	# set right 2 bits to 0
	sll	$a0, $a0, 2

	li	$v0, 9	# allocates memory with sbrk($a0)
	syscall		# $v0 = address of new memory, returns it
	jr	$ra




strlen:
			# $a0 = &cs[i]
	li	$t0, 0	# $t0 = length
	lb	$t1, ($a0)	# $t1 =  cs[0] !!!
while1:
	beq	$t1, 0, endWhile	# while (cs[i] != \0)
	add	$t0, 1	# length++
	add	$a0, 1	# $a0 = &cs[i+1]
	lb	$t1, ($a0)
	b	while
endWhile1:
	move	$v0, $t0	# $v0 = length , returns it
	jr	$ra

strdup:
			# $a0 = &cs[]
	addiu	$sp, $sp, -4	# push($ra)
	sw	$ra, 0($sp)	# used in endDoWhile2
			
	move	$s0, $a0	# s0 = a0, b/c a0 need to be used 



	jal	strlen	# strlen(&cs[]), $v0 = cs.length
	add	$v0, 1	# cs.length + 1  to make room for \0

	move	$a0, $v0	# malloc(cs.length + 1)
	jal	malloc	# $v0 = &dst[] , used as base address to return when strdup done
	move	$s2, $v0	# $s2 = &dst[] , used as effective address in doWhile2
doWhile1:
	lb	$s1, ($s0)	# $s1 = cs[i]
	sb	$s1, ($s2)	# dst[i] = cs[i]
	add	$s0, 1	# cs[i+1]
	add	$s2, 1	# dst[i+1]
	bne	$s1, 0, doWhile2	# while(cs[i] != \0)

endDoWhile1:
	lw	$ra, 0($sp)	# pop(), $ra = ra back to main
	addiu	$sp, $sp, 4

	jr	$ra
