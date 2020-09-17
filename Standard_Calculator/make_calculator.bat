@echo off 

D:\masm32\bin\ml.exe /c /Cp /coff calculator.asm
D:\masm32\bin\link.exe /subsystem:windows calculator.obj

dir "calculator.*"
goto TheEnd

:TheEnd

pause 