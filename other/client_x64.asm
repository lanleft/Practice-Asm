struc sockaddr_in
	.sin_family resw 1
	.sin_port resw 1
	.sin_addr resd 1
	.sin_zero resb 8
endstruc

section .data
	isockaddr_in istruc sockaddr_in
		at sockaddr_in.sin_family, dw 2
		at sockaddr_in.sin_port, dw 0x3930
		at sockaddr_in.sin_addr, dd 0
		at sockaddr_in.sin_zero, dd 0, 0
	iend
	isockaddr_inLen equ $-isockaddr_in

	keyXOR db '!@#$%^&*()'					; key to run XOR encrypt function

section .bss
	listenSocket resd 1
	buff resb 256

section .text
	global _start

_start:
	mov dword[listenSocket], 0

	call _socket

	call _connect

	.mainLoop:
		call _read				; read from STDIN
		call _send				; send to socket
		call _recv				; receive from socket
		call _print				; print to STDOUT

		jmp .mainLoop

	call _close

	call _exit

_socket:
	mov rdx, 0
	mov rsi, 1
	mov rdi, 2
	mov rax, 41
	syscall

	mov [listenSocket], rax

	ret

_connect:
	mov rdx, 0x10
	mov rsi, isockaddr_in
	mov rdi, [listenSocket]
	mov rax, 42					; SYS_CONNECT
	syscall

	ret

_read:
	mov rdx, 256
	mov rsi, buff
	mov rdi, 0
	mov rax, 0
	syscall

	call _encrypt				; data encrypted, then send to server	

	ret

_send:
	mov rdx, rax
	mov rsi, buff
	mov rdi, [listenSocket]
	mov rax, 1
	syscall

	ret

_recv:
	mov rdx, 256				; data decrypted, then print to STDOUT
	mov rsi, buff
	mov rdi, [listenSocket]
	mov rax, 0
	syscall

	call _encrypt

	ret

_print:
	mov rdx, rax
	mov rsi, buff
	mov rdi, 1
	mov rax, 1
	syscall

	ret

_close:
	mov rdi, [listenSocket]
	mov rax, 3
	syscall

	ret

_encrypt:
	mov rcx, -1
	mov r8, -1
	.loop:
		inc rcx
		inc r8
		cmp byte[buff+rcx], 0		; if encryption is complete, then end
		je .next
		cmp byte[keyXOR+r8], 0		; if key to xor is end, then reset
		jne .xorLable

		.reset:
			mov r8, 0

		.xorLable:
			mov bl, byte[keyXOR+r8]	; else xor data with key
			xor byte[buff+rcx], bl	; replace old data
		
		jmp .loop

	.next:
		nop

	ret

_exit:
	mov rdi, 0
	mov rax, 60
	syscall