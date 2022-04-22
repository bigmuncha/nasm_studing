%include "stud_io.inc"

global _start

section .data
	; b dd 1
	; c dd -2
	; d dd 3

section .bss
	array resd 30

; // a
; static unsigned char a;
; static unsigned int b;
; // b
; static char a;
; static short b;

section .text
_start:
	mov ebx, 192
	mov esi, array
	mov eax, 0
lp:
	add eax, [esi]
	add esi, 4
	loop lp
