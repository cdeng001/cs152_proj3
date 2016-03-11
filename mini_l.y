/* Dylan De Los Santos SID: 861063270
   Calvin Deng SID: 861068523 */

%{
  #include <stdlib.h>
  #include <stdio.h>
  
  #include <iostream>
  #include <stack>
  #include <map>
  #include <string>
  #include <sstream>
  
  using namespace std;
  
  extern char* yytext;
  int yyerror (char*s);
  int yylex(void);
  #include "y.tab.h"
  extern FILE * yyin;
  
  map<string, int> declarations;
  stack<string> ident_stack;
  stack<string> var_stack;
  stack<string> comp_stack;
  stack<string> index_stack;
  stack<string> reverse_stack;
  stack<int> size_stack;
  stack<int> label_stack;
  stack<int> loop_stack;
  stack<int> predicate_stack;

  unsigned int t = 0;
  unsigned int p = 0;
  unsigned int l = 0;
  bool Error = false;
  std::stringstream output;
  string s1 = "";
  string s2 = "";
  string e = "";
%}



%union{
  char*    int_val;
  char*     str_val;
 }

%start program
%token  <str_val>   IDENT NUMBER
%token   L_PAREN R_PAREN SUB MULT DIV MOD ADD ASSIGN COMMA COLON SEMICOLON EQ NEQ LT GT LTE GTE PROGRAM BEGIN_PROGRAM END_PROGRAM INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE
%type    <int_val>    program block declaration statement bool_exp relation_and_exp relation_exp comp expression multiplicative_exp term var

%error-verbose

%left LT GT NEQ EQ GTQ LTQ
%left PLUS MINUS
%left MULT DIV

%%

program: PROGRAM Ident SEMICOLON block END_PROGRAM 
{
    //if there was no error detected, then we output the stack
    if(!Error) {
      
      //output the temp registers used
      for(int i = 0; i < t; i++)
        cout << "\t. t" << i << endl;

      //output the pers registers used
      for(int i = 0; i < p; i++)
        cout << "\t. p" << i << endl;

      //output the output stream
      cout << output.str();
    }
}
;

term1: 
    var     
    {
        s2 = var_stack.top();
        if(index_stack.top() != "-1") {
          std::stringstream revout;
          revout << t;
          output << "  =[] t" << t << ", " << s2 << index_stack.top() << endl;
          s2 = "t" + revout.str();
          t++;
        }
        var_stack.pop();
        output << "  - t" << t << ", 0, " << s2 << endl;
        std::stringstream revout;
        revout << t;
        var_stack.push("t" + revout.str());
        index_stack.push("-1");
        t++;
    }

    | Number       
    {
    }

    | L_PAREN expression R_PAREN    
    {
         s2 = var_stack.top();
        var_stack.pop();
        output << "  - t" << t << ", 0, " << s2 << endl;
        std::stringstream revout;
        revout << t;
        var_stack.push("t" + revout.str());
        index_stack.push("-1");
        t++;
    }
;

term2:
    var
    {
    }
    
    | Number
    {  
        var_stack.push(string($1));
        index_stack.push("-1");
    }
    
    | L_PAREN expression R_PAREN
    {
    }
;

term: 
    SUB term1   
    {
        printf("term case 1\n");
    }

    | term2    
    {
        printf("term case 2\n");
    }
;

