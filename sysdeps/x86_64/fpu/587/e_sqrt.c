/* Square root of a double, x87 version for K1OM.
   Copyright (C) 2026 Free Software Foundation, Inc.
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
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

#include <math.h>
#include <math_private.h>
#include <fpu_control.h>
#include <libm-alias-finite.h>

/* fsqrt with the precision control set to double rounds the result
   once, to double, like i386 e_sqrt.S; a double square root is never
   subnormal, so there is no second rounding.  */
double
__ieee754_sqrt (double x)
{
  fpu_control_t cw, cw53;
  double r;

  _FPU_GETCW (cw);
  cw53 = (cw & ~_FPU_EXTENDED) | _FPU_DOUBLE;
  _FPU_SETCW (cw53);
  __asm__ __volatile__ ("fsqrt" : "=t" (r) : "0" (x));
  _FPU_SETCW (cw);
  return r;
}
libm_alias_finite (__ieee754_sqrt, __sqrt)
