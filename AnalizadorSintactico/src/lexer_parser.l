%{
#include "parser.tab.h"
#include <string.h>

extern FILE *salida_parser;
extern int linea_actual;
%}

%option noyywrap

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ALFANUM     [a-zA-Z0-9_]

%%

"//"[^\n]*              { }
"/*"([^*]|\*+[^*/])*\*+"/"  {
    char *p = yytext;
    while (*p) { if (*p == '\n') linea_actual++; p++; }
}

"int"       { return TK_INT; }
"float"     { return TK_FLOAT; }
"string"    { return TK_STRING; }
"bool"      { return TK_BOOL; }
"if"        { return TK_IF; }
"hilux"     { return TK_HILUX; }
"else"      { return TK_ELSE; }
"while"     { return TK_WHILE; }
"return"    { return TK_RETURN; }
"true"      { return TK_TRUE; }
"false"     { return TK_FALSE; }

{LETRA}{ALFANUM}*   { strncpy(yylval.texto, yytext, 255); return TK_IDENTIFICADOR; }

{DIGITO}+"."{DIGITO}+   { strncpy(yylval.texto, yytext, 255); return TK_NUMERO_DECIMAL; }
{DIGITO}+               { strncpy(yylval.texto, yytext, 255); return TK_NUMERO_ENTERO; }

\"([^\"\\]|\\.)*\"      { strncpy(yylval.texto, yytext, 255); return TK_CADENA; }

"=="    { return TK_IGUAL; }
"!="    { return TK_DIFERENTE; }
">="    { return TK_MAYOR_IGUAL; }
"<="    { return TK_MENOR_IGUAL; }
"&&"    { return TK_AND; }
"||"    { return TK_OR; }

"+"     { return TK_SUMA; }
"-"     { return TK_RESTA; }
"*"     { return TK_MULT; }
"/"     { return TK_DIV; }
"="     { return TK_ASIGN; }
">"     { return TK_MAYOR; }
"<"     { return TK_MENOR; }
"!"     { return TK_NOT; }

"("     { return TK_PAREN_A; }
")"     { return TK_PAREN_C; }
"{"     { return TK_LLAVE_A; }
"}"     { return TK_LLAVE_C; }
"["     { }
"]"     { }
";"     { return TK_PCOMA; }
","     { }

" "|\t      { }
\n          { linea_actual++; }
\r\n        { linea_actual++; }
\r          { linea_actual++; }

.           {
    fprintf(salida_parser, "ERROR_LEX|Caracter no reconocido: '%s'|linea %d\n", yytext, linea_actual);
}

%%
