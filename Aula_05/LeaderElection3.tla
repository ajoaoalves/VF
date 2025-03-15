-------------- MODULE LeaderElection3 --------------

EXTENDS Naturals, TLC, Integers

CONSTANTS N, id, None

Nodes == 0..N-1

ASSUMPTION 
    /\ N \in Nat
    /\ N > 0
    /\ id \in [Nodes -> Nat]
    /\ \A x,y \in Nodes: x # y => id[x] # id[y]
    /\ None \in Nat /\ (\A x \in Nodes: id[x] # None)


ring5 == 0 :> 35 @@ 1 :> 100 @@ 2 :> 15 @@ 3 :> 2 @@ 4 :> 37

\* None == CHOOSE x \in Nat : x \notin {id[i] : i \in Node}

VARIABLES inbox, elected, started

vars == << inbox, elected, started >>

TypeOK == 
    /\ inbox \in [Nodes -> SUBSET [type : {"Electing", "Informing"}, id : Nat]]
    /\ elected \in [Nodes -> Nat \union {None}]
    /\ started \in [Nodes -> BOOLEAN]

pred(i) == (i-1) % N
succ(i) == (i+1) % N

Ids == {id[n] : n \in Nodes}

Init ==
    /\ inbox = [i \in Nodes |-> {}]
    /\ elected = [i \in Nodes |-> None]
    /\ started = [i \in Nodes |-> FALSE]

Start(i) ==
    /\ ~ started[i]
    /\ inbox' = [inbox EXCEPT ![succ(i)] = @ \union {[type |-> "Electing", id |-> id[i]]}]
    /\ started' = [started EXCEPT ![i] = TRUE]
    /\ UNCHANGED elected


ReadE(i) == \E m \in inbox[i]:
    /\ m.type = "Electing"
    /\ IF m.id < id[i]
       THEN inbox' = [inbox EXCEPT ![i] = @ \ {m}] /\ UNCHANGED elected
       ELSE IF m.id > id[i]
       THEN inbox' = [inbox EXCEPT ![i] = @ \ {m}, ![succ(i)] = @ \union {m}] /\ UNCHANGED elected
       ELSE elected' = [elected EXCEPT ![i] = id[i]]
            /\ inbox' = [inbox EXCEPT ![i] = @ \ {m}, ![succ(i)] = @ \union {[type |-> "Informing", id |-> id[i]]}]
    /\ UNCHANGED started

ReadI(i) == \E m \in inbox[i]:
    /\ m.type = "Informing"
    /\ m.id # id[i]
    /\ inbox' = [inbox EXCEPT ![i] = @ \ {m}, ![succ(i)] = @ \union {m}]
    /\ elected' = [elected EXCEPT ![i] = m.id]
    /\ UNCHANGED started

FinalRead(i) == \E m \in inbox[i]:
    /\ m.type = "Informing"
    /\ m.id = id[i]
    /\ inbox' = [inbox EXCEPT ![i] = @ \ {m}]
    /\ UNCHANGED started
    /\ UNCHANGED elected

Next == \E i \in Nodes : ReadE(i) \/ ReadI(i) \/ Start(i) \/ FinalRead(i)

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

\* Validation (queremos ver o traço)

SomeElected == ~ <> (elected # [i \in Nodes |-> None])

AllMsgRead == ~ <> (inbox = [i \in Nodes |-> {}])

AllStartedPlusLeader == ~ (~ SomeElected /\ <> (started = [i \in Nodes |-> TRUE]))

\* Verification (queremos que seja verdade)

SomeLeader == <> (\E i \in Nodes : elected[i] # None)

AtMostOneLeader2 == [] (\E n \in Ids: \A i \in Nodes: elected[i] \in {None, n})

OnceLeaderAlwaysLeader2 == \A n \in Ids : \A i \in Nodes: [] ( (elected[i] = n) => [] (elected[i] = n))

AllInformed == <> (started = [i \in Nodes |-> TRUE] 
                    /\ \E n \in Ids: \A x,y \in Nodes: elected[x] = n /\ elected[y] = n)

AllInformed2 == <> (started = [i \in Nodes |-> TRUE]  /\ \A x,y \in Nodes: elected[x] = elected[y])

AllInformed3 == <> (\E n \in Ids: \A x,y \in Nodes: elected[x] = n /\ elected[y] = n)

===================================================