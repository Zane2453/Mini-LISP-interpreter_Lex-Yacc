%option noyywrap
%{
	#include <iostream>
	using namespace std;
    #include "y.tab.h"
    #include <string>
    void yyerror(const char *);
%}

%%
[0-9]+ {
    yylval.intVal = atoi(yytext);
    return NUM;
}
"add" {
    return ADD;
}
"inc"	{
	return INC;
}
"sub" {
	return SUB;
}
"dec" {
	return DEC;
}
"mul" {
	return MUL;
}
"mod" {
	return MOD;
}
"load" {
    return LOAD;
}

. {
	
}

%%