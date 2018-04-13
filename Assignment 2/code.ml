(*Exceptions*)
exception UnEvaluated;;
exception UnCompiled;;
exception UnExecuted;;
exception JoinError;;
exception StackError;;


(*Functions*)
let rec join (s,n) = match (s,n) with (s,0) -> [] | (n1::s',n) -> (join (s',(n-1)))@[n1] | _-> raise JoinError;;

let rec stackleft (s',n1) = match (s',n1) with (s',0) -> s' | (n2::s',n1) -> (stackleft (s',(n1-1))) | _-> raise StackError;; 

let rec power a b = match (a,b) with
	(a,0) -> 1 |
	(a,b) -> a*(power a (b-1));;

let imp a b = match(a,b) with (true,false) -> false| _-> true;;

let rec map f l = match l with
	[]->[]
	| x::xs -> (f x)::(map f xs);;

let rec map2 f l = match l with
	[]->[]
	| x::xs -> (f x)@(map2 f xs);;

let nth l i = match (l,i) with (l,i) -> (Array.of_list(l)).(i);;


(*Type Defined*)
type opcode =  CONST of int| BOOL of bool| LOOKUP of string | ABS| NOT| ADD| SUB| DIV| MUL| MOD| EXP| AND| OR| IMP | EQU| GTEQU| LTEQU| GRT| LST| TUP| PROJ;;

type exp =  Var of string| Const of int| Bool of bool| Abs of exp| Not of exp
	| Add of exp*exp| Sub of exp*exp| Div of exp*exp| Mul of exp*exp| Mod of exp*exp| Exp of exp*exp
	| And of exp*exp| Or of exp*exp| Imp of exp*exp
	| Equ of exp*exp| GTEqu of exp*exp| LTEqu of exp*exp| Grt of exp*exp| Lst of exp*exp
	| Tup of exp list| Proj of exp*exp;;

type answer = I of int | B of bool| T of answer list;;


(*Eval function*)
let rec eval rho t = match t with
	Const t -> I(t)
	| Bool t-> B(t)
	| Var (x) -> rho x
	| Abs(s) -> ( match (eval rho s) with I(a) -> if a>0 then I(a) else I((-1)*a)| _-> raise UnEvaluated)
	| Not(t1) -> ( match (eval rho t1) with B(a) -> B(not a)| _-> raise UnEvaluated)
	| Add (t1,t2) -> (match (eval rho t1,eval rho t2) with (I(a),I(b)) -> I(a+b) | _-> raise UnEvaluated)
	| Sub (t1,t2) -> (match (eval rho t1,eval rho t2) with (I(a),I(b)) -> I(a-b)| _-> raise UnEvaluated)
	| Mul (t1,t2) -> (match (eval rho t1,eval rho t2) with (I(a),I(b)) -> I(a*b)| _-> raise UnEvaluated)
	| Div (t1,t2) -> (match (eval rho t1,eval rho t2) with (I(a),I(b)) -> I(a/b)| _-> raise UnEvaluated)
	| Mod (t1,t2) -> (match (eval rho t1,eval rho t2) with (I(a),I(b)) -> I(a mod b)| _-> raise UnEvaluated)
	| Exp (t1,t2) -> (match (eval rho t1,eval rho t2) with (I(a),I(b)) -> I(power a b)| _-> raise UnEvaluated)
	| And (t1,t2) -> (match (eval rho t1,eval rho t2) with (B(a),B(b)) -> B(a && b)| _-> raise UnEvaluated)
	| Or (t1,t2) -> (match (eval rho t1,eval rho t2) with (B(a),B(b)) -> B(a || b)| _-> raise UnEvaluated)
	| Imp (t1,t2) -> (match (eval rho t1,eval rho t2) with (B(a),B(b)) -> B(imp a b)| _-> raise UnEvaluated)
	| Equ (t1,t2) -> (match (eval rho t1, eval rho t2) with (I(a),I(b)) -> if a==b then B(true) else B(false)| _-> raise UnEvaluated)
	| GTEqu (t1,t2) -> (match (eval rho t1, eval rho t2) with (I(a),I(b)) -> if a>=b then B(true) else B(false)| _-> raise UnEvaluated)
	| LTEqu (t1,t2) -> (match (eval rho t1, eval rho t2) with (I(a),I(b)) -> if a<=b then B(true) else B(false)| _-> raise UnEvaluated)
	| Grt (t1,t2) -> (match (eval rho t1, eval rho t2) with (I(a),I(b)) -> if a>b then B(true) else B(false)| _-> raise UnEvaluated)
	| Lst (t1,t2) -> (match (eval rho t1, eval rho t2) with (I(a),I(b)) -> if a<b then B(true) else B(false)| _-> raise UnEvaluated)	
	| Tup (t1) -> (match (map (eval rho) t1) with a -> T(a)| _-> raise UnEvaluated)
	| Proj (t1,t2) ->  (match (eval rho t1,eval rho t2) with (T(t1),I(t2)) -> (nth t1 t2)| _-> raise UnEvaluated);;

