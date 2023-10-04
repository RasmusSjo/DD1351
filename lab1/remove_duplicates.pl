member(X,[X|_]).
member(X,[_|T]) :- member(X,T).

remove_duplicates([],[]).
remove_duplicates([H|T],L) :- remove_duplicates(T,L), member(H, L).
remove_duplicates([H|T],[H|L]) :- remove_duplicates(T,L), not(member(H, L)).
