%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror(const char* message) {
    printf("syntax error\n");
};

int ans,first_number,equal_number,i,temp,temp2;

struct Node{
    char data_type;
    int number;
    char* name;
    int inFun;
    struct Node *left_node, *right_node, *mid_node;
};

struct Table{
    char* name;
    int value;
    int inFun;
};

struct Node *root=NULL;
struct Node *fun_table[20]; // store functions node's pointer
struct Table var_table[20], param_table[20];
int fun_count=0,var_count=0,param_count=0;

struct Node *newNode(struct Node *Left_pointer, struct Node *Right_pointer, char data);
void traverse(struct Node *node);
void freeAST(struct Node* node);
void add_op(struct Node *node);
void sub_op(struct Node *node);
void multiply_op(struct Node *node);
void divide_op(struct Node *node);
void remainder_op(struct Node *node);
void big_op(struct Node *node);
void small_op(struct Node *node);
void equal_op(struct Node *node);
void and_op(struct Node *node);
void or_op(struct Node *node);
void store_params(struct Node *node);
void bind_params(struct Node *node);

%}

%union {
    int intval,boolval;
    char* strval;
    struct Node *ndval;
}

%token <strval> ID
%token <intval> NUMBER 
%token <boolval> BOOL
%token PRINTNUM PRINTBOOL ADD SUB MUL DIV MOD BIG SMALL EQU AND OR NOT DEF IF FUN
%type <ndval> exp defstmt numop prog stmts stmt printstmt funexp funids funbody funcall funname 
%type <ndval> variable ids temp param
%type <ndval> plus minus multiply divide modules greater smaller equal ifexp testexp thenexp elseexp logicalop andop orop notop

%%
prog
    : stmts {
        root = $1;
    }
    ;
stmts
    : stmt stmts {
        $$ = newNode($1, $2,'A');
    }
    | stmt {
        $$ = $1;
    }
    ;
stmt
    : exp {
        $$ = $1;
    }
    | defstmt {
        $$ = $1;
    }
    | printstmt {
        $$ = $1;
    }
    ;
printstmt
    : '(' PRINTNUM exp ')' {
        $$ = newNode($3, NULL, 'P');
    }
    | '(' PRINTBOOL exp ')' {
        $$ = newNode($3, NULL, 'p');
    }
    ;
exp
    : BOOL {
        $$ = newNode(NULL, NULL, 'B'); 
        $$->number = $1;
    }
    | NUMBER {
        $$ = newNode(NULL, NULL, 'N'); 
        $$->number = $1;
    }
    | variable {
        $$ = $1;
    }
    | numop {
        $$ = $1;
    }
    | logicalop {
        $$ = $1;
    }
    | funexp {
        $$ = $1;
    }
    | funcall {
        $$ = $1;
    }
    | ifexp {
        $$ = $1;
    }
    ;
numop
    : plus {
        $$ = $1;
    }
    | minus {
        $$ = $1;
    }
    | multiply {
        $$ = $1;
    }
    | divide {
        $$ = $1;
    }
    | modules {
        $$ = $1;
    }
    | greater {
        $$ = $1;
    }
    | smaller {
        $$ = $1;
    }
    | equal {
        $$ = $1;
    }
    ;
plus
    : '(' ADD exp temp ')' {
        $$ = newNode($3, $4, '+');
    }
    ;
minus
    : '(' SUB exp exp ')' {
        $$ = newNode($3, $4, '-');
    } 
    ;
multiply
    : '(' MUL exp temp ')' {
        $$ = newNode($3, $4, '*');
    }
    ;
divide
    : '(' DIV exp exp ')' {
        $$ = newNode($3, $4, '/');
    }
    ;
modules
    : '(' MOD exp exp ')' {
        $$ = newNode($3, $4, '%');
    }
    ;
greater
    : '(' BIG exp exp ')' {
        $$ = newNode($3, $4, '>');
    }
    ;