multiplicative_exp1: 
    MULT term multiplicative_exp1 
    {
        //
        s2 = var_stack.top();
        if(index_stack.top() != "-1") {
          std::stringstream revout;
          revout << t;
          output << "\t=[] t" << t << ", " << s2 << ", "
                 << index_stack.top() << endl;
          s2 = "t" + revout.str();
          t++;
        }
        var_stack.pop();
        index_stack.pop();
        s1 = var_stack.top();
        if(index_stack.top() != "-1") {
          std::stringstream revout;
          revout << t;
          output << "\t=[] t" << t << ", " << s1 << ", "
                 << index_stack.top() << endl;
          s1 = "t" + revout.str();
          t++;
        }
        var_stack.pop();
        index_stack.pop();
        output << "  * t" << t << ", " << s1 << ", "  << s2 << endl;
        std::stringstream revout;
        revout << t;
        var_stack.push("t" + revout.str());
        index_stack.push("-1");
        t++;
    }
    
    | DIV term multiplicative_exp1 
    {
        s2 = var_stack.top();
        if(index_stack.top() != "-1") {
          std::stringstream revout;
          revout << t;
          output << "  =[] t" << t << ", " << s2 << ", "
                 << index_stack.top() << endl;
          s2 = "t" + revout.str();
          t++;
        }
        var_stack.pop();
        index_stack.pop();
        s1 = var_stack.top();
        if(index_stack.top() != "-1") {
          std::stringstream revout;
          revout << t;
          output << "  =[] t" << t << ", " << s1 << ", "
                 << index_stack.top() << endl;
          s1 = "t" + revout.str();
          t++;
        }
        var_stack.pop();
        index_stack.pop();
        output << "  / t" << t << ", " << s1 << ", " << s2 << endl;
        std::stringstream revout;
        revout << t;
        var_stack.push("t" + revout.str());
        index_stack.push("-1");
        t++;
    }

    | MOD term multiplicative_exp1 
    {
        s2 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "  =[] t" << t << ", " << s2 << ", "
             << index_stack.top() << endl;
      s2 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    s1 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "  =[] t" << t << ", " << s1 << ", "
             << index_stack.top() << endl;
      s1 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    output << "  % t" << t << ", " << s1 << ", " << s2 << endl;
    std::stringstream revout;
    revout << t;
    var_stack.push("t" + revout.str());
    index_stack.push("-1");
    t++;
    }

| 
;

multiplicative_exp: 
    term multiplicative_exp1    
;

expression1: 
ADD multiplicative_exp expression1 
{
    s2 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "\t=[] t" << t << ", " << s2 << ", "
             << index_stack.top() << endl;
      s2 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    s1 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "\t=[] t" << t << ", " << s1 << ", "
             << index_stack.top() << endl;
      s1 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    output << "\t+ t" << t << ", " << s1 << ", " << s2 << endl;
    std::stringstream revout;
    revout << t;
    var_stack.push("t" + revout.str());
    index_stack.push("-1");
    t++;
}
| SUB multiplicative_exp expression1 
{
    s2 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "\t=[] t" << t << ", " << s2 << ", "
             << index_stack.top() << endl;
      s2 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    s1 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "\t=[] t" << t << ", " << s1 
             << index_stack.top() << endl;
      s1 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    output << "\t- t" << t << ", " << s1 << ", " << s2 << endl;
    std::stringstream revout;
    revout << t;
    var_stack.push("t" + revout.str());
    index_stack.push("-1");
    t++;
}
| 
;

expression: 
    multiplicative_exp expression1 
;

var: 
    Ident1 
    {
        map<string, int>::iterator it;
        it = declarations.find(var_stack.top());
        if(it != declarations.end()) {
            if((*it).second != -1) {
                e = "Error: array " 
                + var_stack.top().substr(1, var_stack.top().length()-1)
                + " requires an index";
                yyerror(e.c_str());
            }
        }
        index_stack.push("-1");
    }

    | Ident1 _L_PAREN expression R_PAREN 
    {
        index_stack.pop();
        index_stack.push(var_stack.top());
        var_stack.pop();
    }
;

comp: 
    EQ 
    {
        comp_stack.push("==");
    }

    | NEQ 
    {
        comp_stack.push("!=");
    }

    | LT 
    {
        comp_stack.push("<");
    }

    | GT 
    {
        comp_stack.push(">");
    }

    | LTE 
    {
        comp_stack.push("<=");
    }

    | GTE 
    {
        comp_stack.push(">=");
    }
