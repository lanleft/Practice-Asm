@echo off 

D:\masm32\bin\rc.exe /v echo_revStr.RC
D:\masm32\bin\ml.exe /c /Cp /coff echo_revStr.asm
D:\masm32\bin\link.exe /subsystem:windows echo_revStr.obj echo_revStr.RES

dir "echo_revStr.*"
goto TheEnd

:TheEnd

pause 