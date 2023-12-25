# 36 variant
.include "macros_lib.asm" # поключение библиотеки макросов

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
	input_double(fa1) 		# ввод точности
	new_line()
	fld fa2, min_acc, t0		# min accuracy
	fld fa3, max_acc, t0		# max accuracy
	j check_input
	
check_input: # бесконечно запрашивает acuurace, пока не получит 1<=число<=10
	# t0 - result of <>
	li t0, 0
	fge.d t0, fa1, fa2 	# проверка на left
	beqz t0, wrong_counter
	fge.d t0, fa3, fa1 	# проверка на right
	beqz t0, wrong_counter
	j main_return
	
wrong_counter: # вывод грозного сообщения, перезапуск цикла проверки ввода
	print_string(wrong_input_phrase)
	new_line()
	print_string(input_acc)
	new_line()
	input_double(fa1)		# reinput if previous was wrong
	j check_input
	
main_return:
	# ft0 - left boundary
	# ft1 - right boundary
	# ft2, ft3 - f(boundary)
	# fa4 - x value
	li t0, 0
	fcvt.d.w  ft0, t0	#set boundaries
	fcvt.d.w  ft4, t0	#x value for changig in macros
	li t1, 1
	fcvt.d.w  ft1, t1
	print_string(passed)	# good boundaries
	method_chords(ft0, ft1, fa1, fa4)	# calculating root
	new_line()
	print_double(fa4)	# print root
	new_line()
	j shutdown
	
shutdown: 	# exit
	print_string(goodbye)
	li a7, 10
	ecall
	
	
	
