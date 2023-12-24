.data
	new_line: .asciz "\n"
	sep:    .asciz  "--------\n"    # разделитель (с \n и нулём в конце)
	changing_boundaries: .asciz "changing coundaries.."
	changed_boundaries: .asciz "boundaies are changed"
.text
.macro print_int(%x)
	mv a0, %x
	li a7, 1
	ecall
	.end_macro
	
.macro print_string(%x)
	la a0, %x
	li a7, 4
	ecall
	.end_macro
	
.macro print_double(%x)
	fmv.d fa0, %x
	li a7, 3
	ecall
	.end_macro
	
.macro input_int(%x)
	li a7, 5
	ecall
	mv %x, a0
	.end_macro
	
.macro input_double(%x)
	li a7, 7
	ecall
	fmv.d %x, fa0
	.end_macro
	
.macro new_line()
	mv a0, new_line
	li a7, 4
	ecall
	.end_macro
	
.macro sep()
	mv a0, sep
	li a7, 4
	ecall
	.end_macro
	
.macro f(%x, %result)
	# 2^(x^2+1)+x-3
	.text
		#ft6 - for counting help = 1
		#ft7 - for counting help = 2
		#ft8 - for countings help
		#ft9 - for x
		#ft10 - for countings osnova
		#ft11 - for countings help
		li t0, 1
		fcvt.d.w  ft11, t0	#ft11 = 1
		fmul.d ft9, %x, ft11 	#ft9 = x
		fmul.d ft10, ft9, ft9 	#ft10 = x^2
		fadd.d ft10, ft10, ft11	#ft10 = x^2+1
		fcvt.d.w  ft8, t0	#ft8 = 1
		fcvt.d.w  ft6, t0	#ft8 = 1
		li t0, 0
		fcvt.d.w  ft11, t0	#ft11 = 0
		li t0, 2
		fcvt.d.w  ft7, t0	#ft11 = 0
		loop_pow_2: 	#ft11 - counter pows of 2
			#ft8 - counter of value
			#ft7 - 2
			#ft6 - 1
			#t0 - stop flag
			fmul.d ft8, ft8, ft7 	#value^2
			fadd.d ft11, ft11, ft6	#counter++
			feq.d t0, ft11, ft10 	#t0=1 - stop
			beqz t0, loop_pow_2
			bnez t0, return
		return:
			#ft8 = 2^(x^2+1)
			fadd.d ft8, ft8, ft9 #ft8 = 2^(x^2+1)+x
			li t0, -3
			fcvt.d.w  ft11, t0
			fadd.d %result, ft8, ft11 #ft8 = 2^(x^2+1)+x-3
	.end_macro
	
.macro change_boundaries(%left, %right)
	print_string(changing_boundaries)
	li t0, -1
	fcvt.d.w  ft5, t0
	fadd.d %left, %left, ft5
	li t0, 1
	fcvt.d.w  ft5, t0
	fadd.d %right, %right, ft5
	print_string(changed_boundaries)
	.end_macro
	
.macro method_chords(%min, %max, %acc)
	#fs2 - 
.end_macro
	

			
			
			
		
