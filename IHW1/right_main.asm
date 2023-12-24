.include "macros_lib.asm" # ����������� ��������� ��������

.data
	input_counter_phrase: .asciz "������� ���������� ��������� � �������: "
	wrong_input_phrase: .asciz "���������� ���������� � ������� �� 1 �� 10. ��������� ���� �����: "
	input_array_elem: .asciz "������� ������� �������: "
	output_array_phrase: .asciz "������� ������������ ������: \n"
	summ_phrase: .asciz "����� ��������� �������: "
	odd_counter_phrase: .asciz "���������� �������� �����: "
	even_counter_phrase: .asciz "���������� ������ �����: "
	new_line: .asciz "\n"
	sep:    .asciz  "--------\n"    # ����������� (� \n � ���� � �����)
	.align  2                       # ������������ �� ������� ����� int
	array:  .space  40              # 64 ����� - 10 of int
	border:
	.align 2
	array_b: .space 40
	border_b:
	
.text
# ��������� ���������
start:
	print_string(input_counter_phrase)
	li t6, 1 	# �������
	li t5, 10	# �������
	j check_input_counter 
	
check_input_counter: # ���������� ����������� ���-�� ��������� �������, ���� �� ������� 1<=�����<=10
	input_int(a0)
	blt a0, t6, wrong_counter 	# �������� �� <1
	bgt a0, t5, wrong_counter 	# �������� �� >10
	mv s11, a0			# s11 - ��� �������� ���-�� ����-�� � �������
	la      t0 array		# �������� ������ �� ������ �
	j main
	
wrong_counter: # ����� �������� ���������, ���������� ����� ����� ���������� ��������� �������
	print_string(wrong_input_phrase)
	j check_input_counter
	
main: # �������� ���������, ���������� �������
	# s11 - �������� ����� ������ � �������
	# s10 - ������� ������ � �������
	making_array(t2, s10, t0, s11)	# ����� �������, ��������� ������ �
	#������ � ������ ���������
       	print_string(sep)        	# ������� ������-�����������
        la      t0, array		# ������ ����� �� ������ �����-�������
        print_string(output_array_phrase)
        array_out(s10, t0, s11)		#  ����� �������, ���������� ������ � �� �������
        # ������ �������
        print_string(sep)          	# ������� ������-�����������
       	la	t0, array		# ������� ������ �� �����
	la      t1, array_b		# ������� ������ �� ������
	li t3, 0			# ��������� ��������
	j making_array_b		# ������� � ������������ �������� ������� �


# ����� ������ � ��������� �������: ���� ������� �� �;
# ���� ������� �� � ������������� ��� ����� 0, ������� �� ���� 5 � ��������� � ������ �
# ���� ������� �� � �������������, ��������� ��� � ��� ���������� �������� �� � � �
making_array_b: # ����� ������ �
	# s11 - �������� ����� ������ � �������
	# s10 - ������� ������ � ������� (a?)
	# t3 - counter of elems in B
        lw      a0 (t0) 			# ���� ������� �� ������� �������       
        blt 	a0, zero, branch_if_negative	# ���� �� �������������
        beq	a0, zero, branch_if_negative	# ���� ����� ����, �� ��� �������������
        bgt 	a0, zero, branch_if_positive	# ���� �������������
	print_string(sep)         	# ������� ������-�����������
       	la      t1, array_b		# �� ������ ������� �
       	j array_b_out
        #����� ������� 
	
branch_if_negative:
	minus_five(a0)
	sw      a0 (t1)		# �������� �������� � ������ �
	addi    t1, t1, 4	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    t3, t3, 1
        addi    t0, t0, 4	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    s10, s10, 1	# ����������� ������� ��������� � �������
        bgtu    s11, s10, making_array_b	# ���� ���� ������ � �� ������
        la      t1, array_b
        j array_b_out
        
branch_if_positive:
	lw      a0 (t0)
	sw      a0 (t1)		# ���� ������� �� ������� �������       
        addi    t1, t1, 4	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    t3, t3, 1
        addi    t0, t0, 4	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    s10, s10, 1	# ����������� ������� ��������� � �������
        bgtu    s11, s10, branch_if_positive # �.�. ����� ������� �������������� �� ������, �� �������������� ����� ��
        la      t1, array_b
        j array_b_out
        
array_b_out:
	#t3 - planned counter
	#t4 - current counter
	li a7, 1
        lw      a0 (t1)        # ������� ��������� ������� �������
        ecall
        la 	a0, new_line
        li      a7, 4           # ������� ������� ������
        ecall
        addi    t1, t1, 4	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    t4, t4, 1	# ����������� ������� ��������� � �������
        bgtu    t3, t4, array_b_out 	
        #����� �������_b ��������
        j ShutDown
        
ShutDown: # ����� ���������
        li      a7, 10           # ��������� ���������
        ecall
