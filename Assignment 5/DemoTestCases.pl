%variables
hastype([(v("X"),(int)),(v("Y"),(int))],v("X"),T).
hastype([(v("X"),(bool)),(v("X"),(int))],v("X"),T).

%ants
hastype([],-652,T).
hastype([],true,T).

%arithmetic
hastype([],addop(subop(2,5), divop(6,mulop(2,5))),T).

%boolean
hastype([(v("X"),(bool))],andop(impop(orop(v("X"), false), true),impop(v("X"), notop(false))),T).

%comparison
hastype([(v("X"),(bool)),(v("Y"),(bool))],orop(andop(greater(-2, 6), lesser(3,100)),impop(equality(5, v("Y")), v("X"))),T).
%--false--

%equality
hastype([],equality(tup([tup([1,3]),true]),tup([1, 3,true])),T).
%--false--

%if then else
hastype([(v("X"),(bool)),(v("Y"),(int))],if_then_else(andop(v("X"),greater(v("Y"), 0)),v("Y"),v("X")),T).
%--false--

%let d in e
hastype([(v("Y"),(int))], letDinE((v("X"),3), addop(v("Y"),v("X"))),T).
hastype([(v(x),(int))],letDinE((v(y),(3)), mulop(v(y),(5))),T).

%abstraction
hastype( [(v(x), (bool)), (v(w), (bool))], abstract(v(x), v(w)), arrowT((bool), (bool))). 
hastype( [(v(x), (bool)), (v(w), (bool))], abstract(v(x), v(w)), arrowT((bool), (bool))). 

%application
hastype([(v(r), arrowT((bool),(bool))), (v(s), (bool))], applied(v(r), v(s)), (bool)).
hastype([(v(r), arrowT((bool),(bool))), (v(s), (bool)), (v(s), (bool)), (v(r), arrowT((bool),(bool)))], applied(v(r), v(s)), X).

%n-tuple
hastype([(v(x), (bool)), (v(w), (bool))], tuple_n(v(x), v(w), andop(v(x), v(y))), prod_n((bool), (bool))).

%projection
hastype([(v(y), (bool)), (v(z), (bool))], proj_n(tuple_n([v(x), v(w), andop(v(x), v(y))]), 1), (bool)).


%constructors
%hastype([(variable(r), typevar(boolT))] ,inl(variable(r)), disjunction(typevar(boolT),typevar(boolT))).
%hastype([(variable(r), typevar(boolT))] ,inl(variable(r)), X).
%hastype([(variable(r), typevar(boolT))] ,inr(variable(r)), disjunction(typevar(boolT),typevar(boolT))).

%case analysis
%hastype([(variable(t), typevar(boolT)), (variable(r), typevar(boolT))], case(inl(variable(t)), variable(r)), typevar(boolT).
%hastype([(variable(t), typevar(boolT)), (variable(r), typevar(boolT))], case(inr(variable(t)), variable(r)), typevar(boolT).

%type elaboropates

typeElaborates([],(v("X"),addop(3,4)),T).
typeElaborates([],(v("Y"),true),T).
typeElaborates([],parallel((v("X"),3),(v("Y"),true)),T).
typeElaborates([],parallel((v("X"),3),(v("X"),true)),T).
typeElaborates([],sequential((v("X"),mulop(31,20)),(v("Y"),true)),T).
typeElaborates([(v("X"),bool),(v("Y"),int)], local((v("X"),31), parallel((v("X"),tuple_n([v("Y")])),(v("Y"),false))),T).
typeElaborates([(v("X"),bool),(v("Y"),int)], local((v("X"),20),parallel((v("X"),3),(v("Y"),false))),T).
typeElaborates([(v(x),(int))],(v(y),(9)),Gamma).
typeElaborates([(v(x),(int))],sequential((v(z),(true)),(v(y),(false))),Gamma).
typeElaborates([(v(x),(int))],parallel((v(z),(9)),(v(y),(0))),Gamma).
typeElaborates([(v(x),(int))],local((v(z),(9)),(v(y),(4))),Gamma).
typeElaborates([(v(x),(int))],parallel(sequential((v(z),(8)),(v(y),(true))),(v(y),(false))),Gamma).
typeElaborates([(v(x),(int))],sequential(parallel((v(z),(45)),(v(y),(false))),(v(y),(8))),Gamma).


