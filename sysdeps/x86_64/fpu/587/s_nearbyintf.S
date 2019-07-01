/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */
/* Adapted for use as nearbyint by Ulrich Drepper <drepper@cygnus.com>.  */

#include <machine/asm.h>

ENTRY(__nearbyintf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)
	fnstcw	-8(%rsp)
	movl	-8(%rsp), %eax
	orl	$0x20, %eax
	movl	%eax, -12(%rsp)
	fldcw	-12(%rsp)
	frndint
	fclex
	fldcw	-8(%rsp)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__nearbyintf)
weak_alias (__nearbyintf, nearbyintf)
