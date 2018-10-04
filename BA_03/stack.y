%{
	#include <stack>
	//stack<int> s;
	int s[100];
	int pointer=0;
	bool check=0;
	int temp1,temp2;
%}

%code requires {
    #include <iostream>
    using namespace std;

    int yylex(void);
    void yyerror(const char *);

    struct Type {
        int intVal;
    };
    
    #define YYSTYPE Type  // for cpp and c (bison itself) compatibility
}

%token <intVal> NUM
%token LOAD ADD SUB INC DEC MUL MOD
%%
in
	: input {
		if(check)
			cout<<"Invalid format";
		else if(pointer!=1)
			cout<<"Invalid format";
		else
			cout<<s[pointer];
	}
	; 
input
    : input stmt {
        //cout<<s[pointer]<<endl;
    }
    | stmt {
    	//cout<<s[pointer]<<endl;
    }
    ;
stmt
	: LOAD NUM {
		s[++pointer]=$2;
	}
	| ADD {
		if(pointer != 0){
			temp1= s[pointer--];
		}
		else
			check=1;
		if(pointer != 0){
			temp2= s[pointer--];
		}
		else
			check=1;
		if(!check)
			s[++pointer]=temp1+temp2;
	} 
	| SUB {
		if(pointer != 0){
			temp1= s[pointer--];
		}
		else
			check=1;
		if(pointer != 0){
			temp2= s[pointer--];
		}
		else
			check=1;
		if(!check)
			s[++pointer]=temp1-temp2;
	}
	| INC {
		if(pointer != 0){
			temp1= s[pointer--];
		}
		else
			check=1;
		if(!check)
			s[++pointer]=temp1+1;
	}
	| DEC {
		if(pointer != 0){
			temp1= s[pointer--];
		}
		else
			check=1;
		if(!check)
			s[++pointer]=temp1-1;
	}
	| MUL {
		if(pointer != 0){
			temp1= s[pointer--];
		}
		else
			check=1;
		if(pointer != 0){
			temp2= s[pointer--];
		}
		else
			check=1;
		if(!check)
			s[++pointer]=temp1*temp2;
	}
	| MOD {
		if(pointer != 0){
			temp1= s[pointer--];
		}
		else
			check=1;
		if(pointer != 0){
			temp2= s[pointer--];
		}
		else
			check=1;
		if(!check)
			s[++pointer]=temp1%temp2;
	}
	;
%%
void yyerror(const char *message) {
    cout<<"Invalid format"<<endl;
}

int main() {
    yyparse();
    return 0;
}