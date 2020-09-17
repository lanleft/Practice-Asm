#include <stdio.h>
#include <windows.h>
// #include <Processthreadsapi.h>
#include <processthreadsapi.h>

int main(){
    int result;
    struct _STARTUPINFORA StartupInfo; 
    struct _PROCESS_INFORMATION ProcessInformation; 
    DWORD NumberOfBytesWritten;
    DWORD nNumberOfBytesToWrite; 
    BOOL v8;
    HANDLE hFile;
    CHAR Filename;
    char Dest;
    char Format[4];

    v8 = 0;
    strcpy(Format, "DEL /F /Q %s");
    StartupInfo.cb = 68; 
    memset(&StartupInfo.lpReserved, 0, 0x40);
    GetModuleFileNameA(0, &Filename, 0x104);
    NumberOfBytesWritten = 0;
    sprintf(&Dest, Format, &Filename);
    nNumberOfBytesToWrite = strlen(&Dest);
    hFile = CreateFileA("hacked.bat", 0x40000000, 0, 0, 2, 0x80, 0);
    if (hFile == -1)
    {
        printf ("Unable to create/open file, aborting...\n");
        result = -1;
    }
    else
    {
        v8 = WriteFile(hFile, &Dest, nNumberOfBytesToWrite, &NumberOfBytesWritten, 0);
        if (v8)
        {
            printf ("bat-file successfully created, launching...\n");
            CloseHandle(hFile);
            CreateProcessA(0, "cmd.exe /C hacked.bat", 0, 0, 0, 0, 0, 0, &StartupInfo, &ProcessInformation);
            result = 0;
        }
        else
        {
            printf ("Unable to write to file, aborting...\n");
            result = -1;
        }
    }
    return result;

}