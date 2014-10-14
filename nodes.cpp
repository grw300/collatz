#include <iostream>
#include <iterator>
#include <string>
#include <vector>
#include <queue>
#include <deque>
#include <stack>
#include <list>
#include <map>
#include <set>

using namespace std;

map<int,int> visited;

void search(int start, map <int, vector<int>> graph) {
    queue<int> s;
    s.push(start);
    visited[start]=0;
    while (s.empty() == false) {
        int top = s.front();
        s.pop();
        int size = graph[top].size();
        for (int i=0;i<size;i++){
            int n=graph[top][i];
            if (!visited.count(n)){
                visited[n]=visited[top]+1;
                s.push(n);
            }
        }
    }
}

int main () {
    int nods,a,b,cases=1;
    while((cin >> nods) && nods){
        map <int,vector<int>> graph;
        for(int i=0; i<nods;i++){
            cin >> a >> b;
            graph[a].push_back(b);
            graph[b].push_back(a);
        }
        
        int ttl, start;
        while((cin >> start >> ttl) && (start!=0 || ttl !=0)){
            map<int,int>::const_iterator itr;
            visited.clear();
            search(start,graph);
            int result=0;
            for(itr = visited.begin(); itr != visited.end(); ++itr){
                if ((*itr).second>ttl) ++result;
            }
            result += graph.size()-visited.size();
            cout << "Case " << cases << ": " << result << " nodes not reachable from node " << start << " with TTL = " << ttl << ".\n";
            cases++;
        }
    }
}    