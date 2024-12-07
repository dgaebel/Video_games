    %Daniel Gaebel
    %Professor: Omar Rivera Morales
    %COMSC.230.01
    %10-30-24
    
    %define all males
    male(dan).
    male(nick).
    male(tomjr).
    male(drew).
    male(corey).
    male(tomsr).

    %Define all females
    female(sam).
    female(kim).
    female(emma).
    female(dina).
    female(wendy).

    %Define all parents
    parent(kim,dan).
    parent(kim,nick).
    parent(kim,sam).
    parent(tomjr,dan).
    parent(tomjr,nick).
    parent(tomjr,sam).

    parent(corey,drew).
    parent(corey,emma).


    parent(wendy,tomjr).
    parent(wendy,dina).
    parent(wendy,corey).
    parent(tomsr,tomjr).
    parent(tomsr,dina).
    parent(tomsr,corey).

    mother(X,Y):-
        female(X),  %checks that X is female
        parent(X,Y). %checks that X is parent of Y

    father(X,Y):-
        male(X),    %checks that X is male
        parent(X,Y).%checks that X is parent of Y
    

    sister(X,Y):-
        X \= Y,
        female(X),  %checks that X is female
        parent(Z,X),%checks that Z is parent of X
        parent(Z,Y).%checks that Z is parent of Y

    grandson(X,Y):-
        male(X),    %checks that X is male
        parent(Z,X),%checks that Z is the parent of X
        parent(Y,Z).%checks that Y is the parent of Z

    firstCousin(X,Y):-
        parent(A,X),%checks that A is the parent of X
        parent(B,Y),%checks that B is the parent of Y
        parent(GP,A),%checks that GP is the parent of A
        parent(GP,B),%checks that GP is the parent of B
        A \= B,      %makes sure A isnt B
        X \= Y.      %makes sure X isnt Y

    descendant(X,Y):-
        parent(Y,X).
    descendant(X,Y):-
         parent(Z,X),
         descendant(Z,Y). %checks recursively that Z is a descendant of Y
    
    %checks the fourth element of a list
    fourth(X,Y):-
        length(X,Z),
        Z>=4,
        nth0(3,X,Y).
    %checks that the first two elements of two lists are the same
    firstPair([X,X| _]).
    %checks that two lists are the same except for the missing third variable 
    del3([X,Y,_|Z], [X,Y|Z]).