smaller
    : '(' SMALL exp exp ')' {
        $$ = newNode($3, $4, '<');
    }
    ;
equal
    : '(' EQU exp temp ')' {
        $$ = newNode($3, $4, '=');
    }
    ;
temp
    : exp temp {
        $$ = newNode($1, $2, 'E');
    }
    | exp {
        $$ = $1;
    }
    ;
logicalop
    : andop {
        $$ = $1;
    }
    | orop {
        $$ = $1;
    }
    | notop {
        $$ = $1;
    }
    ;
andop 
    : '(' AND exp temp ')' {
        $$ = newNode($3, $4, '&');
    }
    ;
orop
    : '(' OR exp temp ')' {
        $$ = newNode($3, $4, '|');
    }
    ;
notop
    : '(' NOT exp ')' {
        $$ = newNode($3, NULL, '~');
    }
    ;
defstmt
    : '(' DEF variable exp ')' {
        $$ = newNode($3, $4, 'D');
    }
    ;
variable
    : ID {
        $$ = newNode(NULL, NULL, 'V'); 
        $$->name = $1;
    }
    ;
funexp
    : '(' FUN funids funbody ')' {
        $$ = newNode($3, $4, 'F');
    }
    ;
funids
    : '(' ids ')' {
        $$ = $2;
    }
    ;
ids
    : ids variable {    
        $$ = newNode($1, $2, 'E'); 
    }
    | {
        $$ = newNode(NULL, NULL, 'n');
    }
    ;
funbody
    : exp {
        $$ = $1;
    }
    ;
funcall
    : '(' funexp param ')' {
        $$ = newNode($2, $3, 'c');
    }
    | '(' funname param ')' {
        $$ = newNode($2, $3, 'C');
    }
    ;
param
    : exp param {
        $$ = newNode($1, $2, 'E');
    }
    | {
        $$ = newNode(NULL, NULL, 'n');
    }
    ;
funname
    : ID {
        $$ = newNode(NULL, NULL, 'f'); 
        $$->name = $1;
    }
    ;
ifexp
    : '(' IF testexp thenexp elseexp ')' {
        $$ = newNode($3, $5, 'I'); 
        $$->mid_node = $4;
    }
    ;
testexp
    : exp {
        $$ = $1;
    }
    ;
thenexp 
    : exp {
        $$ = $1;
    }
    ;
elseexp 
    : exp {
        $$ = $1;
    }
    ;

%%

struct Node *newNode(struct Node *Left_pointer, struct Node *Right_pointer, char data) {
    struct Node *node = (struct Node *) malloc( sizeof(struct Node) );

    node->number=0;
    node->data_type=data;
    node->left_node=Left_pointer;
    node->mid_node=NULL;
    node->right_node=Right_pointer;
    node->name="";
    node->inFun=0;  //not int the function

    return node;
}

