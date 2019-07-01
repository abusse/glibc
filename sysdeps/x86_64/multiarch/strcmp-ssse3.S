#if IS_IN (libc)
# define USE_SSSE3 1
# define STRCMP __strcmp_ssse3
# include "../sse/strcmp.S"
#endif
