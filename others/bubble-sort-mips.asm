#	.file	1 "bubble-sort-mips.c"
#	.section .mdebug.abi32
#	.previous
#	.text
#	.align	2
#	.globl	bubble_sort
#	.set	nomips16
#	.ent	bubble_sort
#	.type	bubble_sort, @function
bubble_sort:
#	.frame	$fp,48,$31		# vars= 40, regs= 1/0, args= 0, gp= 0
#	.mask	0x40000000,-4
#	.fmask	0x00000000,0
	addiu	$sp,$0,0x1000 # test
	addiu	$sp,$sp,-48
	sw	$fp,44($sp)
	move	$fp,$sp
	li	$2,5			# 0x5
	sw	$2,8($fp)
	li	$2,268435456			# 0x10000000
	ori	$2,$2,0x1008
	sw	$2,16($fp)
	li	$2,16777216			# 0x1000000
	ori	$2,$2,0x1002
	sw	$2,20($fp)
	li	$2,-2147483648			# 0xffffffff80000000
	ori	$2,$2,0x1001
	sw	$2,24($fp)
	li	$2,268435456			# 0x10000000
	ori	$2,$2,0x1005
	sw	$2,28($fp)
	li	$2,-2147483648			# 0xffffffff80000000
	ori	$2,$2,0x1000
	sw	$2,32($fp)
	sw	$0,0($fp)
	j	$L2
$L6:
	li	$2,1			# 0x1
	sw	$2,4($fp)
	j	$L3
$L5:
	lw	$2,4($fp)
	#nop
	addiu	$2,$2,-1
	sll	$2,$2,2
	addu	$2,$fp,$2
	lw	$3,16($2)
	lw	$2,4($fp)
	#nop
	sll	$2,$2,2
	addu	$2,$fp,$2
	lw	$2,16($2)
	#nop
	slt	$2,$2,$3
	beq	$2,$0,$L4
	lw	$2,4($fp)
	#nop
	addiu	$2,$2,-1
	sll	$2,$2,2
	addu	$2,$fp,$2
	lw	$2,16($2)
	#nop
	sw	$2,12($fp)
	lw	$2,4($fp)
	#nop
	addiu	$4,$2,-1
	lw	$2,4($fp)
	#nop
	sll	$2,$2,2
	addu	$2,$fp,$2
	lw	$3,16($2)
	sll	$2,$4,2
	addu	$2,$fp,$2
	sw	$3,16($2)
	lw	$2,4($fp)
	#nop
	sll	$2,$2,2
	addu	$2,$fp,$2
	lw	$3,12($fp)
	#nop
	sw	$3,16($2)
$L4:
	lw	$2,4($fp)
	#nop
	addiu	$2,$2,1
	sw	$2,4($fp)
$L3:
	lw	$3,8($fp)
	lw	$2,0($fp)
	#nop
	subu	$3,$3,$2
	lw	$2,4($fp)
	#nop
	slt	$2,$2,$3
	bne	$2,$0,$L5
	lw	$2,0($fp)
	#nop
	addiu	$2,$2,1
	sw	$2,0($fp)
$L2:
	lw	$3,0($fp)
	lw	$2,8($fp)
	#nop
	slt	$2,$3,$2
	bne	$2,$0,$L6
	move	$sp,$fp
	lw	$fp,44($sp)
	addiu	$sp,$sp,48
#	j	$31
#	.end	bubble_sort
#	.size	bubble_sort, .-bubble_sort
#	.ident	"GCC: (GNU) 4.8.1"
