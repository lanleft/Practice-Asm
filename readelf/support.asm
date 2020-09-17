
sys_exit	equ		1
sys_read	equ		3
sys_write	equ		4
stdin		equ		0
stdout		equ		1

; string length calculation function
slen:
    push rbx
    mov rbx, eax

nextchar:
    cmp byte[rax], 0
    jz finished
    inc rax
    jmp nextchar

finished:
    sub rax, rbx
    pop rbx
    ret 

; string printing function
sprint:
    push rdx
    push rcx
    push rbx
    push rax
    call slen
    
    mov rdx, rax
    pop rax

    mov rcx, rax
    mov rbx, 1
    mov rax, sys_write
    int 80h

    pop rbx
    pop rcx
    pop rdx
    ret 

; steirng printing with line feed function
sprintLF:
    call sprint
    push rax
    mov rax, 10
    push rax
    mov rax, rsp
    call sprint
    pop rax     ; remove our linefeed character from the stack
    pop rax     ; restore the original value of rax before my funtion wass called

quit:
    mov rbx, 0
    mov rax, sys_exit
    int 80h
    ret 
    
