/* libpthread symbol versions of the K1OM ABI that upstream dropped
   because x86_64 libc exports the same name@version; the K1OM libc
   starts at GLIBC_2.14.  Each forwards to the libc function.  */

	.text
	.p2align 4
	.globl __k1om_compat_0
	.type __k1om_compat_0, @function
__k1om_compat_0:
	jmp __nanosleep@PLT
	.size __k1om_compat_0, .-__k1om_compat_0
	.symver __k1om_compat_0, __nanosleep@GLIBC_2.2.6
	.p2align 4
	.globl __k1om_compat_1
	.type __k1om_compat_1, @function
__k1om_compat_1:
	jmp __vfork@PLT
	.size __k1om_compat_1, .-__k1om_compat_1
	.symver __k1om_compat_1, __vfork@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_2
	.type __k1om_compat_2, @function
__k1om_compat_2:
	jmp __wait@PLT
	.size __k1om_compat_2, .-__k1om_compat_2
	.symver __k1om_compat_2, __wait@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_3
	.type __k1om_compat_3, @function
__k1om_compat_3:
	jmp nanosleep@PLT
	.size __k1om_compat_3, .-__k1om_compat_3
	.symver __k1om_compat_3, nanosleep@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_4
	.type __k1om_compat_4, @function
__k1om_compat_4:
	jmp pthread_attr_destroy@PLT
	.size __k1om_compat_4, .-__k1om_compat_4
	.symver __k1om_compat_4, pthread_attr_destroy@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_5
	.type __k1om_compat_5, @function
__k1om_compat_5:
	jmp pthread_attr_getdetachstate@PLT
	.size __k1om_compat_5, .-__k1om_compat_5
	.symver __k1om_compat_5, pthread_attr_getdetachstate@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_6
	.type __k1om_compat_6, @function
__k1om_compat_6:
	jmp pthread_attr_getinheritsched@PLT
	.size __k1om_compat_6, .-__k1om_compat_6
	.symver __k1om_compat_6, pthread_attr_getinheritsched@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_7
	.type __k1om_compat_7, @function
__k1om_compat_7:
	jmp pthread_attr_getschedparam@PLT
	.size __k1om_compat_7, .-__k1om_compat_7
	.symver __k1om_compat_7, pthread_attr_getschedparam@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_8
	.type __k1om_compat_8, @function
__k1om_compat_8:
	jmp pthread_attr_init@PLT
	.size __k1om_compat_8, .-__k1om_compat_8
	.symver __k1om_compat_8, pthread_attr_init@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_9
	.type __k1om_compat_9, @function
__k1om_compat_9:
	jmp pthread_attr_setdetachstate@PLT
	.size __k1om_compat_9, .-__k1om_compat_9
	.symver __k1om_compat_9, pthread_attr_setdetachstate@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_10
	.type __k1om_compat_10, @function
__k1om_compat_10:
	jmp pthread_attr_setinheritsched@PLT
	.size __k1om_compat_10, .-__k1om_compat_10
	.symver __k1om_compat_10, pthread_attr_setinheritsched@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_11
	.type __k1om_compat_11, @function
__k1om_compat_11:
	jmp pthread_attr_setschedparam@PLT
	.size __k1om_compat_11, .-__k1om_compat_11
	.symver __k1om_compat_11, pthread_attr_setschedparam@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_12
	.type __k1om_compat_12, @function
__k1om_compat_12:
	jmp pthread_equal@PLT
	.size __k1om_compat_12, .-__k1om_compat_12
	.symver __k1om_compat_12, pthread_equal@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_13
	.type __k1om_compat_13, @function
__k1om_compat_13:
	jmp pthread_self@PLT
	.size __k1om_compat_13, .-__k1om_compat_13
	.symver __k1om_compat_13, pthread_self@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_14
	.type __k1om_compat_14, @function
__k1om_compat_14:
	jmp vfork@PLT
	.size __k1om_compat_14, .-__k1om_compat_14
	.symver __k1om_compat_14, vfork@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_15
	.type __k1om_compat_15, @function
__k1om_compat_15:
	jmp wait@PLT
	.size __k1om_compat_15, .-__k1om_compat_15
	.symver __k1om_compat_15, wait@GLIBC_2.2.5
	.p2align 4
	.globl __k1om_compat_16
	.type __k1om_compat_16, @function
__k1om_compat_16:
	jmp waitpid@PLT
	.size __k1om_compat_16, .-__k1om_compat_16
	.symver __k1om_compat_16, waitpid@GLIBC_2.2.5
