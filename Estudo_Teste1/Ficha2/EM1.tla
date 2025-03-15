----- MODULE EM1 -----

EXTENDS Naturals

CONSTANT N

ASSUME N \in Nat /\ N > 0

VARIABLES s,pc

vars == <<s,pc>>

TypeOK == pc \in [1..N -> {"idle", "wait", "critical"} ] /\ s \in BOOLEAN 

Init == pc = [i \in 1..N |-> "idle"] /\ s = TRUE


Thread1(i) ==
    /\ pc[i] ="idle"
    /\ pc' = [pc EXCEPT![i] = "wait"]
    /\ UNCHANGED s

Thread2(i) ==
    /\ pc[i] ="wait"
    /\ s = TRUE
    /\ pc' = [pc EXCEPT![i] = "critical"]
    /\ s' = FALSE

Thread3(i) ==
    /\ pc[i] ="critical"
    /\ pc' = [pc EXCEPT![i] = "idle"]
    /\ s' = TRUE

Thread(i) == Thread1(i) \/ Thread2(i) \/ Thread3(i)
Next == \E i \in 1..N: Thread(i) 
    
Spec == Init /\ [][Next]_vars /\ \A i \in 1..N: WF_vars(Thread(i)) /\ SF_vars(Thread2(i))

Cenario == [] (\A i, j \in 1..N: i # j/\ pc[i] = "critical" /\ pc[j] = "critical")
    
ExclusaoMutua == [] (\A i, j \in 1..N: i # j/\ pc[i] = "critical" => pc[j] /= "critical")

NoStarvation == [](\A i \in 1..N : pc[i] = "wait" => <> (pc[i] = "critical"))

=====