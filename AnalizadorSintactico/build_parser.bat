@echo off
SET FLEX="C:\Users\manue\Downloads\win_flex_bison-2.5.25\win_flex.exe"
SET BISON="C:\Users\manue\Downloads\win_flex_bison-2.5.25\win_bison.exe"
SET GCC="C:\Users\manue\Downloads\i686-16.2.0-release-mcf-dwarf-ucrt-rt_v14-rev1\mingw32\bin\gcc.exe"

SET SRC_DIR=src
SET OUT=build\parser.exe

echo [1/4] Generando parser.tab.c y parser.tab.h con BISON...
%BISON% -d -o %SRC_DIR%\parser.tab.c %SRC_DIR%\parser.y
if %errorlevel% neq 0 (
    echo ERROR: BISON fallo
    pause
    exit /b 1
)
echo       OK

echo [2/4] Generando lexer_parser.yy.c con FLEX...
%FLEX% --wincompat -o %SRC_DIR%\lexer_parser.yy.c %SRC_DIR%\lexer_parser.l
if %errorlevel% neq 0 (
    echo ERROR: FLEX fallo
    pause
    exit /b 1
)
echo       OK

echo [3/4] Compilando parser.exe con GCC...
%GCC% %SRC_DIR%\parser.tab.c %SRC_DIR%\lexer_parser.yy.c %SRC_DIR%\main_parser.c -o %OUT% -static -static-libgcc -I%SRC_DIR%
if %errorlevel% neq 0 (
    echo ERROR: GCC fallo
    pause
    exit /b 1
)
echo       OK

echo [4/4] Listo. Ejecuta: python main.py
pause
