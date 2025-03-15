----- MODULE Increment4 -----

EXTENDS Naturals

CONSTANT N

ASSUME N \in Nat /\ N > 0

VARIABLES x, l, y, pc

vars == <<x,l,y, pc>>

TypeOK == x \in Nat /\ y \in [1..N -> 0..N] /\ l \in BOOLEAN /\ pc \in [1..N -> 0..4]
    
Init == x = 0 /\ y = [p \in 1..N |-> 0] /\ l = TRUE  /\ pc = [i \in 1..N |-> 0]

Thread1(i) == 
    /\ pc[i] = 0
    /\ l' = FALSE
    /\ pc' = [pc EXCEPT ![i] = 1]
    /\ UNCHANGED <<x,y>>

Thread2(i) == 
    /\ pc[i] = 1
    /\ y' = [y EXCEPT![i] = x]
    /\ pc' = [pc EXCEPT ![i] = 2]
    /\ UNCHANGED <<x,l>>

Thread3(i) == 
    /\ pc[i] = 2
    /\ x' = y[i] + 1
    /\ pc' = [pc EXCEPT ![i] = 3]
    /\ UNCHANGED <<y,l>>

Thread4(i) == 
    /\ pc[i] = 3
    /\ l' = TRUE
    /\ pc' = [pc EXCEPT ![i] = 4]
    /\ UNCHANGED <<x,y>>
    
Next == \E i \in 1..N: Thread1(i) \/ Thread2(i) \/ Thread3(i) \/ Thread4(i) 
    
Spec == Init /\ [][Next]_vars /\ WF_vars(Next)
    
Finish == \A i \in 1..N: pc[i] = 4

PartialCorrectness == [] (Finish => x = N)

Prop == ~ [] \A i, j \in 1..N : i < j => pc[i] >= pc[j]

(*Prop == [](Finish => x = N)*)
    
Termination == <> Finish
=====