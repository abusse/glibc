/* Before 2.43 the generic version computes in double_t, which is long
   double with x87 math and breaks its rounding steps.  */
#include <math.h>
#define double_t double
#include <sysdeps/ieee754/dbl-64/e_log2.c>
