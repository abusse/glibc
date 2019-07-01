/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: e_atan2f.S,v 1.1 1995/05/08 23:35:10 jtc Exp $")

ENTRY(__ieee754_atan2f)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	STORE_FLOAT_REG (1, -8(%rsp))
	flds	-4(%rsp)
	flds	-8(%rsp)
	fpatan
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__ieee754_atan2f)
