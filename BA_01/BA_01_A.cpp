#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <utility>
using namespace std;

stringstream s;
string input,strlit,semi,exp,id,tail,dot;
vector <pair <string, string>> output;
pair <string, string> temp;

bool check = 0;


void Prog();
void Stms();
bool Stm();
bool Exp();
bool Primary();
bool Primary_tail();
bool Match(string value,string type);

void Prog(){
    Stms();
}

void Stms(){
    check = !Stm();
}

bool Stm(){
    if(input[0] == '"'){
        strlit = input.substr (0, input.length() -1) ;
        semi = input.substr(input.length() -1, 1);
        if(!Exp() || !Match (semi, "SEMICOLON"))
            return false;
    }
    else if((input[0] >='A' && input[0] <= 'Z') || (input[0] >='a' && input[0] <= 'z') || input[0] == '_' ){
        exp = input.substr (0, input.length() -1) ;
        semi = input.substr(input.length() -1, 1);
        if(!Primary() || !Match (semi, "SEMICOLON"))
            return false;
    }
    else
        return false;
    return true;
}

bool Exp(){
    int length = strlit.length() ;
    if(strlit[length-1] != '"')
        return false;
    else {
        for(int i = 1; i < length-1 ; i++){
            if(strlit[i] == '"')
                return false;
        }
        temp = make_pair("STRLIT", strlit);
        output.push_back(temp);
    }
    return true;
}

bool Primary(){
    int p=0;
    while(exp[p] != ' ' && p < exp.length()){
        p++;
    }
    id = exp.substr(0, p);
    if(p != exp.length()){
        tail = exp.substr(p+1, exp.length() - p);
        if(!Match(id, "ID") || ! Primary_tail())
            return false;
    }
    else{
        if(!Match(id, "ID"))
            return false;
    }
    return true;
}

bool Primary_tail(){
    int p;
    if(tail[0] == '.'){
        dot = tail.substr(0,1);
        p = 2;
        while(tail[p] != ' ')
            p++;
        id = tail.substr(0, p);
        tail = tail.substr(p+1, tail.length() - p);
        if( Match(dot,"DOT") || Match(id,"ID") || Primary_tail())
            return false;
    }
    else if(tail[0] == '('){
        for(int i = 1;i<tail.length();i++){
            if(tail[i] == ')'){
                p = i;
                exp = tail.substr(2, p-3);
                tail = tail.substr(p+1, tail.length()-p);
                if(!Exp() || !Primary_tail())
                    return false;
            }
        }
    }
    else if(tail.length() == 0)
        return false;
    return true;

}

bool Match(string value,string type){
    if(type == "ID"){
        if(value[0] <'A' || (value[0] >'Z' && value[0] < '_') || (value[0] >'_' && value[0] < 'a') || value[0]>'z')
            return false;
        else{
            for(int i=1;i<value.length();i++){
                if(value[i] <'0' || (value[i] >'9' && value[i] < 'A') || (value[i] >'Z' && value[i] < '_') || (value[i] >'_' && value[i] < 'a') || value[0]>'z')
                    return false;
            }
            temp = make_pair(type, value);
            output.push_back(temp);
        }
    }
    else if(type == "SEMICOLON"){
        if(value[0] != ';' || value.length() >1)
            return false;
        else{
            temp = make_pair(type, value);
            output.push_back(temp);
        }
    }
    else if(type == "DOT"){
        if(value[0] != '.' || value.length() >1)
            return false;
        else{
            temp = make_pair(type, value);
            output.push_back(temp);
        }
    }
    return true;

}


int main(){
    output.clear();
    while(1){
        getline(cin, input);
        if(input.length() == 0)
            break;
        else{
            Prog();
            input.clear();
        }
    }
    if(check ==1)
        cout<<"invalid input"<<endl;
    else{
        for(int i=0; i<output.size(); i++)
            cout<<output[i].first<<" "<<output[i].second<<endl;
    }

}
