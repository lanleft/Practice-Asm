;;ml /c /Cp /coff ver3_ball.asm
;;link /subsystem:windows ver3_ball.asm

.386
.model flat, stdcall
option casemap:none

include D:\masm32\include\windows.inc 
include D:\masm32\include\user32.inc
includelib D:\masm32\lib\user32.lib
include D:\masm32\include\kernel32.inc 
includelib D:\masm32\lib\kernel32.lib
include D:\masm32\include\gdi32.inc 
includelib D:\masm32\lib\gdi32/lib 

.data 
className db 'simpleClass', 0
appName db 'Bouncing Ball', 0

WD_WIDTH dd 700
WD_HEIGHT dd 500

.data? 
hInstance HINSTANCE ?
hdc HDC ?
wc WNDCLASSEX <?>
hPen HPEN ?
hwnd HWND ?
lpCmdLine LPSTR ?
.code 
start:
    ;;call GetModuleHandle
    push NULL
    call GetModuleHandle
    mov hInstance, eax 

    call GetCommandLineA 
    mov lpCmdLine, eax

    ;;call WinMain
    push NULL 
    push lpCmdLine
    push NULL
    push hInstance 
    call WinMain 
    mov hwnd, eax 

    ;;call ExitProcess
    push eax
    call ExitProcess

    ;;define WinMain
    ;;struct and proc
    WinMain Proc hInstance:HINSTANCE,hPrevInst:HINSTANCE, lpCmdLine:LPSTR, ShowCmd:INT  
        





























