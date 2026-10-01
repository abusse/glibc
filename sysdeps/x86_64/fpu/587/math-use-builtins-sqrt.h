/* fsqrt rounds once to the x87 precision: correct for float and long
   double, but double rounding breaks double results.  */
#define USE_SQRT_BUILTIN 0
#define USE_SQRTF_BUILTIN 1
#define USE_SQRTL_BUILTIN 1
#define USE_SQRTF128_BUILTIN 0
