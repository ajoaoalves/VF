----- MODULE TokenRing -----
EXTENDS Naturals

CONSTANT N

(*CONSTANT adj  QUEM SÃO OS VIZINHOS NA REDE QUE É UM ANEL*)

ASSUME N \in Nat \ {0}

succ(n) == (n + 1) % N
pred(n) == (n - 1) % N

VARIABLE channel (*existe um canal de comunicação que vai ter uma mensagem com um token*, mas vamos ter uma variable que é o que está no canal de comunicação entre dois nós. Neste canal só vou ter um token, ou seja podemos assumir que ou temos um token ou não temos*)

TypeOK == channel \in [0..N-1 -> BOOLEAN] (*Indica se o canal tem o token ou não*)

Init == channel = [i \in 0..N-1 |-> IF i=0 THEN TRUE ELSE FALSE] (*O nó inicial começa com a mensagem e depois é enviada para os restantes nós que ainda não têm a mensagem *)

Send(i) == 
    /\ channel[i] (*O token tem de estar no channel 0*)
   /\ channel' = [j \in 0..N-1 |-> IF j = i THEN FALSE (*Se o j for igual a i, o token sai de i passa para o proximo VER NO CADERNO O DESENHO *)
                                   ELSE IF j = succ(i) THEN TRUE
                                   ELSE channel[j]] 



                                    
 Next == \E i \in 0..N-1: Send(i)

Spec == Init /\ [][Next]_channel

MutualExclusion == [] ((\E i \in 0..N-1: channel[i]) 
                    /\ (\A i,j \in 0..N-1: i #j => ~(channel[i] /\ channel[j]))) (*Não pode haver dois anias de saida diferentes com o token*)

=====
