
.386
.model flat,stdcall
option casemap:none
DlgProc proto :DWORD,:DWORD,:DWORD,:DWORD

include D:\masm32\include\windows.inc
include D:\masm32\include\kernel32.inc
include D:\masm32\include\user32.inc
include D:\masm32\include\comdlg32.inc
include D:\masm32\include\shell32.inc
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\user32.lib
includelib D:\masm32\lib\comdlg32.lib
includelib D:\masm32\lib\shell32.lib 

.data
    ; dialog declare 
    DlgName db "MyDialog",0
    
    ; file 
    caption             db "ReadPE - ",0
    newCaption          db 300 dup(0)
    filterString    db "Executable Files (*.exe, *.dll)", 0, 0
    openTitle       db "Open", 0
    fileName        db  200 dup(0)

    ; error
    errorFile       db "Error while open this file!", 0
    notify          db "Error", 0
    errorOpen       db "Error while open file!", 0
    errorMapping    db "Error while mapping file!", 0
    errorMap        db "Error while map view of file!", 0
    errorMZ         db "Error signature MZ!", 0

    ;Header 
    Header          db "Header", 0, 0

        ; ExeHeader 
        ExeHeader       db "Exe Header", 0, 0
        e_magic         db "Signature:MZ", 0, 0
        e_cblp          db "Extra Bytes", 0, 0
        e_cp            db "Pages", 0, 0
        e_crlc          db "Reloc Items", 0, 0
        e_cparhdr       db "Header Size", 0
        e_minalloc      db "Min Alloc", 0
        e_maxalloc      db "Max Alloc", 0
        e_ss            db "Initial SS", 0
        e_sp            db "Initial SP", 0
        e_csum          db "Check sum", 0
        e_ip            db "Initial IP", 0
        e_cs            db "Initial CS", 0
        e_lfarlc        db "Reloc Table", 0
        e_ovno        db "Overlay", 0
        e_lfanew        db "lfanew", 0

        ; CoffHeader 
        CoffHeader                      db "Coff Header", 0
        PESignature                       db "Signature: PE"
        Machine                         db "Machine: 014C=I386", 0
        NumberOfSections                db "Number of Sections", 0
        TimeDateStamp                   db "Time/Date Stamp", 0
        PointerToSymbolTable            db "Poiter to Symbol Table", 0
        NumberOfSymbols                 db "Number of Symbols", 0
        SizeOfOptionalHeader_str            db "Optional Header Size", 0
        Characteristics_coff                 db "Characteristics", 0            ; Characteristics
        
        ; OptionalHeader
        OptHeader                  db "Optional Header", 0
        Magic                           db "Magic: 010B=Nomal Executable (32bit), 0107=ROM Image", 0
        MajorLinkerVersion              db "Linker Major Version Number", 0
        MinorLinkerVersion      db  "Linker Minor Version Number", 0, 0
        SizeOfCode              db  "Size of Code Section", 0, 0
        SizeOfInitializedData   db  "Initialized Data Size", 0, 0
        SizeOfUninitializedData db  "Uninitialized Data Size", 0,0
        AddressOfEntryPoint     db  "Entry Point RVA", 0, 0
        BaseOfCode              db  "Base of Code", 0, 0
        BaseOfData              db  "Base of Data", 0, 0
        ImageBase               db  "Image Base", 0, 0
        SectionAlignment        db  "Section Alignment", 0, 0
        FileAlignment           db  "File Alignment", 0, 0
        MajorOperatingSystemVersion          db  "OS Major Version", 0, 0
        MinorOperatingSystemVersion          db  "OS Minor Version", 0, 0
        MajorImageVersion       db  "User Major Version", 0, 0
        MinorImageVersion       db  "User Minor Version", 0, 0
        MajorSubsystemVersion         db  "Subsystems Major Version", 0, 0
        MinorSubsystemVersion         db  "Subsystems Minor Version", 0, 0
        Win32VersionValue       db  "Reserved", 0, 0
        SizeOfImage             db  "Image Size", 0, 0
        SizeOfHeader            db  "Header Size", 0, 0
        CheckSum                db  "File Checksum", 0 ,0
        Subsystem               db  "Subsystem: 1=Native, 2=Windows GUI, 3=Windows CUI, 4=... ", 0, 0
        DllCharacteristics      db  "DLL Flags (obsolete)", 0,0
        SizeOfStackReserve      db  "Stack Reserved Size", 0,0
        SizeOfStackCommit       db  "Stack Commit Size", 0, 0
        SizeOfHeapReserve        db  "Heap Reserved Size", 0, 0
        SizeOfHeapCommit        db  "Heap Commit Size", 0, 0
        LoaderFlags             db  "Loader FLag (obsolete)", 0, 0
        NumberOfRvaAndSizes     db  "Number of Data Directories", 0, 0

        ; directory part
        andSize                 db  " & Size", 0
        ExportTable              db  "Export Table Address", 0
        ImportTable              db  "Import Table Address", 0
        ResourceTable           db  "Resource Table Address", 0
        ExceptionTable          db  "Exception Table Address", 0
        SecuriryTable           db  "Security Table Address", 0
        BaseRelocationTable     db  "Base Relocation Table Address", 0
        DebugData               db  "Debug Data Address", 0
        CopyrightData           db  "Copyright Data Address", 0
        GlobalPtr               db  "Global Ptr", 0
        TLSTable                db  "TLS Table Address", 0
        LoadConfigTable         db  "Load Config Table Address", 0

        ; Section Header 
        SecHeader       db      "Section Header", 0
        SectionName             db  "Section Name", 0
        VirtualAddress          db  "Virtual Size", 0, 0
        VirtualSize          db  "RAV/Offset", 0, 0
        SizeOfRawData           db  "Size of Raw Data", 0, 0
        PointerToRawData        db  "Pointer to Raw Data", 0 ,0
        PointerToRelocation     db  "Pointer to Relocs", 0, 0
        PointerToLinenumbers    db  "Pointer to Line Numbers", 0 ,0
        NumberOfRelocations     db  "Number of Relocs", 0 ,0
        NumberOfLinenumbers     db  "Number of Line Numbers", 0 ,0
        Characteristics_sec               db  "Section Flags", 0, 0

    ; import 
    Import     db      "Import"   , 0
    Export     db       "Export", 0
    Ordinal_Hint                 db  "Ordinal(Hint)", 0
    Name_Imp                    db  "Function", 0

    ; Resource 
    Resource    db      "Resource", 0
    Bitmap      db      "Bitmap", 0
    Dialog      db      "Dialog", 0
    String      db      "String", 0
    RCData      db      "RCData", 0
    Cursor      db      "Cursor", 0
    Icon        db      "Icon", 0
    Version     db      "Version", 0
    XPManifest  db      "XPManifest", 0

    ; Begin 
    Address     db "Address", 0, 0
    VirAdd      db "Virtual Address", 0,0
    Value       db "Value", 0, 0
    Meaning     db "Meaning", 0, 0

    ; variables
    startAddress dd 0
    hexBuff db 17 dup(0)
    format db "%08X",0
    ordinalNameFinal db     30 dup(0)
    nodeSelect db 20 dup (0)
    detect64 dd 0



