----- MODULE Clock -----

EXTENDS Naturals

VARIABLE h

Init == h = 0

Midnight == h = 23 /\ h' = 0

Other == h < 23 /\ h' = h +1

Next == Midnight \/ Other

(* Spec == h = 0 /\ [] [(h = 23 /\ h' = 0) \/ (h < 23 /\ h' = h +1)]_h *)
Spec == Init /\ [] [Next]_h
Inv1 == [] ( h < 24)

Inv2 == [] ( h # 12)

=====