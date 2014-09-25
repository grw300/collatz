#include <iostream>

using namespace std;


int cache[100000];
//map<int, int> cache;

//int next_number(int n){
//
//    if ((n % 2) == 0)
//        return n / 2;
//    else
//        return n + (n >> 1) + 1;
//}

int cycle_counter(int n){
    if (n == 1) return 1;

    if ((n < 100000) && (cache[n] != 0)) return cache[n];
    
    int length;

    if ((n % 2) == 0)
        length = 1 + cycle_counter(n / 2);
    else
        length = 2 + cycle_counter(n + (n >> 1) + 1);

    if (n < 100000) cache[n] = length;

    return length;
}

//int cycle_counter(int n){
//    int c = 1;
//
//
//
//    int m = n;
//    while (n > 1){
//
//        if ((n % 2) == 0){
//            n = n / 2;
//
//        }
//        else{
//            n = n + (n >> 1) + 1;
//            c ++;
//        }
//                if ((n < 100000) && (cache[n] != 0)) {
//                c += cache[n];
//                break;
//        }
//        
//        
//        c++;
//
//    }
//
//
//    if (m < 100000) cache[m] = c;
//
//    return c;
//
//}

int highest_cycle_count(int start, int end){
    int current_cycle = 0;
    int highest_cycle = 0;

    if (start > end)
        swap(start, end);

    int half_test = end / 2 + 1;

    if (half_test > start) start = half_test;

    for(int i = start; i <= end; i++){
        current_cycle = cycle_counter(i);
        if (current_cycle > highest_cycle)
            highest_cycle = current_cycle;
    }
    return highest_cycle;
}

int main () {
    int a;
    int b;

    while(cin >> a >> b){
        cout << a << ' ' << b << ' ' << highest_cycle_count(a, b) << endl;
    }

    return 0;
}
