----- MODULE Inc -----

EXTENDS Naturals

CONSTANT N

ASSUME N \in Nat /\ N > 0

VARIABLES x,l,pc, y

vars == << x, pc, y, l>>

TypeOK == x \in Nat /\ pc \in [1..N -> 0..4] /\ y \in [1..N -> 0..N] /\ l \in BOOLEAN 

Init == x = 0 /\ pc = [ p \in 1..N |-> 0] (* quando escreve |-> é uma função concreta e variaveis locais sao sempre escritas assim*)
              /\  y = [ p \in 1..N |-> 0]  (*y \in [1..N -> 0..N] quando escreve -> é o produto cartesiano ou seja dominio e contradominio*)
              /\ l = TRUE

In1(p) == 
    /\ pc[p] = 0
    /\ l = TRUE
    /\ l' = FALSE
    /\ pc' = [ pc EXCEPT ![p] = 1 ]
    /\ UNCHANGED <<x,y>>

In2(p) == 
    /\ pc[p] = 1
    /\ y' = [y EXCEPT ![p] = x]
    /\ pc' = [ pc EXCEPT ![p] = 2 ]
    /\ UNCHANGED <<x,l>>

In3(p) == 
    /\ pc[p] = 2
    /\ x' = y[p] + 1
    /\ pc' = [ pc EXCEPT ![p] = 3 ]
    /\ UNCHANGED <<y,l>>

In4(p) == 
    /\ pc[p] = 3
    /\ l' = TRUE 
    /\ pc' = [ pc EXCEPT ![p] = 4 ]
    /\ UNCHANGED<<x,y>>


Next == \E p \in 1..N : In1(p) \/ In2(p) \/ In3(p) \/ In4(p)

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

Finish == \A p \in 1..N : pc[p] = 4

Prop == ~ [] \A i, j \in 1..N : i < j -> pc[i] >= pc[j]

Prop == [](Finish => x = N)

Termination == <> Finish


(* Termination == [] ~ Finish NUNCA VAI ACABAR, o que provamos que não se verifica Invariant Termination is violated.

*)

(*Estados distinct = 1024 que é 2^10 = 2^N, neste caso*)

=====