; compile with ml.exe and link.exe
;
; \masm32\bin\ml /c /Cp /coff test.asm
; \masm32\bin\Link /subsystem:windows test.obj
;

.386
.model flat, stdcall
option casemap:none

; include prototype function and library
include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

; initialized data
.data
    AppName db 'Reverse string MASM32', 0
    ClassName db 'BasicWinClass', 0
    ButtonName db 'Reverse', 0
    ButtonClassName db 'Button', 0
    BoxClassName db 'Edit', 0

; uninitialized data
.data?
    hInstance HINSTANCE ?
    wc WNDCLASSEX <?>
    msg MSG <?>
    hWnd HWND ?
    hWndButton HWND ?
    hWndEdit HWND ?
    hWndEdit2 HWND ?
    buff db 100 dup(?)

.code
start:
    push NULL
    call GetModuleHandle    ; get instance handle of program
    mov hInstance, eax

    mov wc.cbSize, sizeof WNDCLASSEX        
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.cbClsExtra, NULL
    mov wc.cbWndExtra, NULL
    push hInstance
    pop wc.hInstance
    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, offset ClassName
    push IDI_APPLICATION
    push NULL
    call LoadIconA
    mov wc.hIcon, eax
    mov wc.hIconSm, eax
    push IDC_ARROW
    push NULL
    call LoadCursorA
    mov wc.hCursor, eax     ; fill window class structure
    push offset wc
    call RegisterClassExA   ; register window class

    push NULL
    push hInstance
    push NULL
    push NULL
    push 170
    push 400
    push CW_USEDEFAULT
    push CW_USEDEFAULT
    push WS_OVERLAPPEDWINDOW
    push offset AppName
    push offset ClassName
    push NULL
    call CreateWindowExA    ; create window

    mov hWnd, eax           ; new window handle
    push SW_NORMAL
    push hWnd
    call ShowWindow         ; set window to normal, so it is visible
    
    push hWnd
    call UpdateWindow       ; display window

messageLoop:
    push 0
    push 0
    push NULL
    push offset msg
    call GetMessageA        ; get message from message loop
    or eax, eax
    jle endLoop
    push offset msg
    call TranslateMessage   ; translate virtual-key messages into character messages
    push offset msg
    call DispatchMessageA
    jmp messageLoop
endLoop:
    mov eax, msg.wParam
    push eax
    call ExitProcess

WndProc proc
    push ebp
    mov ebp, esp
    cmp dword ptr[ebp+12], WM_DESTROY
    jz WMDESTROY
    cmp dword ptr[ebp+12], WM_CREATE
    jz WMCREATE
    cmp dword ptr[ebp+12], WM_COMMAND
    jz WMCOMMAND

FINISH:
    push dword ptr[ebp+20]
    push dword ptr[ebp+16]
    push dword ptr[ebp+12]
    push dword ptr[ebp+8]
    call DefWindowProc
    jmp EXIT_PROC

WMCREATE:
    ; create button window
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]
    push 20
    push 60
    push 10
    push 10
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset ButtonName
    push offset ButtonClassName
    push 0
    call CreateWindowExA
    mov hWndButton, eax

    ; create first edit window
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]
    push 20
    push 350
    push 50
    push 10
    push WS_CHILD or WS_VISIBLE or WS_BORDER or WS_TABSTOP
    push NULL
    push offset BoxClassName
    push 0
    call CreateWindowExA
    mov hWndEdit, eax

    ; create second edit window
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]
    push 20
    push 350
    push 100
    push 10
    push WS_CHILD or WS_VISIBLE or WS_BORDER or WS_TABSTOP
    push NULL
    push offset BoxClassName
    push 0
    call CreateWindowExA
    mov hWndEdit2, eax

    jmp FINISH

WMCOMMAND:
    mov eax, hWndButton
    cmp dword ptr [ebp+20], eax
    jne FINISH

    ; get string from first edit window
    push 100
    push offset buff
    push hWndEdit
    call GetWindowText

    ; start to reverse string    
    mov esi, offset buff
    mov edi, offset buff
    dec edi

findLastString:
    inc edi
    mov al, [edi]
    cmp al, 0
    jnz findLastString
    dec edi

reverseLoop:
    cmp esi, edi
    jge displayRevStr

    mov bl, [esi]
    mov al, [edi]
    mov [esi], al
    mov [edi], bl

    inc esi
    dec edi
    jmp reverseLoop

    ; show string reversed to second edit window
displayRevStr:
    push offset buff
    push hWndEdit2
    call SetWindowText

    jmp FINISH

WMDESTROY:
    push 0
    call PostQuitMessage
    xor eax, eax

EXIT_PROC:
    pop ebp
    ret 4*4
WndProc endp

end start