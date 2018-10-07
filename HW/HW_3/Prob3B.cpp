#include<iostream>
#include<fstream>
#include<string>
#include <regex>
using namespace std;
int main(){
    string s;
    int count=0;
    regex reg("^[A-Za-z0-9_]*\\s*[A-Za-z0-9_]*\\s*(noodles)\\s*[A-Za-z0-9_]*$");
    smatch sm;

    while(getline(cin,s)){
        while(regex_match(s, reg)){
            cout<<s<<endl;
            break;
        }
    }
    return 0;
}
