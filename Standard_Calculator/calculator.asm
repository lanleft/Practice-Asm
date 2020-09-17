;ml /c /Cp /coff calculator.asm
;link /subsystem:windows calculator.obj

.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\windows.inc
include D:\masm32\include\kernel32.inc
include D:\masm32\include\user32.inc
include D:\masm32\include\gdi32.inc
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\user32.lib
includelib D:\masm32\lib\gdi32.lib

.data
    AppName db 'Calculator', 0
    ClassName db 'BasicWinClass', 0

    BtnOne db '1', 0
    BtnTwo db '2', 0
    BtnThr db '3',0
    BtnFou db '4',0
    BtnFiv db '5',0
    BtnSix db '6',0
    BtnSev db '7',0
    BtnEgh db '8',0
    BtnNin db '9',0
    BtnNeg db '+/-',0
    BtnEqu db '=',0
    BtnAdd db '+',0
    BtnZer db '0',0
    BtnMul db '*',0
    BtnDiv db '/',0
    BtnCle db 'C',0
    BtnCE db 'CE',0
    BtnDE db '<x',0
    BtnSub db '-',0
    BtnPoi db '.', 0

    ButtonClassName db 'Button', 0
    BoxClassName db 'Edit', 0

    errorZero db 'Cannot divide by zero', 0, 0
    errorIntOver db 'Interger Overflow', 0
    errorInvalid db 'Invalid Input', 0
.data?
    hInstance HINSTANCE ?
    wc WNDCLASSEX <?>
    msg MSG <?>
    hwnd HWND ?

    hwndBtnOne HWND ?
    hwndBtnTwo HWND ?
    hwndBtnThr HWND ?
    hwndBtnFou HWND ?
    hwndBtnFiv HWND ?
    hwndBtnZer HWND ?
    hwndBtnSix HWND ?                
    hwndBtnSev HWND ?
    hwndBtnEgh HWND ?
    hwndBtnNin HWND ?
    hwndBtnAdd HWND ?
    hwndBtnSub HWND ?
    hwndBtnMul HWND ?
    hwndBtnDiv HWND ?
    hwndBtnCle HWND ?
    hwndBtnCE HWND ?
    hwndBtnDE HWND ?
    hwndBtnNeg HWND ?
    hwndBtnEqu HWND ?
    hwndBtnPoi HWND ?

    hwndEdit HWND ?
    hwndEdit2 HWND ?
    hFontEdit HWND ?
    buff1 db 100 dup(?)
    string db 100 dup(?)
    string1 db 100 dup(?)
    string2 db 100 dup(?)
    buff2 db 100 dup(?)
    buff3 db 100 dup(?)
    tmp1 dd 100 dup(?)
    tmp2 dd 100 dup(?)
    tmp3 dd 100 dup(?)
    tmp4 dd 100 dup(?)
    tmp5 dd 100 dup(?)
    tmp6 dd 100 dup(?)

    lParam LPARAM ?
    wParam WPARAM ?

.code 
start:
    push NULL 
    call GetModuleHandle 
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
    mov wc.hCursor, eax 

    push offset wc
    call RegisterClassExA 

    push NULL 
    push hInstance
    push NULL
    push NULL
    push 499
    push 356
    push CW_USEDEFAULT
    push CW_USEDEFAULT
    push WS_OVERLAPPEDWINDOW
    push offset AppName
    push offset ClassName
    push NULL
    call CreateWindowExA 

    mov hwnd, eax
    push SW_NORMAL
    push hwnd
    call ShowWindow

    push  hwnd
    call UpdateWindow

messageloop:
    push 0
    push 0
    push NULL
    push offset msg 
    call GetMessageA 
    or eax, eax 
    jle endloop
    push offset msg 
    call TranslateMessage       ; translate message, virtual key message
    push offset msg 
    call DispatchMessageA
    jmp messageloop

endloop:
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

    cmp dword ptr[ebp+12], WM_KEYDOWN
    jz WMKEYDOWN

    cmp dword ptr[ebp+12], WM_HOTKEY
    jz WMHOTKEY 

    jmp FINISH_2

