.include "macros_lib_3.asm"

.eqv     BUF_SIZE 10

.data
	buf1:    .space BUF_SIZE     # ����� ��� ������ ������
	buf2:    .space BUF_SIZE     # ����� ��� ������ ������
	welcome_phrase: .asciz "input of the string: "
	check_string_ph: .asciz "written string: "
	.align  2                       # ������������ �� ������� ����� int
	array:  .space  40              # 64 ����� - 10 of int ��� ������� �����
	border:

.text
.globl main
main:
	# ��������� � �������� �2 �����
	la a3 array
	li a4, 0 	# a4 - ������� ������ � �������
	
	# ���� ������ 1 � �����
    	print_string(welcome_phrase)
    	la      a0 buf1
    	li      a1 BUF_SIZE
    	li      a7 8
    	ecall
    
    	# �������� ����� ������ 1
    	print_string(check_string_ph)
    	la      a0 buf1
    	li      a7 4
    	ecall
    
    	# ���� ������ 2 � �����
    	print_string(welcome_phrase)
    	la      a0 buf2
    	li      a1 BUF_SIZE
    	li      a7 8
    	ecall
    
    	# �������� ����� ������ 2
    	print_string(check_string_ph)
    	la      a0 buf2
    	li      a7 4
    	ecall
    
    	# ��������� ����� � �������
    	la      a0 buf1
    	la      a5 buf2
    	strcmp(a0, a5, a3, a4)
    
    	# ����� ���������� ���������
    	la a3 array
    	array_out(a3, a4)
    
    	# ������� ������
    	new_line()

    	# ���������� ���������
    	li      a7 10
    	ecall
