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

## Assignment-Demos

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


## Contributing
Found a bug or have a suggestion? Feel free to create an issue and make a pull request!

## Attention
If this code is one of your assignments, I strictly recommend you to try it out first by yourself and then come and have a look, if needed. Otherwise, feel free to use it if you want to expand the language or for any other purpose.


