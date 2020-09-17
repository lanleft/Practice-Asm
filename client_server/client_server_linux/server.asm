; simple server in x64 linux
struc sockaddr_in
	.sin_family resw 1
	.sin_port resw 1
	.sin_addr resd 1
	.sin_zero resb 8
endstruc

section .data
	sucs db 'Client connected!'
	sucsLen equ $ -sucs
	
	; clsSock db 'Close socket =='
	; clsSockLen equ $  -clsSock
	
	isockaddr_in istruc sockaddr_in
		at sockaddr_in.sin_family, dw 2				; AF_INET 
		at sockaddr_in.sin_port, dw 0x64f  		; port 1612
		at sockaddr_in.sin_addr, dd 0				; localhost
		at sockaddr_in.sin_zero, dd 0, 0
	iend
	isockaddr_inLen equ $-isockaddr_in
	
	keyEnc db '@#$#%^%9%%@#%&^%*%^&$%^$%@%$$%$^%$&$%^#^$!@#$#$!' 		; key to encrypt message before send to client 
	
section .bss
	listen resd 1
	connect resd 1
	buff resb 256
	
section .text
	global _start
	
_start:
	mov dword[listen], 0
	mov dword[connect], 0
	
	call _socket

	call _bind

	call _listen

		call _accept

		.readloop:
			call _read	
			call _print				; read from socket
			call _send					; send message to socket

			jmp .readloop

	call _close

	call _exit

_socket:
	mov rdx, 0
	mov rsi, 1							; SOCK_STREAM
	mov rdi, 2							; AF_INET
	mov rax, 41							; SYS_SOCKET id
	syscall

	mov [listen], rax

	ret

_bind:
	mov rdx, isockaddr_inLen			; length of sockaddr_in
	mov rsi, isockaddr_in 				; sockaddr_in struct
	mov rdi, [listen] 				; listen socket fd (file 
	mov rax, 49 						; SYS_BIND id 
	syscall

	ret

_listen:
	mov rsi, 1 							; backlog
	mov rdi, [listen]
	mov rax, 50							; SYS_LISTEN id 
	syscall

	ret

_accept:
	mov rdx, 0
	mov rsi, 0
	mov rdi, [listen]
	mov rax, 43							; SYS_ACCEPT
	syscall

	mov [connect], rax

	mov rdx, sucsLen
	mov rsi, sucs
	mov rdi, 1
	mov rax, 1								; sprint "client connected!"
	syscall

	ret

_read:
	mov rdx, 256
	mov rsi, buff
	mov rdi, [connect]
	mov rax, 0								; sys_read id
	syscall

	call _decrypt_encrypt
	
	ret 
_print:
	mov rdx, rax
	mov rsi, buff
	mov rdi, 1
	mov rax, 1
	syscall 
	
	ret 

_send:
	call _decrypt_encrypt

	mov rdx, rax
	mov rsi, buff
	mov rdi, [connect]
	mov rax, 1
	syscall

	ret

_decrypt_encrypt:
	mov r8, -1
	mov r9, -1 
	.loop:
		inc r8
		inc r9 
		cmp byte[buff+r8], 0
		je .next  
		cmp byte[keyEnc+r9], 0
		jne .xor 

		.cycle:
			mov r9, 0

		.xor:
			mov bl, byte[keyEnc+r9]
			xor byte[buff+r8], bl 
	
		jmp .loop
		
	.next:
		nop 
		
	ret 

_close:
	mov rdi, [connect]
	mov rax, 3							; sys_close
	syscall

	ret

_exit:
	mov rsi, 0
	mov rax, 60
	syscall


	
	
	
	
	











