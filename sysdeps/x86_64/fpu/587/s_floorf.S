/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_floorf.S,v 1.3 1995/05/09 00:04:32 jtc Exp $")

ENTRY(__floorf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)

	fstcw	-8(%rsp)		/* store fpu control word */

	/* We use here %edx although only the low 1 bits are defined.
	   But none of the operations should care and they are faster
	   than the 16 bit operations.  */
	movl	$0x400,%edx		/* round towards -oo */
	orl	-8(%rsp),%edx
	andl	$0xf7ff,%edx
	movl	%edx,-12(%rsp)
	fldcw	-12(%rsp)		/* load modified control word */

	frndint				/* round */

	fldcw	-8(%rsp)		/* restore original control word */

	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__floorf)
weak_alias (__floorf, floorf)
