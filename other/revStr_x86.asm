 ; compile .asm x86
;
; nasm -f elf hello.asm
; ld -m elf_i386 -s -o hello hello.o	


sys_exit	equ		1
sys_read	equ		3
sys_write	equ		4
stdin		equ		0
stdout		equ		1

section .data
	msg1 db 'Input: '
	msg1Len equ $-msg1

section .bss
	buff resb 50

section .text
	global _start

_start:
	mov ecx, msg1
	mov edx, msg1Len
	call _print

	mov ecx, buff
	mov edx, 50
	call _read

	mov eax, buff
    mov ecx, -1

	.loop:
	    inc ecx
	    cmp byte [eax + ecx], 0
	    jne .loop

	dec ecx
	push ecx						; push length of message to stack
	mov eax, buff
	mov esi, eax					; pointer to message
	add eax, ecx					
	mov edi, eax					; pointer to last character in the message
	dec edi
	shr ecx, 1						; divide length by 2

	reverseLoop:
	mov al, [esi]					; swap character
	mov bl, [edi]
	mov [esi], bl
	mov [edi], al
	inc esi							; pointer to next character
	dec edi							; pointer to previous character
	dec ecx							; decrease counter
	jnz reverseLoop					; if counter isn't 0, keep looping

	pop ecx							; pop length of message, then save to ecx
	mov edx, ecx
	mov ecx, buff
	call _print

	call _exit

_print:
	mov eax, sys_write
	mov ebx, stdout
	int 80h
	ret

_read:
	mov eax, sys_read
	mov ebx, stdin
	int 80h
	ret

_exit:
	mov eax, sys_exit						
	mov ebx, 0
	int 80h