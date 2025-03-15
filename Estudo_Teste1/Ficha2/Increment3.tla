-----  MODULE Increment3 -----
EXTENDS Naturals

CONSTANT N
    
VARIABLES x,y,pc

vars == <<x,y,pc>>

TypeOK == x \in Nat /\ y \in [1..N -> 0..N] /\ pc \in [1..N -> 0..2]
    
Init == x = 0 /\ y = [p \in 1..N |-> 0] /\ pc = [p \in 1..N |-> 0]

Thread1(p) ==
    /\ pc[p] = 0
    /\ y' = [y EXCEPT![p]=x]
    /\ pc' =  [pc EXCEPT![p]=1]
    /\ UNCHANGED x

Thread2(p) ==
    /\ pc[p] = 1
    /\ x' = y[p] + 1
    /\ pc' =  [pc EXCEPT![p]=2]
    /\ UNCHANGED y
    
Next == \E p \in 1..N: Thread1(p) \/ Thread2(p)
    
Spec == Init /\ [] [Next]_vars /\ WF_vars(Next)

Finish == \A p \in 1..N: pc[p] = 2
    
PartialCorrectness == [] (Finish => x = N)
    
Termination == <> Finish

=====
