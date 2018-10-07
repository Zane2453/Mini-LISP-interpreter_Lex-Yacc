%option noyywrap
%{

%}
start	[a-zA-Z_$]?[a-zA-Z0-9_$]*
end	[a-zA-Z0-9_$]*
cpy	{start}(cpy){end}

%%

{cpy}	{ ECHO; printf(" \n");  }
.|\n	{/* do nothing */}

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}