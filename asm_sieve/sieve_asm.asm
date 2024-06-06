; Aaron Willett
; <aaronw> aaronw@pdx.edu
; 05/31/24
; Sieve of Eratosthenes BUT in Nasm

%define marked 0x01
%define unmarked 0x00
%define NULL 0
%define NL 10
%define two 2
%define two_bil 2000000000
%define ten 10

extern printf
extern scanf
extern malloc
extern free

global main                                     ; the standard entry point!!!!

section .bss                                    ; BSS < uninitialized variables
    upper_bound:    resd 1                      ; Initialize 4 byte integer ~ upper_bound

section .data                                   ; Data section, initialized variables
    prime:          dd 2                        ; Intialize prime to two
    i:              dd 1                        ; Initialize 8 byte integer for iteration
    prime_array:    dd 0x0                      ; mem locale for array
        
section .rodata                                 ; read-only data
    print_fmt:      db NL, "%d", NULL
    print_nl:       db NL, NULL
    input_fmt:      db "%d", NULL
    enter_ub:       db "Enter the upper bound of the prime numbers: ", NULL
    bad_ub_msg:     db NL, "Number is of bounds for this program [ 10 - 2000000000]. Try again!", NL, NULL
    bad_alloc_msg:  db NL, "Allocation of array memory failed. So Sad. Exiting program.", NL, NULL

section .text                                   ; Code section

main:                                           ; the program label for the entry point
        push    ebp                             ; set up stack frame
        mov     ebp, esp                        ;

get_ub:
        push dword enter_ub                     ; displays instructions to user
        call printf                             ; 
        push dword upper_bound                  ; push address of upper_bound onto the stack 
        push dword input_fmt                    ; push input_fmt onto stack
        call scanf                              ; call scanf (gets input from stdin)
        add esp, 12                             ; pop mem off stack (3 ops)

        mov eax, [upper_bound]                  ; move value at upper_bound into eax
        cmp eax, ten
        jl .bad_ub                              ; jump to bad_ub subroutine
        cmp eax, two_bil                        ; compare the minimum val for array to eax val
        jg .bad_ub                              ; jump to bad_ub subroutine
        jmp .alloc                              ; moving to alloc

.bad_ub:
        push dword bad_ub_msg 
        call printf
        add esp, 4
        jmp get_ub

.alloc:
        mov eax, [upper_bound]                  ; move upper-bound into dividend register
        push eax                                ; push onto the stack
        call malloc                             ; call malloc

        test eax, eax
        jz .bad_alloc
        mov [prime_array], eax                  ; move value into allocated array mem
        add esp, 4                              ; clean up stack

        mov edi, [prime_array]                  ; move ptr val to a register
        mov ecx, [upper_bound]                  ; could this be eax? num of elements in the array
        dec ecx                                 ; adjust for correct arr size

        jmp .init_arr

.bad_alloc:
        push dword bad_alloc_msg
        call printf
        add esp, 4
        jmp .exit


.init_arr:
        mov byte [edi + ecx], 1                 ; starting from the size of array
        loop .init_arr                          ; loop decrements until ecx is 0
        mov byte [edi + ecx], 1

.prime_loop:
        xor eax, eax
        mov ecx, two                            ; initializing counter to 2
        mov eax, ecx                            ; move value of counter to eax
        mov ebx, [upper_bound]                  ; enter value of upperbound into ebx 
        jmp .outer                              ; jump to outer loop

    .marked:
        inc ecx

    .outer:
        mov eax, ecx                            ; move counter value into eax
        imul eax, eax                           ; multiply eax by eax
        cmp eax, ebx                            ; compare prime squared with upper bound
        jge .print                              ; if greater than or equal, jump to print

        cmp byte [edi + ecx], unmarked          ; compare unmarked to eax
        je .marked                              ; if equal, move to .marked subroutine
        
        mov edx, ecx                            ; move value of counter into edx
        imul edx, 2                             ; multiply edx by 2

    .inner: 
        cmp edx, ebx                            ; compare current edx (multiple) to upper bound
        jge .marked

        mov byte [edi + edx], 0                 ; "unmark that dude"
        add edx, ecx                            ; add count (current prime) to edx (multiple)
        jmp .inner                              ; jump to top of loop
        inc ecx                                 ; increment counter

    .print:
        mov ecx, 2                              ; resetting counter to 2 to start prime print

    .p_loop:
        cmp byte [edi + ecx], marked
        je .print_primes                        ; jump to .print_primes if equal
        inc ecx                                 ; increment counter
        cmp ebx, ecx                            ; compare counter to upper bound
        jg .p_loop                              ; restart the loop
        jmp .exit                               ; jump to exit

    .print_primes:
        push dword ecx                          ; move value of ecx onto stack
        push ecx                                ; printf does something weird. This is necessary
        push dword print_fmt                    ; push print_fmt to stack
        call printf                             ; WARNING WARNING: printf will fuck your life up.
        add esp, 8                              ; clean up the stack
        pop ecx                                 ; printf does something weird. This is necessary
        inc ecx                                 ; increment counter
        cmp ebx, ecx                            ; compare if counter is greater than upper bound
        jg .p_loop                             ; restart the loop

.exit:
        push dword print_nl                     ; formatting non-sense
        call printf                             ; 
        add esp, 4                              ; clean up stack
        push dword [prime_array]                ; push array address onto stack
        call free                               ; call free (free the mem)
        add esp, 4                              ; clean up the stack
        mov     esp, ebp                        ; take down stack frame
        pop     ebp                             ; pop off the pointer from stack

        mov     eax, 0                          ; normal, no error, return value
        ret
