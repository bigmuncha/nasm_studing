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
	xor r8, r8
.loop_me:
	cmp r8b, [rdi]
	je .ret_len
	inc rax
	inc rdi
	jne .loop_me
.ret_len:
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
	push rdi
	mov rsi, rsp
	mov rax, 1              ; system call 1(write)
	mov rdi, 1              ; fd(stdout)
	mov rdx, 1            ; size
	syscall
	pop rdi
	ret

print_newline:
	mov rsi, 0xA
	call print_char
	ret


;;; thist function get parametr in rdi register
print_uint:
	mov rcx, rdi
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
	mov r8, rdi
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
	add rsp, r8
	ret
.badret:
	mov rax, 0
	ret

;;get string pointer in rdi, return number in rax, in rdi set number len
parse_uint:
	mov r11, rdi
	mov r10, 1
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
	mul r10
	add r8w, ax
	mov al, r10b
	mul r9
	mov r10w, ax
	jmp .start_parse
.escape:
	mov rax, r8
	ret
;;get string pointer in rdi, return number in rax, in rdi set number len
parse_int:
	cmp byte[rdi], '-'
	je .int
.uint:
	call parse_uint
	ret
.int:
	inc rdi
	call parse_uint
	neg rax
	ret
;; get 1st string pointer in rsi and second in rdi return 1 or 0 in rax
string_equals:
	mov al, byte[rsi]
	cmp al, byte[rdi]
	jne .badret
	cmp byte[rsi], 0
	je .goodret
	inc rsi
	inc rdi
	jmp string_equals
.badret:
	mov rax, 0
	ret
.goodret:
	mov rax, 1
	ret

;; string_ptr- rdi, dest_buffer rsi, buffer length - rdx
string_copy:
	mov r8, rsi
	mov r11, rdi
	call string_length
	cmp rax, rdx
	jg .big_string
	mov rdi, r11
.copy_loop:
	cmp byte[rdi], 0
	je .fit_string
	mov dl, byte[rdi]
	mov byte[rsi], dl
	inc rsi
	inc rdi
	jmp .copy_loop
.big_string:
	mov rax,0
	ret
.fit_string:
	mov rax, r8
	ret
