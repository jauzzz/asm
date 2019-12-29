; 在屏幕的 8 行 3 列，用绿色显示 data 段中的字符串

assume cs:codesg, ds:datasg

datasg segment
    db 'Welcome to masm!', 0
datasg ends

codesg segment

; dh 行号
; dl 列号
; cl 颜色，ds:si 指向字符串的首位置
start:  mov dh, 8
        mov dl, 3
        mov cl, 2
        mov ax, datasg
        mov ds, ax
        mov si, 0
        call show_str

        mov ax, 4c00h
        int 21h

; 计算位置
; B8000h ~ Bffffh (80 * 25)
; dh * 160 + dl

show_str:   push ax
            push bx
            push cx
            push es
            push si
            push di

            mov ax, 0b800h
            mov es, ax
            mov bx, 0
            mov di, 0

            mov ah, 0
            mov al, 160
            mul dh
            add bx, ax
            mov al, 2
            mul dl
            add bx, ax

show_char:  mov ch, 0
            mov cl, ds:[si]
            jcxz zero
            
            mov ch, 10000010B
            mov es:[bx+di], cx
            add di, 2
            inc si
            jmp show_char

zero:       pop di
            pop si
            pop es
            pop cx
            pop bx
            pop ax
            ret

codesg ends
end start