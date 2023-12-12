% For SICStus, uncomment line below: (needed for member/2)
%:- use_module(library(lists)).
% Load model, initial state and formula from file.
verify(Input) :-
see(Input), read(T), read(L), read(S), read(F), seen,
check(T, L, S, [], F).
% check(T, L, S, U, F)
% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.SICStus,
%
% Should evaluate to true iff the sequent below is valid.
%
% (T,L), S |- F
% U
% To execute: consult('your_file.pl'). verify('input.txt').
% Literals
check(_, L, S, [], X) :-
    list(L, S, T1),
    member(X, T1).

check(_, L, S, [], neg(X)) :-
    list(L, S, T1),
    \+member(X, T1).

% And
check(T, L, S, [], and(F,G)) :-
    check(T, L, S, [], F),
    check(T, L, S, [], G).

% Or
check(T, L, S, [], or(F,G)) :-
    check(T, L, S, [], F);
    check(T, L, S, [], G).

% AX
check(T, L, S, [], ax(F)) :-
    list(T, S, T1),
    allStates(T, L, T1, [], F).

% EX
check(T, L, S, [], ex(F)) :-
    list(T, S, T1),
    states(T, L , T1, [], F).

% AG
check(_, _, S, U, ag(_)) :-
    member(S, U), !.

check(T, L, S, U, ag(F)) :-
    check(T, L, S, [], F),
    list(T, S, T1),
    allStates(T, L, T1, [S|U], ag(F)).

% EG
check(_, _, S, U, eg(_)) :-
    member(S, U), !.

check(T, L, S, U, eg(F)) :-
    check(T, L, S, [], F),
    list(T, S, T1),
    states(T, L, T1, [S|U], eg(F)).

% EF
check(T, L, S, U, ef(F)) :-
    \+member(S, U),
    check(T, L, S, [], F).

check(T, L, S, U, ef(F)) :-
    \+member(S, U),
    list(T, S, T1),
    member(Next, T1),
    check(T, L, Next, [S|U], ef(F)).

% AF
check(T, L, S, U, af(F)) :-
    \+member(S, U),
    check(T, L, S, [], F).

check(T, L, S, U, af(F)) :-
    \+member(S, U),
    list(T, S, T1),
    allStates(T, L, T1, [S|U], af(F)).

%other things
list([[S, K]|_], S, K).

list([_|T1], S, K) :-
    list(T1, S, K).

allStates(_, _, [], _, _).

allStates(T, L, [H|T1], U, B) :-
    check(T, L, H, U, B),
    allStates(T, L, T1, U, B).

states(_, _, [], _, _).

states(T, L, T1, U, B) :-
    member(Next, T1),
    check(T, L, Next, U, B).

