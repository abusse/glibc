/* ix87 specific frexp implementation for double.
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
	ASM_TYPE_DIRECTIVE(two54,@object)
two54:	.byte 0, 0, 0, 0, 0, 0, 0x50, 0x43
	ASM_SIZE_DIRECTIVE(two54)

#define MO(op) op(%rip)

#define VAL0	-8
#define VAL1	VAL0+4

	.text
ENTRY (__frexp)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	movl	VAL0(%rsp), %ecx
	movl	VAL1(%rsp), %eax
	movl	%eax, %edx
	andl	$0x7fffffff, %eax
	orl	%eax, %ecx
	jz	1f
	xorl	%ecx, %ecx
	cmpl	$0x7ff00000, %eax
	jae	1f

	cmpl	$0x00100000, %eax
	jae	2f

	fldl	VAL0(%rsp)
	fmull	MO(two54)
	movl	$-54, %ecx
	fstpl	VAL0(%rsp)
	fwait
	movl	VAL1(%rsp), %eax
	movl	%eax, %edx
	andl	$0x7fffffff, %eax

2:	shrl	$20, %eax
	andl	$0x800fffff, %edx
	subl	$1022, %eax
	orl	$0x3fe00000, %edx
	addl	%eax, %ecx
	movl	%edx, VAL1(%rsp)

	/* Store %ecx in the variable pointed to by the second argument,
	   get the factor from the stack and return.  */
1:
	LOAD_DOUBLE_REG (VAL0(%rsp), 0)
	movl	%ecx, (%rdi)

	ret
END (__frexp)
weak_alias (__frexp, frexp)
