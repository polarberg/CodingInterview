// Reverse String (in-place)
#include <iostream>
#include <vector>
#include <stdio.h> 
#include <time.h>
using namespace std; 

#define print(test) for(auto x : test) {cout<<x;}

void reverseString(vector<char>& s) {
    // switches front and last chars going inwards 
    int n = s.size();
    for(int i = 0; i < n/2; i++) {
        auto temp = s[i];       // store left in tmp
        s[i] = s[n - i - 1];    // replace left with right 
        s[n - i - 1] = temp;    // replace right with temp (left)
    }
    return;
}

void reverseString_CharArray(char *s, int n) { 
    for(int i = 0; i < n/2; i++) {
        auto temp = s[i];       // store left in tmp
        s[i] = s[n - i - 1];    // replace left with right 
        s[n - i - 1] = temp;     // replace right with temp (left)
    }
    return;
}
void _print(char *arr, unsigned int n) { 
    int i; 
    for (i=0; i<n; i++) 
        printf("%c", arr[i]); 
} 

//void reverseS(vector<char>)
int main(int argc, char *argv[]) { 
    // argc: # of commanline arg (2 if we pass an argument)
    // argv[0]: name of program
    // argv[argc-1]: command-line arguments
    
    // Using Vector 
    cout << "Using Vector" << endl;
    clock_t tStart = clock();

    vector<char> test{'h','e','l','l','o'};
    //for(auto x : test) {cout<<x;}
    print(test)
    cout<<endl;
    
    reverseString(test);
    print(test);

    printf("\nTime taken: %.7fs\n\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);


    // Using Char Array
    cout << "Using Char Array" << endl;
    cout << "hello" << endl;
    tStart = clock(); 

    char arr[] = {'h','e','l','l','o'};
    unsigned int n = sizeof(arr)/sizeof(arr[0]);
    reverseString_CharArray(arr, n);
    _print(arr, n);

    printf("\nTime taken: %.7fs\n\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);


    // Taking input from command line 
    cout << "Taking input from command line" << endl;
    _print(argv[1], n); cout<< endl;
    if(argc > 1) {
        n = sizeof(argv[1])/sizeof(argv[1][0]) + 1;
        reverseString_CharArray(argv[1], n);
        _print(argv[1], n); 
    }

    return 0;
}
