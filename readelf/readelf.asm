;%include "support.asm"
;nasm -f elf64 readelf.asm
; ld -m -s -o hello hello.o

;./test_hexdump < find-password | ./readelf

sys_exit	equ		1
sys_read	equ		3
sys_write	equ		4
stdin		equ		0
stdout		equ		1
sys_close equ 6
sys_open equ 5

O_RDONLY equ 0
O_WRONLY equ 1
O_RDWR equ 2

section .data 

EI_MAG db 'ELF Header:', 0ah 
EI_MAGlen equ $-EI_MAG
ERR db 'ERROR', 0ah 
ERRlen equ $-ERR
magic db "  Magic:", 9
magiclen equ $-magic 

EI_CLASS db '  Class:', 9, 9, 9, 9
EI_CLASSlen equ $-EI_CLASS
ELF32 db 'ELF32', 0ah
ELF32len equ $-ELF32
ELF64 db 'ELF64', 0ah
ELF64len equ $-ELF64

EI_DATA db '  Data:', 9,9,9, 9,9
EI_DATAlen equ $-EI_DATA

Little_Endian db "2's complement, little endian", 0ah
Little_Endianlen equ $-Little_Endian

Big_Endian db "2's complement, big endian", 0ah
Big_Endianlen equ $-Little_Endian

EI_VERSION db '  Version:',0,9,9,9,9, '1 (current)', 0ah 
EI_VERSIONlen equ $-EI_VERSION
OS_ABI db "  OS/ABI:", 9,9,9,9
OS_ABIlen equ $-OS_ABI
  
systemV db "UNIX - System V", 0ah
systemVlen equ $-systemV
 
linux db "LINUX", 0ah
linuxlen equ $-linux

ABI_VERSION db "  ABI Version:",9,9,9,9,"0", 0ah
ABI_VERSIONlen equ $-ABI_VERSION
 
e_type db "  Type:", 9,9,9,9,9
e_typelen equ $-e_type
 
ET_NONE db "NONE", 0ah
ET_NONElen db $-ET_NONE
 
ET_REL db "REl", 0ah
ET_RELlen equ $-ET_REL
 
ET_EXEC db "EXEC (Executable file)", 0ah
ET_EXEClen equ $-ET_EXEC
 
ET_DYN db "DYN (Dinamyc file", 0ah
ET_DYNlen equ $-ET_DYN
 
ET_CORE db "CORE", 0ah
ET_CORElen equ $-ET_CORE 

e_machine db "  Machine:", 9,9,9,9
e_machinelen equ $-e_machine
 
no_specific db "No specific instruction set", 0ah
no_specificlen equ $-no_specific
 
SPARC db "SPARC", 0ah
SPARClen equ $-SPARC
 
x86 db "x86", 0ah
x86len equ $-x86
 
MIPS db "MIPS", 0ah
MIPSlen equ $-MIPS
 
ARM db "Advanced RISC Machine", 0ah
ARMlen equ $-ARM
 
x86_64 db "Advanced Micro Divices x86-64", 0ah
x86_64len equ $-x86_64
 
AArch64 db "AArch64", 0ah
AArch64len equ $-AArch64 

e_version db "  Version:",9,9,9,9, "0x1", 0ah
e_versionlen equ $-e_version 

e_entry db "  Entry point address:", 9, 9, 9
e_entrylen equ $-e_entry
 
e_phoff db "  Start of program headers:", 9, 9
e_phofflen equ $-e_phoff
 
e_shoff db "  Start of section headers:", 9, 9
e_shofflen equ $-e_shoff
  
e_ehsize db "  Size of this header:", 9,9, 9
e_ehsizelen equ $-e_ehsize
 
e_phentsize db "  Size of program header:", 9, 9
e_phentsizelen  equ $-e_phentsize

e_phnum db "  Number of program headers:", 9, 9
e_phnumlen equ $-e_phnum
 
e_shentsize db "  Size of section headers:", 9, 9
e_shentsizelen equ $-e_shentsize
 
e_shnum db "  Number of section headers:", 9, 9
e_shnumlen equ $-e_shnum
 
e_shstrndx db "  Section header string table index:", 9
e_shstrndxlen equ $-e_shstrndx

flag db "  FLags:", 9,9,9,9, "0x0", 0ah 
flaglen equ $-flag

onebyte db "0x00", 0ah 
onebytelen equ $-onebyte

hexstr db "0x00000000", 0ah 
hexstrlen equ $-hexstr

