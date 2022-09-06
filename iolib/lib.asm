global _start

string: db "Omar", 0
;; this function get parametr of exit code in rdi register
exit:
	mov rax, 60
	syscall

;; this function get parametr of string pointer in rdi register
;; and return value in rax
string_length:
	xor rax, rax
	mov rbx, 0
.loop_me:
	cmp bl, [rdi]
	je .ret_len
	inc rax
	inc rdi
	jne .loop_me
.ret_len:
	ret

;; this function get parametr of string point in rdi register
print_string:
	mov rcx, rdi		;save string pointer here
	call string_length
	mov rbx, rax            ;save size 
	mov rax, 1              ; system call 1(write)
	mov rdi, 1              ; fd(stdout)
	mov rsi, rcx            ;buffer 
	mov rdx, rbx            ; size
	syscall
	ret

;; this function get parametr of char in rsi register
print_char:
	mov rax, 1              ; system call 1(write)
	mov rdi, 1              ; fd(stdout)
	mov rdx, 1            ; size
	syscall
	ret

print_newline:
	mov rsi, 0xA
	call print_char
_start:
	mov rdi, string
	call print_string
	mov rdi, rax
	call exit
	