FINISH_2:
    push dword ptr[ebp+20]  ; lParam
    push dword ptr[ebp+16]  ; wParam
    push dword ptr[ebp+12]  ; msg
    push dword ptr[ebp+8]   ; hwnd
    call DefWindowProc
    jmp EXIT_PROC

FINISH: 
    push hwnd
    call SetFocus
    push dword ptr[ebp+20]  ; lParam
    push dword ptr[ebp+16]  ; wParam
    push dword ptr[ebp+12]  ; msg
    push dword ptr[ebp+8]   ; hwnd
    call DefWindowProc
    jmp EXIT_PROC 

WMCREATE:
    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 210    ; y
    push  0    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnCE 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnCE, eax 

    push NULL
    push FF_DONTCARE
    push DEFAULT_QUALITY
    push CLIP_DEFAULT_PRECIS
    push OUT_DEFAULT_PRECIS
    push DEFAULT_CHARSET
    push FALSE
    push FALSE
    push FALSE
    push 0
    push 0
    push 0
    push 13
    push 30
    call CreateFontA
    mov hFontEdit, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnCE
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 210    ; y
    push 85    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnCle 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnCle, eax 

    push NULL
    push FF_DONTCARE
    push DEFAULT_QUALITY
    push CLIP_DEFAULT_PRECIS
    push OUT_DEFAULT_PRECIS
    push DEFAULT_CHARSET
    push FALSE
    push FALSE
    push FALSE
    push 0
    push 0
    push 0
    push 13
    push 30
    call CreateFontA
    mov hFontEdit, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnCle
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 210    ; y
    push 170    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnDE 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnDE, eax 

    push NULL
    push FF_DONTCARE
    push DEFAULT_QUALITY
    push CLIP_DEFAULT_PRECIS
    push OUT_DEFAULT_PRECIS
    push DEFAULT_CHARSET
    push FALSE
    push FALSE
    push FALSE
    push 0
    push 0
    push 0
    push 13
    push 30
    call CreateFontA
    mov hFontEdit, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnDE
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 210    ; y
    push 255    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnDiv 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnDiv, eax 

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnDiv
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 260    ; y
    push  0    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnSev 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnSev, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnSev
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 260    ; y
    push 85    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnEgh 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnEgh, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnEgh
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 260    ; y
    push 170    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnNin 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnNin, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnNin
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 260    ; y
    push 255    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnMul 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnMul, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnMul
    call SendMessage
    
    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 310    ; y
    push 0    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnFou 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnFou, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnFou
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 310    ; y
    push 85    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnFiv 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnFiv, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnFiv
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 310    ; y
    push 170    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnSix 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnSix, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnSix
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 310    ; y
    push 255    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnSub 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnSub, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnSub
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 360    ; y
    push 0    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnOne 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnOne, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnOne
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 360    ; y
    push 85    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnTwo 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnTwo, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnTwo
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 360    ; y
    push 170    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnThr 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnThr, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnThr
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 360    ; y
    push 255    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnAdd 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnAdd, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnAdd
    call SendMessage


    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 410    ; y
    push 0    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnNeg 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnNeg, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnNeg
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 410    ; y
    push 85    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnZer 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnZer, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnZer
    call SendMessage

    ; create button window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]   ; hwndParent 
    push 50     ; height 
    push 85     ; width 
    push 410    ; y
    push 255    ; x
    push WS_CHILD or BS_DEFPUSHBUTTON or WS_VISIBLE or WS_TABSTOP
    push offset BtnEqu 
    push offset ButtonClassName 
    push 0
    call CreateWindowExA 
    mov hwndBtnEqu, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndBtnEqu
    call SendMessage


    ; create first edit window
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]
    push 25
    push 338
    push 55
    push 1
    push WS_CHILD or WS_VISIBLE or WS_BORDER or WS_TABSTOP or ES_READONLY or ES_RIGHT
    push NULL
    push offset BoxClassName 
    push 0
    call CreateWindowExA
    mov hwndEdit, eax 

    ; create second edit window 
    push 0
    push hInstance
    push 0
    push dword ptr[ebp+8]
    push 50
    push 338
    push 80
    push 1
    push WS_CHILD or WS_VISIBLE or WS_BORDER or ES_RIGHT or ES_READONLY or WS_TABSTOP
    push NULL
    push offset BoxClassName 
    push 0
    call CreateWindowExA
    mov hwndEdit2, eax

    push NULL
    push FF_DONTCARE
    push DEFAULT_QUALITY
    push CLIP_DEFAULT_PRECIS
    push OUT_DEFAULT_PRECIS
    push DEFAULT_CHARSET
    push FALSE
    push FALSE
    push FALSE
    push 0
    push 0
    push 0
    push 13
    push 30
    call CreateFontA
    mov hFontEdit, eax

    push TRUE
    push hFontEdit
    push WM_SETFONT
    push hwndEdit2
    call SendMessage

    call SET_TEXT_EDIT2   

    jmp FINISH 
