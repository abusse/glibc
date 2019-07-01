/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Fixed errno handling by Ulrich Drepper <drepper@redhat.com>.
 * Public domain.
 */

#define __need_Emath
#include <bits/errno.h>
#include <machine/asm.h>

RCSID("$NetBSD: s_sinf.S,v 1.3 1995/05/09 00:27:53 jtc Exp $")

ENTRY(__sinf)
	LOAD_REG_K1
	STORE_FLOAT_REG (0, -4(%rsp))
	flds	-4(%rsp)
	fxam
	fstsw	%ax
	movb	$0x45, %dh
	andb	%ah, %dh
	cmpb	$0x05, %dh
	je	3f
4:	fsin
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
	fsin
	fstps	-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
3:
	call	__errno_location@PLT
	movl	$EDOM, (%rax)
	jmp	4b
END (__sinf)
weak_alias (__sinf, sinf)
