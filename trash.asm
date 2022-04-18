%include "stud_io.inc"

global _start

section .data
	a dw 10
	b dd 20

section .bss
	c resd 1

section .text
_start:
	movsx	eax, word [a]
	add	eax, dword [b]
	mov	dword [c], eax