.data?
    ; handle
    hInstance HINSTANCE ?
    hWndTreeView HWND ?
    hWndListView    HWND ?
    hParent     dd ?
    hFile dd ?
    hMap dd ?
    pMapping dd ?

    ; struct 
    tvinsert TV_INSERTSTRUCT <?>
    lvc     LV_COLUMN <?>
    lvi     LV_ITEM   <?>
    tvItem  TV_ITEM <?>
    ofn OPENFILENAME <?>

    ; optional header
    addr_opt_header dd ?

    ; section
    sections_count dd ?
    sizeOfOptionalHeader dd ?
    sectionHeaderOffset dd ?
    importsRVA dd ?
    exportsRVA dd ?
    resourcesRVA dd ?
    exportedNamesOffset dd ?
    exportedFuntionsOffset dd ?
    exportedOrdinalsOffset dd ?
    numberOfNamesValue dd ?
    nBaseValue dd ?

    ; import 
    ImportNode dd ?

.const
    ; list and tree view control
    IDC_TREEVIEW           equ 3000
    IDC_LISTVIEW            equ 3001

    IDM_OPEN  equ 32000
    IDM_EXIT  equ 32001

    ; extend
    SIZEOF_NT_SIGNATURE equ sizeof DWORD 
    SIZEOF_IMAGE_FILE_HEADER equ 14h 

.code
start:
    push NULL
    call GetModuleHandle
    mov    hInstance,eax

    push NULL
    push offset DlgProc
    push NULL
    push offset DlgName
    push hInstance
    call DialogBoxParamA

    push eax 
    call ExitProcess

DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    cmp uMsg, WM_INITDIALOG
    jz ON_INITDIALOG

    cmp uMsg, WM_CLOSE
    jz ON_CLOSE 

    cmp uMsg, WM_COMMAND
    jz ON_COMMAND 

    cmp uMsg, WM_DROPFILES
    jz ON_DROPFILES

    cmp uMsg, WM_NOTIFY
    jz ON_NOTIFY 

    jmp DEFAULT 

    ON_INITDIALOG:
        push IDC_TREEVIEW
        push hWnd
        call GetDlgItem
        mov hWndTreeView, eax 

        push IDC_LISTVIEW
        push hWnd
        call GetDlgItem
        mov hWndListView, eax

        jmp EXIT

    ON_DROPFILES:
        push 200
        push offset fileName
        push 0
        push wParam     ; wParam == hdrop file 
        call DragQueryFileA 
        
        push wParam
        call DragFinish

        jmp FILE_CONTINUE
    ON_CLOSE:
        push 0 
        push IDM_EXIT
        push WM_COMMAND
        push hWnd
        call SendMessage

        jmp EXIT

    ON_COMMAND:
        mov eax,wParam
        mov ebx, lParam
        cmp ebx, 0 
        jz ON_MENU

        jmp DEFAULT

        ON_MENU:
            cmp ax, IDM_OPEN
            jz ON_OPEN_FILE

            cmp ax, IDM_EXIT
            jz ON_EXIT

            jmp EXIT

            ON_OPEN_FILE:
                call funcOpenFile
                cmp eax, 0
                jz EXIT

                jmp FILE_CONTINUE

            ON_EXIT:

                push NULL
                push hWnd
                call EndDialog

                jmp EXIT

        FILE_CONTINUE:
            ; remove tree view 
            push 0 
            push 0 
            push TVM_DELETEITEM
            push hWndTreeView
            call SendMessageA 

            ; remove list view column 
            push 0 
            push 0 
            push LVM_DELETECOLUMN 
            push hWndListView
            call SendMessageA

            push 1 
            push 0 
            push LVM_DELETECOLUMN
            push hWndListView
            call SendMessageA

            push 2 
            push 0 
            push LVM_DELETECOLUMN
            push hWndListView
            call SendMessageA

            ; remove list view item 
            push 0 
            push 0 
            push LVM_DELETEALLITEMS 
            push hWndListView
            call SendMessageA

            ; CreateFile 
            push 0                              ; template file 
            push FILE_ATTRIBUTE_NORMAL          ; default value for file
            push OPEN_EXISTING                  ; creation disposition
            push 0                              ; security attributes
            push FILE_SHARE_READ                ; share mode 
            push GENERIC_READ                   ; desire access
            push offset fileName                ; name of file to be created or opened
            call CreateFile
            mov hFile, eax 
            cmp eax, INVALID_HANDLE_VALUE
            jz NOTIFY_ERROR_OPEN

            ; CreateFileMapping 
            push 0                              ; file mapping object create without a name 
            push 0                              ; maximun size low
            push 0                              ; maximum size high
            push PAGE_READONLY                  ; protect 
            push 0                              ; file mapping attributes, poiter to a security addtributes or null
            push hFile                          ; handle to the file
            call CreateFileMapping
            mov hMap, eax 
            cmp eax, 0
            jz NOTIFY_ERROR_MAPPING

            ; MapViewOfFile 
            push 0
            push 0
            push 0
            push FILE_MAP_READ 
            push hMap
            call MapViewOfFile
            mov pMapping, eax 
            cmp eax, 0
            jz NOTIFY_ERROR_MAP

            ; create treeview record
            mov edi, pMapping
            assume edi:ptr IMAGE_DOS_HEADER

            cmp [edi].e_magic, IMAGE_DOS_SIGNATURE
            jnz NOTIFY_ERROR_MZ

            ; start header 
            mov tvinsert.hParent, NULL 
            mov tvinsert.hInsertAfter, TVI_ROOT
            mov tvinsert.itemex.imask, TVIF_TEXT or TVIF_PARAM
            mov tvinsert.itemex.pszText, offset Header
            call SMInsertTv

            mov tvinsert.hParent, eax 
            mov tvinsert.hInsertAfter, TVI_LAST
            mov tvinsert.itemex.pszText, offset ExeHeader
            call SMInsertTv

            mov tvinsert.itemex.pszText, offset CoffHeader
            call SMInsertTv

            mov tvinsert.itemex.pszText, offset OptHeader
            call SMInsertTv

            mov tvinsert.itemex.pszText, offset SecHeader
            call SMInsertTv
            mov tvinsert.hParent, eax 
            mov tvinsert.hInsertAfter, TVI_LAST

                ; name section 
                add edi, [edi].e_lfanew
                mov eax, [edi].e_lfanew
                mov startAddress, eax 

                assume edi:ptr IMAGE_NT_HEADERS32 
                add edi, SIZEOF_NT_SIGNATURE
                assume edi:ptr IMAGE_FILE_HEADER
                movzx edx, [edi].NumberOfSections
                mov sections_count, edx 
                add edi, SIZEOF_IMAGE_FILE_HEADER
                assume edi:ptr IMAGE_OPTIONAL_HEADER32 

                add edi, 60h 
                mov edx, dword ptr [edi]
                mov exportsRVA, edx 
                mov edx, dword ptr [edi+8h]
                mov importsRVA, edx 
                mov edx, dword ptr [edi+10h]
                mov resourcesRVA, edx 
                sub edi, 60h 

                add edi, sizeof IMAGE_OPTIONAL_HEADER32
                mov sectionHeaderOffset, edi
                assume edi:ptr IMAGE_SECTION_HEADER 

                mov ebx, sections_count

                SECTION_TREE:
                    cmp ebx, 0
                    jz IMPORT_TREE

                    dec ebx
                    mov tvinsert.itemex.pszText, edi  
                    call SMInsertTv

                    add edi, 28h 
                    jmp SECTION_TREE

            IMPORT_TREE:
            mov tvinsert.hParent, NULL 
            mov tvinsert.hInsertAfter, TVI_ROOT
            mov tvinsert.itemex.imask, TVIF_TEXT or TVIF_PARAM
            mov tvinsert.itemex.pszText, offset Import
            call SMInsertTv
            mov tvinsert.hParent, eax 
            mov tvinsert.hInsertAfter, TVI_LAST

                mov edi, importsRVA
                call RVAtoOffset
                mov edi, eax 
                add edi, pMapping
                assume edi:ptr IMAGE_IMPORT_DESCRIPTOR 
                NEXT_IMPORT_DLL_TREE:
                    cmp [edi].OriginalFirstThunk, 0
                    jnz EXTRACT_IMPORT_TREE 
                    cmp [edi].TimeDateStamp, 0
                    jnz EXTRACT_IMPORT_TREE 
                    cmp [edi].ForwarderChain, 0
                    jnz EXTRACT_IMPORT_TREE 
                    cmp [edi].Name1, 0 
                    jnz EXTRACT_IMPORT_TREE
                    cmp [edi].FirstThunk, 0
                    jnz EXTRACT_IMPORT_TREE
                    jmp EXPORT_TREE 

                    EXTRACT_IMPORT_TREE:
                        push edi 
                        mov edi, [edi].Name1 
                        call RVAtoOffset
                        pop edi 
                        mov edx, eax 
                        add edx, pMapping
                        mov tvinsert.itemex.pszText, edx 
                        call SMInsertTv
 

                        add edi, sizeof IMAGE_IMPORT_DESCRIPTOR
                        jmp NEXT_IMPORT_DLL_TREE

            EXPORT_TREE:
            cmp exportsRVA, 0 
            jz RESOURCE_TREE

                READ_INFOR_EXPORT:
                mov tvinsert.hParent, NULL 
                mov tvinsert.hInsertAfter, TVI_ROOT
                mov tvinsert.itemex.imask, TVIF_TEXT or TVIF_PARAM
                mov tvinsert.itemex.pszText, offset Export
                call SMInsertTv
                mov tvinsert.hParent, eax 
                mov tvinsert.hInsertAfter, TVI_LAST 

                    mov edi, exportsRVA
                    call RVAtoOffset
                    mov edi, eax 
                    add edi, pMapping
                    assume edi:ptr IMAGE_EXPORT_DIRECTORY
                    

                NEXT_EXPORT_TREE:
                    mov edi, exportsRVA
                    call RVAtoOffset
                    mov edi, eax 
                    add edi, pMapping
                    assume edi:ptr IMAGE_EXPORT_DIRECTORY 
                    push edi 
                    mov edi, [edi].nName 
                    call RVAtoOffset
                    add eax, pMapping
                    pop edi 
                    mov tvinsert.itemex.pszText, eax 
                    call SMInsertTv

                    jmp RESOURCE_TREE

            RESOURCE_TREE:
            cmp resourcesRVA, 0
            jz EXIT 

                ; READ_INFOR_RESOURCE:
                ; mov tvinsert.hParent, NULL 
                ; mov tvinsert.hInsertAfter, TVI_ROOT
                ; mov tvinsert.itemex.imask, TVIF_TEXT or TVIF_PARAM
                ; mov tvinsert.itemex.pszText, offset Resource
                ; call SMInsertTv
                ; mov tvinsert.hParent, eax 
                ; mov tvinsert.hInsertAfter, TVI_LAST 

                jmp EXIT












        NOTIFY_ERROR_OPEN:
            push MB_OK 
            push offset notify
            push offset errorOpen
            push NULL
            call MessageBox 

            jmp EXIT

        NOTIFY_ERROR_MAPPING:
            push MB_OK 
            push offset notify
            push offset errorMapping
            push NULL
            call MessageBox 

            jmp EXIT

        NOTIFY_ERROR_MAP:
            push MB_OK 
            push offset notify
            push offset errorMap
            push NULL
            call MessageBox 

            jmp EXIT

        NOTIFY_ERROR_MZ:
            push MB_OK 
            push offset notify
            push offset errorMZ
            push NULL
            call MessageBox 

            jmp EXIT

        NOTIFY_ERROR:
            push MB_OK 
            push offset notify
            push offset errorFile
            push NULL
            call MessageBox 

            jmp EXIT
    ON_NOTIFY:
        mov edi, lParam
        assume edi:ptr NM_TREEVIEW
        cmp [edi].hdr.code, TVN_SELCHANGED 
        jnz DEFAULT
        
        ; remove list view column 
        push 0 
        push 0 
        push LVM_DELETECOLUMN 
        push hWndListView
        call SendMessageA

        push 1 
        push 0 
        push LVM_DELETECOLUMN
        push hWndListView
        call SendMessageA

        push 2 
        push 0 
        push LVM_DELETECOLUMN
        push hWndListView
        call SendMessageA

        ; remove list view item 
        push 0 
        push 0 
        push LVM_DELETEALLITEMS 
        push hWndListView
        call SendMessageA

        ; create node select
        mov eax, [edi].itemNew.hItem
        mov tvItem.hItem, eax 
        mov tvItem.imask, TVIF_TEXT 
        mov tvItem.pszText, offset nodeSelect
        mov tvItem.cchTextMax, 30 

        push offset tvItem
        push 0
        push TVM_GETITEM
        push hWndTreeView
        call SendMessage

        ; compare node select 
        push offset Header
        push offset nodeSelect
        call lstrcmpA 
        cmp eax, 0
        jz ON_HEADER

        push offset ExeHeader
        push offset nodeSelect
        call lstrcmpA 
        cmp eax, 0
        jz ON_EXEHEADER

        push offset CoffHeader
        push offset nodeSelect
        call lstrcmpA 
        cmp eax, 0
        jz ON_COFFHEADER

        push offset OptHeader
        push offset nodeSelect
        call lstrcmpA 
        cmp eax, 0
        jz ON_OPTHEADER

        push offset SecHeader
        push offset nodeSelect
        call lstrcmpA 
        cmp eax, 0
        jz ON_SECHEADER

        ; child section select 

        mov edi, sectionHeaderOffset
        mov startAddress, edi 
        assume edi:ptr IMAGE_SECTION_HEADER
        mov edx, sections_count
        mov ecx, 0
        SEC_SELECT:
            cmp edx, 0
            jz DEFFERENT_NODE
            dec edx 

            push edi  
            push offset nodeSelect
            call lstrcmpA
            cmp eax, 0
            jz PRE_SECNODE_SELECT 

            add edi, 28h 
            inc ecx 
            jmp SEC_SELECT

            PRE_SECNODE_SELECT:
                push edi 
                push ecx
                jmp SECNODE_SELECT 

        DEFFERENT_NODE:

        push offset Import
        push offset nodeSelect
        call lstrcmpA 
        cmp eax, 0
        jz ON_IMPORT 

            mov edi, importsRVA
            call RVAtoOffset
            mov edi, eax 
            add edi, pMapping
            assume edi:ptr IMAGE_IMPORT_DESCRIPTOR
            SELECT_IMPORT_DLL:
                push edi 
                mov edi, [edi].Name1 
                call RVAtoOffset
                pop edi 
                mov edx, eax 
                add edx, pMapping

                push edx 
                push offset nodeSelect
                call lstrcmpA
                cmp eax, 0 
                jz PRE_DLL 

                add edi, sizeof IMAGE_IMPORT_DESCRIPTOR
                jmp SELECT_IMPORT_DLL

                PRE_DLL:
                    push edi 
                    jmp ON_DLL_SELECT 

        push offset Resource
        push offset nodeSelect
        call lstrcmpA 
        cmp eax, 0
        jz ON_RESOURCE

        ON_RESOURCE:
            jmp EXIT

        ON_IMPORT:
            jmp EXIT

        ON_DLL_SELECT:
            DLL_CREATE_COLUMN:
                mov lvc.imask, LVCF_TEXT or LVCF_WIDTH 
                mov lvc.pszText, offset Ordinal_Hint
                mov lvc.lx, 200
                push 0
                call SMInsertColLv 

                mov lvc.pszText, offset Name_Imp
                mov lvc.lx, 400 
                push 1
                call SMInsertColLv

            DLL_INSERT_ITEM:
                pop edi 
                push esi 

                mov lvi.imask, LVIF_TEXT 
                mov lvi.iItem, -1

                cmp [edi].OriginalFirstThunk, 0
                jnz useOFT 
                mov esi, [edi].FirstThunk
                jmp useFT 

                useOFT:
                    mov esi, [edi].OriginalFirstThunk
                useFT:
                    push edi 
                    mov edi, esi 
                    call RVAtoOffset 
                    pop edi 
                    add eax, pMapping
                    mov esi, eax 

                EXTRACT_NAME_FUNCTION:
                    cmp dword ptr [esi], 0
                    jz EXIT_EXTRACT_DLL 

                    push edi 
                    mov edi, dword ptr [esi]
                    call RVAtoOffset
                    pop edi 
                    mov edx, eax 
                    add edx, pMapping
                    assume edx:ptr IMAGE_IMPORT_BY_NAME 
                    movzx ecx, [edx].Hint 
                    push edx
                    mov edx, ecx 

                    push ecx
                    push edx
                    push offset format
                    push offset hexBuff     
                    call wsprintfA
                    add esp, 12
                    pop ecx

                    mov lvi.pszText, offset hexBuff 
                    mov lvi.iSubItem, 0
                    inc lvi.iItem
                    call SMInsertLv

                    pop edx  
                    lea edx, [edx].Name1
                    mov lvi.iSubItem, 1 
                    mov lvi.pszText, edx   
                    call SMSetItemLv

                    _NEXT:
                    add esi, 4 
                    jmp EXTRACT_NAME_FUNCTION

                EXIT_EXTRACT_DLL:
                    pop esi 
                    jmp EXIT


        ON_HEADER:
            HEADER_CREATE_COLUMN:
                mov lvc.imask, LVCF_TEXT or LVCF_WIDTH 
                mov lvc.pszText, offset Header
                mov lvc.lx, 600
                push 0
                call SMInsertColLv 

            HEADER_INSERT_LISTVIEW:
                mov lvi.imask, LVIF_TEXT 
                mov lvi.iItem, 0
                mov lvi.iSubItem, 0
                mov lvi.pszText, offset ExeHeader
                call SMInsertLv

                inc lvi.iItem
                mov lvi.pszText, offset CoffHeader
                call SMInsertLv

                inc lvi.iItem
                mov lvi.pszText, offset SecHeader
                call SMInsertLv

            jmp EXIT

        ON_EXEHEADER:
            EXE_CREATE_COLUMN:
                mov lvc.imask, LVCF_TEXT or LVCF_WIDTH
                mov lvc.pszText, offset Address
                mov lvc.lx, 100
                push 0
                call SMInsertColLv

                mov lvc.pszText, offset Value
                mov lvc.lx, 100
                push 1 
                call SMInsertColLv

                mov lvc.pszText, offset Meaning
                mov lvc.lx, 400
                push 2
                call SMInsertColLv

            EXE_INSERT_ITEM:
                mov edi, pMapping
                assume edi:ptr IMAGE_DOS_HEADER

                mov startAddress, 0

                ; e_magic
                push offset e_magic         ;  meaning 
                push 2                      ; word
                push 0                      ; row 0
                push 0h                     ; virtual address 
                call LvInsertRow 

                ; e_cblp
                push offset e_cp
                push 2 
                push 1 
                push 2h 
                call LvInsertRow

                ; e_cp
                push offset e_crlc
                push 2 
                push 2 
                push 4h 
                call LvInsertRow

                ; e_crlc
                push offset e_crlc
                push 2
                push 3
                push 6h 
                call LvInsertRow

                ;  e_cparhdr
                push offset e_cparhdr
                push 2 
                push 4 
                push 8h 
                call LvInsertRow

                ; e_minalloc
                push offset e_minalloc
                push 2 
                push 5 
                push 0ah 
                call LvInsertRow

                ; e_maxalloc
                push offset e_maxalloc
                push 2 
                push 6 
                push 0ch 
                call LvInsertRow

                ; e_ss
                push offset e_ss 
                push 2 
                push 7 
                push 0eh 
                call LvInsertRow

                ; e_sp
                push offset e_sp
                push 2
                push 8 
                push 10h 
                call LvInsertRow

                ; e_csum
                push offset e_csum
                push 2 
                push 9 
                push 12h 
                call LvInsertRow

                ; e_ip
                push offset e_ip
                push 2 
                push 10 
                push 14h 
                call LvInsertRow

                ; e_cs
                push offset e_cs
                push 2 
                push 11 
                push 16h 
                call LvInsertRow

                ; e_lfarlc
                push offset e_lfarlc
                push 2 
                push 12 
                push 18h 
                call LvInsertRow

                ; e_lfanew
                push offset e_lfanew
                push 2 
                push 13 
                push 1ah 
                call LvInsertRow

                jmp EXIT
        ON_COFFHEADER:
            COFF_CREATE_COLUMN:
                mov lvc.imask, LVCF_TEXT or LVCF_WIDTH
                mov lvc.pszText, offset Address
                mov lvc.lx, 100
                push 0
                call SMInsertColLv

                mov lvc.pszText, offset Value
                mov lvc.lx, 100
                push 1
                call SMInsertColLv

                mov lvc.pszText, offset Meaning
                mov lvc.lx, 400 
                push 2 
                call SMInsertColLv

            COFF_INSERT_ITEM:
                mov edi, pMapping
                assume edi:ptr IMAGE_DOS_HEADER
                mov eax, [edi].e_lfanew
                mov startAddress, eax 
                add edi, [edi].e_lfanew
                assume edi:ptr IMAGE_NT_HEADERS

                ; PESignature
                push offset PESignature
                push 4 
                push 0
                push 0h 
                call LvInsertRow

                add startAddress, 4 
                add edi, SIZEOF_NT_SIGNATURE
                assume edi:ptr IMAGE_FILE_HEADER

                ; Machine
                push offset Machine
                push 2 
                push 1
                push 0h 
                call LvInsertRow

                ; NumberOfSections
                push offset NumberOfSections
                push 2 
                push 2
                push 2h 
                call LvInsertRow

                ; TimeDateStamp
                push offset TimeDateStamp
                push 4 
                push 3
                push 4h 
                call LvInsertRow

                ; PointerToSymbols
                push offset PointerToSymbolTable
                push 4 
                push 4
                push 8h 
                call LvInsertRow

                ; NumberOfSymbols
                push offset NumberOfSymbols
                push 4
                push 5
                push 0ch 
                call LvInsertRow

                ; SizeOfOptionalHeader
                push offset SizeOfOptionalHeader_str
                push 2 
                push 6 
                push 10h 
                call LvInsertRow

                ; Characteristics_coff
                push offset Characteristics_coff
                push 2 
                push 7 
                push 12h 
                call LvInsertRow

                jmp EXIT
        
        ON_OPTHEADER:
            OPT_CREATE_COLUMN:
                mov lvc.imask, LVCF_TEXT or LVCF_WIDTH
                mov lvc.pszText, offset Address
                mov lvc.lx, 100
                push 0 
                call SMInsertColLv

                mov lvc.pszText, offset Value
                mov lvc.lx, 100 
                push 1 
                call SMInsertColLv

                mov lvc.pszText, offset Meaning
                mov lvc.lx, 400 
                push 2 
                call SMInsertColLv

            OPT_INSERT_ITEM:
                mov edi, pMapping
                assume edi:ptr IMAGE_DOS_HEADER
                mov eax, [edi].e_lfanew
                add eax, 18h 
                mov startAddress, eax 
                add edi, [edi].e_lfanew
                assume edi:ptr IMAGE_NT_HEADERS
                add edi, SIZEOF_NT_SIGNATURE
                assume edi:ptr IMAGE_FILE_HEADER
                add edi, SIZEOF_IMAGE_FILE_HEADER
                assume edi:ptr IMAGE_OPTIONAL_HEADER32

                ; Magic
                push offset Magic
                push 2 
                push 0 
                push 0h 
                call LvInsertRow

                ; MajorLinkerVersion
                push offset MajorLinkerVersion
                push 1 
                push 1 
                push 2h 
                call LvInsertRow

                ; MinorLinkerVersion
                push offset MinorLinkerVersion
                push 1 
                push 2 
                push 3h 
                call LvInsertRow

                ; SizeOfCode
                push offset SizeOfCode
                push 4
                push 3
                push 4h 
                call LvInsertRow

                ; SizeOfInitializedData
                push offset SizeOfInitializedData
                push 4
                push 4
                push 8h 
                call LvInsertRow

                ;  SizeOfUninitializedData
                push offset SizeOfUninitializedData
                push 4
                push 5
                push 0ch 
                call LvInsertRow

                ; AddressOfEntryPoint
                push offset AddressOfEntryPoint
                push 4 
                push 6
                push 10h 
                call LvInsertRow

                ; BaseOfCode
                push offset BaseOfCode
                push 4 
                push 7 
                push 14h 
                call LvInsertRow

                ;  BaseOfData
                push offset BaseOfData
                push 4 
                push 8 
                push 18h 
                call LvInsertRow

                ;  ImageBase
                push offset ImageBase
                push 4 
                push 9 
                push 1ch 
                call LvInsertRow

                ;  SectionAlignment
                push offset SectionAlignment
                push 4 
                push 10 
                push 20h 
                call LvInsertRow

                ;  FileAlignment
                push offset FileAlignment
                push 4 
                push 11 
                push 24h 
                call LvInsertRow

                ;  MajorOperatingSystemVersion
                push offset MajorOperatingSystemVersion
                push 2
                push 12 
                push 28h 
                call LvInsertRow

                ;  2ah, 13, 2, MinorOperatingSystemVersion
                push offset MinorOperatingSystemVersion
                push 2 
                push 13 
                push 2ah 
                call LvInsertRow

                ;  2ch, 14, 2, MajorImageVersion
                push offset MajorImageVersion
                push 2
                push 14 
                push 2ch 
                call LvInsertRow

                ;  2eh, 15, 2, MinorImageVersion
                push offset MinorImageVersion
                push 2 
                push 15 
                push 2eh 
                call LvInsertRow

                ;  30h, 16, 2, MajorSubsystemVersion
                push offset MajorSubsystemVersion
                push 2 
                push 16 
                push 30h 
                call LvInsertRow

                ;  32h, 17, 2, MinorSubsystemVersion
                push offset MinorSubsystemVersion
                push 2
                push 17
                push 32h 
                call LvInsertRow

                ;  34h, 18, 4, Win32VersionValue
                push offset Win32VersionValue
                push 4
                push 18 
                push 34h 
                call LvInsertRow

                ;  38h, 19, 4, SizeOfImage
                push offset SizeOfImage
                push 4
                push 19
                push 38h
                call LvInsertRow

                ;  3ch, 20, 4, SizeOfHeader
                push offset SizeOfHeader
                push 4
                push 20
                push 3ch
                call LvInsertRow

                ;  40h, 21, 4, CheckSum
                push offset CheckSum
                push 4
                push 21
                push 40h
                call LvInsertRow

                ;  44h, 22, 2, Subsystem
                push offset Subsystem
                push 2
                push 22
                push 44h 
                call LvInsertRow

                ;  46h, 23, 2, DllCharacteristics
                push offset DllCharacteristics
                push 2
                push 23
                push 46h 
                call LvInsertRow

                ;  48h, 24, 4, SizeOfStackReserve
                push offset SizeOfStackReserve
                push 4
                push 24 
                push 48h 
                call LvInsertRow

                ;  4ch, 25, 4, SizeOfStackCommit
                push offset SizeOfStackCommit
                push 4 
                push 25 
                push 4ch 
                call LvInsertRow

                ;  50h, 26, 4, SizeOfHeapReserve
                push offset SizeOfHeapReserve
                push 4
                push 26
                push 50h 
                call LvInsertRow

                ;  54h, 27, 4, SizeOfHeapCommit
                push offset SizeOfHeapCommit
                push 4 
                push 27 
                push 54h 
                call LvInsertRow

                ;  58h, 28, 4, LoaderFlags
                push offset LoaderFlags
                push 4 
                push 28 
                push 58h 
                call LvInsertRow

                ;  5ch, 29, 4, NumberOfRvaAndSizes
                push offset NumberOfRvaAndSizes
                push 4 
                push 29 
                push 5ch 
                call LvInsertRow

                add edi, 60h 
                add startAddress, 60h 

                ;  0h, 30, 4, ExportTable
                push offset ExportTable
                push 4
                push 30
                push 0h 
                call LvInsertRow

                ;  4h, 31, 4, andSize
                push offset andSize
                push 4 
                push 31
                push 4h 
                call LvInsertRow

                ;  8h, 32, 4, ImportTable
                push offset ImportTable
                push 4
                push 32 
                push 8h 
                call LvInsertRow

                ;  0ch, 33, 4, andSize
                push offset andSize
                push 4 
                push 33 
                push 0ch 
                call LvInsertRow

                ;  10h, 34, 4, ResourceTable
                push offset ResourceTable
                push 4 
                push 34 
                push 10h 
                call LvInsertRow

                ;  14h, 35, 4, andSize
                push offset andSize
                push 4 
                push 35 
                push 14h 
                call LvInsertRow

                ;  18h, 36, 4, ExceptionTable
                push offset ExceptionTable
                push 4
                push 36 
                push 18h 
                call LvInsertRow

                ;  1ch, 37, 4, andSize
                push offset andSize
                push 4
                push 37 
                push 1ch 
                call LvInsertRow

                ;  20h, 38, 4, SecurityTable
                push offset SecuriryTable
                push 4 
                push 38 
                push 20h 
                call LvInsertRow

                ;  24h, 39, 4, andSize
                push offset andSize
                push 4
                push 39 
                push 24h 
                call LvInsertRow

                ;  28h, 40, 4, BaseRelocationTable
                push offset BaseRelocationTable
                push 4 
                push 40 
                push 28h 
                call LvInsertRow

                ;  2ch, 41, 4, andSize
                push offset andSize
                push 4
                push 41
                push 2ch 
                call LvInsertRow

                ;  30h, 42, 4, DebugData
                push offset DebugData
                push 4
                push 42 
                push 30h 
                call LvInsertRow

                ;  34h, 43, 4, andSize
                push offset andSize
                push 4
                push 43 
                push 34h 
                call LvInsertRow

                ;  38h, 44, 4, CopyrightData
                push offset CopyrightData
                push 4
                push 44
                push 38h 
                call LvInsertRow

                ;  3ch, 45, 4, andSize
                push offset andSize
                push 4 
                push 45 
                push 3ch 
                call LvInsertRow

                ;  40h, 46, 4, GlobalPtr
                push offset GlobalPtr
                push 4
                push 46 
                push 40h 
                call LvInsertRow

                ;  44h, 47, 4, andSize
                push offset andSize
                push 4
                push 47 
                push 44h 
                call LvInsertRow

                ;  48h, 48, 4, TLSTable
                push offset TLSTable
                push 4
                push 48 
                push 48h 
                call LvInsertRow

                ;  4ch, 49, 4, andSize
                push offset andSize
                push 4
                push 49 
                push 4ch 
                call LvInsertRow

                ;  50h, 50, 4, LoadConfigTable
                push offset LoadConfigTable
                push 4
                push 50 
                push 50h 
                call LvInsertRow

                ;  54h, 51, 4, andSize
                push offset andSize
                push 4
                push 51 
                push 54h 
                call LvInsertRow
                
                jmp EXIT

        SECNODE_SELECT:
            SECNODE_CREATE_COLUMN:
                mov lvc.imask, LVCF_TEXT or LVCF_WIDTH
                mov lvc.pszText, offset Address
                mov lvc.lx, 100
                push 0 
                call SMInsertColLv

                mov lvc.pszText, offset Value
                mov lvc.lx, 100 
                push 1 
                call SMInsertColLv

                mov lvc.pszText, offset Meaning
                mov lvc.lx, 400 
                push 2 
                call SMInsertColLv

            SECNODE_INSERT_ITEM:
                mov edi, pMapping
                assume edi:ptr IMAGE_DOS_HEADER
                xor eax, eax 
                mov eax, 28h
                pop ecx
                mul ecx
                 
                mov startAddress, 0
                pop edi

                ;  0h, 0, 0, SectionName
                push offset SectionName
                push 0
                push 0
                push 0h 
                call LvInsertRow

                ;  8h, 1, 4, VirtualAddress
                push offset VirtualSize
                push 4
                push 1
                push 8h 
                call LvInsertRow

                ;  0ch, 2, 4, VirtualAddress
                push offset VirtualAddress
                push 4
                push 2
                push 0ch 
                call LvInsertRow

                ;  10h, 3, 4, SizeOfRawData
                push offset SizeOfRawData
                push 4
                push 3
                push 10h 
                call LvInsertRow

                ;  14h, 4, 4, PointerToRawData
                push offset PointerToRawData
                push 4
                push 4
                push 14h 
                call LvInsertRow

                ;  18h, 5, 4, PointerToRelocation
                push offset PointerToRelocation
                push 4 
                push 5
                push 18h 
                call LvInsertRow

                ;  1ch, 6, 4, PointerToLinenumbers
                push offset PointerToLinenumbers
                push 4
                push 6
                push  1ch 
                call LvInsertRow

                ;  20h, 7, 2, NumberOfRelocations
                push offset NumberOfRelocations
                push 2 
                push 7
                push 20h 
                call LvInsertRow

                ;  22h, 8, 2, NumberOfLinenumbers
                push offset NumberOfLinenumbers
                push 2 
                push 8 
                push 22h 
                call LvInsertRow

                ;  24h, 9, 4, Characteristics
                push offset Characteristics_sec
                push 4
                push 9 
                push 24h 
                call LvInsertRow

                jmp EXIT
        ON_SECHEADER:
            jmp EXIT        

    DEFAULT:
        mov eax, 0
        ret 
    EXIT: 
        ret

