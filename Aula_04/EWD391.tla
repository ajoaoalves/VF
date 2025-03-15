----- MODULE EWD391 -----

EXTENDS Naturals

CONSTANT N,K

(*CONSTANT adj  QUEM SÃO OS VIZINHOS NA REDE QUE É UM ANEL*)

ASSUME N \in Nat 
ASSUME K \in Nat /\ K >= N

succ(n) == IF n = N THEN 0 ELSE n + 1
pred(n) == IF n = 0 THEN N ELSE n - 1

VARIABLE channel 

TypeOK == channel \in [0..N -> 0..K-1] (*cada canal tem um valor diferente k*)

Init == channel \in [0..N -> 0..K-1] 

(*perspectiva de quem quer libertar o token*)

Token(i) == 
    IF i = 0 
    THEN channel[pred(i)] = channel[i] 
    ELSE channel[pred(i)] # channel[i]

Release(i) == 
     /\ Token(i)
     /\  IF i = 0 
         THEN channel' = [channel EXCEPT ![i] = (channel[i] + 1) % K]
         ELSE channel' = [channel EXCEPT ![i] = channel[pred(i)]]

                                    
Next == \E i \in 0..N: Release(i)

Spec == Init /\ [][Next]_channel /\ WF_channel(Next) 

Legitimate == (\E i \in 0..N: Token(i)) /\
              (\A i,j \in 0..N: i #j => ~(Token(i) /\ Token(j))) /\
              (\A i \in 0..N: <> Token(i))


Convergence == <> Legitimate

Closure == [] (Legitimate => [] Legitimate)

Cenario1 == ~ (\A i \in 0..N: Token(i) /\ <> Legitimate) (* É suposto dar erro *)

======
