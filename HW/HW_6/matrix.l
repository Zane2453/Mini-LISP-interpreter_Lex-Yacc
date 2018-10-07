%option noyywrap
%{
#include "y.tab.h"
#include <stdio.h>
int count=0;
%}
%%
[0-9]+	{count=count+yyleng; sscanf(yytext, "%d", &yylval.intVal); return NUMBER;}
"["|"]"|","|"("|")"	{count=count+yyleng; return yytext[0];}
"+"	{count=count+yyleng; yylval.intVal=count; return ADD;}
"-"	{count=count+yyleng; yylval.intVal=count; return SUB;}
"*"	{count=count+yyleng; yylval.intVal=count; return MUL;}
"^T"	{count=count+yyleng; return TRAN;}
\n	{return 0;}
" "+	{count=count+yyleng;}
.	{}
%%