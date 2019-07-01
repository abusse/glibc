/*
 * Written by Ulrich Drepper <drepper@cygnus.com>.
 * Based on e_remainder by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

#define DVDND	-8
#define DVSOR	DVDND-8

	.text
ENTRY (__remquo)
	LOAD_REG_K1
	STORE_DOUBLE_REG (1, DVSOR(%rsp))
	STORE_DOUBLE_REG (0, DVDND(%rsp))
	fldl	DVSOR(%rsp)
	fldl	DVDND(%rsp)
1:	fprem1
	fstsw	%ax
	sahf
	jp	1b
	fstp	%st(1)
	/* Compute the congruent of the quotient.  */
	movl	%eax, %ecx
	shrl	$8, %eax
	shrl	$12, %ecx
	andl	$4, %ecx
	andl	$3, %eax
	orl	%eax, %ecx
	leal	(%ecx,%ecx,2),%ecx
	movl	$0xef2a60, %eax
	shrl	%cl, %eax
	andl	$7, %eax
	movl	DVDND+4(%rsp), %edx
	xorl	DVSOR+4(%rsp), %edx
	testl	$0x80000000, %edx
	jz	1f
	negl	%eax
1:	movl	%eax, (%rdi)

	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__remquo)
weak_alias (__remquo, remquo)
