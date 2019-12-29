;实验名称：解决除法溢出的问题
;
;应用举例：计算 1000000/10(F424H/01H)
;结果 (dx)=001H, (ax)= 86A0H, (cx)=0
assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

;声明8个字的连续内存空间用做栈
stacksg segment
    dw 8 dup (0)
stacksg ends

codesg segment
start:  mov ax, stacksg
        mov ss, ax
        mov sp, 16

        mov dx, 000fh
        mov ax, 4240h        
        mov cx, 0ah
        call divdw

        mov ax, 4c00h
        int 21h


;=====================不会发生溢出的16位除法运算==================
;子程序描述
;名称：divdw
;功能：进行不会产生溢出的除法运算，被除数为双字（dword）型，
;	  除数为单字（word）型，商为双字型，余数为单字型。
;参数：  （dx） = 被除数的高16位
;		（ax） = 被除数的低16位
;		（cx） = 除数
;返回：	 （dx） = 商的高16位，
;		（ax） = 商的低16位
;		（cx） = 余数
;公式：X/N = int(H/N)*65536 + [rem(H/N)*65536 + L]/N。

divdw:  push bx

        ; H/N
        ; 除数为16位，被除数为32位，在 dx 和 ax 中存放，dx 存放高16位，ax 存放低16位
        mov bx, ax  ; bx stores L
        mov ax, dx
        mov dx, 0
        div cx
        
        ; ax 商, dx 余数
        ; int(H/N) = ax, rem(H/N) = dx
        push ax

        mov ax, bx
        div cx      ;(dx) = rem(H/N),(ax) = L, (cx) = N
        mov cx, dx  ;(dx) = rem{[rem(H/N)*65536 + L]/N}, (ax) = int{[rem(H/N)*65536 + L]/N}
        pop dx

        pop bx
        ret

codesg ends
end start