DlgProc endp

funcOpenFile proc
    push ebp
    mov ebp, esp

    mov ofn.lStructSize, sizeof ofn
    mov ofn.lpstrFilter, offset filterString
    mov ofn.lpstrFile, offset fileName
    mov ofn.nMaxFile, 260
    mov ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_HIDEREADONLY or OFN_LONGNAMES or OFN_EXPLORER 
    mov  ofn.lpstrTitle, offset openTitle
    push offset ofn
    call GetOpenFileNameA

    mov esp, ebp
    pop ebp
    ret 4
funcOpenFile endp

SMInsertTv proc 
    push ebp
    mov ebp, esp 

    push offset tvinsert
    push 0
    push TVM_INSERTITEM 
    push hWndTreeView
    call SendMessage

    mov esp, ebp
    pop ebp 
    ret 

SMInsertTv endp

SMInsertColLv proc 
    push ebp 
    mov ebp, esp 

    push offset lvc 
    push [ebp+8]
    push LVM_INSERTCOLUMN 
    push hWndListView
    call SendMessageA

    mov esp, ebp 
    pop ebp 
    ret 4
SMInsertColLv endp

SMInsertLv proc 
    push ebp 
    mov ebp, esp 

    push ecx 
    push edx 

    push offset lvi 
    push 0 
    push LVM_INSERTITEM 
    push hWndListView
    call SendMessageA

    pop edx 
    pop ecx 

    mov esp, ebp 
    pop ebp 
    ret 
