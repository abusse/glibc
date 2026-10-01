/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */
/* Adapted for use as nearbyint by Ulrich Drepper <drepper@cygnus.com>.  */

#include <machine/asm.h>

ENTRY(__nearbyintf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -8(%rsp))
	flds	-8(%rsp)
	/* Keep the exception flags as they were: frndint may raise inexact.  */
	fnstenv	-40(%rsp)
	frndint
	fldenv	-40(%rsp)
	fstps	-8(%rsp)
	LOAD_FLOAT_REG (-8(%rsp), 0)
	ret
END (__nearbyintf)
weak_alias (__nearbyintf, nearbyintf)
