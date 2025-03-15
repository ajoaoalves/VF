----- ---- MODULE LeaderElection ----

EXTENDS Naturals, TLC

CONSTANT N, id (*quantos nós temos no anel - 0 a N-1 isto indica a posiçao dele no anel*)

Nodes == 0..N-1

ASSUMPTION 
    /\ N \in Nat
    /\ N > 0
    /\ id \in [Nodes -> Nat]
    /\ \A x,y \in Nodes: x#y => id[x] # id[y]

ring5 == 0 :>35 @@ 1:>100 @@ 2:> 15 @@ 3:>2 @@  4 :> 37 (* @@ junta duas funções numa maior *) 
ring1 == 0 :>17

VARIABLES inbox, elected

vars == <<inbox, elected>>

TypeOK == inbox \in [Nodes -> SUBSET Nat] (*Inbox corresponde às mensagens de um dado nó. conjunto de todos os subconjuntos naturais*, o contradominio é um conjunto possiveis de mensagens*)
        /\ elected \in [Nodes -> BOOLEAN]

pred(i) == (i-1) % N
succ(i) == (i+1) % N

Init ==  
    /\ elected = [i \in Nodes |-> FALSE]
    /\ inbox = [i \in Nodes |-> {id[pred(i)]}]
    
Read(i) == (*Dado um identificador de um nó*)
     \E m \in inbox[i]: 
    /\ IF m <= id[i]
       THEN inbox' = [inbox EXCEPT ![i] = @\{m}] (*@\{m} = conjunto antigo(inbox[i]) menos a mensagem que eu li*)
       ELSE inbox' = [inbox EXCEPT ![i] = @\{m}, ![succ(i)] = @\union {m}] (*cup é a unicao de conjuntos*)
    (*O lider é selecionado quando a mensagem é igual o identificador do nó*)
    /\ IF  m = id[i]
       THEN elected' = [elected EXCEPT ![i] = TRUE]
       ELSE UNCHANGED elected 


Next == \E i \in Nodes: Read(i)
    
Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

\* vALIDATION

SomeElected == ~ <> (elected # [i \in Nodes |-> FALSE])

AllMsgRead == ~ <> (inbox = [i \in Nodes |-> {}]) 

\* VERIFICATION

SomeLeader == <> (\E i \in Nodes : elected[i]) (*LIVENSS*)

AtMostOneLeader == [] (\A i,j \in Nodes : elected[i] /\ elected[j] => i = j)

OnceLeaderAlwaysLeader == [] (\A i \in Nodes : elected[i]=> [] elected[i]) (*SAFETY*)
====