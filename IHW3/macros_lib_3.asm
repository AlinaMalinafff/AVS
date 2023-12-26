.data
	new_line: .asciz "\n"
	sep:    .asciz  "--------\n"    # ����������� (� \n � ���� � �����)

.text
# ��� � �������		
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
	
# ������ ���������� ��������� �������
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
	
# ��������� ������� � ������
.macro mass_add_elem(%mass_adr, %iter, %elem_to_add)
	sw      %elem_to_add (%mass_adr)         	# ���������� ����� �� t2 �� ������ � t0
        addi    %mass_adr, %mass_adr, 4         	# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        addi    %iter, %iter, 1       	# ����������� ������� ��������� � �������
        .end_macro
	
.macro strcmp(%first, %second, %mass_adr, %mass_counter)
	# t0 - ������ ������� ������
	# t1 - ������ ���������
	# t3 - �������� ������ ���������
	# %second - ������ ��������� ������
	# t4 - ������ ������
	# t2 - ������� ������ ������
	strcmp:
		mv 	t3, %second
		li 	t2, 0
	main_loop:	# ����� ������� ������� �������
    		lb      t0 (%first)     # �������� ������� �� ������ ��� ���������
    		print_char(t0)
    		lb      t1 (t3)     	# �������� ������� �� ��������� ��� ���������
    		print_char(t1)
    		beqz    t0 end      	# ����� ������ 1
    		addi	t2, t2, 1		# ������ curr ����� ������
    		beq     t0 t1 substr_main   	# ��������� ��� ��� ���������
    		addi    %first %first 1     	# ����� ������� � ������ 1 ������������� �� 1
    		j       main_loop
    		
    	substr_main:	# ������ ������� �����
    		mv t4, t2	# t4 = ������ ��������� ���������
    	substr_loop:
    		lb      t0 (%first)     # �������� ������� �� ������ ��� ���������
    		lb      t1 (t3)     	# �������� ������� �� ��������� ��� ���������
    		beqz	t1 substr_successful_end # ����� ���������
    		beqz    t0 end      		# ����� ������� ������
    		bne	t0, t1, substr_end
    		addi	t2, t2, 1		# ������ curr ����� ������
    		addi    %first %first 1     	# ����� ������� � ������ 1 ������������� �� 1
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
		# s10 - ������� ������ � �������
		lw      a0 (%mass_adr)        # ������� ��������� ������� �������
        	print_int(a0)
        	new_line()
        	addi    %mass_adr, %mass_adr, 4			# �������� ����� �� ������ ����� � ������, ���������� ��������� �� next ��������� �����
        	addi    s10, s10, 1	# ����������� ������� ��������� � �������
        	bgtu    %ideal_amount, s10, array_out_flag 	# �������� �� ��� �� �������� ������?
        	li s10, 0
        .end_macro
