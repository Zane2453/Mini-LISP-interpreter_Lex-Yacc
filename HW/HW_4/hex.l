%{

%}
%option noyywrap
correct	(0X|0x)[0-9A-Fa-f]{1,8}$  
wrong	[^ \f\n\r\t\v]+(0X|0x)[^ \f\n\r\t\v]*  
exceed	(0X|0x)[0-9A-Fa-f]{9,}  
%%

{wrong}	{/*wrong start*/;}
{exceed}	{/*too long digit*/;}
{correct}	{ ECHO; printf(" \n");}
.|\n	{/* do nothing */}
%%
int main(int argc, char *argv[]) {
	yylex();
	return(0);
}