hexstr2 db "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0ah 
hexstr2len equ $-hexstr2

digits db "0123456789ABCDEF", 0
digitslen equ $-digits 

prheader db 0ah,'Program headers:', 0ah 
prheaderlen equ $-prheader

line1 db '  Type', 9,9, 'Offset', 9,9, 'VirtAddr', 9, 'PhysAddr', 9, 'FileSiz', 9, 9, 'MemSiz', 9, 9, 'Flg', 0ah 
line1len equ $-line1

phdr db '  PHDR', 9,9, 0ah 
phdrlen equ $-phdr

interp db '  INTERP', 9,9,0ah 
interplen equ $-interp

load db '  LOAD', 9, 9, 0ah 
loadlen equ $-load

dynamic db '  DYNAMIC', 9,9, 0ah 
dynamiclen equ $-dynamic

note db '  NOTE', 9,9, 0ah 
notelen equ $-note

other db '  OTHER', 9, 9, 0ah 
otherlen equ $-other

addhex1 db '0x00000000', 9
addhex1len equ $-addhex1

addhex2 db '0x00000000', 9, 9
addhex2len equ $-addhex2

hexflag db '0x00', 0ah 
hexflaglen  equ $-hexflag

section .bss 
buff resb 10240

section .text 
global _start 

_start:

    mov     edx, 10240        ; number of bytes to read
    mov     ecx, buff     ; reserved space to store our input (known as a buffer)
    mov     ebx, 0          ; write to the STDIN file
    mov     eax, sys_read          ; invoke SYS_READ (kernel opcode 3)
    int     80h

;	mov al, byte [buff+0]
;	cmp al, 7fh
;	jne quit 
 ;   mov     edx, 10240     ; number of bytes to write - one for each letter plus 0Ah (line feed character)
  ;  mov     ecx,  buff  ; move the memory address of our message string into ecx
   ; mov     ebx, 1      ; write to the STDOUT file
 ;   mov     eax, 4      ; invoke SYS_WRITE (kernel opcode 4)
;    int     80h
;
;quit:

; print elf header 
	mov edx,  EI_MAGlen
	mov ecx, EI_MAG
	mov ebx, 1
	mov eax, sys_write
	int 80h
	
	xor eax,eax 

; print class 
	
	mov edx,  EI_CLASSlen
	mov ecx, EI_CLASS
	mov ebx, 1
	mov eax, sys_write
	int 80h 
	
	xor eax, eax 
	mov al, byte [buff + 4]
	cmp al, 01
	je .printelf32
	cmp al, 02
	je  .printelf64
	
.printelf32:
	mov edx, ELF32len
	mov ecx, ELF32
	jmp .write 
	
.printelf64:
	mov edx, ELF64len
	mov ecx, ELF64 
	jmp .write 
.write:
	mov ebx, 1
	mov eax, sys_write
	int 80h
	
; print data 
	mov edx,  EI_DATAlen
	mov ecx, EI_DATA
	mov ebx, 1
	mov eax, sys_write
	int 80h 
	
	xor eax, eax 
	mov al, byte [buff+5]
	cmp al, 1
	je .prlittle
	cmp al, 2
	je .prbig
.prlittle:
	mov edx, Little_Endianlen
	mov ecx, Little_Endian
	jmp .datawrite
.prbig:
	mov edx, Big_Endianlen
	mov ecx, Big_Endian
	jmp .datawrite
.datawrite:
	mov ebx, 1
	mov eax, sys_write
	int 80h 
	
; print version 
	mov edx,  EI_VERSIONlen
	mov ecx, EI_VERSION
	mov ebx, 1
	mov eax, sys_write
	int 80h 

; print operate system 
	mov edx,  OS_ABIlen
	mov ecx, OS_ABI
	mov ebx, 1
	mov eax, sys_write
	int 80h 
	
	xor eax, eax 
	mov al, byte[buff+7]
	cmp al, 0
	je .prUnix
	cmp al, 2
	je .prLinux
.prUnix:
	mov edx, systemVlen
	mov ecx, systemV
	jmp .oswrite
.prLinux:
	mov edx, linuxlen
	mov ecx, linux
	jmp .oswrite
.oswrite:
	mov ebx, 1
	mov eax, sys_write
	int 80h 
; print ABI version 
	mov edx,  ABI_VERSIONlen
	mov ecx, ABI_VERSION
	mov ebx, 1
	mov eax, sys_write
	int 80h
	
