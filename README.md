# Mini-LISP interpreter
實作項目:
- Syntax Validation  
- Print
- Numerical Operations
- Logical Operations
- if Expression
- Variable Definition
- Function
- Named Function

使用方式:
```
win_bison -d -o y.tab.c final.y
g++ -c -g -I.. y.tab.c
win_flex -o lex.yy.c final.l
g++ -c -g -I.. lex.yy.c
g++ -o final.exe y.tab.o lex.yy.o
final.exe < Input_data.lsp
```

範例: 08_2.lsp
```
(define bar (fun (x) (+ x 1)))

(define bar-z (fun () 2))

(print-num (bar (bar-z)))

```
輸出:

