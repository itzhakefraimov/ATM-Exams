; 03.08.2017 - Moed B - Question 1
.model small
.data
	rem DW ?
	ten DW 10
.code
; extern unsigned int modulo(char str[], int n, unsigned int denom);
;		              [BP+4]	  [BP+6]   [BP+8]
public _modulo
_modulo proc near
	push bp
	mov bp,sp
	push di
	
	mov di,[bp+4] ; di = str[]
	mov cx,[bp+6] ; cx = n
	
	jcxz end ; if(n == 0) before first element calc
	
	; rem = x[0] - '0'
	mov al,[bx]
	sub al,'0'
	xor ah,ah
	mov rem,ax
  ; i++ so we start from n = 1
	inc di
	dec cx
	
	jcxz end ; if(n == 0) after first element calc & before loop
	
	l1:
	mov ax,rem
	mul ten ; (10 * rem)
	mov rem,ax
	mov al,[di]
	sub al,'0' ; x[i] - '0'
	xor ah,ah
	add ax,rem
	div word ptr [BP+8]
	mov rem,dx ; (10 * rem + (x[i] - '0') % denom
	inc di ; x[i++]
	loop l1
	
	end:
	mov ax,rem
	
	pop di
	pop bp
	ret
_modulo endp
end
