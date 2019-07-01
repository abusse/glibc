/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: e_remainderf.S,v 1.2 1995/05/08 23:49:47 jtc Exp $")

ENTRY(__ieee754_remainderf)
	LOAD_REG_K1
	STORE_FLOAT_REG (1, -8(%rsp))
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-8(%rsp)
	flds	-4(%rsp)
1:	fprem1
	fstsw	%ax
	sahf
	jp	1b
	fstp	%st(1)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__ieee754_remainderf)
