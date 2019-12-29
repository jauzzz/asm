; 检测点 14.1
; (1) 读取 CMOS ROM 的 2号单元的内容
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
        in al, 71h

        mov ax, 4c00h
        int 21h
        
codesg ends
end start