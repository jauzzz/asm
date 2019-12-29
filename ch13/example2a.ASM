assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment

start:      mov ax, cs
            mov ds, ax
            mov si, offset sqr  ; 设置 ds:si 指向源地址

            mov ax, 0
            mov es, ax
            mov di, 200h        ; 设置 es:di 指向目的地址

            ; 如何计算 sqr 部分代码的长度
            ; 可以利用编译器
            mov cx, offset sqrend-offset sqr
            cld                 ; 设置传输方向为 正向
            rep movsb

            ; 设置中断向量表
            mov ax, 0
            mov es, ax
            mov word ptr es:[7ch*4], 200h
            mov word ptr es:[7ch*4+2], 0

            mov ax, 3456
            int 7ch
            add ax, ax
            adc dx, dx
            mov ax, 4c00h
            int 21h

sqr:        mul ax
            iret
sqrend:     nop

codesg ends
end start