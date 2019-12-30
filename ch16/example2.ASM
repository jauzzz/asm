; 检测点 16.2
; 下面的程序将 data 段中 a 处的 8 个数据累加，结果存储到 b 处的字中

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
    a db 1,2,3,4,5,6,7,8
    b dw 0
datasg ends

stacksg segment
stacksg ends

codesg segment
start:  mov si, 0
        mov cx, 8

s:      mov ax, data
        mov ds, ax
        
        mov al, a[si]
        mov ah, 0
        add b, ax
        inc si
        loop s

        mov ax, 4c00h
        int 21h
        
codesg ends
end start