section .bss
    buffer_a resb 20            ; Buffer to store the first number as text
    buffer_b resb 20            ; Buffer to store the second number as text
    result resb 20              ; Buffer to store the result

section .data
    newline db 10               ; Newline

section .text
    global _start               ; Specifies the entry-point

_start:
    ; Read the first number
    mov rdi, 1                  ; Select "standard-in" as the channel
    lea rsi, [buffer_a]         ; Point to the "a" buffer
    mov rdx, 20                 ; Set to read 20 bytes
    mov rax, 0                  ; Select the "read" syscall
    syscall                     ; Perform syscall

    ; Read the second number
    mov rdi, 1                  ; Select "standard-in" as the channel
    lea rsi, [buffer_b]         ; Point the the "b" buffer
    mov rdx, 20                 ; Set to read 20 bytes
    mov rax, 0                  ; Select the "read" syscall
    syscall                     ; Perform syscall

    ; Parse first number
    lea rsi, [buffer_a]         ; Point to the "a" buffer
    call atoi                   ; Call "atoi" (ASCII to Integer)
    mov r8, rax                 ; Store the result in "r8"

    ; Parse second number
    lea rsi, [buffer_b]         ; Point to the "b" buffer
    call atoi                   ; Call "atoi" (ASCII to Integer)
    mov r9, rax                 ; Store the result in "r9"

    ; Adds both results
    add r8, r9                  ; Add "r8" and "r9" toguether

    ; Stringifies the result
    lea rsi, [result]           ; Point to the the result buffer
    mov rdi, r8                 ; Move "r8" to rdi
    call itoa                   ; Call "itoa" (Integer to ASCII)

    ; Prints the result
    mov rdi, 1                  ; Select the standard-out channel
    lea rsi, [result]           ; Point to the result string buffer
    mov rdx, 20                 ; Set to write 20 bytes
    mov rax, 1                  ; Set the syscall to "write"
    syscall                     ; Perform the syscall

    ; Adds a new-line
    mov rdi, 1                  ; Select the standard-out channel
    lea rsi, [newline]          ; Point to the newline buffer
    mov rdx, 1                  ; Set to write a single byte
    mov rax, 1                  ; Set the syscall to "write"
    syscall                     ; Perform the syscall

    ; Exits gracefully
    mov rax, 60                 ; Set the syscall to "exit"
    mov rdi, 0                  ; Select exit code "0" (Success)
    syscall                     ; Perform the syscall

; Integer to ASCII
itoa:
    mov rbx, 10                 ; Sets to base-10
    xor rdx, rdx                ; Clears rdx for the division step
    mov rax, rdi                ; Moves the input to "rax"

    add rsi, 20                 ; Moves pointer to the end of the output buffer
    dec rsi                     ; Decrement the output buffer
    mov byte [rsi], 0           ; Accounts for the null terminator

; Loop for Integer to ASCII
itoa_loop:
    dec rsi                     ; Decrements the output pointer
    div rbx                     ; Performs the division
    add dl, '0'                 ; Converts the integer to an ASCII char
    mov [rsi], dl               ; Appends the char to the result buffer
    xor rdx, rdx                ; Clears rdx for the next iteration
    test rax, rax               ; Checks if "rax" is zero
    jnz itoa_loop               ; if "rax" is not zero, iterate again

    ret                         ; else, return

; ASCII to Integer
atoi:
    xor rax, rax                ; Clears "rax"
    xor rcx, rcx                ; Clears "rcx"

; Loop for ASCII to Integer
atoi_loop:
    movzx rcx, byte [rsi]       ; Moves a byte from input to "rcx"
    test rcx, rcx               ; Checks if rcx == 0
    jz atoi_done                ; if it doesnt, return

    sub rcx, '0'                ; Convert from character to integer
    jb atoi_done                ; If it fails, return
    cmp rcx, 9                  ; Checks if it is greater then 9
    ja atoi_done                ; If so, return
    imul rax, rax, 10           ; Multiply "rax" by 10
    add rax, rcx                ; Add the digit
                                ; eg. 2, 3 = 2*10 + 3 = 23

    inc rsi                     ; increment the input pointer
    jmp atoi_loop               ; iterate again

; Break out of the ASCII to Integer Loop
atoi_done:
    ret
