/* Shared RTM header.  */
#ifndef _HLE_H
#define _HLE_H 1

#ifndef __KNC__
# include <x86intrin.h>
#else
/* K1OM has no RTM (elision is never enabled there): every transaction
   aborts without a retry hint.  */
# define _XBEGIN_STARTED	(~0u)
# define _XABORT_EXPLICIT	(1 << 0)
# define _XABORT_RETRY		(1 << 1)
# define _XABORT_CODE(x)	(((x) >> 24) & 0xff)
# define _xbegin()		0u
# define _xend()		((void) 0)
# define _xabort(code)		((void) 0)
#endif

#define _ABORT_LOCK_BUSY	0xff
#define _ABORT_LOCK_IS_LOCKED	0xfe
#define _ABORT_NESTED_TRYLOCK	0xfd

#endif
