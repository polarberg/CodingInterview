#include <iostream>
#include <vector>

using namespace std; 
class Solution {
public:
    string stringShift(string s, vector<vector<int>>& shift) {
        int total = 0;
        for(vector<int> pp : shift) { // [[0,2] , [1,1]]
            if(pp[0] == 0) { // looking at first element in each 2d vector
                total -= pp[1];
            }
            else {
                total += pp[1];
            }
        }
        int n = s.length();
        total %= n;
        if(total < 0) {
            total += n;
        }
        cout<<"total: "<<total<<endl;
        cout<<s.substr(n-total)<<endl;
        // ABCDE
        return s.substr(n-total) + s.substr(0, n-total);
    }
};

int main() {
    Solution str;
    vector<vector<int>> shifts = {{0,2} ,{1,5}, {0,9}};
    cout<<str.stringShift("abcd", shifts);
    return 0; 
}