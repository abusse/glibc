/* ix87 specific implementation of arcsinh.
   Copyright (C) 2011 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#include <machine/asm.h>

#ifdef __ELF__
	.section .rodata
#else
	.text
#endif

	.align ALIGNARG(4)
	ASM_TYPE_DIRECTIVE(huge,@object)
huge:	.double 1e+300
	ASM_SIZE_DIRECTIVE(huge)
	ASM_TYPE_DIRECTIVE(one,@object)
one:	.double 1.0
	ASM_SIZE_DIRECTIVE(one)
	ASM_TYPE_DIRECTIVE(limit,@object)
limit:	.double 0.29
	ASM_SIZE_DIRECTIVE(limit)

#define MO(op) op(%rip)

	.text
ENTRY(__asinh)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	movl	-8+4(%rsp), %ecx
	movl	$0x7fffffff, %eax
	andl	%ecx, %eax
	andl	$0x80000000, %ecx
	movl	%eax, %edx
	orl	$0x800fffff, %edx
	incl	%edx
	jz	7f			// x in ±Inf or NaN
	xorl	%ecx, -8+4(%rsp)
	fldl	-8(%rsp)		// |x|
	cmpl	$0x3e300000, %eax
	jb	2f			// |x| < 2^-28
	fldln2				// log(2) : |x|
	cmpl	$0x41b00000, %eax
	fxch				// |x| : log(2)
	ja	3f			// |x| > 2^28
	cmpl	$0x40000000, %eax
	ja	5f			// |x| > 2

	// 2^-28 <= |x| <= 2 => y = sign(x)*log1p(|x|+|x|^2/(1+sqrt(1+|x|^2)))
	fld	%st			// |x| : |x| : log(2)
	fmul	%st(1)			// |x|^2 : |x| : log(2)
	fld	%st			// |x|^2 : |x|^2 : |x| : log(2)
	faddl	MO(one)			// 1+|x|^2 : |x|^2 : |x| : log(2)
	fsqrt				// sqrt(1+|x|^2) : |x|^2 : |x| : log(2)
	faddl	MO(one)			// 1+sqrt(1+|x|^2) : |x|^2 : |x| : log(2)
	fdivrp				// |x|^2/(1+sqrt(1+|x|^2)) : |x| : log(2)
	faddp				// |x|+|x|^2/(1+sqrt(1+|x|^2)) : log(2)
	fcoml	MO(limit)
	fnstsw
	sahf
	ja	6f
	fyl2xp1
	jecxz	4f
	fchs
4:
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

7:
	ret

6:	faddl	MO(one)
	fyl2x
	jecxz	4f
	fchs
4:
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

	// |x| < 2^-28 => y = x (inexact iff |x| != 0.0)
	.align ALIGNARG(4)
2:
	jecxz	4f
	fchs				// x
4:	fld	%st			// x : x
	faddl	MO(huge)		// huge+x : x
	fstp	%st(0)			// x
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

	// |x| > 2^28 => y = sign(x) * (log(|x|) + log(2))
	.align ALIGNARG(4)
3:	fyl2x				// log(|x|)
	fldln2				// log(2) : log(|x|)
	faddp				// log(|x|)+log(2)
	jecxz	4f
	fchs
4:
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret

	// |x| > 2 => y = sign(x) * log(2*|x| + 1/(|x|+sqrt(x*x+1)))
	.align ALIGNARG(4)
5:	fld	%st			// |x| : |x| : log(2)
	fadd	%st, %st(1)		// |x| : 2*|x| : log(2)
	fld	%st			// |x| : |x| : 2*|x| : log(2)
	fmul	%st(1)			// |x|^2 : |x| : 2*|x| : log(2)
	faddl	MO(one)			// 1+|x|^2 : |x| : 2*|x| : log(2)
	fsqrt				// sqrt(1+|x|^2) : |x| : 2*|x| : log(2)
	faddp				// |x|+sqrt(1+|x|^2) : 2*|x| : log(2)
	fdivrl	MO(one)			// 1/(|x|+sqrt(1+|x|^2)) : 2*|x| : log(2)
	faddp				// 2*|x|+1/(|x|+sqrt(1+|x|^2)) : log(2)
	fyl2x				// log(2*|x|+1/(|x|+sqrt(1+|x|^2)))
	jecxz	4f
	fchs
4:
	fstpl	-8(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END(__asinh)
weak_alias (__asinh, asinh)
