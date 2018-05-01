{
open Parser     
exception Eof
}

rule lexicon = parse
    [' ' '\t']+ { lexicon lexbuf }
  |'.' { DOT }
  |',' { COMMA }
  |'=' { EQU }
  |"\\=" {NOTEQ}
  | "\\==" {NOTEQ}
  |'(' { LP }
  |')' { RP }
  | ']' {RSQ}
  | '[' {LSQ}
  | "not" {NOT}
  | '|' {OR}
  | '\n'  {lexicon lexbuf}
  | ":-" {DEL}
  | ['A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_' ''']* as id{ V(id)}
  | ['a'-'z']['a'-'z' 'A'-'Z' '0'-'9' '_' ''']* as id{ C(id)}
  | eof {EOF}
  | "%" {oneline lexbuf}
  | "/*" {multiline lexbuf}
and oneline = parse
  | eof { lexicon lexbuf}
  | '\n' { lexicon lexbuf}
  | _ { oneline lexbuf}
and multiline = parse
  | "*/" {lexicon lexbuf}
  | eof { raise Eof}
  | _{multiline lexbuf}