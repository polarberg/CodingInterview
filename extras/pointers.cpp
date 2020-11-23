#include <iostream>

using namespace std;

int main () {
   int  x = INT32_MAX;   // actual variable declaration.
   int  *ptr;     // pointer variable 
   ptr = &x;      // store address of var in pointer variable

   cout << "Value of var variable: ";
   cout << x << endl;

   // print the address stored in ip pointer variable
   cout << "Address stored in ip variable: ";
   cout << ptr << endl;

   // access the value at the address available in pointer
   cout << "Value of *ip variable: ";
   cout << *ptr << endl;

   return 0;
}