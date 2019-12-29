assume cs:codesg
codesg segment
    mov ax, cs
    mov ds, ax
    mov ax, 0020h
    mov es, ax
    mov bx, 0
    mov cx, 17h

s:  mov al, [bx]
    mov es:[bx], al
    inc bx
    loop s

    mov ax, 4c00H
    int 21h
codesg ends
end
