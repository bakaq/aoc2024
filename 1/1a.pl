:- use_module(library(lists)).
:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(clpz)).
:- use_module(library(format)).

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
    
with_key(L, L-a).

sort_with_dups(Ls0, Ls) :-
    maplist(with_key, Ls0, Ls1),
    keysort(Ls1, Ls2),
    maplist(with_key, Ls, Ls2).

calculate(As-Bs, Result) :-
    sort_with_dups(As, As1),
    sort_with_dups(Bs, Bs1),
    foldl(calculate_, As1, Bs1, 0, Result).

calculate_(A, B, Acc0, Acc) :-
    #Acc #= #Acc0 + abs(#A - #B).

main :-
    parse_input("1a.in", Input),
    calculate(Input, Result),
    portray_clause(Result),
    halt.