; print type 
	mov edx,  e_typelen
	mov ecx, e_type
	mov ebx, 1
	mov eax, sys_write
	int 80h

	xor eax, eax 
	mov al, byte [buff+16]
	cmp al, 0
	je .prnone
	cmp al, 1
	je .prrel
	cmp al, 2
	je .prexec
	cmp al , 3 
	je .prdyn
	cmp al, 4
	je .prcore
.prnone:
	mov edx, ET_NONElen
	mov ecx, ET_NONE
	jmp .typewrite
.prrel:
	mov edx, ET_RELlen
	mov ecx, ET_REL
	jmp .typewrite
.prexec:
	mov edx, ET_EXEClen
	mov ecx, ET_EXEC
	jmp .typewrite
.prdyn:
	mov edx, ET_DYNlen
	mov ecx, ET_DYN
	jmp .typewrite
.prcore:
	mov edx, ET_CORElen
	mov ecx, ET_CORE
	jmp .typewrite
.typewrite:
	mov ebx, stdout
	mov eax, sys_write
	int 80h
	
; print machine 
	mov edx,  e_machinelen
	mov ecx, e_machine
	mov ebx, 1
	mov eax, sys_write
	int 80h
	
	xor eax, eax 
	mov al, byte [buff+18]
	cmp al, 0
	je .prnospec
	cmp al, 2
	je .prsparc
	cmp al, 3
	je .prx86
	cmp al, 8
	je .prmips
	cmp al, 28h 
	je .prarm 
	cmp al, 3eh 
	je .prx86_64
	cmp al,  183 
	je .praa
.prnospec:
	mov edx, no_specificlen
	mov ecx, no_specific
	jmp .machinewrite
.prsparc:
	mov edx, SPARClen
	mov ecx, SPARC
	jmp .machinewrite
.prx86:
	mov edx, x86len
	mov ecx, x86
	jmp .machinewrite
	
.prmips:
	mov edx, MIPSlen
	mov ecx, MIPS
	jmp .machinewrite
.prarm:
	mov edx, ARMlen
	mov ecx, ARM
	jmp .machinewrite
.prx86_64:
	mov edx, x86_64len
	mov ecx, x86_64
	jmp .machinewrite
.praa:
	mov edx, AArch64len
	mov ecx, AArch64
	jmp .machinewrite
.machinewrite:
	mov ebx, stdout
	mov eax, sys_write
	int 80h 

; print e_version 
	mov edx,  e_versionlen
	mov ecx, e_version
	mov ebx, 1
	mov eax, sys_write
	int 80h

; print entry point 
	mov edx,  e_entrylen
	mov ecx, e_entry
	mov ebx, 1
	mov eax, sys_write
	int 80h
	
	xor eax, eax 
	mov eax, 27
	call _bytes2hex
	
	mov edx,  hexstrlen
	mov ecx, hexstr
	mov ebx, 1
	mov eax, sys_write
	int 80h
	
; print program header offset 

	mov edx,  e_phofflen
	mov ecx, e_phoff
	mov ebx, 1
	mov eax, sys_write
	int 80h
	

	mov eax, 28
	call _convert1byte
	
	mov edx,  onebytelen
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h

; print section header offset 
	mov edx,  e_shofflen
	mov ecx, e_shoff
	mov ebx, 1
	mov eax, sys_write
	int 80h

	
	mov eax, 32

	call _convert1byte
	
	mov edx,  onebytelen
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h
; print flag 
	mov edx,  flaglen 
	mov ecx, flag 
	mov ebx, 1
	mov eax, sys_write
	int 80h

