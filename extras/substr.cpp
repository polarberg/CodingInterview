#include <iostream>
#include <string>

using namespace std; 

int main () 
{
    string str="abcd edf";
    int n = str.length();
    string str2=str.substr(5);
    string str3=str.substr(-3+n);
    string str4=str.substr(0,4);  // total=(-) substr(total) + substr(0,n-total)
    cout<<str2<<endl;
    cout<<str3<<endl;
    cout<<str4<<endl;


    return 0; 
}