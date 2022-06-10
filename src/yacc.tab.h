/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INT = 258,
     FLOAT = 259,
     WORD = 260,
     TYPE = 261,
     RELOP = 262,
     OTHERS = 263,
     LP = 264,
     RP = 265,
     LC = 266,
     RC = 267,
     COMMA = 268,
     PLUS = 269,
     MINUS = 270,
     MUL = 271,
     DIV = 272,
     EQUAL = 273,
     AND = 274,
     OR = 275,
     NOT = 276,
     DOT = 277,
     IF = 278,
     ELSE = 279,
     WHILE = 280,
     RETURN = 281,
     SEMI = 282
   };
#endif
/* Tokens.  */
#define INT 258
#define FLOAT 259
#define WORD 260
#define TYPE 261
#define RELOP 262
#define OTHERS 263
#define LP 264
#define RP 265
#define LC 266
#define RC 267
#define COMMA 268
#define PLUS 269
#define MINUS 270
#define MUL 271
#define DIV 272
#define EQUAL 273
#define AND 274
#define OR 275
#define NOT 276
#define DOT 277
#define IF 278
#define ELSE 279
#define WHILE 280
#define RETURN 281
#define SEMI 282




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 18 "yacc.y"
{
    Node* node;
}
/* Line 1529 of yacc.c.  */
#line 107 "yacc.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif

extern YYLTYPE yylloc;
