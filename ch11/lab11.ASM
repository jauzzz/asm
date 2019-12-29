; 名称: letterc
; 功能: 将以 0 结尾的字符串中的小写字母转变成大写字母

assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
    db "Beginer's All-purpose Symbolic Instruction Code.", 0
datasg ends

stacksg segment
stacksg ends

codesg segment
start:      mov ax, datasg
            mov ds, ax
            mov si, 0
            call letterc

            mov ax, 4c00h
            int 21h

letterc:    mov cx, [si]
            jcxz ok

            mov al, [si]
            cmp al, 97
            jb next
            cmp al, 122
            ja next

            sub al, 32
            mov [si], al

next:       inc si
            jmp letterc

ok:         ret

codesg ends
end start