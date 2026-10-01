ifeq ($(subdir),math)
# The CORE-MATH and generic fma/pow implementations assume
# FLT_EVAL_METHOD == 0 (see sysdeps/i386/Makefile; i386 keeps the x87
# acosh and atanh).
CFLAGS-e_acosh.c += -fexcess-precision=standard
CFLAGS-e_atanh.c += -fexcess-precision=standard
CFLAGS-e_cosh.c += -fexcess-precision=standard
CFLAGS-e_lgamma_r.c += -fexcess-precision=standard
CFLAGS-e_gamma_r.c += -fexcess-precision=standard
CFLAGS-e_sinh.c += -fexcess-precision=standard
CFLAGS-s_erf.c += -fexcess-precision=standard
CFLAGS-s_erfc.c += -fexcess-precision=standard
CFLAGS-s_erf_common.c += -fexcess-precision=standard
CFLAGS-s_fma.c += -fexcess-precision=standard
CFLAGS-s_fmaf.c += -fexcess-precision=standard
CFLAGS-s_tanh.c += -fexcess-precision=standard
CFLAGS-e_pow.c += -fexcess-precision=standard
endif
