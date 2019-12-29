assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
    db 'conversation', 0
datasg ends

stacksg segment
stacksg ends

codesg segment

start:      mov ax, cs
            mov ds, ax
            mov si, offset capital  ; 设置 ds:si 指向源地址

            mov ax, 0
            mov es, ax
            mov di, 200h        ; 设置 es:di 指向目的地址

            ; 如何计算 capital 部分代码的长度
            ; 可以利用编译器
            mov cx, offset capitalend-offset capital
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

capital:        push cx
                push si
change:         mov cl, [si]
                mov ch, 0
                jcxz ok
                and byte ptr [si], 11011111b
                inc si
                jmp short change
ok:             pop si
                pop cx
                iret
capitalend:     nop

codesg ends
end start