

partstring(List, L, F) :-
    append(_, T, List),
    append(F, _, T),
    length(F, L),
    F \= [].
