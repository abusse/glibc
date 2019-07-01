/*
 * Written by Ulrich Drepper <drepper@cygnus.com>.
 * Based on e_remainder by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

#define DVDND	8
#define DVSOR	DVDND+16

	.text
ENTRY (__remquol)
	fldt	DVSOR(%rsp)
	fldt	DVDND(%rsp)
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
	movl	DVDND+8(%rsp), %edx
	xorl	DVSOR+8(%rsp), %edx
	testl	$0x8000, %edx
	jz	1f
	negl	%eax
1:	movl	%eax, (%rdi)

	ret
END (__remquol)
weak_alias (__remquol, remquol)
