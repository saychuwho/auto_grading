#include <iostream>

using namespace std;

int func2(int a, int b)
{
    return a+b;
}

int main()
{
    std::cout << func2(3, -2) << std::endl;
}