SMInsertLv endp 

SMSetItemLv proc 
    push ebp 
    mov ebp, esp 

    push offset lvi 
    push 0 
    push LVM_SETITEM 
    push hWndListView
    call SendMessageA

    mov esp, ebp 
    pop ebp 
    ret 
SMSetItemLv endp 

LvInsertRow  proc 
    push ebp 
    mov ebp, esp 
    
    push esi 

    mov ecx, [ebp+8]
    mov eax, ecx 
    add eax, startAddress

    push ecx 
    push eax 
    push offset format 
    push offset hexBuff
    call wsprintfA 
    add esp, 12 
    pop ecx 

    mov lvi.imask, LVIF_TEXT
    mov eax, [ebp+12]
    mov lvi.iItem, eax 
    mov lvi.iSubItem, 0 
    mov lvi.pszText, offset hexBuff
    call SMInsertLv

    inc lvi.iSubItem
    mov eax, [ebp+16]
    cmp eax, 0
    jz RAW_VALUE 
    cmp eax, 1 
    jz BYTE_VALUE 
    cmp eax, 2 
    jz WORD_VALUE 
    cmp eax, 4 
    jz DWORD_VALUE 

    RAW_VALUE:
        mov eax, dword ptr [edi+ecx]
        mov dword ptr[hexBuff], eax 
        mov eax, dword ptr [edi+ecx+4]
        mov dword ptr [hexBuff+4], eax 
        mov lvi.pszText, offset hexBuff
        jmp INSERT_VALUE 

    BYTE_VALUE:
        movzx eax, byte ptr [edi+ecx]

        push ecx 
        push eax 
        push offset format 
        push offset hexBuff
        call wsprintfA
        add esp, 12 
        pop ecx 

        mov lvi.pszText, offset hexBuff[6]
        jmp INSERT_VALUE

    WORD_VALUE:
        movzx eax, word ptr [edi+ecx]

        push ecx 
        push eax 
        push offset format 
        push offset hexBuff
        call wsprintfA
        add esp, 12 
        pop ecx 

        mov lvi.pszText, offset hexBuff[4]
        jmp INSERT_VALUE

    DWORD_VALUE:
        mov eax, dword ptr [edi+ecx]

        push ecx 
        push eax 
        push offset format
        push offset hexBuff
        call wsprintfA
        add esp, 12 
        pop ecx 

        mov lvi.pszText, offset hexBuff
        jmp INSERT_VALUE

    INSERT_VALUE:
        call SMSetItemLv
    
    inc lvi.iSubItem
    mov eax, [ebp+20]
    mov lvi.pszText, eax 
    ; call LvInsertSubItem 
    call SMSetItemLv

    pop esi 

    mov esp, ebp 
    pop ebp 
    ret 4*4 
LvInsertRow  endp 

RVAtoOffset proc 
    push ebp 
    mov ebp, esp 

    mov edx, sectionHeaderOffset
    assume edx:ptr IMAGE_SECTION_HEADER
    mov ecx, sections_count
    SECTIONS_LOOP:
        cmp ecx, 0
        jle END_ROUTINE 

        cmp edi, [edx].VirtualAddress
        jl NEXT_SECTION 

        mov eax, [edx].VirtualAddress
        add eax, [edx].SizeOfRawData
        cmp edi, eax 
        jge NEXT_SECTION

        mov eax, [edx].VirtualAddress
        sub edi, eax 
        mov eax, [edx].PointerToRawData
        add eax, edi 
        jmp DONE 

        NEXT_SECTION:
            add edx, sizeof IMAGE_SECTION_HEADER
            dec ecx 

        jmp SECTIONS_LOOP

    END_ROUTINE:
        mov eax, edi 

    DONE: 
        mov esp, ebp 
        pop ebp 
        ret 
RVAtoOffset endp 

end start