void traverse(struct Node *node){
    if(node == NULL) 
        return;

    if(node->data_type == '+'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the add operation
        ans=0;
        add_op(node);
        node->number=ans;
    }
    else if(node->data_type == '-'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the substract operation
        sub_op(node);
        node->number=ans;
    }
    else if(node->data_type == '*'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the multiply operation
        ans=1;
        multiply_op(node);
        node->number=ans;
    }
    else if(node->data_type == '/'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the divide operation
        divide_op(node);
        node->number=ans;
    }
    else if(node->data_type == '%'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the remainder operation
        remainder_op(node);
        node->number=ans;
    }
    else if(node->data_type == '>'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the bigger operation
        big_op(node);
        node->number=ans;
    }
    else if(node->data_type == '<'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the smaller operation
        small_op(node);
        node->number=ans;
    }
    else if(node->data_type == '='){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the equal operation
        first_number=0;
        ans=1;
        equal_op(node);
        node->number=ans;
    }
    else if(node->data_type == '&'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the and operation
        ans=1;
        and_op(node);
        node->number=ans;
    }
    else if(node->data_type == '|'){
        traverse(node->left_node);
        traverse(node->right_node);
        //do the or operation
        ans=0;
        or_op(node);
        node->number=ans;
    }
    else if(node->data_type == '~'){
        traverse(node->left_node);
        //do the not operation
        node->number = !node->left_node->number;
    }
    else if(node->data_type == 'P'){
        traverse(node->left_node);
        //do the print_number operation
        printf("%d\n", node->left_node->number);
    }
    else if(node->data_type == 'p'){
        traverse(node->left_node);
        //do the print_boolean operation
        if(node->left_node->number)
            printf("#t\n"); 
        else 
            printf("#f\n");
    }
    else if(node->data_type == 'I'){
        traverse(node->left_node);
        traverse(node->mid_node);
        traverse(node->right_node);
        //do the if operation
        if(node->left_node->number == 1)
            node->number = node->mid_node->number;
        else
            node->number = node->right_node->number;
    }
    else if(node->data_type == 'D'){
        //do the define operation
        //Function
        if(node->right_node->data_type == 'F'){
            //without parameter
            if(node->right_node->left_node->data_type == 'n'){
                var_table[var_count].name = node->left_node->name;
                var_table[var_count].value = node->right_node->right_node->number;
                var_table[var_count++].inFun = 0;
            }
            //need parameter
            else
                fun_table[fun_count++] = node;
        }
        //Variables 
        else{
            traverse(node->left_node);
            traverse(node->right_node);
            var_table[var_count].name = node->left_node->name;
            var_table[var_count++].value = node->right_node->number;
        }
    }
    else if(node->data_type == 'V'){
        for(i=0; i<var_count; i++){
            if(var_table[i].inFun == node->inFun && strcmp(var_table[i].name, node->name) == 0){
                node->number = var_table[i].value;
                break;
            }
        }
    }
    else if(node->data_type == 'F'){
        traverse(node->left_node);
        traverse(node->right_node);
    }
    else if(node->data_type == 'c'){
    //define and call function 
        param_count=0; 
        store_params(node);
        temp=param_count;
        param_count=0; 
        bind_params(node);
        //the variable in function are given the value 
        traverse(node->left_node);
        traverse(node->right_node);
        var_count = var_count - temp; 

        //the result of function call is store in the funbody
        node->number = node->left_node->right_node->number;
    }
    else if(node->data_type == 'C'){
    //call function name
        if(node->right_node->left_node->data_type == 'C') {
            node->right_node->left_node->data_type = 'N';
            for(i=0; i<var_count; i++){
                if (var_table[i].inFun == 0 && strcmp(var_table[i].name, node->right_node->left_node->left_node->name) == 0) {
                    node->right_node->left_node->number = var_table[i].value;
                    break;
                }
            }
        }

        //temp is the function's pointer
        temp=0;
        for(i=0; i<fun_count; i++){
            if(node->left_node->name == fun_table[i]->name){
                temp=i;
                break;
            }
        }
       
        param_count=0; 
        store_params(node->right_node); 
        temp2=param_count;
        param_count=0; 
        bind_params(fun_table[temp]->right_node); 
        traverse(fun_table[temp]->left_node);
        traverse(fun_table[temp]->right_node);
        var_count = var_count - temp2; 

        //the result of function call is store in the funbody
        node->number = fun_table[temp]->right_node->right_node->number;
    }
    else{ // AST_STMTS, AST_EXPRS
        traverse(node->left_node);
        traverse(node->right_node);
    }
}

void add_op(struct Node *node){
    if (node->left_node != NULL) {
        ans = ans + node->left_node->number;
        if(node->left_node->data_type == 'E')
            add_op(node->left_node);
    }
    if (node->right_node != NULL) {
        ans = ans + node->right_node->number;
        if(node->right_node->data_type == 'E')
            add_op(node->right_node);
    }
}

void sub_op(struct Node *node){
    ans = node->left_node->number - node->right_node->number;
}