;

relation_exp1: 
    expression comp expression 
    {
        s2 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "  =[] t" << t << ", " << s2 << ", "
             << index_stack.top() << endl;
      s2 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    s1 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "\t=[] t" << t << ", " << s1 << ", "
             << index_stack.top() << endl;
      s1 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    string c = comp_stack.top();
    comp_stack.pop();
    output << "\t" << c << " p" << p << ", " << s1 << ", " << s2 << endl;
    p++;
    output << "\t== p" << p << ", p" << p-1 << ", 0" << endl;
    predicate_stack.push(p);
    p++;
    }

    | TRUE 
    {
        output << "\t== p" << p << ", 1, 0" << endl;
    predicate_stack.push(p);
    p++;
    }

    | FALSE 
    {
        output << "\t== p" << p << ", 1, 1" << endl;
    predicate_stack.push(p);
    p++;
    }

    | L_PAREN bool_exp R_PAREN 
    {
    }
;

relation_exp2: 
    expression comp expression 
    {
         s2 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "\t=[] t" << t << ", " << s2 << ", "
             << index_stack.top() << endl;
      s2 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    s1 = var_stack.top();
    if(index_stack.top() != "-1") {
      std::stringstream revout;
      revout << t;
      output << "\t=[] t" << t << ", " << s1 << ", "
             << index_stack.top() << endl;
      s1 = "t" + revout.str();
      t++;
    }
    var_stack.pop();
    index_stack.pop();
    string c = comp_stack.top();
    comp_stack.pop();
    output << "\t" << c << " p" << p << ", " << s1 << ", " << s2 << endl;
    predicate_stack.push(p);
    p++;
    }

    | TRUE 
    {
         output << "\t== p" << p << ", 1, 1" << endl;
    predicate_stack.push(p);
    p++;
    }

    | FALSE 
    {
         output << "\t== p" << p << ", 1, 0" << endl;
    predicate_stack.push(p);
    p++;
    }

    | L_PAREN bool_exp R_PAREN 
    {
    }
;

relation_exp: 
    NOT relation_exp1 
    {
    }

    | relation_exp2 
    {
    }
;

relation_and_exp1: 
    AND relation_exp relation_and_exp1 
    {
        int s2 = predicate_stack.top();
        predicate_stack.pop();
        int s1 = predicate_stack.top();
        predicate_stack.pop();
        output << "\t&& p" << p << ", p" << s1 << ", p" << s2 << endl;
        predicate_stack.push(p);
        p++;
    }
|
;

relation_and_exp:  
    relation_exp relation_and_exp1 
;

bool_exp1: 
    OR relation_and_exp bool_exp1 
    {
        int s2 = predicate_stack.top();
        predicate_stack.pop();
        int s1 = predicate_stack.top();
        predicate_stack.pop();
        output << "\t|| p" << p << ", p" << s1 << ", p" << s2 << endl;
        predicate_stack.push(p);
        p++;
    }

|
;

bool_exp: 
    relation_and_exp bool_exp1 
    {
        int s2 = predicate_stack.top();
        predicate_stack.pop();
        output << "\t== p" << p << ", p" << s2 << ", 0" << endl;
        predicate_stack.push(p);
        p++;
    }
;

statement: 
    var ASSIGN expression 
    {
        printf("statement case 1\n");
    }

    | IF bool_exp THEN statement_loop1 ENDIF
    {
        printf("statement case 2\n");
    }

    | IF bool_exp THEN statement_loop1 ELSE statement_loop1 ENDIF 
    {
        printf("statement case 8\n")
    }

    | WHILE bool_exp BEGINLOOP statement_loop1 ENDLOOP 
    {
        printf("statement case 3\n");
    }

    | DO BEGINLOOP statement_loop1 ENDLOOP WHILE bool_exp 
    {
        printf("statement case 4\n");
    }

    | READ var statement_loop3 
    {   
        printf("statement case 5\n");
    }

    | WRITE var statement_loop3 
    {
        printf("statement case 6\n");
    }

    | CONTINUE 
    {
        printf("statement case 7\n");
    }
