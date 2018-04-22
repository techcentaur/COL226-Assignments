(* OCaml data type *)
type symbol = string
	and variable = string
	and predicate = string
		and program = clause list
			and clause = Fact of head | Rule of rule
				and head = Atm of atom
					and rule = head*(head list)
						and term = V of variable | N of symbol*(term list)
							and atom = predicate*(term list)
								and goal = head list;;

type substitution = (variable*term) list;;


(*mergeing x in s*)
(* val merge : 'a -> 'a list -> 'a list = <fun> *)
let merge x s = if List.mem x s then s else s@[x];;


(*unification*)
(* val unification : 'a list -> 'a list -> 'a list = <fun> *)
let rec unification s1 s2 = match s1 with
| [] -> s2
| x::x' -> merge x (unification x' s2);;


(* subst *)
(* val subst : term -> (variable * term) list -> term = <fun> *)
exception TermNotFound;;
let rec subst term s = match term with
	V v -> (try List.assoc v s with | Not_found -> term)
	| N (sym, []) -> N (sym, [])
	| N(sym, termlist) -> if List.length termlist = 0 then term
							  else N(sym, List.map ((fun s term -> subst term s) s) termlist);;

(* val fst : 'a * 'b -> 'a  # Built-in function *)
(* val compose : (variable * term) list -> substitution -> (variable * term) list = <fun> *)
let rec compose s1 s2 = s2 @ (List.map ((fun s s' -> (fst s', subst (snd s') s)) s2) s1);;

exception Not_unifiable;;

(* vars *)

(* val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
List.fold_left f a [b1; ...; bn] is f (... (f (f a b1) b2) ...) bn *)

(* val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b list -> 'c list -> 'a *)
(* List.fold_left2 f a [b1; ...; bn] [c1; ...; cn] is f (... (f (f a b1 c1) b2 c2) ...) bn cn. Raise Invalid_argument if the two lists are determined to have different lengths. *)

(* val vars : term -> variable list = <fun> *)
let rec vars t = match t with
	V v -> [v]
	| N (sym, []) -> [] 
	| N (sym, termlist) -> if List.length termlist = 0 then [] else List.fold_left (fun a b -> unification a (vars b)) [] termlist ;;


(* val mgu : term -> term -> (variable * term) list = <fun> *)
(* most general unifier *)
let rec mgu t1 t2 = match (t1, t2) with
	(V x, V y) -> if y=x then [] else [(x, V y)]
	| (V x, N(sym, [])) -> [(x, t2)]
	| (N(sym, []), V y) -> [(y, t1)]
	| (N(sym1, []), N(sym2, [])) -> if sym1=sym2 then [] else raise Not_unifiable
	| (V x, N(sym, termlist)) -> if List.exists (fun tl -> List.mem x (vars tl)) termlist then raise Not_unifiable else [(x, N(sym, termlist))]
	| (N (sym, termlist), V x) -> if List.exists (fun tl -> List.mem x (vars tl)) termlist then raise Not_unifiable else [(x, N(sym, termlist))]
	| (N(sym1, termlist1), N(sym2, termlist2)) -> if sym1!=sym2 && List.length termlist2 != List.length termlist2 then raise Not_unifiable
												else List.fold_left2 (fun s t u-> compose s (mgu (subst t s) (subst u s))) [] termlist1 termlist2;;


exception Invalid;;
(* val predicate_to_function_symbol : head -> term = <fun> *)
let rec predicate_to_function_symbol p = match p with Atm(x, y) -> N (x, y);;

(* val function_to_predicate_symbol : term -> head = <fun> *)
let rec function_to_predicate_symbol p = match p with N (x, y) -> Atm (x, y)| _-> raise Invalid;;

(* exception DONE;; *)
(* (g: goals; p: program; m: mgu) *)
let rec process g p m = match g with
 			[] -> true
			|g1::grest-> let rec answer g' p' m' = (match p' with
			  [] -> false
			  |p1::prest -> (match p1 with
						  	Fact fact -> (try 
						  				(let u = mgu (predicate_to_function_symbol fact) (predicate_to_function_symbol g') in
						  				let goal = List.map ((fun a t -> subst t a) u) (List.map predicate_to_function_symbol grest) in
						  				if process (List.map function_to_predicate_symbol goal) p (m' @ u) then answer g' prest m' else answer g' prest m')
						  				 with | Not_unifiable -> answer g' prest m';)
					   	    |Rule rule -> (try
					   	  			    (let f = fst rule in
				   						let u = mgu (predicate_to_function_symbol f) (predicate_to_function_symbol g') in
				   						let goal = unification (List.map ((fun a t -> subst t a) u) (List.map predicate_to_function_symbol grest)) (List.map ((fun a t -> subst t a) u) (List.map predicate_to_function_symbol (snd rule))) in
				   						if process (List.map function_to_predicate_symbol goal) p (m' @ u) then answer g' prest m' else answer g' prest m' )
					   					with | Not_unifiable -> answer g' prest m'; ))) in answer g1 p m;;

(* execution -> process goals program [] *)

let x =  Fact(Atm("male", [N ("pandu", [])]));
