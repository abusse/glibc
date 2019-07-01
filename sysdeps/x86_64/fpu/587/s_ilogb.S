/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_ilogb.S,v 1.5 1995/10/12 15:53:09 jtc Exp $")

ENTRY(__ilogb)
	LOAD_REG_K1
	STORE_DOUBLE_REG (0, -8(%rsp))
	fldl	-8(%rsp)
/* I added the following ugly construct because ilogb(+-Inf) is
   required to return INT_MAX in ISO C99.
   -- jakub@redhat.com.  */
	fxam			/* Is NaN or +-Inf?  */
	fstsw   %ax
	movb    $0x45, %dh
	andb    %ah, %dh
	cmpb    $0x05, %dh
	je      1f		/* Is +-Inf, jump.  */

	fxtract
	fstp	%st

	fistpl	-12(%rsp)
	fwait
	movl	-12(%rsp), %eax
	ret

1:	fstp	%st
	movl	$0x7fffffff, %eax
	ret
END (__ilogb)
weak_alias (__ilogb, ilogb)
