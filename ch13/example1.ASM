assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:  mov ax, 0b800h
        mov es, ax
        mov byte ptr es:[12*160+40*2], '!'
        int 0

        mov ax, 4c00h
        int 21h
        
codesg ends
end start