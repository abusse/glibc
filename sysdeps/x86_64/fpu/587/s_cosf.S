/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Fixed errno handling by Ulrich Drepper <drepper@redhat.com>.
 * Public domain.
 */

#define __need_Emath
#include <errno.h>
#include <machine/asm.h>

RCSID("$NetBSD: s_cosf.S,v 1.3 1995/05/08 23:55:16 jtc Exp $")

ENTRY(__cosf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)
	fxam
	fstsw	%ax
	movb	$0x45, %dh
	andb	%ah, %dh
	cmpb	$0x05, %dh
	je	3f
4:	fcos
	fnstsw	%ax
	testl	$0x400,%eax
	jnz	1f
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
	.align ALIGNARG(4)
1:	fldpi
	fadd	%st(0)
	fxch	%st(1)
2:	fprem1
	fnstsw	%ax
	testl	$0x400,%eax
	jnz	2b
	fstp	%st(1)
	fcos
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
3:
	call	__errno_location@PLT
	movl	$EDOM, (%rax)
	jmp	4b
END (__cosf)
weak_alias (__cosf, cosf)
