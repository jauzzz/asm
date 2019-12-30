; 程序功能描述:
;   在屏幕中间依次显示 'a' ~ 'z', 并可以让人看清
;   在显示的过程中，按下 ESC 键后，改变显示的颜色
;
;
; 过程描述:
;   (1) 从 60h 端口读出键盘的输入
;   (2) 调用 BIOS 的 int 9 中断例程，处理其他硬件细节
;   (3) 判断是否为 ESC 的扫描码，如果是，改变显示的颜色后返回，如果不是直接返回

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
    dw 0, 0
datasg ends

stacksg segment
    db 128 dup (0)
stacksg ends

codesg segment
start:  mov ax, stacksg
        mov ss, ax
        mov sp, 128

        mov ax, datasg
        mov ds, ax

        mov ax, 0
        mov es, ax

        ; 需要走自定义的 int9 例程，最后调用 BIOS 的 int9 例程
        ;   1. 需要先安装自定义的 int9
        ;   2. 修改中断向量表
        ;   3. 调用 BIOS

        ; 将原来的 int 9 例程的入口地址保存在 ds:0, ds:2 单元中
        push es:[9*4]
        pop ds:[0]
        push es:[9*4+2]
        pop ds:[2]

        cli
        ; 设置新的中断向量入口
        mov word ptr es:[9*4], offset int9
        mov es:[9*4+2], cs
        sti
        
        mov ax, 0b800h
        mov es, ax
        mov ah, 'a'

; 显示 a ~ z
s:      mov es:[160*12+40*2], ah
        call delay
        inc ah
        cmp ah, 'z'
        jna s
        mov ax, 0
        mov es, ax

        ; 将中断向量表 int 9 中断例程的入口恢复为原来的地址
        push ds:[0]
        pop es:[9*4]
        push ds:[2]
        pop es:[9*4+2]
                
        mov ax, 4c00h
        int 21h

; 显示字符串之后空置一段时间，否则看不清字符串的切换
delay:  push ax
        push dx
        mov dx, 10h
        mov ax, 0
s1:     sub ax, 1
        sbb dx, 0
        cmp ax, 0
        jne s1
        cmp dx, 0
        jne s1
        pop dx
        pop ax
        ret
        
int9:   push ax
        push bx
        push es
        in al, 60h

        pushf        
        ; 对 int 指令进行模拟，调用原来的 int9 中断例程
        call dword ptr ds:[0]
        cmp al, 1
        jne int9ret
        mov ax, 0b800h
        mov es, ax
        ; 属性值加1，改变颜色
        inc byte ptr es:[160*12+40*2+1]

int9ret:pop es
        pop bx
        pop ax
        iret

codesg ends
end start