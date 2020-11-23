#include <iostream> 
using namespace std;

void PrintBinaryAndDecimal(unsigned int c) {
    cout << "Bin = ";
    for(int i = 31; i >= 0; --i) {
        cout << (((c >> i) % 2) ? '1' : '0');
    }

    cout << " : Dec = " << c << endl << endl; 
}

int main() {
    unsigned int c = 28;
    int shift = 2; // can be shifted by [0,31] 0 to anything less than the number of bits for 32 int 
    cout << "Original: " << endl; 
    PrintBinaryAndDecimal(c);

    cout << "Left-shifted: " << endl; 
    PrintBinaryAndDecimal(c << shift);

    cout << "Original: " << endl; 
    PrintBinaryAndDecimal(c >> shift);
    
    int a=5,b=7;
    int d= a & b;
    cout<<d;
    //cin.get(); 
    return 0; 
}