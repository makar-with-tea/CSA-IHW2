#include <iostream>
#include <vector>

using namespace std;

//подпрограммы не выделены в отдельные функции, однако алгоритм нахождения ch(x) аналогичен алгоритму, описанному в основной программе
int main()
{
	double x;
	cout << "Input a non-integer number : \nx = ";
	cin >> x;
	int n = 1;
	double sum = 1, numerator = 1, denominator = 1, term = 1;
	while (term >= 0.0005 * sum) {
		numerator *= x * x;
		denominator *= n;
		++n;
		denominator *= n;
		++n;
		term = numerator / denominator;
		sum += term;
	}
	cout << "ch(x) = " << sum;
}