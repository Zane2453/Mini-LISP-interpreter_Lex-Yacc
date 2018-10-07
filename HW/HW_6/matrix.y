%{
#include <stdio.h>
#include <string.h>
int yylex();
int check=0,ans=0;
void yyerror(const char* message) {
    printf("Invaild format\n");
};

%}
%union {
    int	intVal;
    int mat[2];
}
%token <intVal> NUMBER
%token <intVal> MUL ADD SUB
%type <mat> expression
%token TRAN END
%left ADD SUB
%left MUL 
%right TRAN
%%
input
    : expression {
		if(check==1){
			printf("Semantic error on col %d\n", ans); 
			check=0;
			ans=0;
		}
		else{
			printf("Accepted\n"); 
		}
    }
    ;
expression
	: '[' NUMBER ',' NUMBER ']' {
        $$[0]=$2;
        $$[1]=$4;
    } 
	| '(' expression ')' {
		$$[0]=$2[0];
        $$[1]=$2[1];
    }
    | expression MUL expression {
    	if($1[1]!=$3[0]){
    		if(check==0)
    			ans=$2;
    		check=1;
    	}
    	$$[0]=$1[0];
        $$[1]=$3[1];
    }
    | expression ADD expression {
    	if($1[0]!=$3[0] || $1[1]!=$3[1]){
    		if(check==0)
    			ans=$2;
    		check=1;
    	}
    	$$[0]=$1[0];
        $$[1]=$1[1];
    }
    | expression SUB expression {
    	if($1[0]!=$3[0] || $1[1]!=$3[1]){
    		if(check==0)
    			ans=$2;
    		check=1;
    	}
    	$$[0]=$1[0];
        $$[1]=$1[1];
}
    | expression TRAN {
    	$$[0]=$1[1];
    	$$[1]=$1[0];
    }
    ;
%%
int main() {
    yyparse();
    return 0;
}
