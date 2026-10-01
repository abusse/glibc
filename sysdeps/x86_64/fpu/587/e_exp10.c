/* Before 2.43 the generic version computes in double_t, which is long
   double with x87 math and breaks its rounding steps.  Before 2.39 its
   huge negative argument path returns DBL_MIN * DBL_MIN, which GCC folds
   in long double without raising underflow.  */
#include <math.h>
#include <float.h>
#include <math_private.h>
#if __has_include (<math-narrow-eval.h>)
# include <math-narrow-eval.h>
#endif
#if __has_include (<math-barriers.h>)
# include <math-barriers.h>
#endif
#if __has_include (<math-underflow.h>)
# include <math-underflow.h>
#endif
#include <libm-alias-finite.h>
#pragma push_macro ("libm_alias_finite")
#undef libm_alias_finite
#define libm_alias_finite(from, to)
#define double_t double
#define __ieee754_exp10 __ieee754_exp10_generic
#include <sysdeps/ieee754/dbl-64/e_exp10.c>
#undef __ieee754_exp10
#undef libm_alias_finite
#pragma pop_macro ("libm_alias_finite")

double
__ieee754_exp10 (double arg)
{
  if (isless (arg, DBL_MIN_10_EXP - DBL_DIG - 10) && !isinf (arg))
    return math_narrow_eval (math_opt_barrier (DBL_MIN) * DBL_MIN);
  double ret = __ieee754_exp10_generic (arg);
  if (!isnan (ret))
    math_check_force_underflow_nonneg (ret);
  return ret;
}
libm_alias_finite (__ieee754_exp10, __exp10)