(*Compile Function*)
let rec compile e = match e with
	Const n -> [CONST(n)]
	| Var x -> [LOOKUP(x)]
	| Abs t -> (compile t)@[ABS]
	| Bool t-> [BOOL(t)]
	| Not t -> (compile t)@[NOT]
	| Add (e1,e2) -> (compile e1)@(compile e2)@[ADD]
	| Sub (e1,e2) -> (compile e1)@(compile e2)@[SUB]
	| Mul (e1,e2) -> (compile e1)@(compile e2)@[MUL]
	| Div (e1,e2) -> (compile e1)@(compile e2)@[DIV]
	| Exp (e1,e2) -> (compile e1)@(compile e2)@[EXP]
	| Mod (e1,e2) -> (compile e1)@(compile e2)@[MOD]
	| And (e1,e2) -> (compile e1)@(compile e2)@[AND]
	| Or (e1,e2) -> (compile e1)@(compile e2)@[OR]
	| Imp (e1,e2) -> (compile e1)@(compile e2)@[IMP]
	| Equ (e1,e2) -> (compile e1)@(compile e2)@[EQU]
	| GTEqu (e1,e2) -> (compile e1)@(compile e2)@[GTEQU]
	| LTEqu (e1,e2) -> (compile e1)@(compile e2)@[LTEQU]
	| Grt (e1,e2) -> (compile e1)@(compile e2)@[GRT]
	| Lst (e1,e2) -> (compile e1)@(compile e2)@[LST]
	| Tup(e1) -> (map2 compile e1)@[CONST(List.length e1);TUP]
	| Proj (e1,e2) -> (compile e2)@(compile e1)@[PROJ];;


(*Execute Function*)
let rec execute (rho,s,c) = match (s,c) with
	| (s1::s2, []) -> s1
	| (s, CONST(n)::c') -> execute (rho,I(n)::s, c')
	| (s, BOOL(n)::c') -> execute (rho, B(n)::s, c')
	| (s, LOOKUP(n)::c') -> execute (rho, (rho n)::s, c')
	| (I(n1)::s',ABS::c') -> execute (rho, (if n1>0 then I(n1) else I((-1)*n1))::s',c')
	| (B(n1)::s', NOT::c') -> execute (rho, B(not n1)::s',c')
	| (I(n2)::I(n1)::s',ADD::c') -> execute (rho, I(n1+n2)::s',c')
	| (I(n2)::I(n1)::s',SUB::c') -> execute (rho, I(n1-n2)::s',c')
	| (I(n2)::I(n1)::s',MUL::c') -> execute (rho, I(n1*n2)::s',c')
	| (I(n2)::I(n1)::s',DIV::c') -> execute (rho, I(n1/n2)::s',c')
	| (I(n2)::I(n1)::s',MOD::c') -> execute (rho, I(n1 mod n2)::s',c')
	| (I(n2)::I(n1)::s',EXP::c') -> execute (rho, I(power n1 n2)::s',c')
	| (B(n2)::B(n1)::s',AND::c') -> execute (rho, B(n1 && n2)::s',c')
	| (B(n2)::B(n1)::s',OR::c') -> execute (rho, B(n1 || n2)::s',c')
	| (B(n2)::B(n1)::s',IMP::c') -> execute (rho, B(imp n1 n2)::s',c')
	| (I(n2)::I(n1)::s',EQU::c') -> execute (rho, B(if n1==n2 then true else false)::s',c')
	| (I(n2)::I(n1)::s',GTEQU::c') -> execute (rho, B(if n1>=n2 then true else false)::s',c')
	| (I(n2)::I(n1)::s',LTEQU::c') -> execute (rho, B(if n1<=n2 then true else false)::s',c')
	| (I(n2)::I(n1)::s',GRT::c') -> execute (rho, B(if n1>n2 then true else false)::s',c')
	| (I(n2)::I(n1)::s',LST::c') -> execute (rho, B(if n1<n2 then true else false)::s',c')
	| (I(n1)::s', TUP::c') -> (match (join (s',n1), stackleft (s',n1)) with (a,b) -> execute (rho, T(a)::b,c'))
	| (T(n1)::I(n2)::s', PROJ::c') -> execute (rho, (nth n1 n2)::s',c')
	| _-> raise UnExecuted;;






(*Examples*)
exception RhoError;;
let rho1 t = match t with "x1" -> I 5 | "x2" -> I 2 | "x3" -> I 7 | "x4" -> I (-4) | "y1" -> B false | "y2" -> B true | _-> raise RhoError;;

let ex1 = Proj(Tup([Const(1);Add(Const(3),Abs(Var("x4")));Var("x2")]),Const(2));;
eval rho1 ex1;;
let cmp1 = compile ex1;;
execute (rho1,[],cmp1);;
;;
;;
let ex2 = Sub(Proj(Tup([Const(1);Add(Const(3),Abs(Const(-4)));Var("x3")]),Const(2)), Mul(Const(4),Const(3)));;
eval rho1 ex2;;
let cmp2 = compile ex2;;
execute (rho1,[],cmp2);;
;;
;;
let ex3 = And(Not(Bool(true)),Not(Var("y1")));;
eval rho1 ex3;;
let cmp3 = compile ex3;;
execute (rho1,[],cmp3);;
;;
;;
let ex4 = Lst(Proj(Tup([Const(2);Const(5);Var("x1")]),Abs(Const(-1))), Add(Mul(Const(2),Const(1)),Const(-2)));;
eval rho1 ex4;;
let cmp4 = compile ex4;;
execute (rho1,[],cmp4);;
;;
;;
let ex5 = Grt(Const(5),Const(2));;
eval rho1 ex5;;
let cmp5 = compile ex5;;
execute (rho1,[],cmp5);;
;;
;;
let ex6 = Mul(Const(5),Const(2));;
eval rho1 ex6;;
let cmp6 = compile ex6;;
execute (rho1,[],cmp6);;



