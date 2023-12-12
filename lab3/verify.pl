% check(T, L, S, U, F)
% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.
%
% Should evaluate to true if the sequent below is valid.
% (T,L), S |- F 
%          U
%
% To execute a single file: 
% consult('your_file.pl'). 
% verify('INPUT_FILE_NAME.txt').
%
% To run all tests:
% ['run_all_tests.pl'].
% run_all_tests('verify.pl').
%


% Read and verify input
verify(Input) :-
    see(Input),
    read(T),
    read(L),
    read(S),
    read(F),
    seen,
    check(T, L, S, [], F).


% Literals/atoms (numbers and strings with first character in lower case)
check(_, L, S, [], Literal) :- 
    state_variables(S, L, Variables),
    member(Literal, Variables).

check(_, L, S, [], neg(Literal)) :-
    state_variables(S, L, Variables),
    \+ member(Literal, Variables).


% And
check(T, L, S, U, and(F,G)) :-


% Or
check(T, L, S, U, or(F,G)) :-


% AX q - q is true in the next state
check(T, L, S, U, ax(F,G)) :-


% EX q - q is true in some next state
check(T, L, S, U, ex(F,G)) :-


% AG q - q is true in every state
check(T, L, S, U, ag(F,G)) :-


% EG q - q is true in every state in some path
check(T, L, S, U, eg(F,G)) :-


% AF q - every path will have q true eventually
check(T, L, S, U, af(F,G)) :-


% EF q - there is a path where q will eventually be true
check(T, L, S, U, ef(F,G)) :-



% Utility methods

% Retrieves the variables that are true for a certain state State
state_variables([[State, Variables]|_], State, Variables). % Variables gets unified

state_variables([_|T], S, V) :-
    state_variables(T, S, V).


