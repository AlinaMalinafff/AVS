# 36 variant
.include "macros_lib.asm"
.data
	input_acc: .asciz "input of accuracy (0.001 < input < 0,00000001): "
	max_acc: .double 0.001
	min_acc: .double 0,00000001
	goodbye: .asciz "the end."
	wrong_input_phrase: .asciz "wrong\n"
	passed: .asciz "test passed"
.text

main:
	# fa1 - input accuracy
	# fa2 - min acc
	# fa3 - max acc
	print_string(input_acc)
	input_double(fa1)
	fld fa2, min_acc, t0
	fld fa3, max_acc, t0
	j check_input
	
check_input: # бесконечно запрашивает кол-во элементов массива, пока не получит 1<=число<=10
	# t0 - result of <>
	li t0, 0
	fge.d t0, fa1, fa2 	# проверка на left
	beqz t0, wrong_counter
	fge.d t0, fa3, fa1 	# проверка на right
	beqz t0, wrong_counter
	j main_return
	
wrong_counter: # вывод грозного сообщения, перезапуск цикла ввода количества элементов массива
	print_string(wrong_input_phrase)
	print_string(input_acc)
	input_double(fa1)
	j check_input
	
main_return:
	# ft0 - left boundary
	# ft1 - right boundary
	# ft2, ft3 - check boundaries
	# ft4 - flag_posiible_diapazon
	li t0, 2
	fcvt.d.w  ft0, t0
	li t1, 3
	fcvt.d.w  ft1, t1
	f(ft0, ft2)
	f(ft1, ft3)
	li t0, 0
	fcvt.d.w  ft4, t0
	fgt.s t0, ft2, ft4
	li t1, 0
	fgt.s t1, ft3, ft4
	add t0, t0, t1
	li t1, 1
	bne t0, t1, shutdown
	print_string(passed)

	
shutdown:
	print_string(goodbye)
	li a7, 10
	ecall
	
	
	
