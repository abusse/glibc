/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_significand.S,v 1.4 1995/05/09 00:21:47 jtc Exp $")

ENTRY(__significand)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldl	-8(%rsp)
	fxtract
	fstp	%st(1)
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__significand)
weak_alias (__significand, significand)
