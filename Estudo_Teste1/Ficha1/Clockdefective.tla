----- MODULE Clockdefective -----

EXTENDS Naturals

VARIABLE h

TypeOK == h \in 0..23

Init == h = 0

Midnight1 == 
    /\ h = 23 
    /\ h' = 0

AmbiguousStep ==
    /\ h = 11
    /\ (h' = 12 \/ h' = 0)  \* Pode ir para 12 ou resetar para 0

ChangeHour == 
    /\ (h < 11 \/ (h > 11 /\ h < 23))
    /\ h' = h + 1

Next == Midnight1 \/ ChangeHour \/ AmbiguousStep

Spec == Init /\ [] [Next]_h /\ WF_h(Next)


Prop1 == [] (h /= 24)
Prop2 == <> (h = 12)
Prop3 == []<> (h = 0)
=====