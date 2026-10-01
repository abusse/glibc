ifeq ($(subdir),math)
# The generic exp, exp2, exp10, log, log2 and pow (with double_t as
# double, see e_exp.c) need assignments rounded to double.
CFLAGS-e_exp.c += -fexcess-precision=standard
CFLAGS-e_exp2.c += -fexcess-precision=standard
CFLAGS-e_exp10.c += -fexcess-precision=standard
CFLAGS-e_log.c += -fexcess-precision=standard
CFLAGS-e_log2.c += -fexcess-precision=standard
CFLAGS-e_pow.c += -fexcess-precision=standard
endif
