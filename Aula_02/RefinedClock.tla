----- MODULE RefinedClock -----

EXTENDS Naturals

VARIABLE h, m, am

vars == << h,m,am >> (*triplo em TLA *)

TypeOK == h \in 0..11 /\ m \in 0..59 /\ am \in BOOLEAN 

Init == h = 0
     /\ m = 0
     /\ am = TRUE

MidSomething == 
    /\ h = 11 
    /\ m = 59
    /\ h' = 0 /\ m' = 0
    /\ am' = ~am

Other == 
    /\ h < 11 
    /\ m = 59
    /\ h' = h + 1
    /\ m' = 0
    /\ am' = am

Minute == 
    /\ m < 59
    /\ m' = m +1
    /\ h' = h
    /\ am' = am

Next == MidSomething \/ Other \/ Minute 

Spec == Init /\ [] [Next]_vars /\ WF_vars(Next)

AbstractClock == INSTANCE Clock WITH h <- IF am THEN h ELSE h + 12

Refinement == AbstractClock!Spec

=====