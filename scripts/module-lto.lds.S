/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Backported verbatim from the 4.19 msm kernel tree of the same product line as
 * part of a 4.19 -> 4.4 same-family kbuild backport. Only participates in .ko
 * links when CONFIG_LTO_CLANG is set.
 */
#include <asm/page.h>

/*
 * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
 * -ffunction-sections, which increases the size of the final module.
 * Merge the split sections in the final binary.
 */
SECTIONS {
	/*
	 * LLVM may emit .eh_frame with CONFIG_CFI_CLANG despite
	 * -fno-asynchronous-unwind-tables. Discard the section.
	 */
	/DISCARD/ : {
		*(.eh_frame)
	}

	.bss : {
		*(.bss .bss.[0-9a-zA-Z_]*)
		*(.bss..L*)
	}

	.data : {
		*(.data .data.[0-9a-zA-Z_]*)
		*(.data..L*)
	}

	.rodata : {
		*(.rodata .rodata.[0-9a-zA-Z_]*)
		*(.rodata..L*)
	}

	/*
	 * The 4.19 original also carried CFI here: ALIGN(PAGE_SIZE) plus
	 * .text.__cfi_check. This tree has no CFI, so the alignment and the cfi
	 * section are dropped and only "merge the split-out .text.* back" is kept.
	 */
	.text : {
		*(.text .text.[0-9a-zA-Z_]*)
		*(.text..L*)
	}
}
