------- MODULE Inc -------

EXTENDS Naturals

CONSTANT N

ASSUME N \in Nat /\ N > 0

VARIABLES x,pc

vars == << x, pc >>

TypeOK == x \in Nat /\ pc \in [ 1..N -> {0,1} ]

Init == x = 0 /\ pc = [ p \in 1..N |-> 0 ]

Thread(p) == 
    /\ pc[p] = 0
    /\ x' = x + 1
    /\ pc' = [ pc EXCEPT ![p] = 1 ]


Next == \E p \in 1..N : Thread(p)

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

Finish == \A p \in 1..N : pc[p] = 1 

Prop == [] (Finish => x = N)

Termination == <> Finish

==================