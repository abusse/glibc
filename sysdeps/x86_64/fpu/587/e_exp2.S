/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Adapted for exp2 by Ulrich Drepper <drepper@cygnus.com>.
 * Public domain.
 */

#include <machine/asm.h>

	.section .rodata
	.p2align 3
zero:	.double 0.0

	.text
ENTRY(__ieee754_exp2)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldl	-8(%rsp)
/* I added the following ugly construct because exp(+-Inf) resulted
   in NaN.  The ugliness results from the bright minds at Intel.
   For the i686 the code can be written better.
   -- drepper@cygnus.com.  */
	fxam				/* Is NaN or +-Inf?  */
	fstsw	%ax
	movb	$0x45, %dh
	andb	%ah, %dh
	cmpb	$0x05, %dh
	je	1f			/* Is +-Inf, jump.  */
	fld	%st
	frndint				/* int(x) */
	fsubr	%st,%st(1)		/* fract(x) */
	fxch
	f2xm1				/* 2^(fract(x)) - 1 */
	fld1
	faddp				/* 2^(fract(x)) */
	fscale				/* e^x */
	fstp	%st(1)
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

1:	testl	$0x200, %eax		/* Test sign.  */
	jz	2f			/* If positive, jump.  */
	fstp	%st
	LOAD_DOUBLE_REG (zero(%rip), 0)	/* Set result to 0.  */
	ret
2:
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__ieee754_exp2)
