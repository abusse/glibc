/* Compute cubic root of float value.
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
        ASM_TYPE_DIRECTIVE(f3,@object)
f3:	.double 0.191502161678719066
        ASM_SIZE_DIRECTIVE(f3)
        ASM_TYPE_DIRECTIVE(f2,@object)
f2:	.double 0.697570460207922770
        ASM_SIZE_DIRECTIVE(f2)
        ASM_TYPE_DIRECTIVE(f1,@object)
f1:	.double 0.492659620528969547
        ASM_SIZE_DIRECTIVE(f1)

#define CBRT2		1.2599210498948731648
#define ONE_CBRT2	0.793700525984099737355196796584
#define SQR_CBRT2	1.5874010519681994748
#define ONE_SQR_CBRT2	0.629960524947436582364439673883

	ASM_TYPE_DIRECTIVE(factor,@object)
        .align ALIGNARG(4)
factor:	.double ONE_SQR_CBRT2
	.double ONE_CBRT2
	.double 1.0
	.double CBRT2
	.double SQR_CBRT2
	ASM_SIZE_DIRECTIVE(factor)

        ASM_TYPE_DIRECTIVE(two25,@object)
two25:	.byte 0, 0, 0, 0x4c
        ASM_SIZE_DIRECTIVE(two25)

#define MO(op) op(%rip)

	.text
ENTRY(__cbrtf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	movl	-4(%rsp), %eax
	xorl	%ecx, %ecx
	movl	%eax, %edx
	andl	$0x7fffffff, %eax
	jz	1f
	cmpl	$0x7f800000, %eax
	jae	1f

	cmpl	$0x00800000, %eax
	jae	2f

	flds	-4(%rsp)
	fmuls	MO(two25)
	movl	$-25, %ecx
	fstps	-4(%rsp)
	movl	-4(%rsp), %eax
	movl	%eax, %edx
	andl	$0x7fffffff, %eax

2:	shrl	$23, %eax
	andl	$0x807fffff, %edx
	subl	$126, %eax
	orl	$0x3f000000, %edx
	addl	%eax, %ecx
	movl	%edx, -4(%rsp)

	flds	-4(%rsp)		/* xm */
	fabs

	/* The following code has two tracks:
	    a) compute the normalized cbrt value
	    b) compute xe/3 and xe%3
	   The right track computes the value for b) and this is done
	   in an optimized way by avoiding division.

	   But why two tracks at all?  Very easy: efficiency.  Some FP
	   instruction can overlap with a certain amount of integer (and
	   FP) instructions.  So we get (except for the imull) all
	   instructions for free.  */

	fld	%st(0)			/* xm : xm */
	fmull	MO(f3)			/* f3*xm : xm */
			movl	$1431655766, %eax
	fsubrl	MO(f2)			/* f2-f3*xm : xm */
			imull	%ecx
	fmul	%st(1)			/* (f2-f3*xm)*xm : xm */
			movl	%ecx, %eax
	faddl	MO(f1)			/* u:=f1+(f2-f3*xm)*xm : xm */
			sarl	$31, %eax
	fld	%st			/* u : u : xm */
			subl	%eax, %edx
	fmul	%st(1)			/* u*u : u : xm */
	fld	%st(2)			/* xm : u*u : u : xm */
	fadd	%st			/* 2*xm : u*u : u : xm */
	fxch	%st(1)			/* u*u : 2*xm : u : xm */
	fmul	%st(2)			/* t2:=u*u*u : 2*xm : u : xm */
			movl	%edx, %eax
	fadd	%st, %st(1)		/* t2 : t2+2*xm : u : xm */
			leal	(%edx,%edx,2),%edx
	fadd	%st(0)			/* 2*t2 : t2+2*xm : u : xm */
			subl	%edx, %ecx
	faddp	%st, %st(3)		/* t2+2*xm : u : 2*t2+xm */
			movslq	%ecx, %rcx
			shlq	$3, %rcx
	fmulp				/* u*(t2+2*xm) : 2*t2+xm */
	fdivp	%st, %st(1)		/* u*(t2+2*xm)/(2*t2+xm) */
#ifdef PIC
	lea	16+factor(%rip), %rdx
	fmull	(%rdx, %rcx)		/* u*(t2+2*xm)/(2*t2+xm)*FACT */
#else
	fmull	16+factor(%rcx)		/* u*(t2+2*xm)/(2*t2+xm)*FACT */
#endif
	movl	%eax, -8(%rsp)
	fildl	-8(%rsp)		/* xe/3 : u*(t2+2*xm)/(2*t2+xm)*FACT */
	fxch				/* u*(t2+2*xm)/(2*t2+xm)*FACT : xe/3 */
	fscale				/* u*(t2+2*xm)/(2*t2+xm)*FACT*2^xe/3 */
	movl	-4(%rsp), %eax
	testl	%eax, %eax
	fstp	%st(1)
	jns	4f
	fchs
4:
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret

	/* Return the argument.  */
1:
	ret
END(__cbrtf)
weak_alias (__cbrtf, cbrtf)
