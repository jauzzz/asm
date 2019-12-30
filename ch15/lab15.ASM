; 安装一个新的 int9 中断例程
; 功能: 在 dos 下，按下 “A” 键后，除非不再松开，如果松开就显示满屏幕的 “A”； 其他的键照常处理

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
    db 128 dup (0)
stacksg ends

codesg segment
start:  mov ax, stacksg
        mov ss, ax
        mov sp, 128

        push cs
        pop ds

        mov ax, 0
        mov es, ax

        mov si, offset int9
        mov di, 204h
        mov cx, offset int9end - offset int9
        cld
        rep movsb

        push es:[9*4]
        pop es:[200h]
        push es:[9*4+2]
        pop es:[202h]
        
        cli
        mov word ptr es:[9*4], 204h
        mov word ptr es:[9*4+2], 0
        sti

        mov ax, 4c00h
        int 21h

; custom int9
int9:   push ax
        push bx
        push cx
        push es

        in al, 60h
        pushf
        call dword ptr cs:[200h]
        cmp al, 1eh
        jne int9ret
        
watch:  in al, 60h
        cmp al, 9eh
        jne watch

        mov ax, 0b800h
        mov es, ax
        mov bx, 0
        mov cx, 2000
s:      mov byte ptr es:[bx], 'A'
        add bx, 2
        loop s
        
int9ret:pop es
        pop cx
        pop bx
        pop ax
        iret
int9end:nop
        
codesg ends
end start