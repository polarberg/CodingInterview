#include <iostream>
using namespace std; 
#include <vector>
#include <array>
#include <string> 
#include <time.h>
using namespace std; 
int main() {
    /* initialize random seed: */
    srand (time(NULL));
    cout << "input string: "; 
    char arr[] = {'h','e','l','l','o'};
    /* cin >>   */
    for (auto c : arr) {
        cout<<c;
    }
    cout << '\n';
    vector<int> :: iterator iter = ;

    for (int i=0, j=7; i<j; ++i, --j) {
        cout<<i<<" "<<j<<endl;
    }
    /* auto reverseString!(vector<char>& s) {
        int 
    } */
    array<int,5> myarray = { 2, 16, 77, 34, 50 }; 
    cout << "myarray contains:";
    for (auto it = myarray.begin(); it != myarray.end(); ++it) {
        cout << ' ' << *it;
    }
    
    cout << '\n';
/*     for (auto it = myarray.begin(), e = myarray.end(); it != e; ++it, e--) {
        cout << ' ' << *it;
    } */

    return 0;

}