global _start

string: db "Omar", 0
;; this function get parametr of exit code in rdi register
exit:
	mov rax, 60
	syscall

;; this function get parametr of string pointer in rdi register
;; and return value in rax
string_length:
	push rbx
	xor rax, rax
	mov rbx, 0
.loop_me:
	cmp bl, [rdi]
	je .ret_len
	inc rax
	inc rdi
	jne .loop_me
.ret_len:
	pop rbx
	ret

;; this function get parametr of string point in rdi register
print_string:
	push rbx
	mov rcx, rdi		;save string pointer here
	call string_length
	mov rbx, rax            ;save size 
	mov rax, 1              ; system call 1(write)
	mov rdi, 1              ; fd(stdout)
	mov rsi, rcx            ;buffer 
	mov rdx, rbx            ; size
	syscall
	pop rbx
	ret

;; this function get parametr of char in rsi register
print_char:
	push rsi
	mov rsi, rsp
	mov rax, 1              ; system call 1(write)
	mov rdi, 1              ; fd(stdout)
	mov rdx, 1            ; size
	syscall
	pop rsi
	ret

print_newline:
	mov rsi, 0xA
	call print_char
	ret


;;; thist function get parametr in rcx register
print_uint:
	mov r9, rsp
	mov ax, cx
	mov ecx, 10
	mov edx,0
.loop_mod:
	xor rdx,rdx
	div cx
	mov [rsp - 1], dl
	dec rsp
	cmp al, 0
	jne .loop_mod
	mov  r8, rsi
.loop_print_char:
	xor rax,rax
	mov al, [rsp]
	add al, 48
	mov rsi, rax
	call print_char
	inc rsp
	cmp r9, rsp
	jne .loop_print_char
	mov rsi, r8
	ret
;;; thist function get parametr in rcx register
print_int:
	cmp rcx, 0
	jnl .uint
	neg rcx
	push rcx
	mov rsi, '-'
	call print_char
	pop rcx
.uint:
	call print_uint
	ret

;;this function get char pointer in rsi
read_char:
	mov rax, 0
	mov rdi, 0	; from stdin
	;; rsi is already set
	mov rdx, 1
	syscall
	ret

;;this function get string pointer in rsp and max size in rdi return in rax
read_word:
	mov r10, rdi
	mov r12, rdi
	mov rax, 0
	sub rsp, rdi
	mov rsi, rsp
	mov rdx, rdi
	mov rdi, 0
	syscall
	mov r11, rsi
.wordloop:
	cmp byte[rsi], ' '
	je .goodret
	cmp byte[rsi], 0xA
	je .goodret
	cmp byte[rsi], 0
	je .goodret
	inc rsi
	dec r10
	cmp r10, 0
	je .badret
	jmp .wordloop
.goodret:
	mov byte[rsi], 0
	mov rax, r11
	add rsp, r12
	ret
.badret:
	mov rax, 0
	ret

;;get string pointer in rdi, return number in rax, in rdi set number len
parse_uint:
	mov r11, rdi
	mov r12, 1
	xor r8,r8
	mov r9, 10
.find_tail:
	cmp byte[r11], 0
	je .start_parse
	inc r11
	jmp .find_tail
.start_parse:
	xor rax,rax
	dec r11
	cmp r11, rdi
	jl .escape
	mov al, byte[r11]
	sub al, 48
	mul r12
	add r8w, ax
	mov al, r12b
	mul r9
	mov r12w, ax
	jmp .start_parse
.escape:
	mov rax, r8
	ret
_start:
	; mov rdi, string
	; call print_string
	; call print_newline
	; mov rcx, 216
	; call print_uint
	; call print_newline
	; mov rcx, 15
	; call print_int
	; call print_newline
	; mov rcx, -15
	; call print_int
	; call print_newline
	; ; dec rsp
	; ; mov rsi, rsp
	; ; call read_char
	; ; xor rax, rax
	; ; mov al, byte[rsp]
	; ; mov rsi, rax
	; ; call print_char
	; ; inc rsp
.label:
	sub rsp, 100
	mov rsi, rsp
	mov rdi, 100
	call read_word
	mov rdi, rax
	call parse_uint
	mov rcx, rax
	call print_uint
	call print_newline
	mov rdi, rax
	call exit

