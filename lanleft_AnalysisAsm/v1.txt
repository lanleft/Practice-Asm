.text:00401000 ; int __cdecl main(int argc, const char **argv, const char **envp)
.text:00401000 _main           proc near               ; CODE XREF: ___tmainCRTStartup+F8vp
.text:00401000
.text:00401000 var_8           = dword ptr -8
.text:00401000 var_4           = dword ptr -4
.text:00401000 argc            = dword ptr  8
.text:00401000 argv            = dword ptr  0Ch
.text:00401000 envp            = dword ptr  10h
.text:00401000
.text:00401000                 push    ebp
.text:00401001                 mov     ebp, esp
.text:00401003                 sub     esp, 8
.text:00401006                 mov     [ebp+var_8], 0
.text:0040100D                 mov     [ebp+var_4], 0
.text:00401014                 jmp     short loc_40101F
.text:00401016 ; ---------------------------------------------------------------------------
.text:00401016
.text:00401016 loc_401016:                             ; CODE XREF: _main+2Evj
.text:00401016                 mov     eax, [ebp+var_4]
.text:00401019                 add     eax, 1
.text:0040101C                 mov     [ebp+var_4], eax
.text:0040101F
.text:0040101F loc_40101F:                             ; CODE XREF: _main+14^j
.text:0040101F                 cmp     [ebp+var_4], 14h
.text:00401023                 jg      short loc_401030
.text:00401025                 mov     ecx, [ebp+var_8]
.text:00401028                 add     ecx, [ebp+var_4]
.text:0040102B                 mov     [ebp+var_8], ecx
.text:0040102E                 jmp     short loc_401016
.text:00401030 ; ---------------------------------------------------------------------------
.text:00401030
.text:00401030 loc_401030:                             ; CODE XREF: _main+23^j
.text:00401030                 mov     edx, [ebp+var_8]
.text:00401033                 push    edx
.text:00401034                 push    offset Format   ; "%u"
.text:00401039                 call    ds:printf
.text:0040103F                 add     esp, 8
.text:00401042                 xor     eax, eax
.text:00401044                 mov     esp, ebp
.text:00401046                 pop     ebp
.text:00401047                 retn
.text:00401047 _main           endp