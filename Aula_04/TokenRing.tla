----- MODULE TokenRing -----
EXTENDS Naturals

CONSTANT N

(*CONSTANT adj  QUEM SÃO OS VIZINHOS NA REDE QUE É UM ANEL*)

ASSUME N \in Nat \ {0}

succ(n) == (n + 1) % N
pred(n) == (n - 1) % N

VARIABLE channel (*existe um canal de comunicação que vai ter uma mensagem com um token*, mas vamos ter uma variable que é o que está no canal de comunicação entre dois nós. Neste canal só vou ter um token, ou seja podemos assumir que ou temos um token ou não temos*)

TypeOK == channel \in [0..N-1 -> BOOLEAN] (*Indica se o canal tem o token ou não*)

Init == channel \in [0..N-1 -> BOOLEAN] (*O nó inicial começa com a mensagem e depois é enviada para os restantes nós que ainda não têm a mensagem *)


Acquire(i) == 
     /\ channel[pred(i)]
     /\ channel' = [j \in 0..N-1 |-> IF j = i THEN TRUE 
                                     ELSE IF j = pred(i) THEN FALSE
                                     ELSE channel[j]] 



                                    
Next == \E i \in 0..N-1: Acquire(i)

Spec == Init /\ [][Next]_channel /\ WF_channel(Next) 

Legitimate == (\E i \in 0..N-1: channel[i]) /\
              (\A i,j \in 0..N-1: i #j => ~(channel[i] /\ channel[j]))

Convergence == <> Legitimate

Closure == [] (Legitimate => [] Legitimate)

=====
