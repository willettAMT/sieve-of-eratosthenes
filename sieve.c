#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>

#define RIGHT_BITS 0x0f
#define LEFT_BITS 0xf0
#define FALSE 0
#define TRUE 1
#define U_DEFAULT 100

int sieve(unsigned long u_bound, short p_or_c, short bin, short verb);
int b_out(uint8_t *num_l, short shortp_or_c, unsigned long u_bound);

int main(int argc, char **argv)
{
    short verb = FALSE, opt = 0, p_or_c = TRUE, bin = FALSE;
    unsigned long u_bound = U_DEFAULT;

    while ((opt = getopt(argc, argv, "pcbvhu:")) != -1) // argv element after ':' stored in optarg variable
    {
        switch (opt)
        {
            case 'p': // The output must be prime numbers (default)
                p_or_c = TRUE;
                break;
            case 'c': // Output must be the composite numbers, not prime, goes to standard output
                p_or_c = FALSE;
                break;
            case 'u': // identifies upper bound on the prime/composite number the code generates
                      // takes # argument to generate up to & including. Default is 100
                u_bound = strtol(optarg, NULL, 10);
                break;
            case 'b': // default, the outtput from program is ASCII to standard output. -b will change to binary numbers
                      // (unsigned long) to standard output (STDOUT_FILENO). Use write(). Requires view_long to view
                bin = TRUE;
                break;
            case 'v': // increment internal variable that will allow viewing of what is going inside the code at runtime
                      // all verbose output must go to stderr, not standard output
                verb = TRUE;
                break;
            case 'h': // print helpful messages (to stdout) and exit with an exit status of EXIT_SUCCESS
                printf("\n\nSieve of Eratosthenes\n\n-c: View list of composite numbers from 2 to upper bound (-u #) default 100\n" 
                "-p: View list of prime numbers from 2 to upper bound (-u #) default 100\n"
                "-u #: Set upper bounds, default 100\n" 
                "-v: Verbose mode, using stderr for additional runtime information\n"
                "-b: Output in binary, ADVISORY: Recommend redirection to file\n"
                "-h: Display THIS help message\n\n");
                exit(EXIT_SUCCESS);
            default:/* ? */
                break;
        }
    }

    if (optind < argc)
    {
        fprintf(stderr, "\nFlags not recognized:\n");
        for (int i = optind; i < argc; ++i)
            printf("\t%s\n", argv[i]);
    }

    return sieve(u_bound, p_or_c, bin, verb);
}

int sieve(unsigned long u_bound, short p_or_c, short bin, short verb)
{
    unsigned long bits;
    unsigned long prime;
    uint8_t *num_l = malloc(sizeof(uint8_t) * (u_bound/2) + 1);

    prime = 2;
    while (prime <= u_bound && (prime * prime) <= u_bound) // marking
    {
        if (prime != 2 && prime % 2 == 0)
            ++prime;
        for (bits = (prime * 2); bits <= u_bound; bits += prime)
        {
            if (verb) fprintf(stderr, "\n\nCurrent Prime: %ld\n", prime);
            num_l[bits/2] |= ((bits % 2) == 0) ? LEFT_BITS : RIGHT_BITS; // (array[index/2] LEFT & RIGHT bits
            if (verb) // verbose flag
                fprintf(stderr, "\nMarking Multiple: %ld\n", bits);
        }
            ++prime;
        }

    prime = bits = 0;
    if (bin)
        b_out(num_l, p_or_c, u_bound);
    else
        if (p_or_c)
        {
            for (prime = 2; prime <= u_bound; ++prime)
                if (((prime == 2) || (prime % 2 == 1)) && (num_l[prime/2] & RIGHT_BITS) == 0) printf("%ld\n", prime);
        }
        else
            for (prime = 4; prime <= u_bound; ++prime)
                if ((prime % 2 == 0) || ((num_l[prime/2] & RIGHT_BITS) != 0)) printf("%ld\n", prime);

    free(num_l);
    return EXIT_SUCCESS;
}

int b_out(uint8_t *num_l, short p_or_c, unsigned long u_bound)
{
    unsigned long prime;
    unsigned long buf;
    if (p_or_c)
    {
        for (prime = 2; prime <= u_bound; ++prime)
            if (((prime == 2) || (prime % 2 == 1)) && (num_l[prime/2] & RIGHT_BITS) == 0)
            {
                buf = prime;
                write(STDOUT_FILENO, &buf, sizeof(buf));
            }
    }
    else
        for (prime = 4; prime <= u_bound; ++prime)
            if ((prime % 2 == 0) || ((num_l[prime/2] & RIGHT_BITS) != 0))
            {
                buf = prime;
                write(STDOUT_FILENO, &buf, sizeof(buf));
            }
    return EXIT_SUCCESS;
}