WMKEYDOWN:
    mov eax, 48
    cmp dword ptr[ebp+16], eax
    jz ZERO 

    mov eax, 49
    cmp dword ptr[ebp+16], eax
    jz ONE

    mov eax, 50
    cmp dword ptr[ebp+16], eax
    jz TWO

    mov eax, 51
    cmp dword ptr[ebp+16], eax
    jz THREE

    mov eax, 52
    cmp dword ptr[ebp+16], eax
    jz FOUR

    mov eax, 53
    cmp dword ptr[ebp+16], eax
    jz FIVE

    mov eax, 54
    cmp dword ptr[ebp+16], eax
    jz SIX

    mov eax, 55
    cmp dword ptr[ebp+16], eax
    jz SEVEN

    mov eax, 56
    cmp dword ptr[ebp+16], eax
    jz EIGHT

    mov eax, 57
    cmp dword ptr[ebp+16], eax
    jz NINE

    mov eax, VK_OEM_PLUS
    cmp dword ptr[ebp+16], eax
    jz ADDNUMBERS

    mov eax, 109
    cmp dword ptr[ebp+16], eax
    jz SUBNUMBERS

    mov eax, 106
    cmp dword ptr[ebp+16], eax
    jz MULNUMBERS

    mov eax, 111
    cmp dword ptr[ebp+16], eax
    jz DIVNUMBERS

    mov eax, 8
    cmp dword ptr[ebp+16], eax
    jz DELNUMBERS

    mov eax, 0dh
    cmp dword ptr[ebp+16], eax
    jz EQUNUMBERS

WMHOTKEY:          ; false
    mov eax, dword ptr[ebp+20]
    cmp eax, 02h       ; ctrl key
    jnz FINISH
    mov eax, dword ptr[ebp+16]
    cmp eax, 56h        ; v key
    jnz FINISH

    push NULL 
    call OpenClipboard
    cmp eax, 0
    jz FINISH

    push CF_TEXT
    call GetClipboardData
    cmp eax, 0
    jz ErrorInput
    mov tmp3, eax
    push offset buff2
    push offset tmp3
    call STR_TO_INT
    push offset buff2
    push hwndEdit2
    call SetWindowTextA
    jmp FINISH

    ErrorInput:
        call SET_TEXT_EDIT2
        push offset errorInvalid
        push hwndEdit2
        call SetWindowTextA
        jmp FINISH

