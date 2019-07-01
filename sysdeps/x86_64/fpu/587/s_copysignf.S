/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_copysignf.S,v 1.3 1995/05/08 23:53:25 jtc Exp $")

ENTRY(__copysignf)
	LOAD_REG_K1
	STORE_FLOAT_REG (1, -8(%rsp))
	STORE_FLOAT_REG (0, -4(%rsp))
	movl	-8(%rsp),%edx
	movl	-4(%rsp),%eax
	andl	$0x80000000,%edx
	andl	$0x7fffffff,%eax
	orl	%edx,%eax
	movl	%eax,-4(%rsp)
	LOAD_FLOAT_REG (-4(%rsp), 0)
	ret
END (__copysignf)
weak_alias (__copysignf, copysignf)
