.model small
.stack 100h
cr equ 13d
lf equ 10d

.data
prompt_1 db 'Upper case letter : $'
prompt_2 db cr,lf, 'Corresponding lower case letter : $'

.code
main proc

mov ax, @data
mov ds, ax

lea dx, prompt_1
mov ah,9
int 21h

mov ah,1
int 21h

mov bl,al

lea dx, prompt_2
mov ah,9
int 21h

or bl,20h

mov ah,2
mov dl,bl
int 21h

mov ah,4ch
int 21h

main endp
end main
