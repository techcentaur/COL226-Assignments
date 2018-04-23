(*
 * Note: you need to change the following datatype and expressions as per your submitted code
 * Please do the changes before you come for demo.
 *)

datatype exp = Int of int
			| Bool of bool
			| Var of string
			| List of exp list
			| Add of exp * exp
			| Sub of exp * exp
			| Mul of exp * exp
			| Div of exp * exp
			| Tup of exp list
			| Proj of exp * int
			| Grt of exp * exp
			| Lst of exp * exp
			| Equ of exp * exp
			| Ifthenelse of exp * exp * exp
			| Abs of exp * exp
			| App of exp * exp
			| LetinEnd of exp * exp
			| Assgn of exp * exp
			| Seq of exp list
			| Para of exp list
			| Localinend of exp list * exp
			| Dec of exp list
			| Ctup of closure list
			| At of int
			| Bind of exp
			and
			closure = CLtype of (exp * closure) list * exp



let x = (CLtype(Var("z"), [(Var("z"),CLtype(Int(3), []))]));;
krivinemachine x [];;

let x = (CLtype( Add(Add(Int(2),Int(3)),Add(Int(2),Int(3))), []));;
krivinemachine x [];;

let x = (CLtype(Add(Int(2),Var("z")), [(Var("z"),CLtype(Int(3), []))]));;
krivinemachine x [];;

let x = (CLtype(App(Abs("x",Add(Var("x"),Int(1))),Int(2)),[]));;
krivinemachine x [];;

let x = (CLtype(App(Abs("x", Mul(Var("x"),Add(Var("x"),Int(1)))),Int(2)),[]));;
krivinemachine x [];;

let x = (CLtype(App(Abs("x", App(Abs("d", Mul(Var("d"),Int(2))),Int(2))),Int(2)),[]));;
krivinemachine x [];;

let x = (CLtype(Ifthenelse(Grt(Int(8),Int(2)),App(Abs("x", Div(Var("x"),Int(2))),Int(2)),App(Abs("x", Mul(Var("x"),Add(Var("x"),Int(1)))),Int(2))),[]));;
krivinemachine x [];;
