%include "stud_io.inc"

global _start

section .data
	; b dd 1
	; c dd -2
	; d dd 3

section .bss
	a resb 1
	b resd 1
	c resb 1
	d resw 1
; // a
; static unsigned char a;
; static unsigned int b;
; // b
; static char a;
; static short b;

section .text
_start:
;	mov al, 199
;	add al, -61

	mov al, -35
	add al, 216

	mov al, -13
	add al, 179

	mov al, 2
	add al, 200


