/*
 * Written by Ulrich Drepper <drepper@cygnus.com>.
 * Based on e_remainder by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

#define DVDND	-4
#define DVSOR	DVDND-4

	.text
ENTRY (__remquof)
	LOAD_REG_K1
	STORE_FLOAT_REG (1, DVSOR(%rsp))
	STORE_FLOAT_REG (0, DVDND(%rsp))
	flds	DVSOR(%rsp)
	flds	DVDND(%rsp)
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
	movl	DVDND(%rsp), %edx
	xorl	DVSOR(%rsp), %edx
	testl	$0x80000000, %edx
	jz	1f
	negl	%eax
1:	movl	%eax, (%rdi)

	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__remquof)
weak_alias (__remquof, remquof)
