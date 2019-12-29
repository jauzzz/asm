; 将数据在屏幕上显示出来

assume cs:codesg, ss:stacksg

year segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'         ;年份
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
year ends

income segment
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514         ;收入
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
income ends

people segment
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226      ;人数
	dw 11542,14430,15257,17800
people ends

average segment
	dw 32 dup (0)
average ends

temp segment
	dd 32 dup (0)
temp ends

stacksg segment
	dw 32 dup (0)
stacksg ends

codesg segment

start:		  	; 计算平均收入: 收入 / 人数
				call cal_average

				; 显示
				; 一共有 21 年
				; 从 第 3 行开始显示，一行显示一年的数据
				; 四个字段，分别在 0 20 40 60 列开始显示
				
				; B8000h ~ Bffffh (80 * 25)
				; dh * 160 + dl
				call show_year
				call show_income
				call show_people
				call show_average

				; end
				mov ax, 4c00h
				int 21h

cal_average:	; 如果除数为 16 位，被除数则为 32 位
				; 被除数: 在 dx 和 ax 中存放，dx 存放高16位，ax 存放低16位
				; 结果: ax 存储除法操作的商，dx 存储除法操作的余数
				push ax
				push ds
				push es
				push bx
				push si
				push cx

				mov ax, income
				mov ds, ax
				mov ax, people
				mov es, ax

				mov bx, 0				
				mov si, 0
				mov cx, 21

cal:			mov ax, ds:[bx]
				mov dx, ds:[bx+2]
				div word ptr es:[si]
				mov es:[si], ax
				add bx, 4
				add si, 2
				loop cal

				pop cx
				pop si
				pop bx
				pop es
				pop ds
				pop ax
				ret

show_year:		mov ax, year
				mov ds, ax

				mov ax, 0b800h
				mov es, ax

				mov bx, 490
				mov si, 0
				mov cx, 21

year_str:		mov ah, 10000010B
				mov al, [si]
				mov es:[bx], ax
				mov al, [si+1]
				mov es:[bx+2], ax
				mov al, [si+2]
				mov es:[bx+4], ax
				mov al, [si+3]
				mov es:[bx+6], ax

				add bx, 160
				add si, 4
				loop year_str

				ret

; ---------
; 懒得做了

show_income:	ret

show_people:	ret

show_average:	ret

codesg ends
end start