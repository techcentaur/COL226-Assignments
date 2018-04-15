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



