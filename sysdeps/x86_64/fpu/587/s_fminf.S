/* Compute minimum of two numbers, regarding NaN as missing argument.
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

#include <sysdep.h>

	.text
ENTRY(__fminf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	STORE_FLOAT_REG (1, -8(%rsp))
	flds	-4(%rsp)	// x
	flds	-8(%rsp)	// x : y

	fxam
	fnstsw
	andb	$0x45, %ah
	cmpb	$0x01, %ah
	je	1f		// y == NaN

	fucom	%st(1)
	fnstsw
	sahf
	jc	2f

1:	fxch	%st(1)
2:	fstp	%st(1)

	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END(__fminf)
weak_alias (__fminf, fminf)
