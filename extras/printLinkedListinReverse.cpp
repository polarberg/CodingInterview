/* 
print linked List in Reverse

    1 -> 2 -> 3 -> NULL

    3
    2
    1
*/

struct Node {
    int data;
    Node *next;
    Node() : val(0), next(nullptr) {}
    Node(int x) : data(x), next(nullptr) {}
    Node(int x, Node *next) : data(x), next(next) {}
}

class Solution 
{
private:
    /* data */
public:
    Solution (/* args */);
    ~Solution ();

    void printReverseList(Node *head) {
        if(head == nullptr)
            return;
        
        stack<int> reversedData;
        while(head != NULL) {   // O(n) Space and Time - iterate through LL until NULL
            reversedData.push(head->data);
            head = head->next;
        }

        while(!reversedData.empty()) {
            cout<< reversedData.pop() << endl; 
        }
    }



Node(0) 
for()

}