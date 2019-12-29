assume cs:codesg
codesg segment

    mov ax, 0020h
    mov ds, ax
    mov ax, 0
    mov bx, 0    
    mov cx, 64

s:  mov ds:[bx], ax
    inc ax
    inc bx
    loop s

    mov ax, 4c00H
    int 21h
codesg ends
end
