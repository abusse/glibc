/* ix87 specific frexp implementation for long double.
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
	ASM_TYPE_DIRECTIVE(two64,@object)
two64:	.byte 0, 0, 0, 0, 0, 0, 0xf0, 0x43
	ASM_SIZE_DIRECTIVE(two64)

#define MO(op) op(%rip)

#define VAL0	8
#define VAL1	VAL0+4
#define VAL2	VAL1+4

	.text
ENTRY (__frexpl)
	movl	VAL0(%rsp), %ecx
	movl	VAL2(%rsp), %eax
	orl	VAL1(%rsp), %ecx
	movl	%eax, %edx
	andl	$0x7fff, %eax
	orl	%eax, %ecx
	jz	1f
	xorl	%ecx, %ecx
	cmpl	$0x7fff, %eax
	je	1f

	cmpl	$0, %eax
	jne	2f

	fldt	VAL0(%rsp)

	fmull	MO(two64)	/* It's not necessary to use a 80bit factor */
	movl	$-64, %ecx
	fstpt	VAL0(%rsp)
	fwait
	movl	VAL2(%rsp), %eax
	movl	%eax, %edx
	andl	$0x7fff, %eax

2:	andl	$0x8000, %edx
	subl	$16382, %eax
	orl	$0x3ffe, %edx
	addl	%eax, %ecx
	movl	%edx, VAL2(%rsp)

	/* Store %ecx in the variable pointed to by the second argument,
	   get the factor from the stack and return.  */
1:
	fldt	VAL0(%rsp)
	movl	%ecx, (%rdi)

	ret
END (__frexpl)
weak_alias (__frexpl, frexpl)
