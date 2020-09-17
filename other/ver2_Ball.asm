;ml /c /Cp /coff ver2_ball.asm
;link /subsystem:windows ver2_ball.obj

.386    ; use 80386 instruction
.model flat,stdcall ; uses flat memory addressing model
option casemap:none

include D:\masm32\include\windows.inc   ; windows.inc have structures and constants
include D:\masm32\include\user32.inc
includelib D:\masm32\lib\user32.lib ; CreateWindowEx, RegisterClassEx,...
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\kernel32.lib   ; ExitProcess
include D:\masm32\include\masm32.inc
includelib D:\masm32\lib\masm32.lib
include D:\masm32\include\gdi32.inc
includelib D:\masm32\lib\gdi32.lib

.CONST
DRAWING equ 1
WAITING equ 0
PEN_COLOR equ 00000000h ; black
PEN_SIZE equ 2
BALL_SIZE equ 40


.DATA
ClassName db 'SimpleWinClass',0
AppName db 'Ball',0

state db WAITING

vectorX dd 19
vectorY dd -19

WIN_WIDTH dd 700
WIN_HEIGHT dd 500

.DATA?
; HINSTANCE & LPSTR typedef DWORD in windows.inc
; reserve the space for future use
hInstance HINSTANCE ?

tlpoint POINT <>
brpoint POINT <>

; use for create window
wc WNDCLASSEX <?>
msg MSG <?> ; handle message
hwnd HWND ? ; handle window procedure

hdc HDC ?
ps PAINTSTRUCT <?>

time SYSTEMTIME <?>

hPen HPEN ?
hBrush HBRUSH ?

