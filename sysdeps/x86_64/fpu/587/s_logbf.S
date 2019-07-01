/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_logbf.S,v 1.3 1995/05/09 00:15:12 jtc Exp $")

ENTRY(__logbf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)
	fxtract
	fstp	%st
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__logbf)
weak_alias (__logbf, logbf)
