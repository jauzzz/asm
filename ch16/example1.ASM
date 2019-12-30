; 检测点 16.1
; 下面的程序将 code 段中的 a 处的 8 个数据累加，结果存储在 b 处的 dword 处

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
    a dw 1,2,3,4,5,6,7,8
    b dd 0

start:  mov si, 0
        mov cx, 8

s:      mov ax, a[si]
        add word ptr b[0], ax
        adc word ptr b[2], 0
        add si, 2
        loop s

        mov ax, 4c00h
        int 21h
        
codesg ends
end start