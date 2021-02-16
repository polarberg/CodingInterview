// Minstack 
/*  Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.

    push(x) -- Push element x onto stack.
    pop() -- Removes the element on top of the stack.
    top() -- Get the top element.
    getMin() -- Retrieve the minimum element in the stack. */
#include <iostream>
#include <stack>

using namespace std;  

class MinStack {
public:
    
    /*
    4 , 6 , 3 , 2
    (current element, min elem)
    (4, 4)    
    (6, 4)
    (3, 3)
    (2, 2) */
    
    /** initialize your data structure here. */
    stack<pair<int,int>> s;
    
    MinStack() {
     
    }
    
    void push(int x) {
        if(s.empty())   // if stack empty
            s.push({x, x}); // push to stack, only one val so it is also the min
        else{
            s.push({x, min(x, s.top().second)});
        } 
    }
    
    void pop() {
        if(!s.empty()) {
            s.pop();
        }
    }
    
    int top() {
        return s.top().first;         
    }
    
    int getMin() {
        return s.top().second; 
    }

    void print() { // prints pair<int,int> => (current element, min elem)
        cout << "(" << s.top().first << "," << s.top().second << ")" << endl;
    }
};

int main() {
    MinStack minStack;
    cout<<"(current element, min elem)\n";
    minStack.push(-2);  minStack.print(); 
    minStack.push(0);   minStack.print(); 
    minStack.push(-3);  minStack.print(); 
    minStack.getMin();  minStack.print();   // return -3
    minStack.pop();     minStack.print(); 
    minStack.top();     minStack.print();   // return 0
    cout<<minStack.getMin();    // return -2
}