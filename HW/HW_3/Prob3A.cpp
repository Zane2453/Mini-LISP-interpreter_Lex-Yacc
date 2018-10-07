#include<iostream>
#include<fstream>
#include<string>
#include <regex>
using namespace std;
int main(){
    string s;
    bool check=0;
    regex reg("([A-Za-z_\$])*(cpy)[A-Za-z0-9_\$]*");
    smatch sm;
    while(getline(cin,s)){
        while( regex_search(s, sm, reg) ){

            cout<<sm[0];
            cout << endl;

            s = sm.suffix().str();
        }
    }
    return 0;
}
