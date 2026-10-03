#include <stdio.h>
#include <stdlib.h>

extern FILE *salida_parser;
extern int errores_sintacticos;
extern FILE *yyin;

int yyparse(void);

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Uso: parser <entrada> <salida>\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Error: no se puede abrir %s\n", argv[1]);
        return 1;
    }

    salida_parser = fopen(argv[2], "w");
    if (!salida_parser) {
        fprintf(stderr, "Error: no se puede crear %s\n", argv[2]);
        fclose(yyin);
        return 1;
    }

    yyparse();

    fprintf(salida_parser, "RESUMEN|errores=%d\n", errores_sintacticos);

    fclose(yyin);
    fclose(salida_parser);
    return 0;
}
