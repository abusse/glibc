/* Round argument to nearest integral value according to current rounding
   direction.
   Copyright (C) 2011
   Free Software Foundation, Inc.
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

#include <sysdep.h>

	.text
ENTRY(__llrintf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -8(%rsp))
	flds	-8(%rsp)
	fistpll	-16(%rsp)
	fwait
	movq	-16(%rsp),%rax
	ret
END(__llrintf)
weak_alias (__llrintf, llrintf)
strong_alias (__llrintf, __lrintf)
weak_alias (__llrintf, lrintf)
