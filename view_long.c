#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    int i, fd;
    unsigned long buf;

    if (argc == 1) {
        while(read(STDIN_FILENO, &buf, sizeof(buf)) > 0) {
            printf("%lu\n", buf);
        }
    }
    else {
        for (i = 1; i < argc; ++i)
        {
            fd = open(argv[i], O_RDONLY);
            while (read(fd, &buf, sizeof(buf)) > 0) {
                printf("%lu\n", buf);
            }
        }
    }

    return EXIT_SUCCESS;
}