; print size of this header 
	mov edx,  e_ehsizelen
	mov ecx, e_ehsize
	mov ebx, 1
	mov eax, sys_write
	int 80h	
	
	
	mov eax, 41 
	call _convert1byte
	
	mov edx,  onebytelen 
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h
; print size of program headers
	mov edx,  e_phentsizelen
	mov ecx, e_phentsize
	mov ebx, 1
	mov eax, sys_write
	int 80h	
	
	
	mov eax, 42 
	call _convert1byte
	
	mov edx,  onebytelen 
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h
; print number of program headers
	mov edx,  e_phnumlen
	mov ecx, e_phnum
	mov ebx, 1
	mov eax, sys_write
	int 80h	
	
	
	mov eax, 44 
	call _convert1byte
	
	mov edx,  onebytelen 
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h
; print size of section headers
	mov edx,  e_shentsizelen
	mov ecx, e_shentsize
	mov ebx, 1
	mov eax, sys_write
	int 80h	
	
	
	mov eax, 46 
	call _convert1byte
	
	mov edx,  onebytelen 
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h
; print number of section header 
	mov edx,  e_shnumlen
	mov ecx, e_shnum
	mov ebx, 1
	mov eax, sys_write
	int 80h	
	
	
	mov eax, 48 
	call _convert1byte
	
	mov edx,  onebytelen 
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h
; print section header string table index 
	mov edx,  e_shstrndxlen
	mov ecx, e_shstrndx
	mov ebx, 1
	mov eax, sys_write
	int 80h	
	
	
	mov eax, 50  
	call _convert1byte
	
	mov edx,  onebytelen 
	mov ecx, onebyte
	mov ebx, 1
	mov eax, sys_write
	int 80h
; print magic  == dang bi loi 
;	mov edx,  magiclen
;	mov ecx, magic
;	mov ebx, 1
;	mov eax, sys_write
;	int 80h 
;	
;	mov edx,  hexstr2len
;	mov ecx, hexstr2
;	mov ebx, 1
;	mov eax, sys_write
;	int 80h 
;
;
;	mov esi, 0
;	mov edi, 0
;	.loop1:
;	mov bl, byte [buff+edi]
;	mov dl, bl 
;	shr bl, 4
;	mov cl, byte [digits+ebx]
;	mov byte [hexstr2+esi], cl
;	inc esi 
;	shl bl, 4 
;	sub dl, bl 
;	xor cl, cl 
;	mov cl, byte [digits+edx]
;	mov byte [hexstr2+esi], cl 
;	inc edi
;   inc esi 
;	inc esi
;	cmp esi, 4
;	jne .loop1
;		
; print program headers
;	mov edx,  prheaderlen
;	mov ecx, prheader
;	mov ebx, 1
;	mov eax, sys_write
;	int 80h	
;	
;	mov edx,  line1len
;	mov ecx, line1
;	mov ebx, 1
;	mov eax, sys_write
;	int 80h	
;	
;	mov esi, 0
;	mov al, byte [buff+28]
;	.loop:
;	mov cl, byte [buff+eax]
;	cmp cl, 1
;	je .prload 
;	cmp cl, 2
;	je .prdynamic 
;	cmp cl, 3
;	je .printerp 
;	cmp cl, 4
;	je .prnote 
;	jmp .prother 
;	.prload:
;		mov edx, loadlen
;		mov ecx, load
;		jmp .prwrite 
;	.prdynamic:
;		mov edx, dynamiclen
;		mov ecx, dynamic
;		jmp .prwrite 
;	.printerp:
;		mov edx, interplen
;		mov ecx, interp
;		jmp .prwrite 
;	.prnote:
;		mov edx, notelen
;		mov ecx, note
;		jmp .prwrite 
;	.prother:
;		mov edx, otherlen
;		mov ecx, other
;		jmp .prwrite 
;	.prwrite:
;		mov ebx, 1
;		mov eax, sys_write
;		int 80h 
;		
	
		






















;	inc esi 
;	add eax, 32
;	xor ebx, ebx
;	mov bl, byte [buff+44]
;	cmp ebx, esi 
;	jne .loop 
;	
;	pop eax
;	pop ebx
;	pop ecx
;	pop edx
;	ret 





















_convert1byte:
	mov esi, 0
	mov bl, byte [buff+eax]
	mov dl, bl 
	shr bl, 4
	mov cl, byte [digits+ebx]
	mov byte [onebyte+2+esi], cl
	inc esi 
	shl bl, 4 
	sub dl, bl 
	xor cl, cl 
	mov cl, byte [digits+edx]
	mov byte [onebyte+2+esi], cl
	ret 

_bytes2hex:
	mov esi, 0
	.loop:
	
	mov bl, byte [buff+eax]
	mov dl, bl 
	shr bl, 4
	mov cl, byte [digits+ebx]
	mov byte [hexstr+2+esi], cl
	inc esi 
	shl bl, 4 
	sub dl, bl 
	xor cl, cl 
	mov cl, byte [digits+edx]
	mov byte [hexstr+2+esi], cl 
	dec eax  
    inc esi 
	cmp esi, 8
	jne .loop
	ret 


exit:
	mov eax, sys_exit						
	mov ebx, 0
	int 80h