.CODE
start:
    ; call GetModuleHandle(null)
    push NULL
    call GetModuleHandle    ; module handle same as instance handle in Win32
    mov hInstance, eax  ; return an instance to handle in eax

    ; call WinMain(hInstance, hPrevInstance, CmdLine, CmdShow)
    ; our main function
    push SW_SHOW
    push NULL
    push NULL
    push hInstance
    call WinMain

    ; call ExitProcess
    push eax
    call ExitProcess

    ; Define WinMain
    WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
        ; Structure in msdn, define in windows.inc

        ; Load default icon
        push IDI_APPLICATION
        push NULL
        call LoadIcon
        mov wc.hIcon, eax
        mov wc.hIconSm, eax

        ; Load default cursor
        push IDC_ARROW
        push NULL
        call LoadCursor
        mov wc.hCursor, eax

        mov wc.cbSize, SIZEOF WNDCLASSEX    ; size of this structure
        mov wc.style, CS_HREDRAW or CS_VREDRAW  ; style of windows
        mov wc.lpfnWndProc, OFFSET WndProc  ; andress of window procedure
        mov wc.cbClsExtra, NULL
        mov wc.cbWndExtra, NULL
        push hInstance
        pop wc.hInstance
        mov wc.hbrBackground, COLOR_WINDOW+1    ; background color, require to add 1
        mov wc.lpszMenuName, NULL
        mov wc.lpszClassName, OFFSET ClassName

        ; we register our own class, named in ClassName
        push offset wc
        call RegisterClassEx

        ; after register ClassName, we use it to create windows compond
     
        push NULL
        push hInstance
        push NULL
        push NULL
        push WIN_HEIGHT
        push WIN_WIDTH
        push CW_USEDEFAULT
        push CW_USEDEFAULT
        push WS_OVERLAPPEDWINDOW
        push offset AppName
        push offset ClassName
        push WS_EX_CLIENTEDGE
        call CreateWindowEx

        mov hwnd, eax   ; return windows handle

        ; display window
     
        push CmdShow
        push hwnd
        call ShowWindow

        ; update window
   
        push hwnd
        call UpdateWindow

        ; Message Loop
        MESSAGE_LOOP:
            ; get message
     
            push 0
            push 0
            push NULL
            push offset msg
            call GetMessage

            ; return in eax
            ; if the function retrieves a message other than WM_QUIT, the return value is nonzero.
            ; if the function retrieves the WM_QUIT message, the return value is zero.
            test eax, eax
            jle END_LOOP

            ; translate virtual-key messages into character messages - ASCII in WM_CHAR
            push offset msg
            call TranslateMessage

            ; sends the message data to the window procedure responsible for the specific window the message is for
            push offset msg
            call DispatchMessage

            jmp MESSAGE_LOOP

        END_LOOP:
            mov eax, msg.wParam
        ret
    WinMain endp

    TimerProc PROC thwnd:HWND, uMsg:UINT, idEvent:UINT, dwTime:DWORD
            push TRUE
            push NULL
            push thwnd
            call InvalidateRect
            ret
    TimerProc ENDP

    ; Handle message with switch(notification)
    WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
        cmp uMsg, WM_PAINT
        je ON_WM_PAINT

        cmp uMsg, WM_CREATE
        je ON_WM_CREATE

        cmp uMsg, WM_LBUTTONDOWN
        je ON_WM_LBUTTONDOWN

        cmp uMsg, WM_DESTROY
        je ON_WM_DESTROY

        cmp uMsg, WM_SIZE
        je ON_WM_SIZE

        cmp uMsg, WM_QUIT
        je ON_WM_DESTROY

        cmp uMsg, WM_CLOSE
        je ON_WM_DESTROY

        jmp ON_DEFAULT

        ; user close program
        ON_WM_DESTROY:
            push NULL
            call PostQuitMessage
            jmp EXIT

        ON_WM_CREATE:
            ; create a pen with specific color and size
            push PEN_COLOR
            push PEN_SIZE
            push PS_SOLID
            call CreatePen
            mov hPen, eax

            push Black 
            call CreateSolidBrush
            mov hBrush,eax

            jmp EXIT

        ON_WM_LBUTTONDOWN:
            cmp [state], DRAWING
            je EXIT

            push lParam
            call updateXY

            ; when clicked, set state to DRAWING
            mov [state], DRAWING

            push OFFSET TimerProc
            push 50
            push 1
            push hwnd
            call SetTimer

            jmp EXIT

        ON_WM_PAINT:
            mov dword ptr[time.wMilliseconds], 0

            push offset ps
            push hWnd
            call BeginPaint
            mov hdc, eax

            ; apply pen to hdc
            push hPen
            push hdc
            call SelectObject

            push hBrush
            push hdc
            call SelectObject

            call createEllipse

            push offset ps
            push hWnd
            call EndPaint

            jmp EXIT

        ON_DEFAULT:
            ; handle any message that program don't handle
            push lParam
            push wParam
            push uMsg   ; message
            push hWnd   ; windows
            call DefWindowProc

            jmp EXIT

        ON_WM_SIZE:
            ;;== ko biet xu ly, thoi ke vay 
            

        EXIT:
            ret
    WndProc endp

    createEllipse proc
        push brpoint.y
        push brpoint.x
        push tlpoint.y
        push tlpoint.x
        push hdc
        call Ellipse

        call moveEllipse

        mov eax, WIN_WIDTH
        sub eax, BALL_SIZE
        cmp brpoint.x, eax
        jg MEET_RIGHT_LEFT

        mov eax, WIN_HEIGHT
        sub eax, 60
        cmp brpoint.y, eax
        jg MEET_BOTTOM_TOP

        cmp tlpoint.x, 20
        jl MEET_RIGHT_LEFT

        cmp tlpoint.y, 20
        jl MEET_BOTTOM_TOP

        jmp MEET_NONE

        MEET_RIGHT_LEFT:
            neg vectorX
            jmp MEET_NONE

        MEET_BOTTOM_TOP:
            neg vectorY
            jmp MEET_NONE

        MEET_NONE:

        ret
    createEllipse endp

    moveEllipse proc
        mov eax, dword ptr[vectorX]
        mov ecx, dword ptr[vectorY]

        add tlpoint.x, eax
        add tlpoint.y, ecx
        add brpoint.x, eax
        add brpoint.y, ecx

        ret
    moveEllipse endp

    updateXY proc lParam:LPARAM
        mov eax, lParam

        ; get low word that contain x
        xor ebx, ebx
        mov bx, ax

        mov tlpoint.x, ebx
        mov brpoint.x, ebx
        add brpoint.x, BALL_SIZE

        ; get high word that contain y
        mov eax, lParam
        shr eax, 16

        mov tlpoint.y, eax
        mov brpoint.y, eax
        add brpoint.y, BALL_SIZE

        ret
        updateXY endp

end start 