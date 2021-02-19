// Reverse String Inplace
#include <iostream> 
#include <string> 
#include <vector>
using namespace std;


vector<char> reverseString(vector<char>& s)  {
    int n = s.size(); // size of string
    for(int i = 0; i < n/2; i++) {
        auto tmp = s[n - i - 1]; // last elem
        s[n - i - 1] = s[i];    //
        s[i] = tmp;
    }           
    
    return s; 
}


int main() {
    string str = "Austin";
    vector<char> strExample;
    int n = str.size();
    
    for(int i = 0; i < n; i++) { // populate the vector 
        strExample.push_back(str[i]);
    }

    vector<char> answer = reverseString(strExample);
    for(int i = 0; i < n; i++) { // populate the vector 
        cout<<answer[i];
    }
}