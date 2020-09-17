; compile masm32
; ml /c /Cp /coff wnd.asm
; link /subsystem:windows wnd.obj

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
	ClassName db 'BasicWinClass', 0
	AppName db 'Bouncing Ball', 0
	wndWidth dd 700
	wndHeight dd 500

.data?
	hInstance HINSTANCE ?
	wc WNDCLASSEX <?>
	hwnd HWND ?
	msg MSG <?>

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

	push SW_NORMAL
	push hwnd
	call ShowWindow

	push hwnd
	call UpdateWindow

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

	WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
		cmp uMsg, WM_DESTROY
		jz ON_WM_DESTROY

		jmp DEFAULT

		ON_WM_DESTROY:
			push NULL
			call PostQuitMessage
			
			jmp EXIT

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

end start