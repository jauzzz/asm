; mac dosbox 不知道怎么搞软盘
;
; 安装一个新的 int7ch 中断例程，实现通过逻辑扇区号对软盘进行读写
; 参数说明
;   ah: 传递功能号，0表示读，1表示写
;   bx: 要读写的逻辑扇区号
;   es:bx: 指向存储读出数据或写入数据的内存区
;

assume cs:code

code segment
start:  mov ax, cs
        mov ds, ax
        mov si, offset floppyio
        mov ax, 0
        mov es, ax
        mov di, 200h
        mov cx, offset floppyioend - offset floppyio
        cld
        rep movsb

        mov ax, 0
        mov es, ax
        mov word ptr es:[7ch * 4], 200h
        mov word ptr es:[7ch * 4 + 2], 0
        mov ax, 4c00h
        int 21h

floppyio:   push ax
            push cx
            push dx

            add ah, 2
            mov al, 1
            push ax         ; 计算 ah和al并压栈
            mov ax, dx
            mov dx, 0
            mov cx, 1440
            div cx          ; 计算逻辑扇区号/1440
            push ax         ; 将商即面号压栈
            mov ax, dx
            mov dl, 18
            div dl          ; 计算逻辑扇区号/1440的余数/18
            inc ah
            mov ch, al
            mov cl, ah      ; 设置相应的ch和cl
            pop ax          ; 将相应的面号出栈
            mov dh, al
            mov dl, 0       ; 设置相应的dh和dl
            pop ax          ; 将相应的ah和al出栈
            int 13h         ; 调用13h例程进行实际的读写

            pop dx
            pop cx
            pop ax
            iret
floppyioend:nop

code ends
end start