assume cs:codesg, ds:datasg

; 80 * 25
; 标号 0 ~ 24
; 三个字符串: 11 12 13
; 640h~6dfh 6e0h~77fh 780h~820h

; 16个字节长度，左右空 16 字节
; 加上颜色，就是32字节，左右偏移 64
; 1664  1824   1984
datasg segment
    db 'welcome to masm!'
datasg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax
        mov ax, 0b800h
        mov es, ax
        
        mov bx, 1664
        mov si, 0
        mov cx, 16
  char1:mov al, [si]
        mov ah, 10000010B
        mov es:[bx], ax
        add bx, 2
        inc si
        loop char1

        mov bx, 1824
        mov si, 0
        mov cx, 16
  char2:mov al, [si]
        mov ah, 10100100B
        mov es:[bx], ax
        add bx, 2
        inc si
        loop char2

        mov bx, 1984
        mov si, 0
        mov cx, 16
  char3:mov al, [si]
        mov ah, 11110001B
        mov es:[bx], ax
        add bx, 2
        inc si
        loop char3

        mov ax, 4c00h
        int 21h
codesg ends
end start