
% Read the file
verify(FileName) :-
    see(FileName),
    read(Premises),
    read(Goal),
    read(Proof),
    seen,

    verify_proof().

verify_proof(Premise, Goal, Proof) :-
    checkGoal(Proof, Goal) ,
    checkProof(Proof, Premise, []), !.



verify_proof()

verify_proof()

verify_proof()

verify_proof()

verify_proof()

verify_proof()

verify_proof()

verify_proof()

verify_proof()

verify_proof()


