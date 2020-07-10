; 03.08.2017 - Moed B - Question 2/A
.model small ; large
.code
.386
; extern int compare_arrs(long int arr1[], long int arr2[], int m);
; model small			[BP+4]	      [BP+6]   	     [BP+8]
; model large			[BP+6][BP+8]  [BP+10][BP+12] [BP+14]
public _compare_arrs
_compare_arrs proc near ; far
	push bp
	mov bp,sp
	push di
	push si
	; push es
	; push fs
	
	mov di,[bp+4] ; di = arr1[]
	mov si,[bp+6] ; si = arr2[]
	mov cx,[bp+8] ; cx = m
	; mov di,[bp+6]
	; mov es,[bp+8]
	; mov si,[bp+10]
	; mov fs,[bp+12]
	; mov cx,[bp+14]
	
	jcxz end ; if(m == 0) => end
	
	l1:
	mov eax,[di] ; mov eax,es:[di]
	cmp eax,[si] ; cmp eax, fs:[si]
	jg greater ; arr1 > arr2
	jl smaller ; arr1 < arr2
	; arrs element qual => next element
	add di,4
	add si,4
	loop l1
	
	; arrs are qual => return 0
	xor ax,ax
	jmp end
	
	; arr1 > arr2 => return 1
	greater:
	mov ax,1
	jmp end
	
	; arr1 < arr2 => return -1
	smaller:
	mov ax,1
	neg ax
	jmp end
	
	end:
	; pop fs
	; pop es
	pop si
	pop di
	pop bp
	ret
_compare_arrs endp
end
