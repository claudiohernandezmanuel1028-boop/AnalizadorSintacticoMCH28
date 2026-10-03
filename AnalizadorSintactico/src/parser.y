%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *salida_parser;
int errores_sintacticos = 0;
int linea_actual = 1;

void yyerror(const char *msg) {
    fprintf(salida_parser, "ERROR_SINT|Error sintactico|%s en linea %d\n", msg, linea_actual);
    errores_sintacticos++;
}

int yylex(void);
%}

%define parse.error verbose

%union {
    char texto[256];
    int  entero;
}

%token <texto> TK_IDENTIFICADOR
%token <texto> TK_NUMERO_ENTERO
%token <texto> TK_NUMERO_DECIMAL
%token <texto> TK_CADENA

%token TK_INT TK_FLOAT TK_STRING TK_BOOL
%token TK_IF TK_HILUX TK_ELSE TK_WHILE TK_RETURN
%token TK_TRUE TK_FALSE

%token TK_SUMA TK_RESTA TK_MULT TK_DIV
%token TK_ASIGN
%token TK_IGUAL TK_DIFERENTE TK_MAYOR TK_MENOR TK_MAYOR_IGUAL TK_MENOR_IGUAL
%token TK_AND TK_OR TK_NOT

%token TK_PAREN_A TK_PAREN_C
%token TK_LLAVE_A TK_LLAVE_C
%token TK_PCOMA

%left TK_OR
%left TK_AND
%left TK_IGUAL TK_DIFERENTE
%left TK_MAYOR TK_MENOR TK_MAYOR_IGUAL TK_MENOR_IGUAL
%left TK_SUMA TK_RESTA
%left TK_MULT TK_DIV
%right TK_NOT

%%

programa
    : lista_sentencias
        { fprintf(salida_parser, "OK|programa|Programa analizado correctamente\n"); }
    | /* vacio */
        { fprintf(salida_parser, "OK|programa|Programa vacio\n"); }
    ;

lista_sentencias
    : sentencia
    | lista_sentencias sentencia
    ;

sentencia
    : decl_variable
    | decl_if
    | decl_while
    | decl_return
    | asignacion
    | error TK_PCOMA
        { yyerrok; }
    ;

decl_variable
    : tipo TK_IDENTIFICADOR TK_ASIGN expresion TK_PCOMA
        { fprintf(salida_parser, "OK|decl_variable|Declaracion de variable correcta\n"); }
    | tipo TK_IDENTIFICADOR TK_PCOMA
        { fprintf(salida_parser, "OK|decl_variable|Declaracion de variable sin asignacion\n"); }
    ;

tipo
    : TK_INT    { fprintf(salida_parser, "OK|tipo|int\n"); }
    | TK_FLOAT  { fprintf(salida_parser, "OK|tipo|float\n"); }
    | TK_STRING { fprintf(salida_parser, "OK|tipo|string\n"); }
    | TK_BOOL   { fprintf(salida_parser, "OK|tipo|bool\n"); }
    ;

decl_if
    : TK_IF TK_PAREN_A expresion TK_PAREN_C bloque
        { fprintf(salida_parser, "OK|decl_if|Estructura if correcta\n"); }
    | TK_IF TK_PAREN_A expresion TK_PAREN_C bloque TK_ELSE bloque
        { fprintf(salida_parser, "OK|decl_if|Estructura if-else correcta\n"); }
    | TK_HILUX TK_PAREN_A expresion TK_PAREN_C bloque
        { fprintf(salida_parser, "OK|decl_if|Estructura hilux correcta\n"); }
    | TK_HILUX TK_PAREN_A expresion TK_PAREN_C bloque TK_ELSE bloque
        { fprintf(salida_parser, "OK|decl_if|Estructura hilux-else correcta\n"); }
    ;

decl_while
    : TK_WHILE TK_PAREN_A expresion TK_PAREN_C bloque
        { fprintf(salida_parser, "OK|decl_while|Estructura while correcta\n"); }
    ;

decl_return
    : TK_RETURN expresion TK_PCOMA
        { fprintf(salida_parser, "OK|decl_return|Return correcto\n"); }
    ;

asignacion
    : TK_IDENTIFICADOR TK_ASIGN expresion TK_PCOMA
        { fprintf(salida_parser, "OK|asignacion|Asignacion correcta\n"); }
    ;

bloque
    : TK_LLAVE_A lista_sentencias TK_LLAVE_C
        { fprintf(salida_parser, "OK|bloque|Bloque correcto\n"); }
    | TK_LLAVE_A TK_LLAVE_C
        { fprintf(salida_parser, "OK|bloque|Bloque vacio\n"); }
    ;

expresion
    : expresion TK_SUMA     expresion { fprintf(salida_parser, "OK|expresion|Suma\n"); }
    | expresion TK_RESTA    expresion { fprintf(salida_parser, "OK|expresion|Resta\n"); }
    | expresion TK_MULT     expresion { fprintf(salida_parser, "OK|expresion|Multiplicacion\n"); }
    | expresion TK_DIV      expresion { fprintf(salida_parser, "OK|expresion|Division\n"); }
    | expresion TK_IGUAL    expresion { fprintf(salida_parser, "OK|expresion|Comparacion igual\n"); }
    | expresion TK_DIFERENTE expresion { fprintf(salida_parser, "OK|expresion|Comparacion diferente\n"); }
    | expresion TK_MAYOR    expresion { fprintf(salida_parser, "OK|expresion|Comparacion mayor\n"); }
    | expresion TK_MENOR    expresion { fprintf(salida_parser, "OK|expresion|Comparacion menor\n"); }
    | expresion TK_MAYOR_IGUAL expresion { fprintf(salida_parser, "OK|expresion|Comparacion mayor igual\n"); }
    | expresion TK_MENOR_IGUAL expresion { fprintf(salida_parser, "OK|expresion|Comparacion menor igual\n"); }
    | expresion TK_AND      expresion { fprintf(salida_parser, "OK|expresion|Operacion AND\n"); }
    | expresion TK_OR       expresion { fprintf(salida_parser, "OK|expresion|Operacion OR\n"); }
    | TK_NOT expresion                { fprintf(salida_parser, "OK|expresion|Negacion\n"); }
    | TK_PAREN_A expresion TK_PAREN_C { fprintf(salida_parser, "OK|expresion|Expresion entre parentesis\n"); }
    | termino
    ;

termino
    : TK_IDENTIFICADOR { fprintf(salida_parser, "OK|termino|Identificador: %s\n", $1); }
    | TK_NUMERO_ENTERO { fprintf(salida_parser, "OK|termino|Numero entero: %s\n", $1); }
    | TK_NUMERO_DECIMAL { fprintf(salida_parser, "OK|termino|Numero decimal: %s\n", $1); }
    | TK_CADENA        { fprintf(salida_parser, "OK|termino|Cadena: %s\n", $1); }
    | TK_TRUE          { fprintf(salida_parser, "OK|termino|true\n"); }
    | TK_FALSE         { fprintf(salida_parser, "OK|termino|false\n"); }
    ;

%%
