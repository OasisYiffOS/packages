/*
 * Common module linker script, always used when linking a module.
 * Archs are free to supply their own linker scripts.  ld will
 * combine them automatically.
 */
#ifdef CONFIG_CFI_CLANG
# include <asm/page.h>
# define ALIGN_CFI 		ALIGN(PAGE_SIZE)
# define SANITIZER_DISCARDS	*(.eh_frame)
#else
# define ALIGN_CFI
# define SANITIZER_DISCARDS
#endif

SECTIONS {
	/DISCARD/ : {
		*(.discard)
		*(.discard.*)
	}

	__ksymtab		0 : { *(SORT(___ksymtab+*)) }
	__ksymtab_gpl		0 : { *(SORT(___ksymtab_gpl+*)) }
	__kcrctab		0 : { *(SORT(___kcrctab+*)) }
	__kcrctab_gpl		0 : { *(SORT(___kcrctab_gpl+*)) }

	.ctors			0 : ALIGN(8) { *(SORT(.ctors.*)) *(.ctors) }
	.init_array		0 : ALIGN(8) { *(SORT(.init_array.*)) *(.init_array) }

	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }

	__patchable_function_entries : { *(__patchable_function_entries) }

}

/* bring in arch-specific sections */
