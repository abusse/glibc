/* Compute sine and cosine of argument.
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

	.text
ENTRY (__sincosf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)
	fsincos
	fnstsw	%ax
	testl	$0x400,%eax
	jnz	1f
	fstps	(%rsi)
	fstps	(%rdi)
	ret

	.align ALIGNARG(4)
1:	fldpi
	fadd	%st(0)
	fxch	%st(1)
2:	fprem1
	fnstsw	%ax
	testl	$0x400,%eax
	jnz	2b
	fstp	%st(1)
	fsincos
	fstps	(%rsi)
	fstps	(%rdi)
	ret
END (__sincosf)
weak_alias (__sincosf, sincosf)
