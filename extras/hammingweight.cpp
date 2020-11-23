#include <iostream>

using namespace std; 

void PrintBinaryAndDecimal(unsigned int c) {
    cout << "Bin = ";
    for(int i = 31; i >= 0; --i) {
        cout << (((c >> i) % 2) ? '1' : '0');
    }

    cout << " : Dec = " << c << endl << endl; 
}

int hammingWeight(unsigned int n) {
        int s=0; // total number of 1's
        while(n) { //while n is != 0
            PrintBinaryAndDecimal(n); 
            PrintBinaryAndDecimal(n-1); 
            cout<<endl;
            s++;
            n&=(n-1);            
        }
        return s;
}   




int main() {
    unsigned int test = 115;  // 11101 16+8+4+1
    cout << hammingWeight(test);  
    return 0;
}
