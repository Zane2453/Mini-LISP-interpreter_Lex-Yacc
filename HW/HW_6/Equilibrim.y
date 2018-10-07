%{
#include <stdio.h>
#include <string.h>
int yylex();
void yyerror(const char* message) {
    printf("Invalid format\n");
};
struct element1 {
	int count;
	char* chem;
};
struct alldata1 {
	int length;
	struct element1 eles[10];
};
struct alldata1 left, right;
int i,j,temp,check=0;
%}
%union {
    int	intval;
    char* strval;
    struct element {
		int count;
		char* chem;
	}ele;
	struct alldata {
		int length;
		struct element eles[10];
	}all;
}
%token <intval> NUM
%token <strval> CHAR
%type <ele> expf 
%type <all> expr expa stmt
%token PLUS TO
%left TO
%left PLUS
%%
input
    : stmt TO stmt {
    	left.length=0;
    	temp=0;
    	for(i=65; i<91; i++){
    		for(j=0; j<$1.length; j++){
    			if($1.eles[j].chem[0]==i && strlen($1.eles[j].chem)==1){
    				if(check==0){
    					left.eles[temp].chem = strdup($1.eles[j].chem);
    					left.eles[temp].count = $1.eles[j].count;
    					check=1;
    				}
    				else{
    					left.eles[temp].count = left.eles[temp].count + $1.eles[j].count;
    				}
    			}
    		}
    		if(check==1){
    			temp++;
    			left.length++;
    		}
    		check=0;
    		for(j=0; j<$1.length; j++){
    			if($1.eles[j].chem[0]==i && strlen($1.eles[j].chem)==2){
    				if(check==0){
    					left.eles[temp].chem = strdup($1.eles[j].chem);
    					left.eles[temp].count = $1.eles[j].count;
    					check=1;
    				}
    				else{
    					left.eles[temp].count = left.eles[temp].count + $1.eles[j].count;
    				}
    			}
    		}
    		if(check==1){
    			left.length++;
    			temp++;
    		}
    		check=0;
    	}
    	right.length=0;
    	temp=0;
    	for(i=65; i<91; i++){
    		for(j=0; j<$3.length; j++){
    			if($3.eles[j].chem[0]==i && strlen($3.eles[j].chem)==1){
    				if(check==0){
    					right.eles[temp].chem = strdup($3.eles[j].chem);
    					right.eles[temp].count = $3.eles[j].count;
    					check=1;
    				}
    				else{
    					right.eles[temp].count = right.eles[temp].count + $3.eles[j].count;
    				}
    			}
    		}
    		if(check==1){
    			temp++;
    			right.length++;
    		}
    		check=0;
    		for(j=0; j<$3.length; j++){
    			if($3.eles[j].chem[0]==i && strlen($3.eles[j].chem)==2){
    				if(check==0){
    					right.eles[temp].chem = strdup($3.eles[j].chem);
    					right.eles[temp].count = $3.eles[j].count;
    					check=1;
    				}
    				else{
    					right.eles[temp].count = right.eles[temp].count + $3.eles[j].count;
    				}
    			}
    		}
    		if(check==1){
    			right.length++;
    			temp++;
    		}
    		check=0;
    	}
    	i=j=0;
    	while(i<left.length && j<right.length){
    		if(left.eles[i].chem[0] < right.eles[j].chem[0]){
    			printf("%s %d\n",left.eles[i].chem, left.eles[i].count);
    			i++;
    		}
    		else if(left.eles[i].chem[0] > right.eles[j].chem[0]){
    			printf("%s -%d\n",right.eles[j].chem, right.eles[j].count);
    			j++;
    		}
    		else{
    			if(left.eles[i].count < right.eles[j].count)
    				printf("%s -%d\n",right.eles[j].chem, right.eles[j].count - left.eles[i].count);
    			else if(left.eles[i].count > right.eles[j].count)
    				printf("%s %d\n",right.eles[j].chem, left.eles[i].count - right.eles[j].count);
    			i++;
    			j++;
    		}
    	}
    	for(;i<left.length;i++)
    		printf("%s %d\n",left.eles[i].chem, left.eles[i].count);
    	for(;j<right.length;j++)
    		printf("%s -%d\n",right.eles[j].chem, right.eles[j].count);
    }
    ;
stmt
	: expr PLUS stmt{
		$$.length=$1.length+$3.length;
		temp=$1.length;
		for(i=0; i<temp; i++){
			$$.eles[i].chem = strdup($1.eles[i].chem);
			$$.eles[i].count = $1.eles[i].count;
		}
		temp=$3.length;
		for(i=0; i<temp; i++){
			$$.eles[i+$1.length].chem = strdup($3.eles[i].chem);
			$$.eles[i+$1.length].count = $3.eles[i].count;
		}
	} 
	| expr{
		$$.length=$1.length;
		for(i=0; i<$1.length; i++){
			$$.eles[i].chem = strdup($1.eles[i].chem);
			$$.eles[i].count = $1.eles[i].count;
		}
	}
    ;
expr
	: expf{
		$$.length=1;
		$$.eles[0].chem = strdup($1.chem);
		$$.eles[0].count = $1.count;
	}
	| expr expr{
		$$.length=$1.length+$2.length;
		temp=$1.length;
		for(i=0; i<temp; i++){
			$$.eles[i].chem = strdup($1.eles[i].chem);
			$$.eles[i].count = $1.eles[i].count;
		}
		temp=$2.length;
		for(i=0; i<temp; i++){
			$$.eles[i+$1.length].chem = strdup($2.eles[i].chem);
			$$.eles[i+$1.length].count = $2.eles[i].count;
		}
	}
	| NUM expr{
		$$.length=$2.length;
		for(i=0; i<$2.length; i++){
			$$.eles[i].chem = strdup($2.eles[i].chem);
			$$.eles[i].count = $2.eles[i].count * $1;
		}
	}
	| '(' expa ')' NUM{
		$$.length=$2.length;
		for(i=0; i<$2.length; i++){
			$$.eles[i].chem = strdup($2.eles[i].chem);
			$$.eles[i].count = $2.eles[i].count * $4;
		}
	}
	;
expa
	: expf{
		$$.length=1;
		$$.eles[0].chem = strdup($1.chem);
		$$.eles[0].count = $1.count;
	}
	| expa expa{
		$$.length=$1.length+$2.length;
		temp=$1.length;
		for(i=0; i<temp; i++){
			$$.eles[i].chem = strdup($1.eles[i].chem);
			$$.eles[i].count = $1.eles[i].count;
		}
		temp=$2.length;
		for(i=0; i<temp; i++){
			$$.eles[i+$1.length].chem = strdup($2.eles[i].chem);
			$$.eles[i+$1.length].count = $2.eles[i].count;
		}
	}
	| '(' expa ')' NUM{
		$$.length=$2.length;
		for(i=0; i<$2.length; i++){
			$$.eles[i].chem = strdup($2.eles[i].chem);
			$$.eles[i].count = $2.eles[i].count * $4;
		}
	}
	| '(' expa ')'{
		$$.length=$2.length;
		for(i=0; i<$2.length; i++){
			$$.eles[i].chem = strdup($2.eles[i].chem);
			$$.eles[i].count = $2.eles[i].count;
		}
	}
	;
expf 
	: CHAR{
		$$.chem = strdup($1);
		$$.count = 1;
	}
	| CHAR NUM{
		$$.chem = strdup($1);
		$$.count = $2;
	}
	;
%%
int main() {
    yyparse();
    return 0;
}
