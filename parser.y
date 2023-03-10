%{
	#define YYSTYPE char*
	#define YYSTYPE_IS_DECLARED 1
	#include <stdlib.h>
	#include <ctype.h>
	#include <stdio.h>
	void yyerror(char *s);
	#include "parser.h"

	extern int yylex();
	int registerNumber = 1;
%}
%token NUMBER ID
%right  '+' '-'
%right  '*' '/'

%%
///////////////////////// version 1 /////////////////////////
//program: ID '=' expr { printf("Result: %s = %s", $1, $3); }
//	;
//expr: expr '+' term { $$ = malloc(100); sprintf($$,"%s + %s", $3, $1); }
//	| expr '-' term { $$ = malloc(100); sprintf($$,"%s - %s", $3, $1); }
//	| term { $$ = $1; }
//	;
//term: term '*' factor { $$ = malloc(100); sprintf($$,"%s * %s", $3, $1); }
//	| term '/' factor { $$ = malloc(100); sprintf($$,"%s / %s", $3, $1); }
//	| factor { $$ = $1; }
//	;
//factor: '(' expr ')' { $$ = malloc(100); sprintf($$,"(%s)", $2); }
//	| NUMBER { $$ = malloc(100); sprintf($$,"%s", $1); }
//	| ID { $$ = malloc(100); sprintf($$,"%s", $1); }
//	;

//////////////////////// version 2: generate three address code ////////////////////////
//program: ID '=' expr { printf("%s = %s", $1, $3); }
//	;
//expr: expr '+' term { $$ = malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s + %s\n", registerNumber, $3, $1); registerNumber++; }
//	| expr '-' term { $$= malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s - %s\n", registerNumber, $3, $1); registerNumber++; }
//	| term { $$ = $1; }
//	;
//term: term '*' factor { $$ = malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s * %s\n", registerNumber, $3, $1); registerNumber++; }
//	| term '/' factor { $$ = malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s / %s\n", registerNumber, $3, $1); registerNumber++; }
//	| factor { $$ = $1; }
//	;
//factor: '(' expr ')' { $$ = malloc(100); sprintf($$,"%s", $2); }
//	| NUMBER { $$ = malloc(100); sprintf($$,"%s", $1); }
//	| ID { $$ = malloc(100); sprintf($$,"%s", $1); }
//	;
//////////////////////// version 3: remove last redundant register ////////////////////////
program: ID '=' expr '+' expr { printf("x = %s + %s;", $5, $3); }
| ID '=' expr '-' expr { printf("x = %s - %s;", $5, $3); }
| ID '=' expr '*' expr { printf("x = %s * %s;", $5, $3); }
| ID '=' expr '/' expr { printf("x = %s / %s;", $5, $3); }
| ID '=' '(' expr ')' { printf("x = %s;", $4); }
| NUMBER
| ID
;
expr: expr '+' expr { $$ = malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s + %s;\n", registerNumber, $3, $1); registerNumber++; }
| expr '-' expr { $$= malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s - %s;\n", registerNumber, $3, $1); registerNumber++; }
| expr '*' expr { $$ = malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s * %s;\n", registerNumber, $3, $1); registerNumber++; }
| expr '/' expr { $$ = malloc(100); sprintf($$,"t%d", registerNumber); printf("t%d = %s / %s;\n", registerNumber, $3, $1); registerNumber++; }
| '(' expr ')' { $$ = malloc(100); sprintf($$,"%s", $2); }
| NUMBER { $$ = malloc(100); sprintf($$,"%s", $1); }
| ID { $$ = malloc(100); sprintf($$,"%s", $1); }

%%


void yyerror(char *s) {
	fprintf(stderr, "error: %s\n", s);
}

int main(){
	if (yyparse() != 0 ) {
		printf("Error parsing\n");
	}
	return 0;
}