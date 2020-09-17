.386
.model flat, stdcall
option casemap:none

; include prototype function and library
include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\gdi32.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\gdi32.lib

; initialized data
.data
	ClassName db 'BasicWinClass', 0
	AppName db 'Bouncing Ball', 0
	wndWidth dd 800
	wndHeight dd 500
	vectorX dd 5
	vectorY dd -5

; unitialized data
.data?
	hInstance HINSTANCE ?
	wc WNDCLASSEX <?>
	hwnd HWND ?
	msg MSG <?>
    ps PAINTSTRUCT <?>
    hdc HDC ?
    topLeft POINT <>
    bottomRight POINT <>
    hPen HPEN ?
    hBrush HBRUSH ?

.code
start:
	; get instance handle of program
	push NULL
	call GetModuleHandle
	mov hInstance, eax

	; register window class
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

	; create window
	push NULL
	push hInstance
	push NULL
	push NULL
	push wndHeight
	push wndWidth
	push CW_USEDEFAULT
	push CW_USEDEFAULT
	push WS_OVERLAPPEDWINDOW
	push offset AppName
	push offset ClassName
	push NULL
	call CreateWindowExA
	mov hwnd, eax

	; show window
	push SW_NORMAL
	push hwnd
	call ShowWindow

	; refresh client area of the window
	push hwnd
	call UpdateWindow

	; enter an infinity loop, checking for message from window
	MESSAGE_LOOP:
		push NULL
		push NULL
		push NULL
		push offset msg
		call GetMessageA		
		or eax, eax
		jle END_LOOP

		push offset msg
		call TranslateMessage
		
		push offset msg
		call DispatchMessageA
		
		jmp MESSAGE_LOOP

	END_LOOP:
		mov eax, msg.wParam
		push eax
		call ExitProcess

	; TimeProc function countdown time to renew background, then prepare to draw new image 
    TimerProc proc thWnd:HWND, uMsg:UINT, idEvent:UINT, dwTime:DWORD
		; background is erased when the BeginPaint function is called
		push TRUE
        push NULL
        push thWnd
        call InvalidateRect		;;

        ret
    TimerProc endp

	; WndProc function to paint circle
	WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
		cmp uMsg, WM_DESTROY
		jz ON_WM_DESTROY

        cmp uMsg, WM_CREATE
        jz ON_WM_CREATE

        cmp uMsg, WM_PAINT
        jz ON_WM_PAINT

		jmp DEFAULT

		; quit
		ON_WM_DESTROY:
			push NULL
			call PostQuitMessage
			
			jmp EXIT

        ON_WM_CREATE:
			; create a logical pen to draw circle
            push Black
            push 3
            push PS_SOLID
            call CreatePen
            mov hPen, eax

			; create brush to filled circle
            push Black
            call CreateSolidBrush
            mov hBrush, eax

			; initialize coordinates
            mov topLeft.x, 50
            mov topLeft.y, 50
            mov bottomRight.x, 100
            mov bottomRight.y, 100

			; set countdown time to delay motion of circle
			; exactly time to renew background and redraw image
            push offset TimerProc
            push 25
            push 0
            push hWnd
            call SetTimer

            jmp EXIT

		; paint circle in window
        ON_WM_PAINT:
            push offset ps
            push hWnd
            call BeginPaint
            mov hdc, eax

            push hPen
            push hdc
            call SelectObject

            push hBrush
            push hdc
            call SelectObject

            call createCircle

            push offset ps
            push hWnd
            call EndPaint

            jmp EXIT

		; DefWindowProc ensures that every message is processed
		DEFAULT:
			push lParam
			push wParam
			push uMsg
			push hWnd
			call DefWindowProc

			jmp EXIT

		EXIT:
			ret
	WndProc endp

	; createCircle function create circle, then apply motion for it
    createCircle proc
        push bottomRight.y
        push bottomRight.x
        push topLeft.y
        push topLeft.x
        push hdc
        call Ellipse

		call moveCircle

		call reverseMotion
		
		ret
    createCircle endp

	;  moveCircle function move position of circle on window
	moveCircle proc
		mov eax, dword ptr[vectorX]
		mov ecx, dword ptr[vectorY]

		add topLeft.x, eax
		add topLeft.y, ecx
		add bottomRight.x, eax
		add bottomRight.y, ecx
		
		ret
	moveCircle endp

	; reverseMotion function reversing motion of circle 
	; if circle meet left, right, bottom, up of window
	reverseMotion proc
		mov eax, wndWidth
        cmp bottomRight.x, eax
        jg MEET_RIGHT_LEFT

        mov eax, wndHeight
        cmp bottomRight.y, eax
        jg MEET_BOTTOM_TOP

        cmp topLeft.x, 0
        jl MEET_RIGHT_LEFT

        cmp topLeft.y, 0
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
	reverseMotion endp

end start