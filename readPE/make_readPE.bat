@echo off 

D:\masm32\bin\rc.exe /v readPE.RC
D:\masm32\bin\ml.exe /c /Cp /coff readPE.asm
D:\masm32\bin\link.exe /subsystem:windows readPE.obj readPE.RES

dir "readPE.*"
goto TheEnd

:TheEnd

pause 