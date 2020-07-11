; 03.08.2017 - Moed B - Question 3
.model small
.data
	x1 DQ ?
	x2 DQ ?
	mid DQ ?
	two DW 2
.code
.386
.387
; extern double compute_approx(double (*f)(double), double (*fd)(double), double x0, double x);
;				[BP+4]                 [BP+6]             [BP+8]    [BP+16]
public _compute_approx
_compute_approx proc near
	push bp
	mov bp,sp
	
	push qword ptr [bp+8] ; push x0
	call word ptr [bp+4] ; call f
	fld qword ptr [bp+16] ; st0 = x, st1 = f(x0)
	fsub qword ptr [bp+8] ; st0 = x - x0, st1 = f(x0)
	
	call word ptr [bp+6] ; call fd
	add sp,8
	fmul ; st0 = fd(x0) * (x - x0), st1 = f(x0)
	fadd ; st0 = fd(x0) * (x - x0) + f(x0)
	
	pop bp
	ret
_compute_approx endp
; extern double approx_range( double (*f)(double), double (*fd)(double), double x0, double epsilon1, double epsilon2);
;                               [BP+4]                  [BP+6]             [BP+8]        [BP+16]         [BP+24]
public _approx_range
_approx_range proc near
	push bp
	mov bp,sp

	fldz
	fstp mid ; mid = 0.0
	
	fld qword ptr [bp+8] ; st0 = x0
	fst x1 ; x1 = x0
	fabs ; st0 = |x0|
	fimul dword ptr two ; st0 = 2 * |x0|
	fld1 ; st0 = 1, s1 = 2 * |x0|
	fadd ; st0 = 2 * |x0| + 1
	fld qword ptr [bp+8] ; st0 = x0, st1 = 2 * |x0| + 1
	fadd ; st0 = x0 + 2 * |x0| + 1
	fstp x2 ; x2 = x0 + 2 * |x0| + 1
		
	l1:
	fld qword ptr x2 ; st0 = x2
	fsub qword ptr x1 ; st0 = x2 - x1	
	fcomp qword ptr [bp+24] ; x2 - x1 > epsilon2 ?
	fstsw ax
	sahf
	jbe end
	
	; mid = (x1 + x2) / 2
	fld qword ptr x1 ; st0 = x1
	fadd qword ptr x2 ; st0 = x1 + x2
	fidiv dword ptr two ; st0 = (x1 + x2) / 2
	fstp mid
	
	push qword ptr mid ; push mid
	call [bp+4] ; call f
	
	push qword ptr [bp+8] ; push x0
	push word ptr [bp+6] ; push fd
	push word ptr [bp+4] ; push f
	call _compute_approx
	add sp,20 ; free parameters, st0 = compute_approx(), st1 = f(mid)
	fsub ; f(mid) - compute_approx()
	fabs ; |f(mid - compute_approx()|
	fcomp qword ptr [bp+16] ; |f(mid| - compute_approx()| > epsilon1 ?
	fstsw ax
	sahf
	fld qword ptr mid
	jbe update_x1
	
	fstp x2 ; x2 = mid
	jmp next
	
	update_x1:
	fstp x1 ; x1 = mid
	
	next:
	jmp l1
	
	end:
	fld qword ptr mid ; return mid
	pop bp
	ret
_approx_range endp
end
