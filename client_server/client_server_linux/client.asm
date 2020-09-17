; client in x64 linux
; nasm -f elf64 server.asm
; ld -s server.o -o server

struc sockaddr_in
	.sin_family resw 1
	.sin_port resw 1
	.sin_addr resd 1
	.sin_zero resb 8
endstruc 

section .data
	isockaddr_in istruc sockaddr_in
		at sockaddr_in.sin_family, dw 2				; AF_INET 
		at sockaddr_in.sin_port, dw 0x64f       	; port 1612
		at sockaddr_in.sin_addr, dd 0				; localhost
		at sockaddr_in.sin_zero, dd 0, 0
	iend
	isockaddr_inLen equ $-isockaddr_in
	
	keyEnc db '@#$#%^%h%%@#%&^%*%^&$%^$%@%$$%$^%$&$%^#^$!@#$#$!' 
	
section .bss
	listen resd 1
	buff resb 256 
	
section .text
	global _start
	
_start:
	mov dword [listen], 0

	call _socket

	call _connect

	.readloop:
		call _read 			; read string 
		call _send 			; send msg 

		call _receive  	
		call _print
		jmp .readloop
		
	call _close
	
	call _exit 
	
_socket:
	mov rdx, 0
	mov rsi, 1 
	mov rdi, 2
	mov rax, 41
	syscall 
	
	mov [listen], rax 
	ret 
	
_connect:
	mov rdx, 16
	mov rsi, isockaddr_in
	mov rdi, [listen]
	mov rax, 42 
	syscall 
	
	ret 
	
_read:
	mov rdx, 256
	mov rsi, buff
	mov rdi, 0
	mov rax, 0
	syscall
	
	call _decrypt_encrypt
	
	ret

_send:
	mov rdx, rax
	mov rsi, buff 
	mov rdi, [listen]
	mov rax, 1
	syscall
	
	ret 
_receive:
	mov rdx, 256
	mov rsi, buff
	mov rdi, [listen]
	mov rax, 0
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
_close:
	mov rdi, [listen]
	mov rax, 3
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
	
_exit:
	mov rdi, 0
	mov rax, 60 
	syscall

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
