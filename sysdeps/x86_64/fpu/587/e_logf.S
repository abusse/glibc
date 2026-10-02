/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 * Adapted for float by Ulrich Drepper <drepper@cygnus.com>.
 *
 * Changed to use fyl2xp1 for values near 1, <drepper@cygnus.com>.
 */

#include <machine/asm.h>

	.section .rodata.cst8,"aM",@progbits,8

	.p2align 3
	.type one,@object
one:	.double 1.0
	ASM_SIZE_DIRECTIVE(one)
	/* It is not important that this constant is precise.  It is only
	   a value which is known to be on the safe side for using the
	   fyl2xp1 instruction.  */
	.type limit,@object
limit:	.double 0.29
	ASM_SIZE_DIRECTIVE(limit)


#define MO(op) op(%rip)

	.text
ENTRY(__ieee754_logf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	fldln2			// log(2)
	flds	-4(%rsp)		// x : log(2)
	fxam
	fnstsw
	fld	%st		// x : x : log(2)
	sahf
	jc	3f		// in case x is NaN or +-Inf
4:	fsubl	MO(one)		// x-1 : x : log(2)
	fld	%st		// x-1 : x-1 : x : log(2)
	fabs			// |x-1| : x-1 : x : log(2)
	fcompl	MO(limit)	// x-1 : x : log(2)
	fnstsw			// x-1 : x : log(2)
	andb	$0x45, %ah
	jz	2f
	fxam
	fnstsw
	andb	$0x45, %ah
	cmpb	$0x40, %ah
	jne	5f
	fabs			// log(1) is +0 in all rounding modes.
5:	fstp	%st(1)		// x-1 : log(2)
	fyl2xp1			// log(x)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret

2:	fstp	%st(0)		// x : log(2)
	fyl2x			// log(x)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret

3:	jp	4b		// in case x is +-Inf
	fstp	%st(1)
	fstp	%st(1)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__ieee754_logf)

ENTRY(__logf_finite)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	fldln2			// log(2)
	flds	-4(%rsp)		// x : log(2)
	fld	%st		// x : x : log(2)
	fsubl	MO(one)		// x-1 : x : log(2)
	fld	%st		// x-1 : x-1 : x : log(2)
	fabs			// |x-1| : x-1 : x : log(2)
	fcompl	MO(limit)	// x-1 : x : log(2)
	fnstsw			// x-1 : x : log(2)
	andb	$0x45, %ah
	jz	2b
	fxam
	fnstsw
	andb	$0x45, %ah
	cmpb	$0x40, %ah
	jne	6f
	fabs			// log(1) is +0 in all rounding modes.
6:	fstp	%st(1)		// x-1 : log(2)
	fyl2xp1			// log(x)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END(__logf_finite)