WMCOMMAND:
   
    mov eax, hwndBtnZer
    cmp dword ptr[ebp+20], eax
    jz ZERO 

    
    mov eax, hwndBtnOne
    cmp dword ptr[ebp+20], eax
    jz ONE

    
    mov eax, hwndBtnTwo
    cmp dword ptr[ebp+20], eax
    jz TWO

    
    mov eax, hwndBtnThr
    cmp dword ptr[ebp+20], eax
    jz THREE


   
    mov eax, hwndBtnFou
    cmp dword ptr[ebp+20], eax
    jz FOUR

   
    mov eax, hwndBtnFiv
    cmp dword ptr[ebp+20], eax
    jz FIVE

    
    mov eax, hwndBtnSix
    cmp dword ptr[ebp+20], eax
    jz SIX

    
    mov eax, hwndBtnSev
    cmp dword ptr[ebp+20], eax
    jz SEVEN

    
    mov eax, hwndBtnEgh
    cmp dword ptr[ebp+20], eax
    jz EIGHT

    
    mov eax, hwndBtnNin
    cmp dword ptr[ebp+20], eax
    jz NINE

    
    mov eax, hwndBtnAdd
    cmp dword ptr[ebp+20], eax
    jz ADDNUMBERS

    mov eax, hwndBtnSub
    cmp dword ptr[ebp+20], eax
    jz SUBNUMBERS

    
    mov eax, hwndBtnMul
    cmp dword ptr[ebp+20], eax
    jz MULNUMBERS

    
    mov eax, hwndBtnDiv
    cmp dword ptr[ebp+20], eax
    jz DIVNUMBERS

    mov eax, hwndBtnNeg
    cmp dword ptr[ebp+20], eax
    jz NEGNUMBERS

   
    mov eax, hwndBtnEqu
    cmp dword ptr[ebp+20], eax
    jz EQUNUMBERS

    
    mov eax, hwndBtnCE
    cmp dword ptr[ebp+20], eax
    jz CENUMBERS

    
    mov eax, hwndBtnCle
    cmp dword ptr[ebp+20], eax
    jz CLEARNUMBERS

    
    mov eax, hwndBtnDE
    cmp dword ptr[ebp+20], eax
    jz DELNUMBERS

    
    ;mov eax, hwndBtnPoi
    ;cmp dword ptr[ebp+20], eax
    ;jz POINTNUMBERS

    jmp FINISH


STR_TO_INT proc 
    push ebp 
    mov ebp, esp 
    xor ecx, ecx 
    xor esi, esi 
    mov ecx, [ebp + 8]
    mov ecx, [ecx]
    cmp ecx, 0 
    jl CONVERT 
    jmp CONTINUE 

    CONVERT:
        neg ecx
        mov dh, 45 
        mov eax, [ebp+12]
        mov [eax], dh
        inc eax 
        mov [ebp+12], eax 

    CONTINUE:
        xor edi, edi
        xor edx, edx 
        xor eax, eax 
        mov ebx, 10 
        mov eax, ecx 
        div ebx 
        mov ecx, eax 
        add dl, 48 
        mov edi, [ebp+12]
        mov [esi+edi], dl 
        inc esi 
        cmp ecx, 0
        jz  func1 
        jmp CONTINUE

    func1:
        mov dl, 0 
        mov [esi+edi], dl 
        xor edi, edi 
        xor esi, esi 
        mov esi, [ebp+12]
        mov edi, [ebp+12]
        dec edi 
    func2:
        inc edi
        mov al, [edi]
        cmp al, 0
        jnz func2
        dec edi 

    func3:
        cmp esi, edi
        jge EXIT_STR 
        mov bl, [esi]
        mov al, [edi]
        mov [esi], al
        mov [edi], bl 
        inc esi 
        dec edi 
        jmp func3 
    EXIT_STR:
        pop ebp 
        ret 8 

STR_TO_INT endp 


SET_TEXT_EDIT2 proc
    push ebp
    mov ebp, esp
    mov tmp3, 0
    mov string1, 0
    mov string2, 0
    mov buff3, 0
    mov tmp6, 0
    mov buff2, 0
    mov string,0
    mov tmp5, 0
    mov tmp4, 1
    mov tmp2, 1
    push offset buff2
    push offset tmp3
    call STR_TO_INT
    push offset string1
    push hwndEdit
    call SetWindowTextA
    push offset buff2
    push hwndEdit2
    call SetWindowTextA
    pop ebp
    ret

