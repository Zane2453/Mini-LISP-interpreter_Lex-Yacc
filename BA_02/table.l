%option noyywrap
%{

%}
unit	[0-9]
ten	[1-9][0-9]
onehund	(1[0-9][0-9])
twohund	(2[0-4][0-9]|25[0-5])
digit	{unit}|{ten}|{onehund}|{twohund}
ip	^{digit}\.{digit}\.{digit}\.{digit}$
first	[A-Z]
letter	[a-zA-Z]
word	^{first}{letter}*$
email	[a-zA-Z0-9]+
address	^{email}(@)({email}\.)+{email}$


%%

{word}	{ ECHO; printf(" is a word\n");  }
{ip}	{ ECHO; printf(" is an IP address\n");  }
{address}	{ ECHO; printf(" is an email address\n");  }
.|\n	{/* do nothing */}

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}