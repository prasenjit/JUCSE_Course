.model small
.stack 100h
.data
myname db 'Prasenjit$'

.code
main proc
mov ax, @data
mov ds, ax
lea dx, myname
mov ah, 9
int 21h
mov ah, 4ch
int 21h
main endp
end main
