
.386
.model flat,stdcall
option casemap:none
DlgProc proto :DWORD,:DWORD,:DWORD,:DWORD

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
DlgName db "MyDialog",0
AppName db "String",0
; TestString db "Wow! I'm in an edit box now",0

.data?
hInstance HINSTANCE ?
CommandLine LPSTR ?
buffer db 512 dup(?)

.const
IDC_EDIT1            equ 3000
IDC_EDIT2            equ 3004
IDC_BUTTON     equ 3001
IDC_CLEAR            equ 3002
IDM_GETTEXT  equ 32000
IDM_CLEAR       equ 32001
IDM_EXIT           equ 32002
 

.code
start:
    push NULL
    call GetModuleHandle
    mov    hInstance,eax

    push NULL 
    push offset DlgProc
    push NULL 
    push offset DlgName
    push hInstance
    call DialogBoxParamA

    push eax 
    call ExitProcess

DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    
    cmp uMsg, WM_INITDIALOG
    jz ONINITDIALOG

    cmp uMsg, WM_CLOSE
    jz ONCLOSE

    cmp uMsg, WM_COMMAND
    jz ONCOMMAND 

    jmp DEFAULT 

    ONINITDIALOG:
        push IDC_EDIT1
        push hWnd
        call GetDlgItem

        push eax 
        call SetFocus

        jmp EXIT

    ONCLOSE:
        push 0
        push IDM_EXIT
        push WM_COMMAND
        push hWnd
        call SendMessage
        jmp EXIT

    ONCOMMAND:
        mov eax,wParam
        mov ebx, lParam
        cmp bx, 0
        jnz CLK_BUT

        cmp ax, IDM_GETTEXT
        jz ONGETTEXT 

        cmp ax, IDM_CLEAR
        jz ONCLEAR

        cmp ax, IDM_EXIT
        jz ONEXIT 

            ONGETTEXT:
                push 512
                push offset buffer
                push IDC_EDIT1
                push hWnd
                call GetDlgItemText

                push MB_OK
                push offset AppName
                push offset buffer
                push NULL
                call MessageBox

                jmp EXIT

            ONCLEAR:
                push NULL 
                push IDC_EDIT1
                push hWnd
                call SetDlgItemText

                push NULL 
                push IDC_EDIT2
                push hWnd
                call SetDlgItemText

                jmp EXIT 

            ONEXIT:
                push NULL
                push hWnd
                call EndDialog
                
                jmp EXIT 

        CLK_BUT:
            mov edx,wParam
            shr edx,16

            cmp dx, BN_CLICKED
            jz ONBUTTON 

            jmp DEFAULT

            ONBUTTON:
                cmp ax, IDC_BUTTON
                jz ONIDCBUT

                cmp ax, IDC_CLEAR
                jz ONIDCCLEAR 

                jmp DEFAULT

                ONIDCBUT:
                    push 512 
                    push offset buffer
                    push IDC_EDIT1
                    push hWnd
                    call GetDlgItemText

                    mov esi, offset buffer
                    mov edi, offset buffer
                    dec edi

                    findLastString:
                        inc edi
                        mov al, [edi]
                        cmp al, 0
                        jnz findLastString
                        dec edi

                    reverseLoop:
                        cmp esi, edi
                        jge done

                        mov bl, [esi]
                        mov al, [edi]
                        mov [esi], al
                        mov [edi], bl

                        inc esi
                        dec edi
                        jmp reverseLoop

                    done:
                        push offset buffer
                        push IDC_EDIT2
                        push hWnd
                        call SetDlgItemText

                    jmp EXIT

                ONIDCCLEAR:
                    push NULL 
                    push IDC_EDIT1
                    push hWnd
                    call SetDlgItemText

                    push NULL 
                    push IDC_EDIT2
                    push hWnd
                    call SetDlgItemText

                    jmp EXIT 

    DEFAULT:
        mov eax, 0
        jmp EXIT

    EXIT:
        ret
DlgProc endp

end start


