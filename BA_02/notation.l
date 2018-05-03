%option noyywrap
%{

%}
sign	[+-]?
dot	(\.)
first	[1-9]
digit	[0-9]
normal	^{sign}{first}{dot}{digit}+(E){sign}{digit}+$
normal2	^{sign}{first}(E){sign}{digit}+$

%%

{normal}	{ ECHO; printf(" \n");  }
{normal2}	{ ECHO; printf(" \n");  }
.|\n	{/* do nothing */}

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}