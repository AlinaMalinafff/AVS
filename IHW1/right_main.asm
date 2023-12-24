.include "macros_lib.asm" # подключение библиотки макросов

.data
	input_counter_phrase: .asciz "Введите количество элементов в массиве: "
	wrong_input_phrase: .asciz "Допустимое количество в массиве от 1 до 10. Повторите ввод снова: "
	input_array_elem: .asciz "Введите элемент массива: "
	output_array_phrase: .asciz "Выведем получившийся массив: \n"
	summ_phrase: .asciz "Сумма элементов массива: "
	odd_counter_phrase: .asciz "Количество нечётных чисел: "
	even_counter_phrase: .asciz "Количество чётных чисел: "
	new_line: .asciz "\n"
	sep:    .asciz  "--------\n"    # разделитель (с \n и нулём в конце)
	.align  2                       # выравнивание на границу слова int
	array:  .space  40              # 64 байта - 10 of int
	border:
	.align 2
	array_b: .space 40
	border_b:
	
.text
# стартовая программа
start:
	print_string(input_counter_phrase)
	li t6, 1 	# граница
	li t5, 10	# граница
	j check_input_counter 
	
check_input_counter: # бесконечно запрашивает кол-во элементов массива, пока не получит 1<=число<=10
	input_int(a0)
	blt a0, t6, wrong_counter 	# проверка на <1
	bgt a0, t5, wrong_counter 	# проверка на >10
	mv s11, a0			# s11 - тут хранится кол-во элем-ов в массиве
	la      t0 array		# загрузка адреса на массив а
	j main
	
wrong_counter: # вывод грозного сообщения, перезапуск цикла ввода количества элементов массива
	print_string(wrong_input_phrase)
	j check_input_counter
	
main: # основная программа, вызывающая макросы
	# s11 - конечное число элемов в массиве
	# s10 - счётчик элемов в массиве
	making_array(t2, s10, t0, s11)	# вызов макроса, строящего массив а
	#запись в массив закончена
       	print_string(sep)        	# выведем строку-разделитель
        la      t0, array		# ссылка снова на начало стека-массива
        print_string(output_array_phrase)
        array_out(s10, t0, s11)		#  вызов макроса, выводящего массив а на консоль
        # массив выведен
        print_string(sep)          	# выведем строку-разделитель
       	la	t0, array		# возврат ссылки на ачало
	la      t1, array_b		# возврат ссылки на начало
	li t3, 0			# обнуление счётчика
	j making_array_b		# переход к подпрограмме создания массива б


# делаю массив б следующим образом: беру элемент из а;
# если элемент из а отрицательный или равен 0, отнимаю от него 5 и записываю в массив б
# если элемент из а положительный, записываю его и все оставшиеся элементы из а в б
making_array_b: # делаю массив б
	# s11 - конечное число элемов в массиве
	# s10 - счётчик элемов в массиве (a?)
	# t3 - counter of elems in B
        lw      a0 (t0) 			# беру элемент из первого массива       
        blt 	a0, zero, branch_if_negative	# если он отрицательный
        beq	a0, zero, branch_if_negative	# если равен нулю, то как отрицательный
        bgt 	a0, zero, branch_if_positive	# если положительный
	print_string(sep)         	# выведем строку-разделитель
       	la      t1, array_b		# на начало массива б
       	j array_b_out
        #вывод массива 
	
branch_if_negative:
	minus_five(a0)
	sw      a0 (t1)		# загрузка элемента в массив б
	addi    t1, t1, 4	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    t3, t3, 1
        addi    t0, t0, 4	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    s10, s10, 1	# передвигаем счётчик элементов в массиве
        bgtu    s11, s10, making_array_b	# пока весь массив а не обойдём
        la      t1, array_b
        j array_b_out
        
branch_if_positive:
	lw      a0 (t0)
	sw      a0 (t1)		# беру элемент из первого массива       
        addi    t1, t1, 4	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    t3, t3, 1
        addi    t0, t0, 4	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    s10, s10, 1	# передвигаем счётчик элементов в массиве
        bgtu    s11, s10, branch_if_positive # т.к. после первого положиетльного не меняет, то закцикливается здесь же
        la      t1, array_b
        j array_b_out
        
array_b_out:
	#t3 - planned counter
	#t4 - current counter
	li a7, 1
        lw      a0 (t1)        # выведем очередной элемент массива
        ecall
        la 	a0, new_line
        li      a7, 4           # выведем перевод строки
        ecall
        addi    t1, t1, 4	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    t4, t4, 1	# передвигаем счётчик элементов в массиве
        bgtu    t3, t4, array_b_out 	
        #вывод массива_b завершён
        j ShutDown
        
ShutDown: # конец программы
        li      a7, 10           # остановка программы
        ecall
