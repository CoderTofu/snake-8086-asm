.model small
.stack 100h
.data
    filename db 'progs\snek\data.txt', 0
    handle dw ?
    ; scores db 05h
    ;        db 'JOE$', 000h, 010h
    ;        db 'BEN$', 000h, 00Fh
    ;        db 'GEK$', 000h, 009h
    ;        db 'KIM$', 000h, 004h
    ;        db 'JON$', 000h, 001h
    ;----expected output from scores.asm
    ; JOE 016 BEN 015 GEK 009 KIM 004 JON 001

    scores db 00h, 6*50 dup (0)
    ;inputs here
    uname db 'JOE$'
    iscore db 000h, 010h

.code 
    mov ax, @data
    mov ds, ax
    ; ;create file
    ; mov ah, 3ch
    ; mov cx, 0h  
    ; lea dx, filename
    ; int 21h
    ;open file  
    mov ax, 3d02h
    lea dx, filename
    int 21h
    mov handle, ax
    ;seek to start of file
    mov ax, 4200h
    mov bx, handle
    mov cx, 0
    mov dx, 0
    int 21h

    ;read from file
    mov ah, 3fh
    mov bx, handle
    mov cx, 1fh
    lea dx, scores
    int 21h
    
    ;insert
    lea di, scores
    xor ax, ax
    mov al, byte ptr [di]
    mov bl, 06h ;go to the last score record
    mul bl
    xor ah, ah
    add di, ax ;move di to the the last byte of the last record
    add di, 01h
    insrec:
        lea si, uname
        mov cx, 04h
        inpname:
            mov dl, byte ptr [si]
            mov byte ptr [di], dl
            inc si
            inc di
            loop inpname
        lea si, iscore
        mov dh, byte ptr [si]
        mov dl, byte ptr [si+1]
        mov byte ptr [di], dh
        mov byte ptr [di+1], dl
    
    ;increment score size 
    lea si, scores
    mov ch, byte ptr [si]
    inc ch
    mov byte ptr [si], ch
    
    ;SORTING
    mov dh, ch
    ;ch = outer loop counter
    ;dh = inner loop counter
    outsort:
        lea si, scores ;reset pointers
        lea di, scores
        add si, 06h
        add di, 06h
        push cx
        mov ch, dh
        insort:
            mov di, si
            mov al, byte ptr [si]
            mov ah, byte ptr [si-1]
            mov bl, byte ptr [si+6]
            mov bh, byte ptr [si+5]
            cmp ax, bx
            jge noswap
            add di, 01h
            sub si, 05h
            mov dl, 06h
            swapscore:
                mov bh, byte ptr [di]
                mov bl, byte ptr [si]
                mov byte ptr [di], bl
                mov byte ptr [si], bh
                inc si
                inc di
                dec dl
                jnz swapscore
            noswap:
            add si, 06h
            dec ch 
        jnz insort
        pop cx
        dec dh
        dec ch
    jnz outsort

    ;cap score size for storage
    lea si, scores
    mov al, byte ptr [si]
    cmp al, 05h
    jle undercap
    mov al, 05h
    undercap:
    mov byte ptr[si], al
        
    ;seek to start of file
    mov ax, 4200h
    mov bx, handle
    mov cx, 0
    mov dx, 0
    int 21h
    ;write to file
    mov ah, 40h
    mov bx, handle
    lea dx, scores
    mov cx, 1fh;
    int 21h
    ;close file
    mov ah, 3eh
    mov bx, handle
    int 21h

    mov ah, 4ch
    int 21h
    ;-----------------------------------------------------
    ; ;insert into sorted position (failed attempt)
    ; lea di, scores
    ; mov ch,  byte ptr [di]
    ; add di, 01h
    ; cmp ch, 00h
    ; je insrec
    ; add di, 04h ;look at the first score 
    ; lea si, iscore
    ; mov dh, byte ptr [si]
    ; mov cl, 01h
    ; scorepos:
    ;     add cl, 01h
    ;     mov dl, byte ptr [di]
    ;     cmp cl, ch 
    ;     jg endscore
    ;     cmp dh, dl  
    ;     jle endscore
    ;     add di, 05h
    ;     jmp scorepos


    ; endscore:
    ;     cmp cl, 05h
    ;     jle notout
    ;     ;ret
    ;     mov ah, 4ch
    ;     int 21h
    ;     notout:
    ;     cmp cl, ch
    ;     5 notnew
    ;     lea di, scores
    ;     add ch, 01h
    ;     mov al, ch
    ;     mov bl, 05h
    ;     mul bl
    ;     add di, ax
    ;     sub di, 04h
    ;     jmp insrec

    ; ;cl holds the target index
    ; notnew:
    ;     lea di, scores
    ;     lea si, scores
    ;     mov al, byte ptr [di]
    ;     mov bl, 05h
    ;     mul bl
    ;     add di, ax
    ;     sub di, 04h
    ;     sub ch, cl ;counter for outer shift loop, (score size - target index) -> 0
    ;     shiftloop:
    ;         mov si, di
    ;         sub si, 05h
    ;         mov bl, 00h ;counter for inner shift loop, 0 -> 5 
    ;         shftinloop:
    ;             add bl, 01h
    ;             mov dh, byte ptr [si]
    ;             mov byte ptr [di], dh
    ;             add si, 01h
    ;             add di, 01h
    ;             cmp bl, 05h
    ;             jle shftinloop
    ;         sub di, 0ah
    ;         sub ch, 01h
    ;         jnz shiftloop
    
    ; lea di, scores
    ; mov al, cl
    ; mov bl, 05h
    ; mul bl
    ; add di, ax
    ; sub di, 04h
    ; insrec:
    ;     lea si, uname
    ;     mov cx, 04h
    ;     inpname:
    ;         mov dl, byte ptr [si]
    ;         mov byte ptr [di], dl
    ;         add si, 01h
    ;         add di, 01h
    ;         loop inpname
    ;     lea si, iscore
    ;     mov dl, byte ptr [si]
    ;     mov byte ptr [di], dl
end