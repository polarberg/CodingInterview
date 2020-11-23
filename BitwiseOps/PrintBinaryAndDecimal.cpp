#include <iostream>

using namespace std; 

void PrintBinaryAndDecimal(unsigned int c) {
    cout << "Bin = ";
    for(int i = 31; i >= 0; --i) {
        cout << (((c >> i) % 2) ? '1' : '0');
    }

    cout << " : Dec = " << c << endl << endl; 
}