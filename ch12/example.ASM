assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:  mov ax, 1000h
        mov bh, 1
        div bh

        mov ax, 4c00h
        int 21h
        
codesg ends
end start