/*  
    f[0]=0 
    f[1]=1
    f[i]=f[i-1]+f[i-2] 
 */

#include <iostream> 
using namespace std;

int FibConstSpace(int n) { // 0 1 1 2 3 5 8 
    int f[2] = {0,1};
    
    if(n < 2) 
        return f[n];
    
    int s = 0;
    for(int i = 2; i <= n; i++) {
        s = f[0] + f[1]; //f[i]=f[i-1]+f[i-2] 
        f[0]=f[1];
        f[1]=s; 
    }
    
    return s;
}

int main() {
    int n; 
    cin>>n;
    cout << FibConstSpace(n);
}