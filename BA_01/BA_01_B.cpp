#include <iostream>
#include <string>
#include <stack>
#include <vector>
#include <utility>
using namespace std;

string input,test;
stack <int> s;
vector <pair <string, string>> output;
vector <int> error;
vector <string> in;
int innum=0;
bool ill=0, zero=0,space=0, non=1, seq=0;

void Print_error();

void Exp(){
    if( in[innum] == "OPERATOR"){
        innum++;
        Exp();
        Exp();
    }
    else if(in[innum] == "INT"){
       innum++;
    }
    else {
        ill=1;
    }
}

void TOExp(){
    if(in[innum] == "INT" || in[innum] == "OPERATOR"){
        Exp();
        if(innum != in.size()-1)
            ill=1;
    }
}

void TOExps(){
    if(in[innum] == "INT" || in[innum] == "OPERATOR"){
        TOExp();
        TOExps();
    }
    else ;
}

void program(){
    TOExps();
}

void read_formula(){
    int length = input.length();
    int start=0, count;

    for(int i = 0; i<length ; i++){
        if((input[i] == '+' || input[i] == '-') && input[i+1]>='0'&&input[i+1]<='9'){
            start = i;
            count=1;
            while(input[i+1]>='0'&&input[i+1]<='9'){
                count++;
                i++;
            }
            output.push_back(make_pair("sint", input.substr(start, count)));
        }
        else if(input[i]>='0'&&input[i]<='9'){
            start = i;
            count=1;
            while(input[i+1]>='0'&&input[i+1]<='9'){
                count++;
                i++;
            }
            output.push_back(make_pair("int", input.substr(start, count)));
        }
        else if(input[i]=='+'){
            output.push_back(make_pair("plus", "+"));
        }
        else if(input[i]=='-'){
            output.push_back(make_pair("minus", "-"));
        }
        else if(input[i]=='*'){
            output.push_back(make_pair("mul", "*"));
        }
        else if(input[i]=='/'){
            output.push_back(make_pair("div", "/"));
        }
        else if(input[i]==' '){
            continue;
        }
        else{
            error.push_back(i);
        }
    }

}

void eval_formula(){
    int count=0;
    bool sign=0, cycle=1;
    int val=0,v1,v2,op;
    for(int i=0;i<output.size();i++){
        if(output[i].first == "plus"){
            s.push(10000);
            count = 0;
        }
        else if(output[i].first == "minus"){
            s.push(10001);
            count = 0;
        }
        else if(output[i].first == "mul"){
            s.push(10002);
            count = 0;
        }
        else if(output[i].first == "div"){
            s.push(10003);
            count = 0;
        }
        else if(output[i].first == "int"){
            for(int j = 0;j <output[i].second.length();j++){
                val = val *10 + (output[i].second[j]-48);
            }
            s.push(val);
            val=0;

            count++;
        }
        else if(output[i].first == "sint"){
            if(output[i].second[0] == '-')
                sign=1;
            for(int j = 1;j <output[i].second.length();j++){
                val = val *10 + (output[i].second[j]-48);
            }
            if(sign == 1){
                val = -val;
                sign = 0;
            }
            s.push(val);
            val=0;

            count++;
        }


        if(count==2){
            while(cycle&&s.size()>1){
                v1=s.top();
                s.pop();
                if(s.empty()){
                    ill=1;
                    break;
                }
                v2=s.top();
                s.pop();
                if(s.empty()){
                    ill=1;
                    break;
                }
                op=s.top();
                s.pop();

                if(op==10000)
                    v2=v1+v2;
                else if(op==10001)
                    v2=v2-v1;
                else if(op==10002)
                    v2=v2*v1;
                else if(op==10003){
                    if(v1 == 0){
                        zero = 1;
                        break;
                    }
                    v2=v2/v1;
                }
                if(!s.empty()){
                    v1 = s.top();
                    if(v1==10000||v1==10001||v1==10002||v1==10003)
                        cycle=0;
                    else
                        cycle=1;
                }

                s.push(v2);

                if(s.size()==1 && i !=output.size()-1){
                    seq=1;
                    break;
                }
            }
            cycle=1;
            count=1;
        }
        if(seq || zero)
            break;
    }
    while(s.size()!=1 && zero !=1 &&ill!=1 &&seq!=1){
        v1=s.top();
        s.pop();
        v2=s.top();
        s.pop();
        op=s.top();
        s.pop();

        if(op==100)
            v2=v1+v2;
        else if(op==101)
            v2=v2-v1;
        else if(op==102)
            v2=v2*v1;
        else if(op==103){
            if(v1 == 0){
                zero = 1;
                break;
            }
            v2=v2/v1;
        }
        s.push(v2);
    }
    if(zero == 1 && seq == 0)
        Print_error();
    else if(ill==1){
        cout<<"> Error: Illegal formula!"<<endl;
        ill=0;
    }
    else if(s.empty());
    else
        cout<<"> "<<s.top()<<endl;
    while(!s.empty())
        s.pop();
    seq=0;
}

void Print_error(){
    if(error.size() >0){
            int pos,start,endp;
            pos = error[0];
            while( input[pos]!=' '&& input[pos]!='+'&&input[pos]!='-'&&input[pos]!='/' && pos >0)
                pos--;
            if( pos == 0 &&input[pos]!=' '&& input[pos]!='+'&&input[pos]!='-'&&input[pos]!='/')
                start = pos;
            else if(input[pos+1]>='0'&&input[pos+1]<='9'&&(input[pos]=='+' || input[pos]=='-'))
                start = pos;
            else
                start = pos+1;
            pos = error[0];
            while(input[pos]!=' '&& input[pos]!='+'&&input[pos]!='-'&&input[pos]!='/'&& pos <input.length())
                pos++;
            if( pos == input.length() &&input[pos]!=' '&& input[pos]!='+'&&input[pos]!='-'&&input[pos]!='/')
                endp = pos-1;
            else
                endp=pos-1;
            cout<<"> Error: Unknown token ";
            for(int j=start;j<=endp;j++)
                cout<<input[j];
            cout<<endl;
    }
    else if(zero == 1){
        cout<<"> Error: Divide by ZERO!"<<endl;
        zero=0;
    }

}

int main(){
    cout<<"Welcome use our calculator!"<<endl;
    while(1){
        if(cin.eof())
            break;
        getline(cin,input);
        if(input == test && non==0){
            input.clear();
            space = 1;
        }
        if(input == " "){
            cout<<"> ";
            break;
        }
        else if(input.length()==0)
            cout<<"> ";
        else{
            non=0;
            read_formula();
            if(error.size() == 0){
                for(int i=0;i<output.size();i++){
                    if(output[i].first == "sint" || output[i].first == "int")
                        in.push_back("INT");
                    else
                        in.push_back("OPERATOR");
                }
                in.push_back(" ");
                program();
                eval_formula();
            }
            else
                Print_error();
            test = input.substr(0, input.length());
            output.clear();
            error.clear();
            in.clear();
            innum = 0;
        }
    }
    cout<<"ByeBye~";
}
