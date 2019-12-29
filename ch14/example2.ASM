; 检测点 14.1
; (2) 向 CMOS ROM 的 2号单元的写入 0
assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:  ; 数据存放地址：访问 8 位端口用 al, 访问 16 位端口用 ax
        ; 端口地址信息存放：dx
        mov al, 2
        out 70h, al
        mov al, 0
        out 71h, al

        mov ax, 4c00h
        int 21h
        
codesg ends
end start