%option noyywrap
%{
#include "y.tab.h"
#include <stdio.h>
%}
digit	[0-9]
letter	[a-z]
number	0|[1-9]{digit}*|-[1-9]{digit}*
id	{letter}({letter}|{digit}|-)*
%%
"print-num"	{return PRINTNUM;}
"print-bool"	{return PRINTBOOL;}
"#t"|"#f"	{
			if(strcmp(yytext,"#t")==0)
				yylval.boolval=1;
			else
				yylval.boolval=0;
			return BOOL;}
{number}	{yylval.intval=atoi(yytext); return NUMBER;}
"+"	{return ADD;}
"-"	{return SUB;}
"*"	{return MUL;}
"/"	{return DIV;}
"mod"	{return MOD;}
">"	{return BIG;}
"<"	{return SMALL;}
"="	{return EQU;}
"and"	{return AND;}
"or"	{return OR;}
"not"	{return NOT;}
"define"	{return DEF;}
"fun"	{return FUN;}
"if"	{return IF;}
{id}	{yylval.strval=strdup(yytext); return ID;}
"("|")"	{return yytext[0];}
.|\n	{}
%%