#include <iostream>
#include <string>

using namespace std;

string func3(string a, string b)
{
    return a+b;
}

int main()
{
    std::cout << func3(" ", " ") << std::endl;
}