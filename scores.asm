.model small
.stack 100h
.data
    filename db 'progs\snek\data.txt', 0
    handle dw ?
    scores db 00h, 6*6 dup (0)
    strbuf db 4 dup(?)
    screbuf db 00h
.code 
    mov ax, @data
    mov ds, ax
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

    lea si, scores
    mov ch, byte ptr [si]
    ;ch = number of records
    inc si
    iter_scores:
        lea di, strbuf
        mov cl, 04h
        ldbuf:
            mov dl, byte ptr [si]
            mov byte ptr [di], dl
            inc di
            inc si
            dec cl
            jnz ldbuf
        lea dx, ldbuf
        mov ah, 09h
        int 21h
        mov ah, 02h
        mov dl, 20h
        int 21h
        
        mov ah, byte ptr [si]
        inc si
        mov al, byte ptr [si]
        push cx
        mov cx, 03h
        divide:         ; convert to decimal (thank u raffy)
            xor dx, dx
            mov bx, 0ah
            div bx
            push dx
        loop divide
        mov cx, 03h
        printnum:
            pop dx
            add dx, '0'
            mov ah, 02 
            int 21h
        loop printnum
        inc si
        pop cx
        dec ch
    jnz iter_scores



    ;close file
    mov ah, 3eh
    mov bx, handle
    int 21h

    mov ah, 4ch
    int 21h
end