void multiply_op(struct Node *node){
    if(node->left_node != NULL) {
        if(node->left_node->data_type != 'E')
            ans = ans * node->left_node->number;
        else
            multiply_op(node->left_node);
    }
    if(node->right_node != NULL) {
        if(node->right_node->data_type != 'E')
            ans = ans * node->right_node->number;
        else
            multiply_op(node->right_node);
    }
}

void divide_op(struct Node *node){
    if(node->left_node != NULL && node->right_node != NULL)
        ans = node->left_node->number / node->right_node->number;
}

void remainder_op(struct Node *node){
    if(node->left_node != NULL && node->right_node != NULL)
        ans = node->left_node->number % node->right_node->number;
}

void big_op(struct Node *node){
    if(node->left_node != NULL && node->right_node != NULL){
        if(node->left_node->number > node->right_node->number)
            ans=1;
        else
            ans=0;
    }
}

void small_op(struct Node *node){
    if(node->left_node != NULL && node->right_node != NULL){
        if(node->left_node->number < node->right_node->number)
            ans=1;
        else
            ans=0;
    }
}

void equal_op(struct Node *node){
    if(node->left_node != NULL){
        if(node->left_node->data_type != 'E'){
            if(first_number==0){
                equal_number=node->left_node->number;
                first_number=1;
            }
            else{
                if(node->left_node->number != equal_number)
                    ans=0;
            }
        } 
        else
            equal_op(node->left_node);
    }
    if(node->right_node != NULL) {
        if(node->right_node->data_type != 'E'){
            if(first_number==0){
                equal_number=node->right_node->number;
                first_number=1;
            }
            else{
                if(node->right_node->number != equal_number)
                    ans=0;
            }
        } 
        else
            equal_op(node->right_node);
    }
}

void and_op(struct Node *node){
    if(node->left_node != NULL){
        if(node->left_node->data_type != 'E')
            ans = ans & node->left_node->number;
        else
            and_op(node->left_node);
    }
    if(node->right_node != NULL){
        if (node->right_node->data_type != 'E')
            ans = ans & node->right_node->number;
        else
            and_op(node->right_node);
    }
}

void or_op(struct Node *node){
    if(node->left_node != NULL){
        if(node->left_node->data_type != 'E')
            ans = ans | node->left_node->number;
        else
            or_op(node->left_node);
    }
    if(node->right_node != NULL){
        if(node->right_node->data_type != 'E')
            ans = ans | node->right_node->number;
        else
            or_op(node->right_node);
    }
}

void store_params(struct Node * node){
    //store the parameter's value into parameter's table
    if(node->left_node != NULL && node->left_node->data_type != 'F'){
        if(node->left_node->data_type == 'N')
            param_table[param_count++].value = node->left_node->number;
        store_params(node->left_node);
    }
    if(node->right_node != NULL && node->right_node->data_type != 'F'){
        if(node->right_node->data_type == 'N')
            param_table[param_count++].value = node->right_node->number;
        store_params(node->right_node);    
    }
}

void bind_params(struct Node * node){
    //give the parameter's value to the variable in function
    if(node->left_node != NULL){
        if (node->left_node->data_type == 'V') {
            var_table[var_count].name = node->left_node->name;
            var_table[var_count].value = param_table[param_count++].value;
            var_table[var_count++].inFun = 1;

            node->left_node->inFun=1;
        }
        bind_params(node->left_node);
    }
    if(node->right_node != NULL){
        if(node->right_node->data_type == 'V'){
            var_table[var_count].name = node->right_node->name;
            var_table[var_count].value = param_table[param_count++].value;
            var_table[var_count++].inFun = 1;

            node->right_node->inFun=1;
        }
        bind_params(node->right_node);
    }
}

int main() {
    yyparse();

    traverse(root);
    freeAST(root);

    return 0;
}

void freeAST(struct Node* node){ // free with postorder
    if(node != NULL) {
        freeAST(node->left_node);
        freeAST(node->mid_node);
        freeAST(node->right_node);
        free(node);
    }
}