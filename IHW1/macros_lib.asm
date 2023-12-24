.text
# �������� ������ � �������
.macro print_string(%str)
	la a0, %str
	li a7, 4
	ecall
	.end_macro
	
# �������� -5 �� ��������
.macro minus_five (%x)
	addi %x, %x, -5
	.end_macro

# ���� ������ � ������� � ������� � ������ �������
.macro input_int(%x)
	li a7, 5
	ecall
	mv %x, a0
	.end_macro

# ��� � �������		
.macro print_int(%x)
	mv a0, %x
	li      a7, 1
        ecall
        .end_macro
	
# ��������� ������� � ������
.macro mass_add_elem(%mass_adr, %iter, %elem_to_add)
	sw      %elem_to_add (%mass_adr)         	# ���������� ����� �� t2 �� ������ � t0
        addi    %mass_adr, %mass_adr, 4         	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    %iter, %iter, 1       	# ����������� ������� ��������� � �������
        .end_macro
  
# ������ ������      
.macro making_array(%register_for_elem, %local_counter, %mass_adr, %ideal_amount)
	making_array_flag: # ����������� �����, ��������� ������
	# s11 - �������� ����� ������ � �������
	# s10 - ������� ������ � �������
	print_string(input_array_elem)
	input_int(%register_for_elem)
	mass_add_elem(%mass_adr, %local_counter, %register_for_elem)
        bgtu    %ideal_amount, %local_counter, making_array_flag     # ���������� � ��������������� �������� �������
        li %local_counter, 0	# ��������� �������� ��������
        #������ � ������ ���������
        .end_macro
 
# ����� ������� � �������      
.macro array_out(%local_counter, %mass_adr, %ideal_amount)
	array_out_flag: # s11 - �������� ����� ������ � �������
	# s10 - ������� ������ � �������
	lw      a0 (%mass_adr)        # ������� ��������� ������� �������
        print_int(a0)
        print_string(new_line)
        addi    %mass_adr, %mass_adr, 4	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    %local_counter, %local_counter, 1	# ����������� ������� ��������� � �������
        bgtu    %ideal_amount, %local_counter, array_out_flag # �������� �� ��� �� �������� ������?
        li %local_counter, 0
        .end_macro
        
