#include <iostream>
using namespace std;

int main() {

cout<<"i++\n";
int i = 5; 
int j = i++; 
cout<<"i:"<<i<<endl; // 6
cout<<"j:"<<j<<endl; // 5

cout<<"++i\n";
i = 5; 
j = ++i; 
cout<<"i:"<<i<<endl; // 6
cout<<"j:"<<j<<endl; // 6

cout<<"i--\n";
i = 5; 
j = i--; 
cout<<"i:"<<i<<endl; // 6
cout<<"j:"<<j<<endl; // 5

cout<<"--i\n";
i = 5; 
j = --i; 
cout<<"i:"<<i<<endl; // 6
cout<<"j:"<<j<<endl; // 6
}