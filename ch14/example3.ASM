; 检测点 14.2
; 用加法和移位指令计算 (ax) = (ax) * 10
; 提示: (ax) * 10 = (ax) * 2 + (ax) * 8

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:  shl ax, cl
        mov bx, ax
        mov cl, 2
        shl bx, cl
        add ax, bx

        mov ax, 4c00h
        int 21h
        
codesg ends
end start