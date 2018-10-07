#include<iostream>
#include<fstream>
#include<string>
using namespace std;
int main(){
    string s,s_output;
    int end,count=0;
    char id1,id2,q1,q2;
    bool check=0;
    getline(cin,s);
    for(int i=0;i<s.length();i++){
        if(s[i]=='¡§'||s[i]=='"'||s[i]==92||s[i]=='¡¨'){
            end=i;
            count++;
        }
    }

    if(count!=2){
        check=1;
    }
    if(s[0]!='s'||s[1]!=' '||s[3]!=' '){
        check=1;
    }
    else if(s[2]<97||s[2]>122||s[2]=='p'||s[2]=='s'){
        check=1;
    }
    else if(s[4]!='¡§'&&s[4]!='"'&&s[4]!=92&&s[4]!='¡¨'){
        check=1;
    }
    else if(s[end]!='¡§'&&s[end]!='"'&&s[end]!=92&&s[end]!='¡¨'){
        check=1;
    }
    else{
        for(int i=5;i<end;i++){
            if(s[i]<48||(s[i]>57&&s[i]<65)||(s[i]>90&&s[i]<97)||s[i]>122){
                check=1;
            }
            else
                s_output=s_output.assign(s,0,end+1);
        }
    }

    getline(cin,s);
    if(s[0]!='p'||s[1]!=' ')
        check=1;
    else if(s[2]<97||s[2]>122||s[2]=='p'||s[2]=='s'){
        check=1;
    }

    if(check==1)
        cout<<"valid input";
    else{
        cout<<"strdcl s"<<endl<<"id "<<s_output[2]<<endl<<"quote "<<s_output[4]<<endl<<"string ";
        for(int i=5;i<end;i++)
            cout<<s_output[i];
        cout<<endl<<"quote "<<s_output[end]<<endl<<"print p"<<endl<<"id "<<s[2];
    }

    return 0;
}
