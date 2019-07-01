/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */
/* Adapted for use as nearbyint by Ulrich Drepper <drepper@cygnus.com>.  */

#include <machine/asm.h>

ENTRY(__nearbyint)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldl	-8(%rsp)
	fnstcw	-12(%rsp)
	movl	-12(%rsp), %eax
	orl	$0x20, %eax
	movl	%eax, -16(%rsp)
	fldcw	-16(%rsp)
	frndint
	fclex
	fldcw	-12(%rsp)
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__nearbyint)
weak_alias (__nearbyint, nearbyint)