;

statement_loop1: 
    statement SEMICOLON statement_loop2 
    {
        printf("statement_loop1 case 1\n");
    }
;

statement_loop2: 
    statement SEMICOLON statement_loop2 
    {
        printf("statement_loop2 case 1\n");
    }
|
;

statement_loop3: 
    COMMA var statement_loop3
    {
        printf("statement_loop3 case 1\n");
    }
| 
;

declaration1: 
    COMMA Ident declaration1 
    {
    }
| 
;

declaration2: 
    INTEGER 
    {
         while(!ident_stack.empty()) {
          output << "\t. " << ident_stack.top() << endl;
          ident_stack.pop();
        }
    }

    | ARRAY L_PAREN Number R_PAREN OF INTEGER 
    {
        if(atoi($5) <= 0) {
          e = "Error: declaring an array of size <= 0";
          yyerror(e.c_str());
        }
        while(!ident_stack.empty()) {
          output << "\t.[] " << ident_stack.top() << ", " << atoi($5) << endl;
          declarations[ident_stack.top()] = atoi($5);
          ident_stack.pop();
        }
    }
; 

declaration: 
    Ident declaration1 COLON declaration2 
    {
    }
;

block1: 
    declaration SEMICOLON block1 
    {
    }
| 
;

block2: 
    statement SEMICOLON block2 
    {
    }
| 
;

block: 
    block1 _BEGIN_PROGRAM block2 
    {
    }
;

Number: NUMBER 
{
    output << "  - t" << t << ", 0, " << string($1)<< endl;
    std::stringstream revout;
    revout << t;
    var_stack.push("t" + revout.str());
    index_stack.push("-1");
    t++;
}
;

Ident: IDENT 
{
    if(declarations.find("_" + string($1)) != declarations.end()) {
      e = "Error: " + string($1) + " was previously defined";
      yyerror((char*)e.c_str());
    }
    declarations["_" + string($1)] = -1;
    ident_stack.push("_" + string($1));
}
;

_BEGIN_PROGRAM: BEGIN_PROGRAM{
    output << ": START" << endl;
}
;

_L_PAREN
: L_PAREN {
    map<string, int>::iterator it;
    it = declarations.find(var_stack.top());
    if(it != declarations.end()) {
      if((*it).second == -1) {
        e = "Error: variable "
          + var_stack.top().substr(1, var_stack.top().length()-1)
          + " does not require an index";
        yyerror((char*)e.c_str());
      }
    }
}
;

Ident1 
    : IDENT {
    string s = string($1);
    if(declarations.find("_" + s) == declarations.end()) {
      e = "Error: " + s + " was not declared";
      yyerror((char*)e.c_str());
    }
    else if(s == "program"    || s == "beginprogram" ||
            s == "endprogram" || s == "integer" ||
            s == "array"      || s == "of" ||
            s == "if"         || s == "then" ||
            s == "endif"      || s == "else" ||
            s == "while"      || s == "do" ||
            s == "beginloop"  || s == "endloop" ||
            s == "continue"   || s == "read" ||
            s == "write"      || s == "and" ||
            s == "or"         || s == "not" ||
            s == "true"       || s == "false") {
      e = "Error: " + string($1) + " is a keyword";
      yyerror((char*)e.c_str());
    }
    var_stack.push("_" + string($1));
  }
  ;

%%

int main(int argc, char ** argv)
{
   if(argc >= 2)
   {
      yyin = fopen(argv[1], "r");
      if(yyin == NULL)
      {
	printf("syntax: %s filename\n", argv[0]);
      }
   }
   
   yyparse();
   return 0;
}


int yyerror(char * s)
{
  printf("error: %s\n", s);
  //exit(1);
  //return 0;
}
