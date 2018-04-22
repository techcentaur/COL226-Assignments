(*Types*)
type symbol = string;;
type variable = string;;
type signature = S of (symbol*int) list;;
type term = V of variable | Node of symbol*(term list);;


let remove_elt e l =
  let rec go l acc = match l with
    | [] -> List.rev acc
    | x::xs when e = x -> go xs acc
    | x::xs -> go xs (x::acc)
  in go l [];;

let remove_duplicates l =
  let rec go l acc = match l with
    | [] -> List.rev acc
    | x :: xs -> go (remove_elt x xs) (x::acc)
  in go l [];;

(*1*)
let rec check_arity s = match s with
	S((x,y)::xs) -> if y<0 then false else check_arity (S(xs))
	| S([]) -> true;;

let rec check_sym s = match s with
	S([]) -> []
	| S((x,y)::xs) -> [x] @ check_sym (S(xs));; 

let rec check_symList s = match s with
	[]-> true
	| x::xs ->  if (List.mem x xs) then false else check_symList xs;;

let check_sig s = if check_arity s then (check_symList (check_sym(s))) else false;;

exception InvalidSignature;;

let rec arity (t,s) = match (t,s) with
	(t,S((x,y)::xs))-> if x=t then y else arity (t,S(xs)) | 
	_-> raise InvalidSignature;;

(*2*)
let rec checkPresent (sym,s) = match (sym,s) with 
	(sym,S[]) -> false |
	(sym,S((x,y)::l)) -> if x=sym then true else checkPresent (sym,S(l));;

let rec termchecker (t,s) = match (t,s) with
	(V(x),s) -> true |
	(Node(x,[]),s) -> checkPresent (x,s) | 
	(Node(x,l'::l),s) -> termchecker ((l'),s);;

let wfterm (t,s) = match (t,s) with
	(V(x),s) -> true |
	(Node(x,y),s) -> if  List.length y = arity (x,s) then (termchecker (Node(x,y),s)) else false;;


(*3*)
(*Map, foldr, foldl*)
let rec map f l = match l with []->[] | x::xs -> (f x)::(map f xs);;

let rec fold_left f acc l =
  match l with
    [] -> acc
  | x :: xs -> fold_left f (f acc x) xs;;


let rec varsc term = match term with
	(V(x)) -> [x]|
	(Node(sym,x)) -> (match x with []-> [] | x'::xs -> (varsc x') @ varsc (Node(sym,xs)));; 

let vars t = match t with
	_-> remove_duplicates (varsc t);;

let add a b = a +b ;;

let rec size term = match term with
	(V(x)) -> 1 |
	(Node(sym,x)) -> (match x with
					| [] -> 1
					| x'::xs-> 1+ (fold_left add 0 (map size x)));;

let my_max l = match l with
    [] -> 0  | x::xs -> List.fold_left max x xs;;

let rec ht term = match term with
	(V(x)) -> 0 |
	(Node(sym,x)) -> (match x with
					| [] -> 0
					| x'::xs -> 1 + my_max (map (ht) x));;


(*4*)
type substitution = (variable*term) list;;

(*6*)

let rec search l x = match l with
| [] -> V (x)
| (p,q)::xs -> if (p=x) then q else search xs x;;

let rec subst sigma t = match t with
	V(x) -> search sigma x |
	Node(x,[]) -> Node(x,[]) |
	Node(x,l) -> Node(x,(List.map (subst sigma) l));;

(*5*)
let rec isexists v t = match t with
	V x -> v=x |
	Node(_,l) -> List.mem true (map (isexists v) l);; 

let rec replace t1 v2 t2 = match t2 with
 V x -> if x=v2 then t1 else t2
| Node (f,l) -> Node(f, List.map (replace t1 v2) l);;

let rec isVexistinS v s = match s with
| (x,t)::s' -> if (List.mem v (vars t)) then true else isVexistinS v s'
| _ -> false

let rec isavail l e = match (l,e) with
| [],xs -> false
| (x,y)::l, (p,q) -> if (x=p) then true else isavail l e;;

let composition s1 s2 = (
	let rec s3 s1 s2 = 
		(
		match (s1,s2) with
		([],[]) -> []| 
		(s1,[]) -> s1 |
		([],s2) -> s2 |
		((v1,t1)::s1,s2) -> (v1, subst s2 t1)::(s3 s1 s2)) in
			
			(let rec s4 ss1 ss2 = (
				match (ss1,ss2) with
				| (ss1, []) -> []
				| (ss1,x::ss2) -> if not (isavail ss1 x) then x::(s4 ss1 ss2)
				else s4 ss1 ss2) in (s4 (s3 s1 s2) s2)@(s3 s1 s2)));;


(*7*)
exception NOT_UNIFIABLE;;

let rec mgu t1 t2= match (t1,t2) with
	(V x, V y) -> if x=y then [] else [(x,V y)] |
	(V x, n) -> if isexists x n then raise NOT_UNIFIABLE else [(x, n)] |
	(n, V x) -> if isexists x n then raise NOT_UNIFIABLE else [(x, n)] |
	(Node(f,[]),Node(g,[])) -> if f=g then [] else raise NOT_UNIFIABLE |
	(Node(f,l1'::l1),Node(g,l2'::l2)) -> if f=g then (
		match ((mgu l1' l2'),List.length l1) with
			(s,0) -> s |
			(s,_) -> composition s (mgu (Node(f,(map (subst s) l1))) (Node(f,(map (subst s) l2))))
	) else raise NOT_UNIFIABLE | 
	_-> raise NOT_UNIFIABLE;;


(*8  - examples*)


let s1 = S[("a", 0); ("f", 2); ("g", 1); ("b", 0)];;
let s2 = S[("b", -1); ("f", 2); ("g", 1)];;
let s3 = S[("d", 5); ("f", 2); ("g", 3)];;
let s4 = S[("a", 0); ("f", 2); ("g", 1); ("g", 1)];;
let s5 = S[];;
let s6 = S[("a", 3); ("f", 2); ("g", 1); ("b", 2)];;


check_sig s1;;
check_sig s2;;
check_sig s3;;
check_sig s4;;
check_sig s5;;

let t = Node("c", [V("g")]);;
let u = Node ("b", [t; V("a")]);;
let v = Node ("a", [u;u;t]);;
let w = Node ("a", [v; u; V("x")]);;

wfterm (u,s1);;
wfterm (v,s6);;

ht t;;
ht u;;
ht v;;
ht w;;

size t;;
size u;;
size v;;
size w;;


let sx1 = [("a",V "b");("x",w)];;

subst sx1 t;;
subst sx1 u;;
subst sx1 v;;
subst sx1 w;;

let sx2 = [("b",w);("x",V "a")];;


let sx3 = composition sx1 sx2;;

let sx4 = composition sx1 sx2;;

let x = V "x";;
let a = Node ("a", []);;
let b = Node ("b", []);;
let hxa = Node ("h", [x;a]);;
let hba = Node ("h", [b;a]);;
let mgu5 = mgu hxa hba;;
subst mgu5 hxa = subst mgu5 hba;;

let hbx = Node ("h", [b;x]);;
let z = V "z";;
let hxz = Node ("h",[x;z]);;
let mgu6 = mgu hbx hxz;;
subst mgu6 hbx = subst mgu6 hxz;;

let gh = Node ("g", [hxa; hbx]);;
let ghh = Node ("g", [hba; hxz]);;
let mgu7 = mgu gh ghh;;
subst mgu7 gh = subst mgu7 ghh;;
