.model small
.stack 100h
.data
    ;main menu
    strTitle db "BSCS 2-2, Group 1",13,10
    strTitle_l equ $-strTitle

    strYear db "[v1.0] | 2024",13,10
    strYear_l equ $ - strYear

    ;main menu choices
    strStart db "[S] START",13,10
    strStart_l equ $ - strStart

    strLeaderboard db "[L] LEADERBOARD",13,10
    strLeaderboard_l equ $ - strLeaderboard

    strMech db "[M] MECHANICS",13,10
    strMech_l equ $ - strMech

    strExit db "[ESC] EXIT",13,0
    strExit_l equ $ - strExit

    ;difficulty options
    strDiffSelec db "SELECT A DIFFICULTY",13,10
    strDiffSelec_l equ $ - strDiffSelec

    strEasy db "[1] EASY",13,10
    strEasy_l equ $ - strEasy

    strModerate db "[2] MODERATE",13,10
    strModerate_l equ $ - strModerate

    strHard db "[3] HARD",13,10
    strHard_l equ $ - strHard

    strBack db "[B] BACK",13,10
    strBack_l equ $ - strBack
    
    ;leaderboard ; changed HERE by adding '$'
    strLeadPage db "LEADERBOARD",13,10
    strLeadPage_l equ $ - strLeadPage

    ; for the leaderboard
    score_file db 'progs\snek\snekscor.txt', 0
    lead_ctr db 8
    handle dw ?
    scores db 00h, 6*6 dup (0)
    strbuf db 4 dup('1'), 13
    screbuf db 00h

    ;score saving page
    strScorePage db "SAVE SCORE", 13,10
    strScorePage_l equ $ - strScorePage

    ;gameover choices
    strGameOver db "GAME OVER!",13,10
    strGameOver_l equ $ - strGameOver

    strScore_GO db "SCORE: ",13,10
    strScore_GO_l equ $ - strScore_GO

    intScore db '0' ;placeholder for score value

    strRetry db "[R] RETRY",13,10
    strRetry_l equ $ - strRetry

    strMenu db "[M] MAIN MENU",13,10
    strMenu_l equ $ - strMenu 

    strSave db "[S] SAVE SCORE",13,10
    strSave_l equ $ - strSave 

    ;mechanics
    strMechMsg db "HOW TO PLAY",13,10
    strMechMsg_l equ $ - strMechMsg

    ;invalid choice
    strInvalid db "Invalid choice!",13,10
    strInvalid_l equ $ - strInvalid

    ;player input
    charResp db ?

