Gamma = [(variable("x"), intT)].


(* E expressions *)

(* Constants both numerical and boolean *)
hastype(Gamma, true, boolT).
hastype(Gamma, false, boolT).
hastype(Gamma, n, intT) :- integer(n).
hastype(Gamma, (), unitT).

(* lookup rules for bro-relation *)
bro(X,[]) :- fail.
bro(X,[X|_]) :- !.
bro(X,[_|Z]) :- bro(X,Z).

hastype(Gamma, variable(X), T) :- bro(Gamma, variable(X)).


(* arithmetic operations over numerical expressions *)
hastype(Gamma, arith(E1, E2), intT) :- hastype(Gamma, E1, intT), hastype(Gamma, E2, intT).

hastype(Gamma, add(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, sub(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, mul(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, div(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, exp(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, mod(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, absolute(E1, E2), T) :- hastype(Gamma, E1, T).


(* boolean operations over boolean expressions *)
hastype(Gamma, boolop(E1, E2), boolT) :- hastype(Gamma, E1, boolT), hastype(Gamma, E2, boolT).

hastype(Gamma, and(E1, E2), T) :- hastype(Gamma, boolop(E1, E2), T).
hastype(Gamma, or(E1, E2), T) :-hastype(Gamma, boolop(E1, E2), T).
hastype(Gamma, not(E1), T) :- hastype(Gamma, E1, T).


(* comparison operations over numerical expressions *)
hastype(Gamma, equal(E1, E2), boolT) :- hastype(Gamma, E1, intT), hastype(Gamma, E2, intT).
hastype(Gamma, greatorequal(E1, E2), boolT) :- hastype(Gamma, E1, intT), hastype(Gamma, E2, intT).
hastype(Gamma, lessorequal(E1, E2), boolT) :- hastype(Gamma, E1, intT), hastype(Gamma, E2, intT).
hastype(Gamma, greater(E1, E2), boolT) :- hastype(Gamma, E1, intT), hastype(Gamma, E2, intT).
hastype(Gamma, lesser(E1, E2), boolT) :- hastype(Gamma, E1, intT), hastype(Gamma, E2, intT).

(* equality over arbitrary expressions, where equality can be decided *)
hastype(Gamma, equalilty(E1, E2), boolT) :- hastype(Gamma, E1, T), hastype(Gamma, E2, T).

(* conditional expressions if_then_else *)
hastype(Gamma, if_then_else(E0, E1, E2), (boolT, T)) :- hastype(Gamma, E0, T0), hastype(Gamma, E1, T), hastype(Gamma, E2, T).

(* function abstractions \X.E  with functions as first-class citizens *)
hastype(Gamma, abstract(variable(X), E), arrowT(T1, T2)) :- hastype([ (variable(X),T1)| Gamma], E, T2).

(* function application (E1 E2)   *)
hastype(Gamma, applied(E1, E2), T) :- hastype(Gamma, E1, arrowT(T1, T)), hastype(Gamma, E2, T1).


(* n-tuples  (n >= 0) *)
hastype(_, tuple_n([]), prod_n([])).
hastype(Gamma, tuple_n([E1 | E]), prod_n([T1 | T])) :- hastype(Gamma, E1, T1), hastype(Gamma, tuple_n(E), prod_n(T)).

(* expressions using projection operations. *)
hastype(Gamma, tuple_n([E1 | E]), prod_n([T1 | T])) :- hastype(Gamma, E1, T1), hastype(Gamma, tuple_n(E), prod_n(T)).

hastype(Gamma, proj_n(tuple_n(E), K), T) :- hastype(Gamma, Ek, T)



(* D definitions *)

(* simple definitions X =def= E
sequential definitions D1; D2
parallel definitions D1 || D2
local definitions local D1 in D2 end *)

typeElaborates(Gamma, (variable(X), E), Gamma') :- typeElaborates(Gamma, (variable(X), E), [(variable(X),E) | Gamma]).
typeElaborates(Gamma, sequential(D1, D2), Gamma') :- typeElaborates(Gamma, D1, Gamma1), typeElaborates([Gamma1| Gamma], D2, Gamma').
typeElaborates(Gamma, parallel(D1, D2), [Gamma1 | Gamma2]) :- typeElaborates(Gamma, D1, Gamma1), typeElaborates(Gamma, D2, Gamma2).
typeElaborates(Gamma, local(D1, D2), Gamma') :- typeElaborates(Gamma, D1, Gamma1), typeElaborates(Gamma1, D2, Gamma').


(* qualified expressions of the form let D in E end *)
hastype(Gamma, letDinE(D, E), T) :- hastype(Gamma, D, Gamma'), hastype(Gamma', E, T).


