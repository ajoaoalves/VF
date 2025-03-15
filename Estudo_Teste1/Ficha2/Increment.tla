----- MODULE Increment -----

EXTENDS Naturals

VARIABLE x, pc0, pc1

vars == << x, pc0, pc1 >>

TypeOK == x \in Nat /\ pc0 \in {0,1} /\ pc1 \in {0,1}
    
Init == x = 0 /\ pc0 = 0 /\ pc1 = 0

Increment0 == 
    pc0 = 0
    /\ x' = x+ 1
    /\ pc0' = 1
    /\ UNCHANGED pc1

Increment1 == 
    pc1 = 0
    /\ x' = x+ 1
    /\ pc1' = 1
    /\ UNCHANGED pc0

Next == Increment0 \/ Increment1

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)
    
Finish == pc0 = 1 /\ pc1 = 1

PartialCorrectness == [] (Finish => x = 2)

Termination == <> Finish
=====