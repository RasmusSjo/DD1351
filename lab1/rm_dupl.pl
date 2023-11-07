
remove_duplicates([],[]).

remove_duplicates([H|T],[H|L]) :-
    remove_element(H,T,List),
    !,
    remove_duplicates(List,L).

remove_element(_,[],[]).
remove_element(E,[E|T],L) :-
    remove_element(E, T, L).

remove_element(E,[H|T],[H|L]) :-
    remove_element(E, T, L).
