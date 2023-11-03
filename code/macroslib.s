# ������ ��� ������ ���������� ������������� �������� ����� � ������� %x
.macro read_double(%x)
	li a7 7
    	ecall
    	fmv.d %x fa0
.end_macro 

# ������ ��� ������ �������� ����� �� ��������� �������� %x
.macro print_double(%x)
	li a7 3
    	#fsd %x -100(a0)
    	fmv.d fa0 %x
    	ecall
    	print_str("\n")
.end_macro 

# ������ ��� ������ ������ �� ��������� �������� %x
.macro print_str(%x)
	.data
	str: .asciz %x
	.text
	li a7, 4
	la a0, str
	ecall
.end_macro