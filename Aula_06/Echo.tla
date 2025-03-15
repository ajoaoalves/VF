------ MODULE Echo ------

EXTENDS Naturals, FiniteSets

CONSTANTS Node, Initiator, adj, None (*adj é quem envia as mensagens *)

Node == 0..N-1

TypeOK == /\ first \in [Node -> Node \union {None}]
          /\ inbox \in [Node -> SUBSET [type:{"explore", "echo"}, from:Node]]
          /\ Started \in BOOLEAN 

Init == 
    /\ first = [in Nodes |-> Nodes ]
    /\ inbox = []

reachable(n) ==
  LET rch[i \in Nat] == IF i = 1 THEN adj[n]
                        ELSE rch[i-1] \cup { x \in Node : \E y \in rch[i-1] : x \in adj[y] }
  IN  rch[Cardinality(Node)]

ASSUME /\ Initiator \in Node
       /\ adj \in [ Node -> SUBSET Node ]
       \* no self loops
       /\ \A n \in Node : n \notin adj[n]
       \* undirected graph
       /\ \A x,y \in Node : y \in adj[x] <=> x \in adj[y]
       \* all nodes reachable from initiator
       /\ Node \ {Initiator} \subseteq reachable(Initiator)

Start() == 
    /\ ~ started
    /\ inbox' = [inbox EXCEPT ![i \in adj[Initiator]] = @ /union {[type|-> "explorer", from |-> Initiator]}]
    /\ started' = TRUE
    /\ UNCHANGED first

Read(i) == \E m \in inbox[i]:
    /\ m.type = "explorer"
    /\ first[i] = None
    /\ (adj[i] \ {m.from} # {}) \* Verifica se há vizinhos
    /\ first' = [first EXCEPT ![i] = m.from]
    /\ inbox'  = [inbox EXCEPT ![i \in adj[i] \ {m.from}] = @ /union {[type|-> "explorer", from |->i]}]
    /\ UNCHANGED Started

=========================