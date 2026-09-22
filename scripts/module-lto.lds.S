/* SPDX-License-Identifier: GPL-2.0 */
/*
 * 本项目移植来源：kernels/xiaomi-4.19/scripts/module-lto.lds.S（原样复制，2026-09-21
 * 做 4.19 -> 4.4 同族 kbuild 回移时引入）。只在 CONFIG_LTO_CLANG 下参与 .ko 链接。
 * 归属与改动清单见 docs/PROJECT-MEMORY.md 的 §5.6 / §5.8。
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
	 * 4.19 原版这里带 CFI：`ALIGN(PAGE_SIZE)` + `.text.__cfi_check`。
	 * 本项目没有 CFI，去掉对齐和 cfi 段，只保留"把切分出来的 .text.* 合回去"。
	 */
	.text : {
		*(.text .text.[0-9a-zA-Z_]*)
		*(.text..L*)
	}
}
