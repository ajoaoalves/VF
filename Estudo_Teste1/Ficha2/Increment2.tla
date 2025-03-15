----- MODULE Increment2 -----

EXTENDS Naturals

CONSTANT N 

ASSUME N \in Nat /\ N > 0

VARIABLES x, pc

vars == <<x, pc>>

TypeOK == x \in Nat /\ pc \in [1..N -> {0,1}]
    
Init == x = 0 /\ pc = [i \in 1..N |-> 0]

Thread(i) == 
    /\ pc[i] = 0
    /\ x' = x+1
    /\ pc' = [pc EXCEPT![i] = 1]
    
Next == \E i \in 1..N: Thread(i)
    
Spec == Init /\ [][Next]_vars /\ WF_vars(Next)
    
Finish == \A i \in 1..N: pc[i] = 1

PartialCorrectness == [] (Finish => x = N)

Termination == <> Finish


=====