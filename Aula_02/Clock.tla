----- MODULE Clock -----

EXTENDS Naturals

VARIABLE h

TypeOK == h \in 0..23

Init == h = 0

Midnight == 
    /\ h = 23 
    /\ h' = 0

Other == 
    /\ h < 23 
    /\ h' = h +1


Next == Midnight \/ Other

(* Spec == h = 0 /\ [] [(h = 23 /\ h' = 0) \/ (h < 23 /\ h' = h +1)]_h *)
Spec == Init /\ [] [Next]_h /\ WF_h(Next)

Inv1 == [] ( h < 24)

Prop1 == <> (h=23) => ([]<> (h=12))
=====