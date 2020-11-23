#include <iostream>
using namespace std;

// Definition for singly-linked list.
struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

class Solution {
    
public:
    ListNode * head = NULL;
    ListNode* reverseListIterative();
    ListNode* reverseListRecursive(ListNode* head);
    void insert(int new_data);
    void print(ListNode* head);
};

ListNode* Solution::reverseListIterative() {       
    if(head == NULL) // check for NULL list
        return head;  

    ListNode* p1 = head;        // 1->2->3->NULL
    ListNode* p2 = NULL;        // NULL
    ListNode* p3 = p1->next;    // 2->3->NULL
    
    p1->next = NULL;            // 1->(NULL)
    while(p3!= NULL){
        p2 = p3;                // 2->3->NULL
        p3 = p3->next;          // 3->NULL

        p2->next = p1;          // 2->(1->NULL)
        p1 = p2;                // 2->1->NULL
        //print(head);
    }
    head=p1; // ***DO you want to change original or create a new reversed list? 
    return p1;
}
ListNode* Solution::reverseListRecursive(ListNode* head) { // *** DIDN"T FIX YET
    //recursive 
    if(!head || !(head -> next)) return head;
    
    ListNode *node = reverseListRecursive(head->next);
    head -> next -> next = head;
    head -> next = NULL;
    return node;   
}
     
void Solution::insert(int new_data) { //insert new node at front of list
    /* ListNode* new_node = (ListNode*) malloc(sizeof(struct ListNode));
    new_node->val = new_data;
    new_node->next = head; */
    ListNode* new_node = new ListNode(new_data, head);
    head = new_node;
}    

void Solution::print(ListNode* head) {
    ListNode * curr; 
    curr = head; 
    while(curr != NULL) {
        cout << curr-> val << endl; 
        curr = curr -> next;
    }
    cout<<"NULL"<<endl;
}

/* 
Given:  1->2->3->NULL
Goal:   3->2->1->NULL 
*/
int main() {
    Solution test;
    int n = 3;
    for(int i = n; i > 0; i--) {
        test.insert(i);
    }
    test.print(test.head); 
    cout<<endl;

    test.print(test.reverseListIterative());
    cout<<endl;
    test.print(test.head); 

}