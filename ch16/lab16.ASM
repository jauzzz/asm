; 安装一个新的 int 7ch 中断例程，为显示输出提供如下功能子程序：
;   (1) 清屏
;   (2) 设置前景色
;   (3) 设置背景色
;   (4) 向上滚动一行
;
; 入口参数说明:
;   ah 传递功能号：0表示清屏，1表示设置前景色，2表示设置背景色，3表示向上滚动一行
;   对于2、3号功能，al传送颜色值, al 属于 {0,1,2,3,4,5,6,7}
;

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
datasg ends

stacksg segment
stacksg ends

codesg segment
start:      ; 先安装 rep movsb
            ; 设置源地址、目标地址
            mov ax, cs
            mov ds, ax
            mov si, offset int7ch

            mov ax, 0
            mov es, ax
            mov di, 200h

            ; 长度
            mov cx, offset int7chend-offset int7ch
            cld
            rep movsb

            ; 设置中断向量表
            cli
            mov word ptr es:[7ch*4], 200h
            mov word ptr es:[7ch*4+2], 0
            sti

            mov ax, 4c00h
            int 21h

int7ch:         jmp main
                table dw offset sub1-offset int7ch + 200h, offset sub2-offset int7ch + 200h, offset sub3-offset int7ch + 200h, offset sub4-offset int7ch + 200h
main:           push bx
                cmp ah, 3
                ja int7chret
                mov bl, ah
                mov bh, 0
                add bx, bx
                call word ptr cs:(table - int7ch + 200h)[bx]
int7chret:      pop bx
                iret

sub1:           push bx
                push cx
                push es
                mov bx, 0b800h
                mov es, bx
                mov bx, 0
                mov cx, 2000
sub1s:          mov byte ptr es:[bx], ' '
                add bx, 2
                loop sub1s
                pop es
                pop cx
                pop bx
                ret

sub2:           push bx
                push cx
                push es

                mov bx, 0b800h
                mov es, bx
                mov bx, 1
                mov cx, 2000
sub2s:          and byte ptr es:[bx], 11111000B
                or es:[bx], al
                add bx, 2
                loop sub2s

                pop es
                pop cx
                pop bx
                ret

sub3:           push bx
                push cx
                push es
                mov cl, 4
                shl al, cl
                mov bx, 0b800h
                mov es, bx
                mov bx, 1
                mov cx, 2000
sub3s:          and byte ptr es:[bx], 10001111B
                or es:[bx], al
                add bx, 2
                loop sub3s
                pop es
                pop cx
                pop bx
                ret

sub4:           push cx
                push si
                push di
                push es
                push ds

                mov si, 0b800h
                mov es, si
                mov ds, si
                mov si, 160
                mov di, 0
                cld
                mov cx, 24
sub4s:          push cx
                mov cx, 160
                rep movsb
                pop cx
                loop sub4s

                mov cx, 80
                mov si, 0
sub4s1:         mov byte ptr [160*24+si], ' '
                add si, 2
                loop sub4s1

                pop ds
                pop es
                pop di
                pop si
                pop cx
                ret

int7chend:      nop  

codesg ends
end start