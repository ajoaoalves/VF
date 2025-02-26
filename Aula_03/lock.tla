----- MODULE lock -----

EXTENDS Naturals

CONSTANT N

ASSUME  N > 0

VARIABLES l,pc

vars == <<l,pc>>

TypeOK == l \in BOOLEAN /\ pc \in [1..N -> {"idle","waiting", "critical"}]

Init == l = TRUE /\ pc = [i \in 1..N |-> "idle"]

Idle(i) == /\ pc[i] = "idle"
           /\ UNCHANGED <<l,pc>>

Want(i) == /\ pc[i] = "idle"
           /\ pc' = [pc EXCEPT ![i] = "waiting"]
           /\ UNCHANGED l

Enter(i) == /\ pc[i] = "waiting"
            /\ l = TRUE
            /\ pc' = [pc EXCEPT ![i]="critical"]
            /\ l'= FALSE

Leave(i) == /\ pc [i] = "critical"
            /\ pc' = [pc EXCEPT ![i] = "idle"]
            /\ l' = TRUE

Thread(i) == Idle(i) \/ Want(i) \/ Enter(i) \/ Leave(i)

Next == \E i \in 1..N :Thread(i)

Spec == Init /\ [][Next]_vars /\ \A i \in 1..N: WF_vars(Thread(i)) /\ SF_vars(Enter(i))

MutualExclusion == [](\A i, j \in 1..N : i # j /\ pc[i] = "critical" => pc[j] /= "critical")

NoStarvation == [](\A i \in 1..N : pc[i] = "waiting" => <> (pc[i] = "critical"))
=====