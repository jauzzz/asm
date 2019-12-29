assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
    db 'welcome to masm', 0
datasg ends

stacksg segment
stacksg ends

codesg segment

start:      mov ax, cs
            mov ds, ax
            mov si, offset show  ; 设置 ds:si 指向源地址

            mov ax, 0
            mov es, ax
            mov di, 200h        ; 设置 es:di 指向目的地址

            ; 如何计算 show 部分代码的长度
            ; 可以利用编译器
            mov cx, offset showend-offset show
            cld                 ; 设置传输方向为 正向
            rep movsb

            ; 设置中断向量表
            mov ax, 0
            mov es, ax
            mov word ptr es:[7ch*4], 200h
            mov word ptr es:[7ch*4+2], 0

            mov dh, 10      ;行
            mov dl, 10      ;列
            mov cl, 2       ;颜色
            mov ax, datasg
            mov ds, ax
            mov si, 0       ;ds:si 指向字符串首地址
            int 7ch

            mov ax, 4c00h
            int 21h

show:       push ax
            push es
            push bx
            push cx
            push dx

            ; 计算 bx
            mov ax, 0b800h
            mov es, ax

            mov ah, 0
            mov al, 160            
            mul dh
            
            mov bx, ax
            add bl, dl
            adc bh, 0
            
show_str:   mov ch, 0
            mov cl, ds:[si]
            jcxz zero
            
            mov ch, 10000010B
            mov es:[bx+di], cx
            add di, 2
            inc si
            jmp show_str

zero:       pop dx
            pop cx
            pop bx
            pop es
            pop ax
            iret
showend:    nop

codesg ends
end start