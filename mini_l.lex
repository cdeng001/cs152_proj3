/* Dylan De Los Santos SID: 861063270
   Calvin Deng SID: 861068523 */

%{   
  #include <stdlib.h>
  #include <stdio.h>
#include "y.tab.h"
#include <string>
   int currLine = 1, currPos = 1;
%}

DIGIT    [0-9]
ID		[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]
IDSINGLE        [a-zA-Z]
   
%%

"##".*"\n"				{currLine++; currPos = 1;}
"("					{currPos += yyleng; return L_PAREN;}
")"					{currPos += yyleng; return R_PAREN;}
"-"					{currPos += yyleng; return SUB;}
"*"					{currPos += yyleng; return MULT;}
"/"					{currPos += yyleng; return DIV;}
"%"					{currPos += yyleng; return MOD;}
"+"					{currPos += yyleng; return ADD;}
":="				{currPos += yyleng; return ASSIGN;}
","					{currPos += yyleng; return COMMA;}
":"					{currPos += yyleng; return COLON;}
";"					{currPos += yyleng; return SEMICOLON;}
"=="				{currPos += yyleng; return EQ;}
"<>"				{currPos += yyleng; return NEQ;}
"<"					{currPos += yyleng; return LT;}
">"					{currPos += yyleng; return GT;}
"<="				{currPos += yyleng; return LTE;}
">="				{currPos += yyleng; return GTE;}
"program"			{currPos += yyleng; return PROGRAM;}
"beginprogram"		{currPos += yyleng; return BEGIN_PROGRAM;}
"endprogram"		{currPos += yyleng; return END_PROGRAM;}
"integer"			{currPos += yyleng; return INTEGER;}
"array"				{currPos += yyleng; return ARRAY;}
"of"				{currPos += yyleng; return OF;}
"if"				{currPos += yyleng; return IF;}
"then"				{currPos += yyleng; return THEN;}
"endif"				{currPos += yyleng; return ENDIF;}
"else"				{currPos += yyleng; return ELSE;}
"while"				{currPos += yyleng; return WHILE;}
"do"				{currPos += yyleng; return DO;}
"beginloop"			{currPos += yyleng; return BEGINLOOP;}
"endloop"			{currPos += yyleng; return ENDLOOP;}
"continue"			{currPos += yyleng; return CONTINUE;}
"read"				{currPos += yyleng; return READ;}
"write"				{currPos += yyleng; return WRITE;}
"and"				{currPos += yyleng; return AND;}
"or"				{currPos += yyleng; return OR;}
"not"				{currPos += yyleng; return NOT;}
"true"				{currPos += yyleng; return TRUE;}
"false"				{currPos += yyleng; return FALSE;}


[0-9]*   {currPos += yyleng; yylval.int_val = yytext; return NUMBER;}


[A-Za-z]|([a-zA-z][a-zA-Z0-9_]*[a-zA-Z0-9]) {currPos +=yyleng; yylval.str_val = yytext; return IDENT;}

[ \t]+         {/* ignore spaces */ currPos += yyleng;}

"\n"           {currLine++; currPos = 1;}

[0-9_][a-zA-Z0-9_]*[a-zA-Z0-9_]		{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter and cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}

[a-zA-z][a-zA-z0-9_]*[a-zA-z0-9_]		{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}

.              {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%
