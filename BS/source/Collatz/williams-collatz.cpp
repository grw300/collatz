#include <cassert>
#include <string>
#include <iostream>
#include <sstream>
#include <vector>
using namespace std;

int cycle_counter(int n){
    int c = 1;
    assert(n > 0);

    while (n > 1){
        if ((n % 2) == 0)
            n = n / 2;
        else
            n = 3 * n + 1;

        c++;
    }

    assert(c > 0);

    return c;

}

int highest_cycle_count(int start, int end){
    int current_cycle = 0;
    int highest_cycle = 0;

    for(int i = start; i <= end; i++){
        current_cycle = cycle_counter(i);
        if (current_cycle > highest_cycle)
            highest_cycle = current_cycle;
    }
    return highest_cycle;
}

//vector<int> split_string(string str, char delimiter){
//    vector<int> split;
//    string item;
//    stringstream ss(str);
//    while (getline(ss, item, delimiter)){
//        if(!item.empty())
//            split.push_back(std::atoi(item.c_str()));
//    }
//    return split;
//}


int main () {

    string n;
    //vector<int> items;
    int a;
    int b;

    while(cin >> a >> b){
        //items = split_string(n,' ');
        cout << a << ' ' << b << ' ' << highest_cycle_count(a, b) << endl;
    }
    
    return 0;
}