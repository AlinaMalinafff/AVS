.data
	new_line: .asciz "\n"
	sep:    .asciz  "--------\n"    # разделитель (с \n и нулём в конце)

.text
# инт в консоль		
.macro print_int(%x)
	mv a0, %x
	li      a7, 1
        ecall
        .end_macro
        
#print string	
.macro print_string(%x)
	la a0, %x
	li a7, 4
	ecall
	.end_macro
	
# Печать отдельного заданного символа
.macro print_char(%x)
   	li a7, 11
   	mv a0, %x
   	ecall
	.end_macro
	
#\n string input
.macro new_line()
	la a0, new_line
	li a7, 4
	ecall
	.end_macro
	
# добавляет элемент в массив
.macro mass_add_elem(%mass_adr, %iter, %elem_to_add)
	sw      %elem_to_add (%mass_adr)         	# записываем число из t2 по адресу в t0
        addi    %mass_adr, %mass_adr, 4         	# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        addi    %iter, %iter, 1       	# передвигаем счётчик элементов в массиве
        .end_macro
	
.macro strcmp(%first, %second, %mass_adr, %mass_counter)
	# t0 - символ главной строки
	# t1 - символ подстроки
	# t3 - хранение начала подстроки
	# %second - начало подстроки всегда
	# t4 - первый индекс
	# t2 - счётчик первой строки
	strcmp:
		mv 	t3, %second
		li 	t2, 0
	main_loop:	# поиск первого равного символа
    		lb      t0 (%first)     # Загрузка символа из строки для сравнения
    		print_char(t0)
    		lb      t1 (t3)     	# Загрузка символа из подстроки для сравнения
    		print_char(t1)
    		beqz    t0 end      	# Конец строки 1
    		addi	t2, t2, 1		# индекс curr элема строки
    		beq     t0 t1 substr_main   	# отдельный луп для сравнения
    		addi    %first %first 1     	# Адрес символа в строке 1 увеличивается на 1
    		j       main_loop
    		
    	substr_main:	# первые символы равны
    		mv t4, t2	# t4 = индекс вхождения подстроки
    	substr_loop:
    		lb      t0 (%first)     # Загрузка символа из строки для сравнения
    		lb      t1 (t3)     	# Загрузка символа из подстроки для сравнения
    		beqz	t1 substr_successful_end # конец сабстроки
    		beqz    t0 end      		# Конец главной строки
    		bne	t0, t1, substr_end
    		addi	t2, t2, 1		# индекс curr элема строки
    		addi    %first %first 1     	# Адрес символа в строке 1 увеличивается на 1
    		addi	t3, t3, 1
    		b       substr_loop
    	substr_successful_end:
    		mass_add_elem(%mass_adr, %mass_counter, t4)
    	substr_end:
    		li 	t4, 0
    		mv 	t3, %second
    		b	main_loop
    	
	end:
    		ret
    	.end_macro
    	
.macro array_out(%mass_adr, %ideal_amount)
	array_out_main:
		li s10, 0
		li a0, 0
	array_out_flag: 
		# s10 - счётчик элемов в массиве
		lw      a0 (%mass_adr)        # выведем очередной элемент массива
        	print_int(a0)
        	new_line()
        	addi    %mass_adr, %mass_adr, 4			# увеличим адрес на размер слова в байтах, передвинем указатель на next свободное место
        	addi    s10, s10, 1	# передвигаем счётчик элементов в массиве
        	bgtu    %ideal_amount, s10, array_out_flag 	# проверка не все ли элементы прошли?
        	li s10, 0
        .end_macro
