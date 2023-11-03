.data
x: .double 0  # ���������� ������������� �������� x
n: .double 1.0  # ��������� �������� �����, ������������� ��� ���������� ����������� �������� ���������� ����
sum: .double 1.0  # ��������� �������� ��� �����
numerator: .double 1.0  # ��������� �������� ��������� �������� �������� ���������� ����
denominator: .double 1.0 # ��������� �������� ����������� �������� �������� ���������� ����
mes_error: .double 0.0005  # ���������� �����������
_1: .double 1.0 # ������� ��� ��������

.include "macroslib.s"

.text
main:
	print_str("Input a non-integer number. NOTE: for numbers smaller than -113 or larger than 113 the result ")
	print_str("may be displayed as Infinity due to calculation accuracy.\nx = ")
	read_double(fs0) # ���� ����� x �������������
	# ���������� ����������� ���������� � ��������
	fsd fs0 x t0
	fld fs1 sum t0
	fld fs2 mes_error t0
	fld fs3 numerator t0
	fld fs4 denominator t0
	fld fs5 n t0

	# ���������� ����� ���������� ���� ch(x) � ������� �����
	loop:
		# ���������� � ������ �������� ���������� � ������������ ����������
		fmv.d fa0 fs0 # 1 �������� - x
		fmv.d fa1 fs3 # 2 �������� - numerator, ��������� ����������� �������� ����
		fmv.d fa2 fs4 # 3 �������� - denominator, ����������� ����������� �������� ����
		fmv.d fa3 fs5 # 4 �������� - n, �����, ������������ ��� ���������� ����������� �������� ���������� ����
		jal next_term # ����� ������������ next_term � �������������� �����������
		# ������������ �������� - term, ������� ������� ���������� ���� � fa4,
		# � ����� ����������� �������� numerator, denominator, n � ��������� fa1-fa3 ��������������.
		
		# ���������� �������� numerator, denominator � n � �������� ���������
		fmv.d fs3 fa1
		fmv.d fs4 fa2
		fmv.d fs5 fa3
		
		fadd.d fs1 fs1 fa4 # ����������� � ����� ���� �������� �������� ����
		
		# ���������� � ������ �������� ���������� � ������������ ����������
		fmv.d fa0 fs1 # 1 �������� - sum, ����� ����
		fmv.d fa1 fs2 # 2 �������� - mes_error, ���������� �����������
		fmv.d fa2 fa4 # 3 �������� - term, ������� ������� ����
		jal check_accuracy # ����� ������������ check_accuracy � �������������� �����������
		# ������������ �������� - ������� �������� ��������� (mes_error * sum < term) � �������� a0
		bgtz a0 loop # ������� �� �������� �������� �����, ���� ����������� ������ ����������
	
	print_str("ch(x) = ")
	print_double(fs1) # ����� ���������� ����������
	li a7 10 # �������
	ecall

.include "next_term.s"
.include "check_accuracy.s"
