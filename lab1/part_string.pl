is_partstring(_,[]).
is_partstring([H|T1],[H|T2]) :- is_partstring(T1,T2).

% Base case: the substring/sublist of an empty 
% list is an empty list and it has a length of 0
partstring([], 0, []).

% Add H to L if [H | L] is a sublist of [H | T]
partstring([H|T], Y, [H|L]) :- partstring(T, X, L), is_partstring([H|T],[H|L]), Y is X + 1.

% If the previous condition wasn't met, keep L as it is
partstring([H|T], X, L) :- partstring(T, X, L).
