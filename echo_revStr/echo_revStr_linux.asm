sys_exit	equ		1
sys_read	equ		3
sys_write	equ		4
stdin		equ		0
stdout		equ		1

section .data
	inputStr db 'Input String to Reverse : ', 0
	inputStrLen equ $-inputStr

section .bss
	buff resb 250

section .text
	global _start

_start:
	mov ecx, inputStr
	mov edx, inputStrLen
	call _print

	mov ecx, buff
	mov edx, 250
	call _read

	mov eax, buff
    mov ecx, -1

	.loop:
	    inc ecx
	    cmp byte [eax + ecx], 0
	    jne .loop

	dec ecx
	push ecx						
	mov eax, buff
	mov esi, eax					
	add eax, ecx					
	mov edi, eax					
	dec edi
	shr ecx, 1						

	reverseLoop:
	mov al, [esi]					
	mov bl, [edi]
	mov [esi], bl
	mov [edi], al
	inc esi							
	dec edi							
	dec ecx							
	jnz reverseLoop					

	pop ecx							
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