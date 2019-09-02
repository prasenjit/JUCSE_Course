; This code works for single digit hex numbers


	.model small
	.stack 256

CR equ 13d
LF equ 10d

	.data
prompt1 db 'Enter num1:$'
prompt2 db CR,LF,'Enter num2:$'
result db CR,LF,'num1+num2=$'

num1 dw ?
num2 dw ?

	.code
start:
	mov ax,@data
	mov ds,ax

	mov ax,offset prompt1
	call puts	; display prompt1

	call getn	; read num1
	mov num1,ax

	mov ax,offset prompt2
	call puts	; display prompt2

	call getn	; read num2
	mov num2,ax

	mov ax,offset result
	call puts	; display result prompt

	mov ax,num1
	add ax,num2
	call putn	; display sum

	mov ax,4c00h
	int 21h		; finished

getn:		; read a number from keyboard
		; store its value in ax
		; dx stores sign of num, 1 for +, -1 for -
		; cx stores number read so far
		; bl stores each digit
		; al stores each char read in
		; ax used in mul instruc
	push bx		; save registers
	push cx
	push dx

	mov dx,1	; positive num
	mov bx,0	; initial digit set 0
	mov cx,0	; num = 0  initially

	call getc	; read first char
	cmp al,'-'	; negative?
	jne newline	; if not, goto newline
	mov dx,-1	; else record sign

	call getc	; get next digit

newline:
	push dx		; save sign on stack
	cmp al,CR	; if (digit == CR)
	je fin_read	; goto fin_read
	sub al,'0'	; input-'0'
	cmp al,9
	jle l1
	sub al,7
	l1: mov cl,al	; cl=first digit
	call getc	; get next char
read_loop:
	cmp al,CR	; if (digit == CR)
	je fin_read	; reading finished
	sub al,'0'
	cmp al,9
	jle l2
	sub al,7
	l2: mov bl,al	; bl = al
	mov ax,16	; ax = 16
	mul cx		; ax = ax * 16
	mov cx,ax	; cx = ax
	add cx,bx	; cx = cx + bx(current entered digit)
	call getc	; read next digit
	jmp read_loop
fin_read:
	mov ax,cx	; number saved in ax
	pop dx		; retrieve sign from stack
	cmp dx,1	; compare sign with +
	je fin_getn	; if +, goto fin_getn
	neg ax		; ax = -ax
fin_getn:
	pop dx
	pop cx
	pop bx
	ret

puts:		; display a string terminated by $
		; dx contains address of string
	push ax
	push bx
	push cx
	push dx

	mov dx,ax
	mov ah,9h
	int 21h

	pop dx
	pop cx
	pop bx
	pop ax
	ret

putn:		; display number in ax
		; ax contains number
		; dx contains remainder
		; cx contains 16
	push bx
	push cx
	push dx

	mov dx,0	; sentinel 0 pushed to empty stack
	push dx
	mov cx,16

	cmp ax,0	; num == 0?
	jge calc_digits
	neg ax		; ax = -ax, ax becomes +
	mov al,'-'
	call putc
	pop ax		; restore ax

calc_digits:
	div cx		; dx:ax = ax / cx, dx=rem, ax=quotient
	add dx,'0'	; add '0' to remainder to get ascii
	cmp dx,57
	jle l3
	add dx,7
	l3: push dx	; save digit on stack
	mov dx,0
	cmp ax,0
	jne calc_digits
; all digits now on stack, display them now
disp_loop:
	pop dx
	cmp dx,0	; is dx = 0(sentinel)?
	je end_disp_loop; means stack was empty, goto end_disp_loop
	mov al,dl
	call putc
	jmp disp_loop
end_disp_loop:
	pop dx
	pop cx
	pop bx
	ret

putc:		; display char in al
	push ax
	push bx
	push cx
	push dx

	mov dl,al
	mov ah,2h
	int 21h

	pop dx
	pop cx
	pop bx
	pop ax
	ret

getc:		; read a char in al
	push bx
	push cx
	push dx

	mov ah,1h
	int 21h

	pop dx
	pop cx
	pop bx
	ret

	end start