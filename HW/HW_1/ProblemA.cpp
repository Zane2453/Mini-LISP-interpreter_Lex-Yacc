#include<iostream>
#include<fstream>
#include<cstring>
using namespace std;
int main(){
    string s;
    int val=0;
    bool check=0;
    getline(cin,s);
    if(s[0]<97||s[0]>122)
        cout<<"valid input";
    else if(s[2]!='=')
        cout<<"valid input";
    else if(s[3]!=' ')
        cout<<"valid input";
    else{
        if(s[4]>=97&&s[4]<=122&&s.length()!=5)
            cout<<"valid input";
        else if(s[4]>=97&&s[4]<=122&&s.length()==5)
            cout<<"id "<<s[0]<<endl<<"assign ="<<endl<<"id "<<s[4];
        else{
            for(int i=4;i<s.length();i++){
                if(s[i]<48||s[i]>57){
                    check=1;
                    break;
                }
                else
                    val=val*10+(s[i]-48);
            }
            if(check==1)
                cout<<"valid input";
            else
                cout<<"id "<<s[0]<<endl<<"assign ="<<endl<<"inum "<<val;
        }
    }
    return 0;
}
