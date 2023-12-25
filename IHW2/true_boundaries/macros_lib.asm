.data
	new_line: .asciz "\n"
	sep:    .asciz  "--------\n"    # разделитель (с \n и нулём в конце)
	changing_boundaries: .asciz "changing coundaries.."
	changed_boundaries: .asciz "boundaies are changed"
	new_circle: .asciz "new circle\n"
	end_w: .asciz "end"
	abs_w: .asciz "abs"
	bigger_zero_w: .asciz "bigger_zero"
	less_zero_w: .asciz "less_zero"
	return_1_w: .asciz "return_1"
	loop_pow: .asciz "new pow"
	f_w: .asciz "f working"
.text

#print int
.macro print_int(%x)
	mv a0, %x
	li a7, 1
	ecall
	.end_macro

#print string	
.macro print_string(%x)
	la a0, %x
	li a7, 4
	ecall
	.end_macro

#print double	
.macro print_double(%x)
	fmv.d fa0, %x
	li a7, 3
	ecall
	.end_macro

# input int	
.macro input_int(%x)
	li a7, 5
	ecall
	mv %x, a0
	.end_macro
	
# input double
.macro input_double(%x)
	li a7, 7
	ecall
	fmv.d %x, fa0
	.end_macro
	
#\n string input
.macro new_line()
	la a0, new_line
	li a7, 4
	ecall
	.end_macro

# calculate value of equasion when x=%x
# %x - value for replacing x, %result - result of equasion	
.macro f(%x, %result) #ft6-11, t1
	# 2^(x^2+1)+x-3
	.text
		#ft6 - for counting help = 1
		#ft7 - for counting help = 2
		#ft8 - for countings help
		#ft9 - for x
		#ft10 - for countings osnova
		#ft11 - for countings help
		#t5 - counter pows of 2
		#t6 - final counter
		li t1, 0
		fcvt.d.w  ft6, t1
		fcvt.d.w  ft7, t1
		fcvt.d.w  ft8, t1
		fcvt.d.w  ft9, t1
		fcvt.d.w  ft10, t1
		fcvt.d.w  ft11, t1
		
		li t1, 1
		fcvt.d.w  ft11, t1	#ft11 = 1
		fmul.d ft9, %x, ft11 	#ft9 = x
		fmul.d ft10, ft9, ft9 	#ft10 = x^2
		fadd.d ft10, ft10, ft11	#ft10 = x^2+1
		fcvt.d.w  ft8, t1	#ft8 = 1
		fcvt.d.w  ft6, t1	#ft6 = 1
		li t1, 0
		fcvt.d.w  ft11, t1	#ft11 = 0
		li t1, 2
		fcvt.d.w  ft7, t1	#ft7 = 2
		fcvt.w.d t6, ft10	#t6=ft10
		add t6, t6, zero
		li t5, 0
		
		loop_pow_2: 	
			#ft11 - counter pows of 2
			#ft8 - counter of value
			#ft7 - 2
			#ft6 - 1
			#t1 - stop flag
			fmul.d ft8, ft8, ft7 	#value^2
			addi t5, t5, 1	#counter++
			bgt t6, t5, loop_pow_2

		return:
			#ft8 = 2^(x^2+1)
			fadd.d ft8, ft8, ft9 #ft8 = 2^(x^2+1)+x
			li t1, -3
			fcvt.d.w  ft11, t1	
			fadd.d %result, ft8, ft11 #ft8 = 2^(x^2+1)+x-3
	.end_macro
	
# change wrong boundaries for good
.macro change_boundaries(%left, %right)
	print_string(changing_boundaries)
	li t2, -1
	fcvt.d.w  ft5, t2
	fadd.d %left, %left, ft5
	li t2, 1
	fcvt.d.w  ft5, t2
	fadd.d %right, %right, ft5
	print_string(changed_boundaries)
	.end_macro
	
# calculating x by chords method
# min, max - boundaries
# acc - input accuracy
# result - x value
.macro method_chords(%min, %max, %acc, %result)
	#fs2 - f(min)
	#fs3 - f(max)
	#fs4 - f(max) - f(min) or наоборот
	#fs5 = 0
	#fs6 - f(b)*a
	#fs7 - f(a)*b
	#fs8 - c
	li t3, 0
	fcvt.d.w  fs2, t3
	fcvt.d.w  fs3, t3
	fcvt.d.w  fs5, t3
	loop:
	f(%min, fs2) 		# fs2 - f(min)
	f(%max, fs3)		# fs3 - f(max)
	fsub.d fs4, fs3, fs2	# fs4 = f(max) - f(min)
	fge.d t3, fs4, fs5	# t0=1 <=> f(max)-f(min)
	beq t3, zero, abs	# t0=0 <=> -f(max)+f(min)
	return_0:
	fgt.d t3, fs4, %acc	# abs(f(max)-f(min)) > %acc ? t0=1 : t0=0
	beq t3, zero, end	# t0=0 => stop loop => ret result
	return_1:		
	fmul.d fs6, fs3, %min	# fs6 = f(max) * min
	fmul.d fs7, fs2, %max	# fs7 = f(min) * max
	fsub.d fs6, fs6, fs7	# fs6 = f(max) * min - f(min) * max
	fdiv.d fs8, fs6, fs4	# fs8 = c
	f(fs8, fs6)		# fs6 = f(c)
	fmul.d fs7, fs2, fs6	# fs7 = f(min) * f(c)
	fgt.d t3, fs7, fs5	# f(min) * f(c) > 0 ? t0=1 : t0=0
	beqz t3, less_zero	# t0=0 => max=c
	bnez t3, bigger_zero	# t0=1 => min=c
	less_zero:
		#max = c
		li t3, 1
		fcvt.d.w  fs5, t3
		fmul.d %max, fs8, fs5
		j loop
	bigger_zero:
		#min = c
		li t3, 1
		fcvt.d.w  fs5, t3
		fmul.d %min, fs8, fs5
		j loop
	abs:
		li t3, -1
		fcvt.d.w  fs5, t3
		fmul.d fs4, fs4, fs5
		j return_0
	end:
	li t3, 1
	fcvt.d.w  fs5, t3
	fmul.d %result, fs8, fs5
.end_macro
