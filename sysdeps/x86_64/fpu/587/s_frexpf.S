/* ix87 specific frexp implementation for float.
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
	ASM_TYPE_DIRECTIVE(two25,@object)
two25:	.byte 0, 0, 0, 0x4c
	ASM_SIZE_DIRECTIVE(two25)

#define MO(op) op(%rip)

#define VAL	-4

	.text
ENTRY (__frexpf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	movl	VAL(%rsp), %eax
	xorl	%ecx, %ecx
	movl	%eax, %edx
	andl	$0x7fffffff, %eax
	jz	1f
	cmpl	$0x7f800000, %eax
	jae	1f

	cmpl	$0x00800000, %eax
	jae	2f

	flds	VAL(%rsp)
	fmuls	MO(two25)
	movl	$-25, %ecx
	fstps	VAL(%rsp)
	fwait
	movl	VAL(%rsp), %eax
	movl	%eax, %edx
	andl	$0x7fffffff, %eax

2:	shrl	$23, %eax
	andl	$0x807fffff, %edx
	subl	$126, %eax
	orl	$0x3f000000, %edx
	addl	%eax, %ecx
	movl	%edx, VAL(%rsp)

	/* Store %ecx in the variable pointed to by the second argument,
	   get the factor from the stack and return.  */
1:
	LOAD_FLOAT_REG (VAL(%rsp), 0)
	movl	%ecx, (%rdi)

	ret
END (__frexpf)
weak_alias (__frexpf, frexpf)
