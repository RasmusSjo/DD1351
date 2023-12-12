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
check(_, Labels, State, [], Literal) :- 
    state_variables(Labels, State, Variables),
    member(Literal, Variables).

check(_, Labels, State, [], neg(Literal)) :-
    state_variables(Labels, State, Variables),
    \+ member(Literal, Variables).


% And
check(Transitions, Labels, State, [], and(Statement1, Statement2)) :-
    check(Transitions, Labels, State, [], Statement1),
    check(Transitions, Labels, State, [], Statement2).


% Or
check(Transitions, Labels, State, [], or(Statement1, Statement2)) :-
    check(Transitions, Labels, State, [], Statement1);
    check(Transitions, Labels, State, [], Statement2).


% AX q - q is true in the next state
%check(Transitions, Labels, State, [], ax(Statement1, Statement2)) :-



% EX q - q is true in some next state
%check(Transitions, Labels, State, U, ex(Statement1, Statement2)) :-


% AG q - q is true in every state
%check(Transitions, Labels, State, U, ag(Statement1, Statement2)) :-


% EG q - q is true in every state in some path
%check(Transitions, Labels, State, U, eg(Statement1, Statement2)) :-


% AF q - every path will have q true eventually
%check(Transitions, Labels, State, U, af(Statement1, Statement2)) :-


% EF q - there is a path where q will eventually be true
%check(Transitions, Labels, State, U, ef(Statement1, Statement2)) :-



% ------------Utility methods------------

% Retrieves the variables that are true for a certain state
state_variables([[State, Variables]|_], State, Variables). % Variables gets unified

state_variables([_|T], State, Variables) :-
    state_variables(T, State, Variables).

% Base case, if all adjacent states have been verified or the state doesn't have any transitions (to other states)
verify_all_adjacents(_, _, [], _, _).

verify_all_adjacents(Transitions, Labels, [Adjacent|Adjacent_states], U, F) :-
    check(Transitions, Labels, Adjacent, U, F), % Check if the adjacent state is true
    verify_all_adjacents(Transitions, Labels, Adjacent_states, U, F). % Check if the rest of the adjacent states are true

% Base case, if the state don't have any transitions (to other states)
verify_atleast_one_adjacents(_, _, [], _, _).

verify_atleast_one_adjacent(Transitions, Labels, Adjacent_states, U, F) :-
    member(Adjacent, Adjacent_states), % Get every adjacent state
    check(Transitions, Labels, Adjacent, U, F). % Check every adjacent state til one is true or all are false

