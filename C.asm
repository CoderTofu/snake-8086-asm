;Accepts name & center it on the screen

.model small
.stack
.data
namepar label byte		; name parameter list
maxnlen db 20			; maximum length of name
namelen db ? 			; no. of characters entered
namefld db 20 dup(' '), '$'	; name & delimiter for displaying
prompt db 'Enter your Name $'

.code
begin proc near
	mov ax, @data
	mov ds, ax
	mov es, ax

	call cls

next: 
	mov dx, 0000
	call setcur			; set the cursor
	call displayprompt	; displays the prompt var
	call inputname		; user can now input
	call cls			; cls
	cmp namelen, 00
	je terminate
	call bell_$
	call cls
	call displayname
	jmp next

terminate: 
	mov ah, 4ch
	int 21h

begin endp

cls proc near
	mov ax, 0600h
	mov bh, 30
	mov cx, 0000
	mov dx, 184fh
	int 10h
	ret
cls endp

setcur proc near
	mov ah, 02
	mov bh, 00
	int 10h
	ret
setcur endp 

displayprompt proc near
	mov ah, 09
	lea dx, prompt
	int 21h
	ret
displayprompt endp

inputname proc near
	mov ah, 0Ah
	lea dx, namepar
	int 21h
	ret
inputname endp

bell_$ proc near
	mov bh, 00
	mov bl, namelen
	mov namefld[bx], 07
	mov namefld[bx+1], '$'
	ret
bell_$ endp

displayname proc near
	mov dl, namelen
	shr dl, 1
	neg dl
	add dl, 40
	mov dh, 12
	call setcur

	mov ah, 09
	lea dx, namefld
	int 21h 

	mov ah, 08
	int 21h
	ret
displayname endp

End
