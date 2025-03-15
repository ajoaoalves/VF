--------- MODULE ClockHours ----

EXTENDS Naturals

VARIABLES h

Init == h = 0

TypeOK ==  h \in 0..23

Midnight == 
    /\ h = 23
    /\ h' = 0

ChangeHour == 
    /\ h < 23
    /\ h' = h + 1

Next == Midnight \/ ChangeHour

Spec == Init /\ [] [Next]_h /\ WF_h(Next)

Prop1 == [] (h /= 24)
Prop2 == <> (h = 12)
Prop3 == []<> (h = 0)

=====