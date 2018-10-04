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
"{"|"}"|"^" {
	
    return yytext[0];
}
"+"	{
	return ADD;
}
"-" {
	return SUB;
}
"\\frac" {
	
    return FRAC;
}

. {
	
}

%%