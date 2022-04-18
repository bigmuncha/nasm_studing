#!/bin/bash
nasm  -felf32 $1.asm -o $1.o -g -i./include
ld  -m  elf_i386 $1.o -o run
rm $1.o
