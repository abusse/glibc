/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_floor.S,v 1.4 1995/05/09 00:01:59 jtc Exp $")

ENTRY(__floor)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldl	-8(%rsp)

	fstcw	-12(%rsp)		/* store fpu control word */

	/* We use here %edx although only the low 1 bits are defined.
	   But none of the operations should care and they are faster
	   than the 16 bit operations.  */
	movl	$0x400,%edx		/* round towards -oo */
	orl	-12(%rsp),%edx
	andl	$0xf7ff,%edx
	movl	%edx,-16(%rsp)
	fldcw	-16(%rsp)		/* load modified control word */

	frndint				/* round */

	fldcw	-12(%rsp)		/* restore original control word */

	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__floor)
weak_alias (__floor, floor)
