// Petr and a Combination Lock
// https://codeforces.com/problemset/problem/1097/B

#include <algorithm>
#include <iostream>
#include <cstring>
#include <cstdio>
#include <time.h>
using namespace std;

typedef long long ll;
int a[20];
int n;

int main(){
    cin>>n;
    for(int i=0;i<n;i++){
        scanf("%d",a+i);
    }

    clock_t tStart = clock();

    bool flag=false;
    for(int i=0;i<1<<n;i++){
        int ans=0;
        for(int j=0;j<n;j++){
            if(i&(1<<j)){
                ans+=a[j];
            }else{
                ans-=a[j];
            }
        }
        if(ans%360==0){
            flag=true;
            break;
        }
    }
    if(flag){
        printf("YES");
    }else{
        printf("NO");
    }

    printf("\nTime taken: %.4fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);
    return 0;
}