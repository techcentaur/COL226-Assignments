all:
	ocamlc -c toy.ml
	ocamllex lexer.mll
	ocamlyacc parser.mly
	ocamlc -c parser.mli
	ocamlc -c lexer.ml
	ocamlc -c parser.ml
	ocamlc -c toyprolog.ml
	ocamlc -o toyprolog toy.cmo lexer.cmo parser.cmo toyprolog.cmo

clean:
	rm toyprolog *.cmi *.cmo *.mli lexer.ml parser.ml