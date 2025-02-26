----- MODULE peterson -----

EXTENDS Naturals

CONSTANT N

ASSUME N \in Nat /\ N > 0

VARIABLE pc, turn, want

vars == <<pc, turn, want>>

TypeOK ==
        /\ pc \in [0 .. N -> {"idle", "want", "waiting", "critical"}]
        /\ turn \in {0, 1}
        /\ want \in [0 .. N -> BOOLEAN]

Init == pc = [i \in 0 .. N |-> "idle"]
        /\ want = [i \in 0 .. N |-> FALSE]
        /\ turn \in {0, 1}

Thread(p) ==
    /\ pc[p] = "idle"
    /\ pc' = [pc EXCEPT ![p] = "want"]
    /\ want' = [want EXCEPT ![p] = TRUE]
    /\ turn' = turn

Thread2(p) ==
    /\ pc[p] = "want"
    /\ pc' = [pc EXCEPT ![p] = "waiting"]
    /\ turn' = 1 - p
    /\ want' = want

Thread3(p) ==
    /\ pc[p] = "waiting"
    /\ ~(want[1 - p] /\ turn = 1-p)
    /\ pc' = [pc EXCEPT ![p] = "critical"]
    /\ want' = want
    /\ turn' = turn

Thread4(p) ==
    /\ pc[p] = "critical"
    /\ pc' = [pc EXCEPT ![p] = "idle"]
    /\ want' = [want EXCEPT ![p] = FALSE]
    /\ turn' = turn

AllThread(i) == Thread(i) \/ Thread2(i) \/ Thread3(i) \/ Thread4(i)

Next == \E p \in 0 .. N : AllThread(p)

Spec == Init /\ [][Next]_vars /\ \A i \in 0 .. N : WF_vars(AllThread(i)) 

MutualExclusion == [] (\A i, j \in 0 .. N: pc[i] = "critical" /\ pc[j] = "critical" => i = j)

StarvationFree == [] (\A i \in 0 .. N: pc[i] = "waiting" => <> (pc[i] = "critical"))

===========================