.include "macros_lib_3.asm"

.eqv     BUF_SIZE 10

.data
	buf1:    .space BUF_SIZE     # Буфер для первой строки
	buf2:    .space BUF_SIZE     # Буфер для второй строки
	welcome_phrase: .asciz "input of the string: "
	check_string_ph: .asciz "written string: "
	.align  2                       # выравнивание на границу слова int
	array:  .space  40              # 64 байта - 10 of int тут индексы будут
	border:

.text
.globl main
main:
	# Открываем в регистре а2 эррей
	la a3 array
	li a4, 0 	# a4 - счётчик элемов в массиве
	
	# Ввод строки 1 в буфер
    	print_string(welcome_phrase)
    	la      a0 buf1
    	li      a1 BUF_SIZE
    	li      a7 8
    	ecall
    
    	# Тестовый вывод строки 1
    	print_string(check_string_ph)
    	la      a0 buf1
    	li      a7 4
    	ecall
    
    	# Ввод строки 2 в буфер
    	print_string(welcome_phrase)
    	la      a0 buf2
    	li      a1 BUF_SIZE
    	li      a7 8
    	ecall
    
    	# Тестовый вывод строки 2
    	print_string(check_string_ph)
    	la      a0 buf2
    	li      a7 4
    	ecall
    
    	# Сравнение строк в буферах
    	la      a0 buf1
    	la      a5 buf2
    	strcmp(a0, a5, a3, a4)
    
    	# Вывод результата сравнения
    	la a3 array
    	array_out(a3, a4)
    
    	# Перевод строки
    	new_line()

    	# Завершение программы
    	li      a7 10
    	ecall
