; ml /c /Cp /coff createBall.asm
; link /subsystem:windows createBall.obj

.386 
.model flat, stdcall
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

.const
    DRAWING equ 1
    WATTING equ 0
    PEN_COLOR equ 00000000h;  black
    PEN_SIZE equ 2
    BALL_SIZE equ 40
    BALL_SPEED equ 100


.data
    ClassName db 'SimpleWinclass', 0
    AppName db 'Ball', 0

    WIN_HEIGHT dd 500
    WIN_WIDTH dd 700

    state db WATTING

    vectorX dd 19
    vectorY dd -19



.data?
    hInstance HINSTANCE ?
    
    tlpoint POINT <> ; top and left
    brpoint POINT <> ; bottom and right

    ; use for create window
    wc WNDCLASSEX <?>
    msg MSG     <?>    ; handle message
    hwnd HWND   ?     ; handle window procedure

    hdc HDC ?
    ps PAINTSTRUCT <?>

    time SYSTEMTIME <?>
    hPen HPEN   ?

.code 
start:
    push NULL
    call GetModuleHandle    ; retrive the handle of my program
    mov hInstance, eax      ; a win32 function will nearly always preserve the segment registers and the ebx, edi, esi and ebp registers

    ;call WinMain(hInstance, hPrevInstance, lpCmdLine, nShowCmd)
    push SW_SHOW
    push NULL
    push NULL
    push hInstance
    call WinMain
    ; return the exit value contained in that message's wParam parameter
    
    ;call ExitProcess(uExitCode)
    push eax
    call ExitProcess

    ;Define WinMain
    WinMain Proc hInst:HINSTANCE, hPrevInst: HINSTANCE, CmdLine: LPSTR, CmdShow:DWORD
        ; struct, define in window.inc

        ; load defaul icon, call LoadIconA(hInstance, lpIconName)
        push IDI_APPLICATION
        push NULL
        call LoadIconA
        mov wc.hIcon, eax
        mov wc.hIconSm, eax

        ; load defaul cursor 
        ; call LoadCursorA(hInstance, lpIconName)
        push IDC_ARROW
        push NULL
        call LoadCursorA
        mov wc.hCursor, eax

        mov wc.cbSize, sizeof WNDCLASSEX    ; size of this structure
        mov wc.style, CS_HREDRAW or CS_VREDRAW  ; redraw the entire when change the width and height of the client area
        mov wc.lpfnWndProc, offset WndProc      ; address of window procedure 
        mov wc.cbClsExtra, NULL 
        mov wc.cbWndExtra, NULL
        push hInstance
        pop wc.hInstance
        mov wc.hbrBackground, COLOR_WINDOW+1 
        mov wc.lpszMenuName, NULL
        mov wc.lpszClassName, offset ClassName

        push offset ClassName
        call RegisterClassEx

        ; after register ClassName , use it to create window
        ; call CreateWindowA(lpClassName, lpWindowName, dwStyle, x,y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam)
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

        mov hwnd, eax       ;return window handle

        ; display window
        ; call ShowWindow(hWnd, CmdShow)
        push CmdShow
        push hwnd
        call ShowWindow

        ; update window
        push hwnd
        call UpdateWindow

        ; messgae loop
        MESSAGE_LOOP:
            ; get message
            push 0
            push 0
            push NULL 
            push offset msg
            call GetMessage

            ; return in eax
            test eax, eax
            jle END_LOOP

            ; translate vitural-key message into character  message in WM_CHAR
            push offset msg
            call DispatchMessage

            jmp MESSAGE_LOOP

            END_LOOP:
                mov eax, msg.wParam
                ret
    WinMain endp

    ; an application-defined callback function that processes WM_TIMER message
    TimerProc Proc thwnd:HWND, uMsg:UINT, idEvent:UINT, dwtime:DWORD
        ; call InvalidateRect function adds a rectangle to the specified window's update region 
        ; hwnd a handle to the window whose update region has changed 
        ; lpRect is a pointer to a rect structure that contain the client coordinates of the rectangle to be added to the update region 
        ; bErase, specifies whether the backgraound within the update region is to bo ereased when update region is processed     
        push TRUE
        push NULL
        push thwnd 
        call InvalidateRect
        ret 
    TimerProc endp

    ; handle message with notification
    WndProc Proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
        cmp uMsg, WM_PAINT
        je ON_WM_PAINT

        cmp uMsg, WM_CREATE
        je ON_WM_CREATE

        cmp uMsg, WM_LBUTTONDOWN
        je ON_WM_LBUTTONDOWN

        cmp uMsg, WM_DESTROY
        je ON_WM_DESTROY

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
            ; create a pen with special color and size
            push PEN_COLOR
            push PEN_SIZE
            push PS_SOLID
            call CreatePen 
            mov hPen, eax

            jmp EXIT 
        
        ON_WM_LBUTTONDOWN:
            cmp [state], DRAWING
            je EXIT

            push lParam
            call UpdateXY

            ; when clicked , set state to DRWAING 
            mov [state], DRAWING
            
            ;call SetTimer(hwnd, nidEvent, uElapse, lpTimerFunc)
            ; Creates a timer with the specified time-out value 
            ; uElapse is the time-out value, in milliseconds 
            ; lpTimerFunc is a pointer to the function to be notified when the time-ou t value alapses
            push offset TimerProc
            push 200
            push 1
            push hwnd
            call SetTimer

            jmp EXIT

        ON_WM_PAINT:
            mov dword ptr[time.wMilliseconds], 0 
            
            push offset ps 
            push hwnd
            call BeginPaint 
            mov hdc, eax        ; handle DC

            ; apply pen to hdc
            ; the SelectObject function selects an object into the specified device context (DC)
            push hPen
            push hdc        ; handle device context 
            call SelectObject 

            call createEllipse

            push offset ps
            push hwnd
            call EndPaint

            jmp EXIT 

        ON_DEFAULT:
            ; process default other message 
            push lParam
            push wParam
            push uMsg       ; message
            push hwnd       ; window
            call DefWindowProc 

            jmp EXIT 

        EXIT:
            ret 
    WndProc endp

    createEllipse Proc
        push brpoint.y      ; bottom right 
        push brpoint.x      ;  
        push tlpoint.y      ; top left
        push tlpoint.x 
        push hdc 
        call Ellipse 

        call moveEllipse 
        
        mov eax, WIN_WIDTH
        cmp brpoint.x , eax 
        jg MEET_RIGHT_LEFT 

        mov eax, WIN_HEIGHT
        cmp brpoint.y, eax
        jg MEET_BOTTOM_TOP

        cmp tlpoint.x, 0
        jl MEET_RIGHT_LEFT

        cmp tlpoint.y, 0
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
        add tlpoint.y, ecx 

        ret 
    moveEllipse endp

    UpdateXY proc lParam: LPARAM
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
    UpdateXY endp

end start


