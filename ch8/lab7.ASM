assume cs:codesg, ds:data, ss:table

data segment
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'
    ; 以上是表示 21 年的 21 个字符串
    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
    ; 以上是表示 21 年公司总收入的 21 个 dword 型数据
    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800
    ; 以上是表示 21 年公司雇员人数的 21 个 word 型数据
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

codesg segment
start:  mov ax, data
        mov ds, ax
        mov ax, table
        mov ss, ax

      s:mov bx, 0
        mov cx, 21
        mov si, 0
        
     s1:mov ax, 4
        mul si
        mov di, ax
        mov ax, [di]
        mov ss:[bx], ax
        mov ax, [di+2]
        mov ss:[bx+2], ax
        
        ; people
        mov ax, 2
        mul si
        mov di, ax
        mov ax, [di+00a8h]
        mov ss:[bx+10], ax
        
        ; income
        mov ax, 4
        mul si
        mov di, ax
        mov ax, [di+0054h]
        mov ss:[bx+5], ax
        mov dx, [di+0054h+2]
        mov ss:[bx+7], dx
        
        ; average income
        div word ptr ss:[bx+10]
        mov ss:[bx+13], ax

        ; 空格
        mov byte ptr ss:[bx+4], 0020h
        mov byte ptr ss:[bx+9], 0020h
        mov byte ptr ss:[bx+12], 0020h        

        add bx, 10h
        inc si, 1
        loop s1

        mov ax, 4c00h
        int 21h
codesg ends
end start