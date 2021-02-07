#include <iostream>
#include <vector>
#include <string>

using namespace std; 

class Solution {
public:
    vector<string> fizzBuzz(int n) {
        // intialize vector filling it all in with numbers
        // create bitset multiples of 3 
        // create bitset multiples of 5
        // Find intersection (&)
        // replace 3's with fizz
        
        vector<string> answer(n);
        for(int i = 1; i <= n; i++) {    // numbers
            answer[i-1] = to_string(i);
        }
        
        for(int i = 2; i < n; i += 3)   {
            answer[i] = "Fizz";
        }
        for(int i = 4; i < n; i += 5)   {
            answer[i] = "Buzz";
        }
        for(int i = 14; i < n; i += 15)   {
            answer[i] = "FizzBuzz";
        }
        
        return answer; 
    }

    void print(vector<string> const &a) {
        cout << "The vector elements are : " << endl;

        for(int i = 0; i < a.size(); i++) {
            cout << a.at(i) << endl;
        }
    }
};

int main() {
    Solution test; 
    test.print(test.fizzBuzz(40));
}