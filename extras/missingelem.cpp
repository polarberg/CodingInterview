// Missing element in Array 
#include <iostream>
#include <vector>
using namespace std; 

int findMissingElem(vector<int> vec1, vector<int> vec2) { // can't pass entire Array as arg in c++. Hence passing pointer to array 
    int difference = 0; // 
    int s1 = vec1.size();
    int s2 = vec2.size();
    int n = (s1 < s2) ? s1 : s2; // size of array
    for(int i = 0; i < n; i++) {
        difference += vec1[i] - vec2[i];
        cout<< difference;
    }
    int lastElemVal = (s1 > s2) ? vec1[s1-1] : vec2[s2-1]; // if size of array1 > lower (2nd array) return last elem of array1
    return difference + lastElemVal;
}

int xorFindMissingElem(vector<int> vec1, vector<int> vec2) { // XOR = (1^2^3^4...) ^ (1^2^4^5)
    /*
    A ^ 0 = A;
    A ^ A = 0;
    (A^B) ^ C = A ^ (B^C);
    (A ^ B) ^ B = A ^ (B^B) = A ^ 0 = A
    */
    int XOR = 0; 
    for(int x : vec1) {
        XOR ^= x;
    }
    for(int x : vec2) {
        XOR ^= x;
    }
    
    return XOR; 
}

int main() {
    vector<int> vec1 {1,2,3,4,5,6};
    vector<int> vec2 {1,2,4,5,6};

    cout << '\n' << findMissingElem(vec1,vec2) << endl;
    cout << xorFindMissingElem(vec1,vec2) << endl;

    return 0; 
}