struc sockaddr_in
	.sin_family resw 1
	.sin_port resw 1
	.sin_addr resd 1
	.sin_zero resb 8
endstruc

section .data
	msgAcceptSuccess db 'Client connected!'
	msgAcceptSuccessLen equ $-msgAcceptSuccess

	isockaddr_in istruc sockaddr_in
		at sockaddr_in.sin_family, dw 2				; AF_INET
		at sockaddr_in.sin_port, dw 0x3930			; port 12345
		at sockaddr_in.sin_addr, dd 0				; localhost
		at sockaddr_in.sin_zero, dd 0, 0
	iend
	isockaddr_inLen equ $-isockaddr_in

section .bss
	listenSock resd 1
	connSock resd 1
	buff resb 256

section .text
	global _start

_start:
	mov dword[listenSock], 0
	mov dword[connSock], 0

	call _socket

	call _bind

	call _listen

	.mainLoop:
		call _accept

		.readLoop:
			call _read					; read from socket
			call _echo					; echo to socket

			jmp .readLoop

	call _close

	call _exit

_socket:
	mov rdx, 0
	mov rsi, 1							; SOCK_STREAM
	mov rdi, 2							; AF_INET
	mov rax, 41							; SYS_SOCKET
	syscall

	mov [listenSock], rax

	ret

_bind:
	mov rdx, isockaddr_inLen			; length of sockaddr_in
	mov rsi, isockaddr_in 				; sockaddr_in struct
	mov rdi, [listenSock] 				; listen socket fd
	mov rax, 49 						; SYS_BIND
	syscall

	ret

_listen:
	mov rsi, 1 							; backlog
	mov rdi, [listenSock]
	mov rax, 50							; SYS_LISTEN
	syscall

	ret

_accept:
	mov rdx, 0
	mov rsi, 0
	mov rdi, [listenSock]
	mov rax, 43							; SYS_ACCEPT
	syscall

	mov [connSock], rax

	mov rdx, msgAcceptSuccessLen
	mov rsi, msgAcceptSuccess
	mov rdi, 1
	mov rax, 1
	syscall

	ret

_read:
	mov rdx, 256
	mov rsi, buff
	mov rdi, [connSock]
	mov rax, 0
	syscall

	ret

_echo:
	mov rdx, rax
	mov rsi, buff
	mov rdi, [connSock]
	mov rax, 1
	syscall

	ret

_close:
	mov rdi, [connSock]
	mov rax, 3							; SYS_CLOSE
	syscall

	ret

_exit:
	mov rsi, 0
	mov rax, 60
	syscall