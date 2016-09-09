.org 0x0
	.set noat
	.set noreorder
	.set nomacro
	.global _start
_start:
	ori $1, $0, 0x0003
	ori $3, $0, 0x0003
	ori $4, $0, 0x0005
loop:
	sb $1, 0($2)
	add $2, $2, $1
	andi $2, $2, 0x000f
	mult $1, $4
	mflo $1
	andi $1, $1, 0x000f
	bne $1, $3, loop
end:
	j end
