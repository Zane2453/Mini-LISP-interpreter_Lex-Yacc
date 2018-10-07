%option noyywrap
%{

%}
item	[a-zA-Z]+
space	[ \r\t\n\f]+
noodle	^{item}{space}{item}{space}(noodles){space}{item}$

%%

{noodle}	{ ECHO; printf(" \n");  }
.|\n	{/* do nothing */}

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}