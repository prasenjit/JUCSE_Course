; Make sure to add a space at last of input, for e.g. "22 33 22 34 "

        .model small
        .stack 256
CR equ 13d
LF equ 10d
        .data
prompt1 db 'Enter numbers(last space): $'
max2msg db CR, LF,'2nd max is: $'
min2msg db CR, LF, '2nd min is: $'
max1 dw ?
max2 dw ? 
min1 dw ? 
min2 dw ? 
        .code
start:
        mov ax, @data
        mov ds, ax

        mov max1,0
        mov max2,0
        mov min1,9999
        mov min2,9999

        mov dx, offset prompt1
        mov ah,9
        int 21h

        l0:  mov bx,0	; set bx=0
        l1:  mov ah,1	; take input of next digit
        int 21h

        cmp al,13	; (input == CR)?
        je l3		; taking input finished
        cmp al,32	; (input == ' ')?
        je l2

        sub al,'0'
        push ax
        mov ax,bx
        mov cx,10
        mul cx
        mov bx,ax
        pop ax
        mov ah,0
        add bx,ax
        jmp l1

        l2:  cmp max1,bx; (max1 < bx)?
        jnl l4		; if yes, goto l4
        mov cx,max1	; cx = max1
        mov max2,cx	; max2 = cx
        mov max1,bx	; max1 = bx
        jmp lb2		; goto lb2

        l4:  cmp max2,bx; (max2 < bx)?
        jnl lb2		; if yes, goto lb2
        mov max2,bx	; max2 = bx
        ;jmp lb2

        lb2:  cmp min1,bx; (min1 > bx)?
        jng lb4		; if yes, goto lb4
        mov cx,min1	; cx = min1
        mov min2,cx	; min2 = cx
        mov min1,bx	; min1 = bx
        jmp l0		; goto l0, i.e. take new input

        lb4:  cmp min2,bx; (min2 > bx)?
        jng l0		; if yes, goto l0, i.e. take new input
        mov min2,bx	; min2 = bx
        jmp l0		; goto l0, i.e. take new input

; taking input of nums finished
; now print max2 and min2

        l3:  mov dx, offset max2msg
        mov ah,9
        int 21h

        mov ax,max2	; print max2
        call putn

        mov dx, offset min2msg
        mov ah,9
        int 21h

        mov ax,min2	; print min2
        call putn
        mov ax, 4c00h
        int 21h

putn:               ; display number in ax
                ; ax contains number (and also div C in above)
                ; dx contains remainder (rem in C above)
                ; cx contains 10 for division
    push    bx
    push    cx
    push    dx
 
    mov     dx, 0           ; dx = 0
    push    dx          ; push 0 as sentinel
    mov     cx, 10      ; cx = 10
 
    cmp     ax, 0
    jge     calc_digits     ; number is negative
    neg     ax          ; ax = -ax; ax is now positive
    push    ax          ; save ax
    mov al, '-'     ; display - sign
    call    putc
    pop ax          ; restore ax
 
calc_digits:
    div cx          ; dx:ax = ax / cx
                    ; ax = result, dx = remainder
    add dx, '0'     ; convert dx to digit
    cmp dx,57
    jle l33
    add dx,7
    l33:		push    dx          ; save digit on stack
    mov dx, 0       ; dx = 0
    cmp ax, 0           ; finished ?
    jne calc_digits     ; no, repeat process
 
;   all digits now on stack, display them in reverse
 
disp_loop:
    pop dx          ; get last digit from stack
    cmp dx, 0           ; is it sentinel
    je  end_disp_loop   ; if yes, we are finished 
    mov al, dl      ; al = dl
    call    putc            ; otherwise display digit
    jmp disp_loop
 
end_disp_loop:
    pop dx          ; restore registers
    pop cx
    pop bx
    ret
 
putc: ; display character in al
 
        push ax ; save ax
        push bx ; save bx 
        push cx ; save cx
        push dx ; save dx
 
        mov dl, al
        mov ah, 2h
        int 21h
 
        pop dx ; restore dx
        pop cx ; restore cx
        pop bx ; restore bx
        pop ax ; restore ax
        ret
end start
