/*
 * Written by Ulrich Drepper.
 */

#include <machine/asm.h>

	.section .rodata
	.p2align 2
zero:	.float 0.0

	.text
/* e^x = 2^(x * log2(10)) */
ENTRY(__ieee754_exp10f)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)
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
	fldl2t
	fmulp				/* x * log2(10) */
	fld	%st
	frndint				/* int(x * log2(10)) */
	fsubr	%st,%st(1)		/* fract(x * log2(10)) */
	fxch
	f2xm1				/* 2^(fract(x * log2(10))) - 1 */
	fld1
	faddp				/* 2^(fract(x * log2(10))) */
	fscale				/* e^x */
	fstp	%st(1)
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret

1:	testl	$0x200, %eax		/* Test sign.  */
	jz	2f			/* If positive, jump.  */
	fstp	%st
	LOAD_FLOAT_REG (zero(%rip), 0)	/* Set result to 0.  */
	ret
2:
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__ieee754_exp10f)
