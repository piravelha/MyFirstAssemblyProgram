nasm -f elf64 -o main.o main.asm
ld -o main main.o
rm main.o
./main
rm main