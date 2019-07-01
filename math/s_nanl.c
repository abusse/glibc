/* Return quiet nan.
   Copyright (C) 1997-2015 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1997.

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
   <http://www.gnu.org/licenses/>.  */

#include <math.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ieee754.h>

#define L_(Ch) Ch
#define SET_MANTISSA(flt, mant) \
  do { union ieee854_long_double u;                                           \
       u.d = (flt);                                                           \
       if ((mant & 0x7fffffffffffffffULL) == 0)                               \
         mant = 0x4000000000000000ULL;                                        \
       u.ieee.mantissa0 = (((mant) >> 32) & 0x7fffffff) | 0x80000000;         \
       u.ieee.mantissa1 = (mant) & 0xffffffff;                                \
       (flt) = u.d;                                                           \
  } while (0)

#undef __nanl
long double
__nanl (const char *tagp)
{
  const char *cp = tagp;

  while ((*cp >= L_('0') && *cp <= L_('9'))
         || (*cp >= L_('A') && *cp <= L_('Z'))
         || (*cp >= L_('a') && *cp <= L_('z'))
         || *cp == L_('_'))
    ++cp;

  long double retval = NAN;
  if (*cp != 0)
    goto out;

  /* This is a system-dependent way to specify the bitmask used for
     the NaN.  We expect it to be a number which is put in the
     mantissa of the number.  */
  char *endp;
  unsigned long long int mant;

  mant = strtoull (tagp, &endp, 0);
  if (endp == cp)
    SET_MANTISSA (retval, mant);

 out:
  return retval;
}
weak_alias (__nanl, nanl)
