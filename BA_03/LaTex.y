%{
	#include <cmath>
	#include <iomanip>
    bool check=0;
    float temp1,temp2;
    int ans=0;
%}

%code requires {
    #include <iostream>
    using namespace std;

    int yylex(void);
    void yyerror(const char *);

    struct Type {
        int intVal;
        float floatVal;
    };
    
    #define YYSTYPE Type  // for cpp and c (bison itself) compatibility
}

%token <intVal> NUM
%token FRAC ADD SUB
%type <floatVal> expr fra stmt input expa
%left ADD SUB
%%
in
	: input {
		cout<<fixed<<setprecision(3)<<$1;
	}
input
    : input ADD stmt {
        $$ = $1 + $3;
    }
    | input SUB stmt {
    	$$ = $1 - $3;
    }
    | stmt {
    	$$ = $1;
    }
    ;
stmt
	: NUM '^' expr {
		$$ = pow($1, $3);
	}
	| fra '^' expr {
		$$ = pow($1, $3);
	} 
	| fra {
		$$ = $1;
	}
	;
expr
	: '{' expa '}' {
		$$ = $2;
	}
	| NUM {
		$$ = $1;
	}
expa
	: expa ADD expa {
		$$ = $1 + $3;
	}
	| expa SUB expa {
		$$ = $1 - $3;
	}
	| NUM {
		$$ = $1;
	}
	| fra {
		$$ = $1;
	}
	;
fra
	: FRAC '{' expa '}' '{' expa '}' {
		temp1=$3;
		temp2=$6;
		$$ = temp1 / temp2;
	}
	| FRAC '{' expa '}' '{' stmt '}' {
		temp1=$3;
		temp2=$6;
		$$ = temp1 / temp2;
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