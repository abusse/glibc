/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_log1p.S,v 1.7 1995/05/09 00:10:58 jtc Exp $")

#ifdef __ELF__
	.section .rodata
#else
	.text
#endif
	.align ALIGNARG(4)
	/* The fyl2xp1 can only be used for values in
		-1 + sqrt(2) / 2 <= x <= 1 - sqrt(2) / 2
	   0.29 is a safe value.
	*/
limit:	.double 0.29
one:	.double 1.0

/*
 * Use the fyl2xp1 function when the argument is in the range -0.29 to 0.29,
 * otherwise fyl2x with the needed extra computation.
 */
	.text
ENTRY(__log1p)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldln2
	fldl	-8(%rsp)

	fxam
	fnstsw
	fld	%st
	sahf
	jc	3f		// in case x is NaN or ±Inf
4:	fabs
	fcompl	limit(%rip)
	fnstsw
	sahf
	jc	2f

	faddl	one(%rip)
	fyl2x
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

2:	fyl2xp1
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

3:	jp	4b		// in case x is ±Inf
	fstp	%st(1)
	fstp	%st(1)
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

END (__log1p)
weak_alias (__log1p, log1p)
