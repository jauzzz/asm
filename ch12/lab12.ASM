assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment

start:      mov ax, cs
            mov ds, ax
            mov si, offset do0  ; 设置 ds:si 指向源地址

            mov ax, 0
            mov es, ax
            mov di, 200h        ; 设置 es:di 指向目的地址

            ; 如何计算 do0 部分代码的长度
            ; 可以利用编译器
            mov cx, offset do0end-offset do0
            cld                 ; 设置传输方向为 正向
            rep movsb

            ; 设置中断向量表
            mov ax, 0
            mov es, ax
            mov word ptr es:[0*4], 200h
            mov word ptr es:[0*4+2], 0

            mov ax, 4c00h
            int 21h

do0:        ; 显示字符串 "overflow"
            ; 设置 ds:si 指向字符串
            ; 不能用 data 存储 字符串，否则程序返回时，data段已变换
            jmp short do0start
            db "divide error!"

do0start:   mov ax, cs
            mov ds, ax
            mov si, 202h                ; 设置 ds:si 指向字符串

            mov ax, 0b800h
            mov es, ax
            mov di, 12*160+36*2         ; 显存的中间位置

            mov cx, 13                  ; cx 为字符串长度
s:          mov al, [si]
            mov ah, 10000010B
            mov es:[di], ax            
            inc si
            add di, 2
            loop s

            mov ax, 4c00h
            int 21h
do0end:     nop

codesg ends
end start