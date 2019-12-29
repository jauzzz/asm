; 应用举例
; 编程，将数据 1266 以十进制的形式在屏幕的8行3列，用绿色显示出来
assume cs:codesg, ds:datasg, ss:stacksg

stacksg segment
    dw 16 dup (0)
stacksg ends

datasg segment
    db 10 dup (0)
datasg ends

codesg segment
start:  mov ax, stacksg
        mov ss, ax
        mov sp, 32
        mov bx, datasg
        mov ds, bx
        
        mov ax, 12666
        mov si, 0
        call dtoc

        mov dh, 8
        mov dl, 3
        mov cl, 2
        call show_str

        mov ax, 4c00h
        int 21h

; ======= 子程序描述 ======
; 名称: dtoc
; 功能: 将 word 型数据转换为表示十进制数的字符串，字符串以 0 为结尾符
; 参数:
;   (ax) = word 型数据
;   ds:si 指向字符串的首地址
; 返回: 无
dtoc:       push bx
            push cx
            push dx
            push si
            push di
            
            mov bx, 10
            
            ; 除10、取余、加30h、下一个循环
cal:        mov dx, 0
            mov cx, ax
            jcxz stop

            ; 被除数为 ax, ax为16位，但使用32位除法, 否则会溢出
            ; ax = 商，dx = 余            
            div bx            
            add dx, 30h
            push dx
            inc di

            jmp cal

stop:      ; 循环次数
            mov cx, di

write:      pop dx
            mov ds:[si], dl
            inc si

            loop write

            pop di
            pop si
            pop dx
            pop cx
            pop bx
            ret

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