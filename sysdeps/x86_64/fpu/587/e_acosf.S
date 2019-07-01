/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 * Adapted for float type by Ulrich Drepper <drepper@cygnus.com>.
 */

#include <machine/asm.h>

RCSID("$NetBSD: $")

/* acos = atan (sqrt(1 - x^2) / x) */
ENTRY(__ieee754_acosf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)		/* x */
	fld	%st
	fmul	%st(0)			/* x^2 */
	fld1
	fsubp				/* 1 - x^2 */
	fsqrt				/* sqrt (1 - x^2) */
	fabs
	fxch	%st(1)
	fpatan
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__ieee754_acosf)
