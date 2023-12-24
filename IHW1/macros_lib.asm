.text
# печатает строку в консоль
.macro print_string(%str)
	la a0, %str
	li a7, 4
	ecall
	.end_macro
	
# отнимает -5 от элемента
.macro minus_five (%x)
	addi %x, %x, -5
	.end_macro

# ввод строки с консоли и перевод в нужный регистр
.macro input_int(%x)
	li a7, 5
	ecall
	mv %x, a0
	.end_macro

# инт в консоль		
.macro print_int(%x)
	mv a0, %x
	li      a7, 1
        ecall
        .end_macro
	
# добавляет элемент в массив
.macro mass_add_elem(%mass_adr, %iter, %elem_to_add)
	sw      %elem_to_add (%mass_adr)         	# записываем число из t2 по адресу в t0
        addi    %mass_adr, %mass_adr, 4         	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    %iter, %iter, 1       	# передвигаем счётчик элементов в массиве
        .end_macro
  
# создаёт массив      
.macro making_array(%register_for_elem, %local_counter, %mass_adr, %ideal_amount)
	making_array_flag: # запрашиваем число, заполняем массив
	# s11 - конечное число элемов в массиве
	# s10 - счётчик элемов в массиве
	print_string(input_array_elem)
	input_int(%register_for_elem)
	mass_add_elem(%mass_adr, %local_counter, %register_for_elem)
        bgtu    %ideal_amount, %local_counter, making_array_flag     # сравниваем с запланированным размером массива
        li %local_counter, 0	# обнуление местного счётчика
        #запись в массив закончена
        .end_macro
 
# вывод массива в консоль      
.macro array_out(%local_counter, %mass_adr, %ideal_amount)
	array_out_flag: # s11 - конечное число элемов в массиве
	# s10 - счётчик элемов в массиве
	lw      a0 (%mass_adr)        # выведем очередной элемент массива
        print_int(a0)
        print_string(new_line)
        addi    %mass_adr, %mass_adr, 4	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    %local_counter, %local_counter, 1	# передвигаем счётчик элементов в массиве
        bgtu    %ideal_amount, %local_counter, array_out_flag # проверка не все ли элементы прошли?
        li %local_counter, 0
        .end_macro
        
