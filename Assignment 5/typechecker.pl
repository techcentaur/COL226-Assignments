/** Constants both numerical and boolean */
hastype(Gamma, true, bool).
hastype(Gamma, false, bool).
hastype(Gamma, N, int) :- integer(N).


/** lookup rules for bro-relation */
bro([], X) :- fail.
bro([X|_], X) :- !.
bro([_|Z], X) :- bro(Z, X).

hastype(Gamma, v(X), T) :- bro(Gamma, (v(X), T)).

append([], L, L).
append([X | Xs], L, [X | L1]) :- append(Xs, L, L1).

/** arithmetic operations over numerical expressions */
hastype(Gamma, arith(E1, E2), int) :- hastype(Gamma, E1, int), hastype(Gamma, E2, int).

hastype(Gamma, addop(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, subop(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, mulop(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, divop(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, expop(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, modop(E1, E2), T) :- hastype(Gamma, arith(E1, E2), T).
hastype(Gamma, absolute(E1), int) :- hastype(Gamma, E1, int).


/** boolean operations over boolean expressions */
hastype(Gamma, boolop(E1, E2), bool) :- hastype(Gamma, E1, bool), hastype(Gamma, E2, bool).

hastype(Gamma, andop(E1, E2), T) :- hastype(Gamma, boolop(E1, E2), T).
hastype(Gamma, orop(E1, E2), T) :-hastype(Gamma, boolop(E1, E2), T).
hastype(Gamma, notop(E1), bool) :- hastype(Gamma, E1, bool).


/** comparison operations over numerical expressions */
hastype(Gamma, equal(E1, E2), bool) :- hastype(Gamma, E1, int), hastype(Gamma, E2, int).
hastype(Gamma, greatorequal(E1, E2), bool) :- hastype(Gamma, E1, int), hastype(Gamma, E2, int).
hastype(Gamma, lessorequal(E1, E2), bool) :- hastype(Gamma, E1, int), hastype(Gamma, E2, int).
hastype(Gamma, greater(E1, E2), bool) :- hastype(Gamma, E1, int), hastype(Gamma, E2, int).
hastype(Gamma, lesser(E1, E2), bool) :- hastype(Gamma, E1, int), hastype(Gamma, E2, int).

/** equality over arbitrary expressions, where equality can be decided */
hastype(Gamma, equality(E1, E2), bool) :- hastype(Gamma, E1, T), hastype(Gamma, E2, T).

/** conditional expressions if_then_else */
hastype(Gamma, if_then_else(E0, E1, E2), T) :- hastype(Gamma, E0, bool), hastype(Gamma, E1, T), hastype(Gamma, E2, T).

/** function abstractions \X.E  with functions as first-class citizens */
hastype(Gamma, abstract(v(X), E), arrowT(T1, T2)) :- hastype([(v(X),T1)| Gamma], E, T2).

/** function application (E1 E2)   */
hastype(Gamma, applied(E1, E2), T) :- hastype(Gamma, E1, arrowT(T1, T)), hastype(Gamma, E2, T1).


/** n-tuples  (n >= 0) */
hastype(Gamma, tuple_n([]), prod_n([])).
hastype(Gamma, tuple_n([E1|E]), prod_n([T1|T])) :- hastype(Gamma, E1, T1), hastype(Gamma, tuple_n(E), prod_n(T)).

/** expressions using projection operations. */

hastype(Gamma, proj_n(tuple_n([Ek | E]), 0), T) :- hastype(Gamma, Ek, T), !.
hastype(Gamma, proj_n(tuple_n([E1 | E]), K), T) :- hastype(Gamma, proj_n(tuple_n(E), K-1), T).

/** D definitions */

/** simple definitions X =def= E
sequential definitions D1; D2
parallel definitions D1 || D2
local definitions local D1 in D2 end */

typeElaborates(Gamma, (v(X), E), [v(X), T]) :- hastype(Gamma, E, T).
typeElaborates(Gamma, sequential(D1, D2), Gamma3) :- append(Gamma1, Gamma2, Gamma3), typeElaborates(Gamma, D1, Gamma1), append(Gamma, Gamma1, Gamma4), typeElaborates(Gamma4, D2, Gamma2).
typeElaborates(Gamma, parallel(D1, D2), Gamma3) :- append(Gamma1, Gamma2, Gamma3), typeElaborates(Gamma, D1, Gamma1), typeElaborates(Gamma, D2, Gamma2).
typeElaborates(Gamma, local(D1, D2), Gamma_new) :- typeElaborates(Gamma, D1, Gamma1), append(Gamma, Gamma1, Gamma2),typeElaborates(Gamma2, D2, Gamma_new).


/** qualified expressions of the form let D in E end */
hastype(Gamma, letDinE(D, E), T) :- typeElaborates(Gamma, D, Gamma1), append(Gamma, Gamma1, Gamma2), hastype(Gamma2, E, T).



/**

test examples - 

hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], addop(4, v(x)), int).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], divop(10, v(x)), int).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], absolute(v(z)), bool).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], orop(true, v(z)), bool).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], equality(v(z), true), bool).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], lessorequal(2, v(x)), bool).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], if_then_else(v(z), v(x), 5), int).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], abstract(v(x), v(w)), arrowT(int, int)).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], applied(abstract(v(x), v(z)), 4), int).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], applied(abstract(v(x), v(w)), 4), int).
hastype([(v(x),int), (v(y), float), (v(z), bool), (v(w), int)], tuple_n([v(x), v(y)]), prod_n([int, float])).
hastype([(v(x),int), (v(y), float), (v(z), bool), (v(w), int)], proj_n(tuple_n([v(x), v(y)]), 0), int).
hastype([(v(x),int), (v(y), char), (v(z), bool), (v(w), int)], letDinE((v(x), 3), v(w)), int).

*/




/**

Counter-examples that it can not work as polymorphic type inference.

1. hastype([(v(x),int), (v(y), float), (v(z), bool), (v(w), int)], tuple_n([v(p), v(q)]), prod_n([T1, T2])).

- In this example, it suggests only one type, because we used '!' operator. Since, we need cut operator to make it work like
type inference, it can't work as polymorphic type inference altogether.

2. hastype([(v(x),int), (v(y), float), (v(z), bool), (v(w), int)], tuple_n([v(p), v(q), v(r)]), prod_n([T1, T2, T3])).

- Similar explanation.

*/