SET_TEXT_EDIT2 endp
    ZERO:
        cmp tmp2, 0
        jnz V1ZERO 
        mov tmp2, 1

        push offset string2
        push offset string1
        call lstrcatA

        push offset string  
        push hwndEdit2
        call SetWindowTextA
        mov tmp3, 0

        V1ZERO:
            mov eax, tmp3
            cmp eax, 0
            jge V2ZERO
            neg eax
            imul eax, 10
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT 
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2ZERO:
            imul eax, 10
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH


    ONE:
        cmp tmp2, 0
        jnz V1ONE 
        mov tmp2, 1

        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0

        V1ONE:
            mov eax, tmp3 
            cmp eax, 0
            jge V2ONE 
            neg eax 
            imul eax, 10 
            add eax, 1
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2ONE:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 1 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH


    TWO:
        cmp tmp2, 0
        jnz V1TWO 
        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1TWO:
            mov eax, tmp3 
            cmp eax, 0
            jge V2TWO 
            neg eax 
            imul eax, 10 
            add eax, 2
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2TWO:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 2 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

    THREE:
        cmp tmp2, 0
        jnz V1THREE
        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1THREE:
            mov eax, tmp3 
            cmp eax, 0
            jge V2THREE 
            neg eax 
            imul eax, 10 
            add eax, 3
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2THREE:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 3 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

    FOUR:
        cmp tmp2, 0
        jnz V1FOUR
        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1FOUR:
            mov eax, tmp3 
            cmp eax, 0
            jge V2FOUR 
            neg eax 
            imul eax, 10 
            add eax, 4
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2FOUR:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 4 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

    FIVE:
        cmp tmp2, 0
        jnz V1FIVE
        mov buff3, 0
        

        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1FIVE:
            mov eax, tmp3 
            cmp eax, 0
            jge V2FIVE 
            neg eax 
            imul eax, 10 
            add eax, 5
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2FIVE:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 5 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

    SIX:
        cmp tmp2, 0
        jnz V1SIX
        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1SIX:
            mov eax, tmp3 
            cmp eax, 0
            jge V2SIX 
            neg eax 
            imul eax, 10 
            add eax, 6
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2SIX:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 6 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

    SEVEN:
        cmp tmp2, 0
        jnz V1SEVEN
        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1SEVEN:
            mov eax, tmp3 
            cmp eax, 0
            jge V2SEVEN 
            neg eax 
            imul eax, 10 
            add eax, 7
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2SEVEN:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 7 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

    EIGHT:  
        cmp tmp2, 0
        jnz V1EIGHT
        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1EIGHT:
            mov eax, tmp3 
            cmp eax, 0
            jge V2EIGHT 
            neg eax 
            imul eax, 10 
            add eax, 8
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2EIGHT:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 8 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH     


    NINE:     
        cmp tmp2, 0
        jnz V1NINE
        mov tmp2, 1


        push offset string2
        push offset string1
        call lstrcatA

        push offset string
        push hwndEdit2
        call SetWindowTextA

        mov tmp3, 0
    V1NINE:
            mov eax, tmp3 
            cmp eax, 0
            jge V2NINE 
            neg eax 
            imul eax, 10 
            add eax, 9
            neg eax 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH

        V2NINE:
            cmp eax, 222222222
            jg REFUSE
            imul eax, 10 
            add eax, 9 
            mov tmp3, eax 
            push offset buff2 
            push offset tmp3 
            call STR_TO_INT
            push offset buff2 
            push hwndEdit2
            call SetWindowTextA
            jmp FINISH  

    REFUSE:
        call SET_TEXT_EDIT2
        push offset errorIntOver
        push hwndEdit2
        call SetWindowTextA
        jmp FINISH
    DIVNUMBERS:

        mov eax, tmp4 
        cmp eax, 1
        jnz v1div 
        mov eax, tmp3 
        mov tmp5, eax 
        mov tmp4, 0
        push offset string
        push offset tmp5 
        call STR_TO_INT
        mov eax, tmp2 
        cmp eax, 1
        jnz DIVTEXT 
        push offset buff2 
        push offset string1 
        call lstrcatA
        mov tmp2, 0
        jmp DIVTEXT

        v1div:
            mov eax, tmp2 
            cmp eax, 1
            jnz DIVTEXT
            push offset buff2
            push offset string1 
            call lstrcatA
            mov tmp2, 0
            mov al, buff3
            cmp al, 43
            jz Div_add
            cmp al, 45
            jz Div_sub
            cmp al, 42
            jz Div_mul 
            cmp al, 47
            jz Div_div
            
            jmp DIVTEXT 

            

            Div_add:
                mov eax, tmp5
                sub eax, tmp3
                mov tmp5, eax 
                push offset string
                push offset tmp5 
                call STR_TO_INT
                jmp DIVTEXT

            Div_sub:
                mov eax, tmp5 
                add eax, tmp3 
                mov tmp5, eax 
                push offset string
                push offset tmp5 
                call STR_TO_INT
                jmp DIVTEXT

            Div_mul:
                mov eax, tmp5 
                mov edx, tmp4 
                imul eax, edx 
                mov tmp5, eax 
                push offset string 
                push offset tmp5 
                call STR_TO_INT
                jmp DIVTEXT

            Div_div:
                mov ebx, tmp3 
                cmp ebx, 0
                jz CANNOT_DIV
                xor edx, edx 
                mov eax, tmp5 
                cdq
                idiv ebx
                mov tmp5, eax 
                push offset string
                push offset tmp5 
                call STR_TO_INT
                jmp DIVTEXT

            DIVTEXT:
                mov string2, 0
                mov buff3, 47
                push offset string1 
                push offset string2
                call lstrcatA
                push offset buff3
                push offset string2 
                call lstrcatA
                push offset string2
                push hwndEdit
                call SetWindowTextA
                push offset string 
                push hwndEdit2
                call SetWindowTextA
                mov string1, 0
                jmp FINISH

    
            


    ADDNUMBERS:
        mov eax, tmp4 
        cmp eax, 1
        jnz v1add 
        mov eax, tmp3 
        mov tmp5, eax 
        mov tmp4, 0 
        push offset string 
        push offset tmp5 
        call STR_TO_INT
        mov eax, tmp2 
        cmp eax, 1
        jnz ADDTEXT 
        push offset buff2 
        push offset string1 
        call lstrcatA
        mov tmp2, 0 
        jmp ADDTEXT

    v1add:
        mov eax, tmp2 
        cmp eax, 1
        jnz ADDTEXT
        push offset buff2 
        push offset string1 
        call lstrcatA
        mov tmp2, 0
        mov al,buff3 
        cmp al,  43
        jz Add_add 
        cmp al, 45
        jz Add_sub
        cmp al, 42
        jz Add_mul
        cmp al, 47
        jz Add_div 
        jmp ADDTEXT 


        Add_add:
            mov eax, tmp5 
            add eax, tmp3 
            mov tmp5, eax 
            push offset string 
            push offset tmp5 
            call STR_TO_INT
            jmp ADDTEXT

        Add_sub:
            mov eax, tmp5 
            sub eax, tmp3 
            mov tmp5, eax 
            push offset string 
            push offset tmp5 
            call STR_TO_INT
            jmp ADDTEXT
        Add_mul:
            mov eax, tmp5 
            mov edx, tmp3 
            imul eax, edx 
            mov tmp5, eax 
            push offset string 
            push offset tmp5 
            call STR_TO_INT
            jmp ADDTEXT
        Add_div:
            mov ebx, tmp3 
            cmp ebx, 0 
            jz CANNOT_DIV
            xor edx, edx 
            mov eax, tmp5 
            idiv ebx 
            mov tmp5, eax 
            push offset string 
            push offset tmp5 
            call STR_TO_INT
            jmp ADDTEXT
        ADDTEXT:
            mov string2, 0
            mov buff3, 43
            push offset string1
            push offset string2 
            call lstrcatA
            push offset buff3 
            push offset string2 
            call lstrcatA
            push offset string2 
            push hwndEdit
            call SetWindowTextA
            push offset string
            push hwndEdit2
            call SetWindowTextA
            mov string1, 0
            jmp FINISH

    CANNOT_DIV:
        call SET_TEXT_EDIT2
        push offset errorZero
        push hwndEdit2
        call SetWindowTextA
        jmp FINISH


    POINTNUMBERS:

    SUBNUMBERS:
        mov eax, tmp4
        cmp eax, 1
        jnz v1sub
        mov eax, tmp3
        mov tmp5, eax 
        mov tmp4, 0
        push offset string
        push offset tmp5 
        call STR_TO_INT
        mov eax, tmp2
        cmp eax, 1
        jnz SUBTEXT 
        push offset buff2 
        push offset string1 
        call lstrcatA
        mov tmp2, 0
        jmp SUBTEXT

        v1sub:
            mov eax, tmp2
            cmp eax, 1
            jnz SUBTEXT
            push offset buff2
            push offset string1 
            call lstrcatA
            mov tmp2, 0
            mov al, buff3
            cmp al, 43
            jz Sub_add
            cmp al, 45
            jz Sub_sub
            cmp al, 42
            jz Sub_mul
            cmp al, 47
            jz Sub_div
            jmp SUBTEXT

        Sub_add:
            mov eax, tmp5 
            add eax, tmp3 
            mov tmp5, eax
            push offset string
            push offset tmp5
            call STR_TO_INT
            jmp SUBTEXT
        Sub_sub:
            mov eax, tmp5
            sub eax, tmp3 
            mov tmp5,eax
            push offset string
            push offset tmp5 
            call STR_TO_INT
            jmp SUBTEXT
        Sub_mul:
            mov eax, tmp5
            mov edx, tmp3
            imul eax, edx
            mov tmp5, eax
            call STR_TO_INT
            jmp SUBTEXT
        Sub_div:
            mov ebx, tmp3
            cmp ebx, 0
            jnz CANNOT_DIV
            xor edx, edx
            mov eax, tmp5 
            cdq 
            idiv ebx
            mov tmp5, eax 
            push offset string 
            push offset tmp5
            call STR_TO_INT
            jmp SUBTEXT
        SUBTEXT:
            mov string2, 0
            mov buff3, 45
            push offset string1
            push offset string2
            call lstrcatA
            push offset buff3
            push offset string2
            call lstrcatA
            push offset string2 
            push hwndEdit
            call SetWindowTextA
            push offset string
            push hwndEdit2
            call SetWindowTextA
            mov string1, 0
            jmp FINISH



            

    NEGNUMBERS:
        mov eax, tmp2
        cmp eax, 1
        jnz NEG_EXIT
        mov eax, tmp3
        neg eax
        mov tmp3, eax 
        push offset buff2
        push offset tmp3
        call STR_TO_INT
        push offset buff2
        push hwndEdit2
        call SetWindowTextA

        NEG_EXIT:
            jmp FINISH

    MULNUMBERS:
        mov eax, tmp4
        cmp eax, 1
        jnz v1mul
        mov eax, tmp3
        mov tmp5, eax
        mov tmp4, 0
        push offset string
        push offset tmp5
        call STR_TO_INT
        mov eax, tmp2
        cmp eax, 1
        jnz MULTEXT 
        push offset buff2
        push offset string1
        call lstrcatA
        mov tmp2, 0
        jmp MULTEXT

        v1mul:
            mov eax, tmp2
            cmp eax, 1
            jnz MULTEXT
            push offset buff2
            push offset string1
            call lstrcatA
            mov tmp2, 0
            mov al, buff3
            cmp al, 43
            jz Mul_add
            cmp al, 45
            jz Mul_sub
            cmp al, 42
            jz Mul_mul
            cmp al, 47
            jz Mul_div
            jmp MULTEXT

        Mul_add:
            mov eax, tmp5
            add eax, tmp3
            mov tmp5, eax
            push offset string
            push offset tmp5
            call STR_TO_INT
            jmp MULTEXT

        Mul_sub:
            mov eax, tmp5
            sub eax, tmp3
            mov tmp5, eax
            push offset string
            push offset tmp5
            call STR_TO_INT
            jmp MULTEXT

        Mul_mul:
            mov eax, tmp5
            mov edx, tmp3
            imul eax, edx
            mov tmp5, eax
            push offset string
            push offset tmp5
            call STR_TO_INT
            jmp MULTEXT

        Mul_div:
            mov ebx, tmp3
            cmp ebx, 0
            jz CANNOT_DIV
            xor edx, edx
            mov eax, tmp5
            cdq
            idiv ebx
            mov tmp5, eax
            push offset string
            push offset tmp5
            call STR_TO_INT
            jmp MULTEXT

        MULTEXT:
            mov string2, 0
            mov buff3, 42
            push offset string1
            push offset string2
            call lstrcatA
            push offset buff3
            push offset string2
            call lstrcatA
            push offset string2
            push hwndEdit
            call SetWindowTextA
            push offset string
            push hwndEdit2
            call SetWindowTextA
            mov string1, 0
            jmp FINISH



    EQUNUMBERS:
        mov al, buff3
        cmp al, 43
        jz Equ_add
        cmp al, 45
        jz Equ_sub
        cmp al, 42
        jz Equ_mul
        cmp al, 47
        jz Equ_div
        jmp EQUTEXT_2

    EQUTEXT_2:
      ;  mov edx, tmp5
       ; mov tmp3, edx
       ; mov string1, 0
       ; mov string2, 0
        mov buff3, 0
       ; mov tmp6,0
       ; mov tmp4, 1
       ; mov tmp2, 1
      ;  mov tmp5, 0
        push offset buff2
        push offset tmp3
        call STR_TO_INT
        push offset string1
        push hwndEdit
        call SetWindowTextA
        push offset buff2
        push hwndEdit2
        call SetWindowTextA
        mov buff2, 0
        mov tmp3, 0
        jmp FINISH


    Equ_add:
        mov eax, tmp5
        add eax, tmp3
        mov tmp5, eax
        jmp EQUTEXT

    Equ_sub:
        mov eax, tmp5
        sub eax, tmp3
        mov tmp5, eax
        jmp EQUTEXT

    Equ_mul:
        mov eax, tmp5
        mov edx, tmp3
        imul eax, edx
        mov tmp5, eax
        jmp EQUTEXT

    Equ_div:
        mov ebx, tmp3
        cmp ebx, 0
        jz CANNOT_DIV
        xor edx, edx
        mov eax, tmp5
        cdq
        idiv ebx
        mov tmp5, eax
        jmp EQUTEXT

    EQUTEXT:
        mov edx, tmp5
        mov tmp3, edx
        mov string1, 0
      ;  mov string2, 0
        mov buff3, 0
        mov tmp6,0
        mov tmp4, 1
        mov tmp2, 1
        mov tmp5, 0
        push offset buff2
        push offset tmp3
        call STR_TO_INT
        push offset string1
        push hwndEdit
        call SetWindowTextA
        push offset buff2
        push hwndEdit2
        call SetWindowTextA
        mov buff2, 0
        mov tmp3, 0
        jmp FINISH

    
    CENUMBERS:
        mov eax, tmp2
        cmp eax, 1
        jnz CE_EXIT
        mov tmp3, 0
        push offset buff2
        push offset tmp3
        call STR_TO_INT
        push offset buff2
        push hwndEdit2
        call SetWindowTextA

        CE_EXIT:
            jmp FINISH


    CLEARNUMBERS:
        call SET_TEXT_EDIT2
        jmp FINISH

    DELNUMBERS:
        mov eax, tmp2
        cmp eax, 1
        jnz DE_EXIT
        xor edx, edx
        mov ebx, 10
        mov eax, tmp3
        cdq
        idiv ebx
        mov tmp3, eax
        push offset buff2
        push offset tmp3
        call STR_TO_INT
        push offset buff2
        push hwndEdit2
        call SetWindowTextA

        DE_EXIT:
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