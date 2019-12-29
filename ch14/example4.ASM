; 14.4 CMOS ROM 中存储的时间信息

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:  mov al, 8
        out 70h, al
        in al, 71h

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111b

        add ah, 30h
        add al, 30h

        mov bx, 0b800h
        mov es, bx
        mov byte ptr es:[160*12+40*2], ah
        mov byte ptr es:[160*12+40*2+2], al        

        mov ax, 4c00h
        int 21h
        
codesg ends
end start