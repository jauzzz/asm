; 编程：以 "年/月/日 时:分:秒" 的格式，显示当前的日期、时间

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:      mov bx, 0b800h
            mov es, bx
            mov dh, 12
            mov dl, 40
            mov si, 0

            ; 计算 bx
            mov ah, 0
            mov al, 160
            mul dh
            mov bx, ax
            mov al, 2
            mul dl
            add bx, ax

            ; year
            mov al, 9
            call display
            mov byte ptr es:[bx+si],'/'
            add si, 2

            ; month
            mov al, 8
            call display
            mov byte ptr es:[bx+si],'/'
            add si, 2

            ; day
            mov al, 7
            call display
            mov byte ptr es:[bx+si],' '
            add si, 2

            ; hour
            mov al, 4
            call display
            mov byte ptr es:[bx+si],':'
            add si, 2

            ; minute
            mov al, 2
            call display
            mov byte ptr es:[bx+si],':'
            add si, 2

            ; hour
            mov al, 0
            call display

            mov ax, 4c00h
            int 21h

; read information from CMOS ROM
; input: al
; output: al
display:    push ax
            push cx

            out 70h, al
            in al, 71h
            
            mov ah, al
            mov cl, 4
            shr ah, cl
            and al, 00001111b
            
            add ah, 30h
            add al, 30h
            mov byte ptr es:[bx+si], ah
            mov byte ptr es:[bx+si+2], al
            
            add si, 4
            ; add bx, 160
            
            pop cx
            pop ax
            ret

codesg ends
end start