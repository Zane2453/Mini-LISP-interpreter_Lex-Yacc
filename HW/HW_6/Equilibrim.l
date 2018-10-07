%option noyywrap
%{
#include "y.tab.h"
#include <stdio.h>
int i,temp;
%}
%%
[A-Z][a-z]?	{yylval.strval = strdup(yytext); return CHAR;}
[0-9]+	{yylval.intval=atoi(yytext); return NUM;}
"("|")"	{return yytext[0];}
"+"	{return PLUS;}
"->"	{return TO;}
\n	{return 0;}
.	{}
%%