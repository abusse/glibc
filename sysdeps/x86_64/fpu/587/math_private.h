#ifndef _MATH_PRIVATE_H

#define math_opt_barrier(x) \
({ __typeof(x) __x;					\
   if (sizeof (x) <= sizeof (double))			\
     __asm ("" : "=x" (__x) : "0" (x));			\
   else							\
     __asm ("" : "=t" (__x) : "0" (x));			\
   __x; })
#define math_force_eval(x) \
do							\
  {							\
    if (sizeof (x) <= sizeof (double))			\
      __asm __volatile ("" : : "x" (x));		\
    else						\
      __asm __volatile ("" : : "f" (x));		\
  }							\
while (0)

/* The x87 rounding and precision helpers (SET_RESTORE_ROUND_53BIT etc.);
   from 2.28 the generic math_private.h includes them via fenv_private.h.  */
#include <sysdeps/i386/fpu/fenv_private.h>
#include <../../generic/math_private.h>

#endif
