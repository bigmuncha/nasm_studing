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
	mov rsi,rsp
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

_start:
	mov rdi, string
	call print_string
	call print_newline
	mov rcx, 216
	call print_uint
	mov rdi, rax
	call exit

