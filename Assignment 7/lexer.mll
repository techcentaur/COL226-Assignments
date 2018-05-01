(* lexer.mll *)
{
open Parser
exception Eof
}
let _int = '-'?('0'|['1'-'9']['0'-'9']*)
let _add = '+'
let _mul = '*'
let _sub = '-'
let _div = '/'
let _exp = '^'
let _mod = "mod"
let _leftp = '('
let _rightp = ')'
let _true 'T'
let _false = 'F'
let _equ = '='
let _lt = '<'
let _gt = '>'
let _gte = ">="
let _lte = "<="
let _ident = ['a'-'z']['a'-'z' 'A'-'Z' '0'-'9' '_' ''']*
let _del = [';' '.' ',']
let _leftsq = '['
let _rightsq = ']'
let _pipe = '|'
let _iff = ":-"
let _whitespace = [' ' '\t' '\n']
rule lexicon = parse
         { token lexicon }
  | _int as i {INT(i)}
  | _add { ADD }
  | _sub { SUB }
  | _mul { MUL }
  | _div { DIV }
  | _exp { EXP }
  | _mod { MOD }
  | _leftp { LEFTP }
  | _rightp { RIGHTP }
  | _true  { BOOL(true) }
  | _false  { BOOL(false)}
  | _equ { EQU }
  | _lt { LT }
  | _gt { GT }
  | _gte { GTE }
  | _lte { LTE }
  | _ident as i { IDENT(i) }
  | _del { DEL }
  | _leftsq { LEFTSQ }
  | _rightsq { RIGHTSQ }
  | _pipe { PIPE }
  | _iff { IFF }
  | _whitespace { lexicon lexbuf}
  | eof {EOF}

