/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>
#include <x86_64-math-asm.h>

#define MO(op) op(%rip)

RCSID("$NetBSD: e_atan2.S,v 1.4 1995/05/08 23:46:28 jtc Exp $")

DEFINE_DBL_MIN

	.text
ENTRY(__ieee754_atan2)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	STORE_DOUBLE_REG (1, -16(%rsp))
	fldl	-8(%rsp)
	fldl	-16(%rsp)
	fpatan
	DBL_CHECK_FORCE_UFLOW
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__ieee754_atan2)
