:- use_module(library(lists)).
:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(clpz)).
:- use_module(library(format)).
:- use_module(library(reif)).

digit(D) --> [D], { member(D, "1234567890") }.

number(Num) --> number(Ds, D), { number_chars(Num, [D|Ds]) }.
number([], D) --> digit(D).
number([D1|D1s], D) --> digit(D), number(D1s, D1).

parse_input_([], []) --> [] ; "\n".
parse_input_([A|As], [B|Bs]) -->
    number(A),
    "   ",
    number(B),
    "\n",
    parse_input_(As, Bs).

parse_input(Filename, As-Bs) :-
    phrase_from_file(parse_input_(As, Bs), Filename).
    
calculate(As-Bs, Result) :-
    calculate_(As, Bs, 0, Result).

calculate_([], _, Result, Result).
calculate_([A|As], Bs, Result0, Result) :-
    ocurrences(Bs, A, 0, Occur),
    #Result1 #= #Result0 + #Occur * #A,
    calculate_(As, Bs, Result1, Result).

ocurrences([], _, Occur, Occur).
ocurrences([L|Ls], X, Occur0, Occur) :-
    if_(
        L = X,
        #Occur1 #= #Occur0 + 1,
        Occur1 = Occur0
    ),
    ocurrences(Ls, X, Occur1, Occur).


main :-
    parse_input("1a.in", Input),
    calculate(Input, Result),
    portray_clause(Result),
    halt.

