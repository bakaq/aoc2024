:- use_module(library(lists)).
:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(clpz)).
:- use_module(library(reif)).
:- use_module(library(format)).

digit(D) --> [D], { member(D, "1234567890") }.

number(Num) --> number(Ds, D), { number_chars(Num, [D|Ds]) }.
number([], D) --> digit(D).
number([D1|D1s], D) --> digit(D), number(D1s, D1).

report([L|Ls]) --> report(Ls, L).

report([], L) --> number(L).
report([Ls|Lss], L) --> number(L), " ", report(Lss, Ls).

parse_input_([]) --> [] ; "\n".
parse_input_([Report|Reports]) -->
    report(Report),
    "\n",
    parse_input_(Reports).

parse_input(Filename, Input) :-
    phrase_from_file(parse_input_(Input), Filename).
    
calculate(Reports, NumSafe) :-
    calculate_(Reports, 0, NumSafe).
calculate_([], NumSafe, NumSafe).
calculate_([Report|Reports], NumSafe0, NumSafe) :-
    if_(
        is_safe(Report),
        #NumSafe1 #= #NumSafe0 + 1,
        NumSafe1 = NumSafe0
    ),
    calculate_(Reports, NumSafe1, NumSafe).

is_safe([], true).
is_safe([Level|Levels], T) :-
    is_safe(Levels, Level, _, T).
is_safe([], _, _, true).
is_safe([Level1|Levels], Level0, Dir, T) :-
    if_(
        clpz_t(#Level0 #< #Level1),
        Dir0 = inc,
        Dir0 = dec
    ),
    if_(
        Dir = Dir0,
        (
            #Diff #= abs(#Level0 - #Level1),
            if_(
                (
                    clpz_t(#Diff #>= 1),
                    clpz_t(#Diff #=< 3)
                ),
                is_safe(Levels, Level1, Dir, T),
                T = false
            )
        ),
        T = false
    ).

main :-
    parse_input("2.in", Input),
    calculate(Input, Result),
    portray_clause(Result),
    halt.

