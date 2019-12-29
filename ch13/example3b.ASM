assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:  mov ax, cs
        mov ds, ax
        mov si, offset lp  ; 设置 ds:si 指向源地址

        mov ax, 0
        mov es, ax
        mov di, 200h        ; 设置 es:di 指向目的地址
        
        mov cx, offset lpend-offset lp
        cld                 ; 设置传输方向为 正向
        rep movsb

        ; 设置中断向量表
        mov ax, 0
        mov es, ax
        mov word ptr es:[7ch*4], 200h
        mov word ptr es:[7ch*4+2], 0

        mov ax, 0b800h
        mov es, ax
        mov di, 160*12
        mov bx, offset s-offset se
        mov cx, 80
s:      mov byte ptr es:[di], '!'
        mov byte ptr es:[di+1], 10000010B
        add di, 2
        int 7ch
se:     nop
        mov ax, 4c00h
        int 21h

; works like jmp near ptr s
lp:     push bp
        mov bp, sp
        add [bp+2], bx
        pop bp
        iret
lpend:  nop

codesg ends
end start