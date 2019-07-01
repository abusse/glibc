/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: e_acos.S,v 1.4 1995/05/08 23:44:37 jtc Exp $")

/* acos = atan (sqrt(1 - x^2) / x) */
ENTRY(__ieee754_acos)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldl	-8(%rsp)		/* x */
	fld	%st			/* x : x */
	fmul	%st(0)			/* x^2 : x */
	fld1				/* 1 : x^2 : x */
	fsubp				/* 1 - x^2 : x */
	fsqrt				/* sqrt (1 - x^2) : x */
	fabs
	fxch	%st(1)			/* x : sqrt (1 - x^2) */
	fpatan				/* atan (sqrt(1 - x^2) / x) */
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__ieee754_acos)