.code
    mov ax, 0013h ;set video mode
    int 10h

    main:
        call cls

        mov ax, 0013h ;set video mode
        int 10h

        mov ah, 0Bh   ;set bg color
        mov bx, 0002h
        int 10h

    menu_page:
        mov ax, @data
        mov es, ax
        call cls
        ;write title
        mov dh, 20 ;row
        mov dl, 12 ;coloumn
        mov bl, 0Ch ;color
        mov cx, strTitle_l
        lea bp, strTitle
        call str_out

        ;write year
        mov dh, 21
        mov dl, 13
        mov bl, 0Fh
        mov cx, strYear_l
        lea bp, strYear
        call str_out

        ;write menu choices
        mov dh, 11
        mov dl, 14
        mov bl, 0Eh 
            ;start 
        mov cx, strStart_l
        lea bp, strStart
        call str_out
            ;leaderboard
        mov dh, 13
        mov cx, strLeaderboard_l
        lea bp, strLeaderboard
        call str_out
            ;mechanics
        mov dh, 15
        mov cx, strMech_l
        lea bp, strMech
        call str_out
            ;exit
        mov dh, 17
        mov dl, 14
        mov bl, 0Eh
        mov cx, strExit_l
        lea bp, strExit
        call str_out
        ;get resp
        call resp 
        ;if s, start
        cmp al, 's'
            je mm_diff
        cmp al, 'l'
            je mm_lead
        cmp al, 'm'
            je mm_mech
        cmp al, 27
            je exit
            call InvalidMsg
            jmp menu_page
        
            mm_diff: jmp diff_page
            mm_lead: jmp lead_page
            mm_mech: jmp mech_page
    
    exit:
        mov ah, 4ch
        int 21h 

    diff_page:
        mov ax, @data
        mov es, ax
        call cls
        ;write diff prompt
        mov dh, 7 ;row
        mov dl, 10 ;coloumn
        mov bl, 0Ch ; red
        mov cx, strDiffSelec_l
        lea bp, strDiffSelec
        call str_out

        ;write diff choices
        mov dh, 10
        mov dl, 14
        mov bl, 0Eh ; yellow
            ;easy
        mov cx, strEasy_l
        lea bp, strEasy
        call str_out
            ;mod
        mov dh, 12
        mov cx, strModerate_l
        lea bp, strModerate
        call str_out
            ;hard
        mov dh, 14
        mov cx, strHard_l
        lea bp, strHard
        call str_out
            ;back
        mov dh, 17
        mov cx, strBack_l
        lea bp, strBack
        call str_out

        ;get resp
        call resp
        cmp al, '1'
            jz game_over_page
            ;set difficulty 0
        cmp al, '2'
            ;set difficulty 1
            jz game_over_page
        cmp al, '3'
            ;set difficulty 2
            jz game_over_page
        cmp al, 'b'
            je df_menu
            call InvalidMsg
            jmp diff_page

            df_menu: jmp menu_page
            
    game_over_page:
        mov ax, @data
        mov es, ax
        call cls

        ;write game over prompt
        mov dh, 7 ;row
        mov dl, 14 ;coloumn
        mov bl, 0Ch ;color
        mov cx, strGameOver_l
        lea bp, strGameOver
        call str_out

        ;write score prompt
        mov dh, 8
        mov dl, 14
        mov bl, 0Ah
        mov cx, strScore_GO_l
        lea bp, strScore_GO
        call str_out
            mov bp, strScore_GO_l

            ;place cursor beside prompt
            inc bp
            mov ah, 02h 
            add dx, bp
            int 10h
            ;write score int
            mov cx, 1
            mov al, intScore
            mov ah, 09h
            add al, '0'
            int 10h

        ;write diff choices
        mov dh, 10
        mov dl, 14
        mov bl, 0Eh ; yellow
            ;easy
        mov cx, strRetry_l
        lea bp, strRetry
        call str_out
            ;mod
        mov dh, 12
        mov cx, strMenu_l
        lea bp, strMenu
        call str_out
        ; go to score saving page
        mov dh, 14
        mov cx, strSave_l
        lea bp, strSave
        call str_out

        call resp
        cmp al, 'r'
            jz retry

        cmp al, 'm'
            je go_menu

         cmp al, 's'
            je go_save

        cmp al, 27
            je go_exit
            call InvalidMsg
            jmp game_over_page

            retry: jmp diff_page
            go_menu: jmp menu_page
            go_exit: jmp exit
            go_save: jmp score_page
        
    lead_page:
        mov ax, @data
        mov es, ax
        call cls

        ;write leaderboard prompt
        mov dh, 7 ;row
        mov dl, 14 ;coloumn
        mov bl, 0Ah ;color

        ; changed HERE
        mov cx, strLeadPage_l
        lea bp, strLeadPage
        call str_out

        ; everything changed below this line
        ; everything changed below this line
        ; everything changed below this line
            
            ; open the file
            mov ds, ax
            mov ax, 3d02h
            lea dx, score_file
            int 21h
            mov handle, ax

            ;seek to start of file
            mov ax, 4200h
            mov bx, handle
            mov cx, 0
            mov dx, 0
            int 21h

            lea si, scores
            mov ch, byte ptr [si]
            ;ch = number of records
            inc si
            mov lead_ctr, 8
            iter_scores:
                lea di, strbuf
                mov cl, 04h
                ldbuf:
                    mov dl, byte ptr [si]
                    mov byte ptr [di], dl
                    inc di
                    inc si
                    jnz ldbuf
                lea dx, ldbuf

                push dx
                push ax
                mov dh, lead_ctr ;row 
                mov dl, 14 ; column
                mov bl, 0Ah ; color  
                inc lead_ctr
                pop dx

                ; changed HERE
                push cx
                mov cx, 4 
                lea bp, strbuf ; insert string here
                call str_out
                pop cx
                pop ax

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
                    ; mov ah, 02 
                    ; int 21h
                loop printnum
                inc si
                pop cx
                dec ch
            jnz iter_scores

            ;close file
            mov ah, 3eh
            mov bx, handle
            int 21h

        ; everything changed above this line

        back_to_menu:
        mov dh, 19
        mov dl, 14
        mov bl, 0Eh ; yellow
        mov cx, strBack_l
        lea bp, strBack
        call str_out

        call resp
        cmp al, 'b'
            je lead_back
            call InvalidMsg
            jmp lead_page

            lead_back: jmp menu_page
        

    mech_page:
        ;write leaderboard prompt
        call cls
        mov dh, 7 ;row
        mov dl, 14 ;coloumn
        mov bl, 0Eh ;color
        mov cx, strMechMsg_l
        lea bp, strMechMsg
        call str_out

        jmp back_to_menu

    score_page: ; for saving scores along with username
        mov ax, @data
        mov es, ax
        call cls

        ;write save score prompt
        mov dh, 7 ;row
        mov dl, 14 ;coloumn
        mov bl, 0Ah ;color
        mov cx, strScorePage_l
        lea bp, strScorePage
        call str_out
        
        mov dl, 14
        mov bl, 0Eh ; yellow
        mov dh, 19
        mov cx, strBack_l
        lea bp, strBack
        call str_out

str_out PROC
    mov ax, 1301h   
    mov bh, 00h   ;page
    int 10h
    ret 
str_out ENDP

cls PROC
    mov ah, 07h          ; scroll down function
    mov al, 0            ; number of lines to scroll
    mov cx, 0
    mov dx, 9090
    mov bh, 00h          ; clear entire screen
    int 10h
    ret    
cls ENDP

resp PROC
    mov ah, 01h         ;get resp
    int 16h
    mov ah, 00h         ;read resp 
    int 16h
    ret
resp ENDP

lead_out PROC
    
    mov dh, 8 ;row
    mov dl, 14 ;coloumn
    mov bl, 0Eh ;color
    mov cx, strMechMsg_l
    lea bp, strMechMsg
    call str_out

    mov dh, 9 ;row
    mov dl, 14 ;coloumn
    mov bl, 0Eh ;color
    mov cx, strMechMsg_l
    lea bp, strMechMsg
    call str_out

lead_out ENDP

InvalidMsg PROC
    call cls
    mov dh, 13 ;row
    mov dl, 14 ;coloumn
    mov bl, 0Ah ;color
    mov cx, strInvalid_l
    lea bp, strInvalid
    call str_out

    call resp
    cmp al, 27
    je im_exit

    ret

    im_exit:
        mov ah, 4ch
        int 21h
InvalidMsg ENDP
end main