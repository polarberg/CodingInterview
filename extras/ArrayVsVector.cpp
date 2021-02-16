#include <bits/stdc++.h> 
using namespace std; 
  
int main() 
{ 
    int n; 
    cin>>n;
    int* arr = new int[n]; // Dynamic Implementation 
    delete[] arr; // array Explicitly deallocated 
  
    vector<int> v; // Automatic deallocation when variable goes out of scope 
    return 0; 
} 