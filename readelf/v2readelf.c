#include <stdio.h>
#include <assert.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdbool.h>
#include <elf.h>

#define DEBUG 1 
#define debug(...) \ 
            do {if (DEBUG) printf("<debug>:"__VA_ARGS__);} while (0)

void read_elf_header64(int32_t fd, Elf64_Ehdr *elf_header)
{
    assert(elf_header != NULL );
    assert(leek(fd, (off_t)0, SEEK_SET) == (off_t)0);
    assert(read(fd, (void *)elf_header, sizeof(Elf64_Ehdr)) == sizeof(Elf64_Ehdr));

}

bool is_ELF64(Elf64_Ehdr eh)
{
    if (!strcmp((char *)eh.e_ident, "\177ELF", 4)){
        printf("ELFMAGIC \t= ELF \n");
        return 1;
    }else{
        printf("ELFMAGIC mismatch!\n");
        return 0;
    }
}

void print_elf_header64(Elf64_Ehdr elf_header)
{
    // Storage capacity class
    printf("Storage class\t=");
    switch(elf_header.e_ident[EI_CLASS])
    {
        case ELFCLASS32:
            printf("32-bit objects\n");
            break;
        
        case ELFCLASS64:
            printf("64-bit objects\n");
            break;

        default:
            printf("INVALID CLASS\n");
            break;
    }
    // Data format
    printf("Data format\t= ");
    switch(elf_header.e_ident[EI_DATA])
    {
        case ELFDATA2LSB:
            printf("2's complement, little endian\n");
            break;

        case ELFDATA2MSB:
            printf("2's complement, big endian\n");
            break;

        default:
            printf("INVALID Format\n");
            break;
    }
    // OS ABI 
    printf("OS ABI\t\t= ");
    switch(elf_header.e_ident[EI_OSABI])
    {
        case ELFOSABI_SYSV:
            printf("UNIX system V ABI\n");
            break;

        case ELFOSABI_NETBSD:
            printf("Net")
    }
}