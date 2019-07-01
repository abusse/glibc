/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: e_asin.S,v 1.4 1995/05/08 23:45:40 jtc Exp $")

/* asin = atan (x / sqrt(1 - x^2)) */
ENTRY(__ieee754_asin)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldl	-8(%rsp)		/* x */
	fld	%st
	fmul	%st(0)			/* x^2 */
	fld1
	fsubp				/* 1 - x^2 */
	fsqrt				/* sqrt (1 - x^2) */
	fpatan
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__ieee754_asin)
