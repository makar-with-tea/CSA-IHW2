.data
x: .double 0  # задаваемый пользователем параметр x
n: .double 1.0  # начальное значение числа, используемого при вычислении знаменателя элемента степенного ряда
sum: .double 1.0  # начальное значение для суммы
numerator: .double 1.0  # начальное значение числителя текущего элемента степенного ряда
denominator: .double 1.0 # начальное значение знаменателя текущего элемента степенного ряда
mes_error: .double 0.0005  # допустимая погрешность
_1: .double 1.0 # единица для удобства

.include "macroslib.s"

.text
main:
	print_str("Input a non-integer number. NOTE: for numbers smaller than -113 or larger than 113 the result ")
	print_str("may be displayed as Infinity due to calculation accuracy.\nx = ")
	read_double(fs0) # ввод числа x пользователем
	# сохранение именованных переменных в регистры
	fsd fs0 x t0
	fld fs1 sum t0
	fld fs2 mes_error t0
	fld fs3 numerator t0
	fld fs4 denominator t0
	fld fs5 n t0

	# вычисление суммы степенного ряда ch(x) с помощью цикла
	loop:
		# сохранение в нужные регистры подаваемых в подпрограмму аргументов
		fmv.d fa0 fs0 # 1 аргумент - x
		fmv.d fa1 fs3 # 2 аргумент - numerator, числитель предыдущего элемента ряда
		fmv.d fa2 fs4 # 3 аргумент - denominator, знаменатель предыдущего элемента ряда
		fmv.d fa3 fs5 # 4 аргумент - n, число, используемое при вычислении знаменателя элемента степенного ряда
		jal next_term # вызов подпрограммы next_term с вышеуказанными аргументами
		# возвращаемые значения - term, текущий элемент степенного ряда в fa4,
		# а также обновленные значения numerator, denominator, n в регистрах fa1-fa3 соответственно.
		
		# обновление значений numerator, denominator и n в основной программе
		fmv.d fs3 fa1
		fmv.d fs4 fa2
		fmv.d fs5 fa3
		
		fadd.d fs1 fs1 fa4 # прибавление к сумме ряда текущего элемента ряда
		
		# сохранение в нужные регистры подаваемых в подпрограмму аргументов
		fmv.d fa0 fs1 # 1 аргумент - sum, сумма ряда
		fmv.d fa1 fs2 # 2 аргумент - mes_error, допустимая погрешность
		fmv.d fa2 fa4 # 3 аргумент - term, текущий элемент ряда
		jal check_accuracy # вызов подпрограммы check_accuracy с вышеуказанными аргументами
		# возвращаемое значение - булевое значение выражения (mes_error * sum < term) в регистре a0
		bgtz a0 loop # переход на следущую итерацию цикла, если погрешность больше допустимой
	
	print_str("ch(x) = ")
	print_double(fs1) # вывод результата вычислений
	li a7 10 # останов
	ecall

.include "next_term.s"
.include "check_accuracy.s"
