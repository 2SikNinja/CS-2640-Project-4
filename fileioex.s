
# periodict table i/o
#	replace path with the path of enames in your computer
 
	.data
ptfname:	.asciiz	"path/enames.dat"
buf:	.space	64

	.text
main:	la	$a0, ptfname
	jal	open
	move	$s0, $v0		# save fd in s0

	# to read a string
	move 	$a0, $s0
	la	$a1, buf
	jal	fgetln
	# string read into buf

	move	$a0, $s0
	jal	close

	#exit

