/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 * Adapted for float type by Ulrich Drepper <drepper@cygnus.com>.
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
ENTRY(__ieee754_log10f)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	fldlg2			// log10(2)
	flds	-4(%rsp)		// x : log10(2)
	fxam
	fnstsw
	fld	%st		// x : x : log10(2)
	sahf
	jc	3f		// in case x is NaN or ±Inf
4:	fsubl	MO(one)		// x-1 : x : log10(2)
	fld	%st		// x-1 : x-1 : x : log10(2)
	fabs			// |x-1| : x-1 : x : log10(2)
	fcompl	MO(limit)	// x-1 : x : log10(2)
	fnstsw			// x-1 : x : log10(2)
	andb	$0x45, %ah
	jz	2f
	fxam
	fnstsw
	andb	$0x45, %ah
	cmpb	$0x40, %ah
	jne	5f
	fabs			// log10(1) is +0 in all rounding modes.
5:	fstp	%st(1)		// x-1 : log10(2)
	fyl2xp1			// log10(x)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret

2:	fstp	%st(0)		// x : log10(2)
	fyl2x			// log10(x)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret

3:	jp	4b		// in case x is ±Inf
	fstp	%st(1)
	fstp	%st(1)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__ieee754_log10f)
strong_alias (__ieee754_log10f, __log10f_finite)
