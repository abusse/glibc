/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_copysign.S,v 1.4 1995/05/08 23:53:02 jtc Exp $")

ENTRY(__copysign)
	LOAD_REG_K1
	STORE_DOUBLE_REG (1, -16(%rsp))
	STORE_DOUBLE_REG (0, -8(%rsp))
	movl	-12(%rsp),%edx
	movl	-4(%rsp),%eax
	andl	$0x80000000,%edx
	andl	$0x7fffffff,%eax
	orl	%edx,%eax
	movl	%eax,-4(%rsp)
	LOAD_DOUBLE_REG (-8(%rsp), 0)
	ret
END (__copysign)
weak_alias (__copysign, copysign)
