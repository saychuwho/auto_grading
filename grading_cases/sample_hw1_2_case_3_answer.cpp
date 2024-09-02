#include <iostream>

using namespace std;

int func2(int a, int b)
{
    return a+b;
}

int main()
{
    std::cout << func2(-5, 5) << std::endl;
}