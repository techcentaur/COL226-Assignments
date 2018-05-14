# COL226-Assignments
The code in this repository is relevant to the assignments given in the course COL226, namely, programming languages, taught by Prof. Sanjiva Prasad.


### List of Assignments

- [Assign1](https://github.com/techcentaur/COL226-Assignments/tree/master/Assignment%201): An efficient functional data type to represent editable strings.
- [Assign2](https://github.com/techcentaur/COL226-Assignments/tree/master/Assignment%202): A definitional interpreter.
- [Assign3](https://github.com/techcentaur/COL226-Assignments/tree/master/Assignment%203): Terms, Substitutions and Unification.
- [Assign4](https://github.com/techcentaur/COL226-Assignments/tree/master/Assignment%204): Abstract Machines.
	- For more elaboration on Krivine Machine click [here](https://github.com/techcentaur/Krivine-Machine).

- [Assign5](https://github.com/techcentaur/COL226-Assignments/tree/master/Assignment%205): Type checker written in Prolog.
- [Assign6](https://github.com/techcentaur/COL226-Assignments/tree/master/Assignment%206): Toy interpreter Prolog.
- [Assign7](https://github.com/techcentaur/COL226-Assignments/tree/master/Assignment%207): Front-end for toy-interpreter.

## Demo-Results

- Assignment 1, 2, 3 are fine and working correctly.
- Assignment 4
	- Parallel calls of krivine machine, even though correct, but needn't be implemented.
	- SECD machine should give an error in a case like - ```if true then 2+3 else 9/0``` but my secd machine evaluates boolean case first and then decides which expression to be evaluated next, which is a minor error.
- Assignment 5
	- In my code there was a possiblity of more than one type assumptions created in the output for a single variable, which is wrong or popping order should be set accordingly.
- Assignment 6
	- Working correctly and cut implemented by forced enter, in a way, like actual prolog.
- Assignment 7
	- `lexer.mll` working correctly and `parser.mly` is causing some errors, that would be hard to correct and will cause major changes in the already coded program. The semester is over and I am not going to complete it. Let's leave something incomplete.

## Books 
- [Programming Language Pragmatics](https://www.amazon.com/Programming-Language-Pragmatics-Third-Michael/dp/0123745144) by Michael Scott. 


## About the Professor
[Prof. Sanjiva Prasad](http://www.cse.iitd.ernet.in/~sanjiva/)


## Support
If you are having some kind of difficulty understanding a part of the code, feel free to create an issue. Also, feel free to improve the code by forking it over.


## Attention
If this code is one of your assignments, I strictly recommend you to try it out first by yourself and then come and have a look, if needed. Otherwise, feel free to use it if you want to expand the language or for any other purpose.

## MOSS
- IIT Delhi uses a tool named MOSS (Measure Of Software Similarity) to detect similarity in code, even though it will be hard to detect copying while working with OCaml given that it's a less-typed functional programming language, and more or less there will always be a similarity around 30%. But still, if you are copying the code from here, make sure to build sufficient changes or prepare to fail if caught.

- Registering for MOSS service is free. So do check your similarity score, if copying, before submitting the assignment and aim at a score below 30.