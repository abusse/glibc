/* Assembler macros for KNC.
   Copyright (C) 2011 Free Software Foundation, Inc.
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
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#ifdef	__ASSEMBLER__

/* Conditional move.  */
#undef CMOVE
#define CMOVE(TRUE_COND, FALSE_COND, SRC, DST, LABEL)	\
  j##FALSE_COND LABEL##f;				\
  mov SRC, DST;						\
LABEL:

/* Load vector registers.  */
#undef LOAD_VEC_REG
#define LOAD_VEC_REG(SRC, REGNO) vmovaps SRC, %zmm##REGNO
/* Store vector registers.  */
#undef STORE_VEC_REG
#define STORE_VEC_REG(REGNO, DEST) vmovaps %zmm##REGNO, DEST
/* Save vector registers.  */
#undef SAVE_VEC_REG
#define SAVE_VEC_REG(REGNO, DEST) STORE_VEC_REG (REGNO, DEST)
/* Restore vector registers.  */
#undef RESTORE_VEC_REG
#define RESTORE_VEC_REG(SRC, REGNO) LOAD_VEC_REG (SRC, REGNO)

/* Store float vector registers.  */
#undef STORE_FLOAT_REG
#define STORE_FLOAT_REG(REGNO, DEST) vpackstorelps %zmm##REGNO, DEST{%k1}
/* Load float vector registers.  */
#undef LOAD_FLOAT_REG
#define LOAD_FLOAT_REG(SRC, REGNO) vbroadcastss SRC, %zmm##REGNO

/* Store double vector registers.  */
#undef STORE_DOUBLE_REG
#define STORE_DOUBLE_REG(REGNO, DEST) vpackstorelpd %zmm##REGNO, DEST{%k1}
/* Load double vector registers.  */
#undef LOAD_DOUBLE_REG
#define LOAD_DOUBLE_REG(SRC, REGNO) vbroadcastsd SRC, %zmm##REGNO

/* Load mask register k1.  */
#undef LOAD_REG_K1
#define LOAD_REG_K1 mov $1, %eax; kmov %eax, %k1;

#else

/* FP invalid exception.  */
#undef FP_INVALID_EXCEPTION
#define FP_INVALID_EXCEPTION						\
  {									\
    /* One example of a invalid operation is 0.0 / 0.0.  */		\
    double d;								\
    __asm__ __volatile__ ("fldz; fdiv %%st, %%st(0); fwait" : "=t" (d));\
    (void) &d;								\
  }

/* FP invalid exception.  */
#undef FP_DIVBYZERO_EXCEPTION
#define FP_DIVBYZERO_EXCEPTION						\
  {									\
    double d;								\
    __asm__ __volatile__ ("fldz; fld1; fdivp %%st, %%st(1); fwait"	\
			    : "=t" (d));				\
    (void) &d;								\
  }


/* The K1OM MXCSR has no exception mask bits (vector exceptions are
   always masked); setting bits 7-12 faults.  */
#undef MXCSR_EXCEPT_MASK
#define MXCSR_EXCEPT_MASK 0

/* Machine type in ELF header compatible with the running host.  */
#undef EM_HOST_MACHINE_TYPE
#define EM_HOST_MACHINE_TYPE EM_K1OM

#endif	/* __ASSEMBLER__ */
