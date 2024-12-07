/*
This is a little adventure game.  There are three
entities: you, a treasure, and an ogre.  There are
six places: a valley, a path, a cliff, a fork, a maze,
and a mountaintop.  Your goal is to get the treasure
without being killed first.
*/

/*
First, text descriptions of all the places in
the game.
*/
description(valley, 'You are in a pleasant valley, with a trail ahead.').
description(path,  'You are on a path, with ravines on both sides.').
description(cliff, 'You are teetering on the edge of a cliff.').
description(fork, 'You are at a fork in the path (go right or left)').
description(gate, 'You are at the gate, unlock it to move foward').
description(gateTemp,'').
description(maze(_),'You are in a maze of twisty trails, all alike.').
description(secret_room,"you've found a secret room with a Book of Knowledge.").
description(mountaintop,  'You are on the mountaintop.').
description(key_room, 'you are in a room with a key.').



/*condition(key,true):- key=true, write('Now you can open the gate'); key=false, write('You dont have the key').*/
/* report prints the description of your current  location. */

report :-  at(you,X),
  description(X,Y),
  write(Y), nl.


  /*These connect predicates establish the map.
  The meaning of connect(X,Dir,Y) is that if you
  are at X and you move in direction Dir, you
  get to Y.  Recognized directions are
  forward, right and left.*/
  connect(valley,forward,path).
  connect(path,right,cliff).
  connect(path,left,cliff).
  connect(path,forward,fork).
  connect(fork,left,maze(0)).
  connect(fork,right,gate).
  /*connect(gate,forward,gateTemp).*/
  connect(gate,forward,gateTemp).
  connect(gateTemp,forward,mountaintop).
  connect(gateTemp,backward,fork).
  connect(gate,backward,fork).
  connect(mountaintop,backward,fork).
  /*connect(gate,open,mountaintop).*/
  connect(maze(0),left,maze(1)).
  connect(maze(0),right,maze(3)).
  connect(maze(1),left,maze(0)).
  connect(maze(1),right,maze(2)).
  connect(maze(2),left,key_room).
  /*connect(key_room,pick_up,key_on_me).
  connect(key_on_me,left,gate).*/
  connect(key_room,right,maze(2)).
  /*connect(secret_room,pick_up,book).*/
  connect(secret_room,backward,key_on_me).
  connect(maze(2),right,maze(0)).
  connect(maze(2),forward,secret_room).
  connect(secret_room,right,gate).
  connect(maze(3),left,maze(0)).
  connect(maze(3),right,maze(3)).

  /* move(Dir) moves you in direction Dir, then
  prints the description of your new location. */

  move(Dir) :- 
    at(you,Loc),
    connect(Loc,Dir,Next),
    retract(at(you,Loc)),
    assert(at(you,Next)),
    report,
    ((Next = gateTemp) -> gate; true),
    !.

  move(pick_up):-
    pickup,
    !.

  /* But if the argument was not a legal direction,
  print an error message and don't move.*/

move(_) :-  write('That is not a legal move.\n'),
report.


/*Shorthand for moves.*/
forward :- move(forward).
left :- move(left).
right :- move(right).
backward :- move(backward).
open :- move(open).
pick_up :- move(pick_up),
  pickup.
drop :- move(throwaway).


/*If you and the ogre are at the same place, it  kills you.*/
ogre :- at(ogre,Loc),
at(you,Loc),
write('An ogre sucks your brain out through\n'),
write('your eyesockets, and you die.\n'),
retract(at(you,Loc)),
assert(at(you,done)),
!.
/*But if you and the ogre are not in the same place, nothing happens.*/
ogre.



/*If you and the key are at the same place, you can pick up the key.*/
key :- 
  at(key,Loc),
  at(you,Loc),
  write('You are in a room with a key\n'),
  !.
/*But if you and the key are not in the same place, nothing happens.
key.*/


book:-
  at(book,secret_room),
  at(you,secret_room),
  write('There is a Book of Knowledge.\n'),
  !.


/*gate function. */
gate:- 
    at(you, gate),
    \+ at(key, inv),
    \+ unlocked(gate),
    write('You need to unlock the gate first.\n'),
    !.
gate:- 
    at(you, gateTemp),
    unlocked(gate),
    at(key, inv),    
    write('ZAPPP! You are struck by lightning for trying to pass while holding the key!\n'),
    retract(at(you, gateTemp)),
    assert(at(you, done)),
    !.
gate:- 
    at(you, gateTemp),
    \+ unlocked(gate),
    write('You need to unlock the gate first.\n'),
    retract(at(you, gateTemp)),
    assert(at(you, gate)),
    !.
gate:- 
    at(you, gateTemp),
    unlocked(gate),
    \+ at(key, inv), 
    retract(at(you, gateTemp)),
    assert(at(you, mountaintop)),
    report,
    treasure,
    !.
gate.

/*unlock function*/
unlock:-
  at(you,gate),
  at(key,inv),
  \+ unlocked(gate),
  write('You unlock the gate.\n'),
  assert(unlocked(gate)),
  !.
unlock:-
  at(you,gate),
  \+ at(key,inv),
  \+ unlocked(gate),
  write('You need a key to do that.\n'),
  !.
unlock:-
  at(you,gate),
  unlocked(gate),
  write('The gate is already unlocked!\n'),
  !.
unlock.

/*pickup function*/
pickup:-
  at(you,Loc),
  at(key,Loc),
  write('You pick up the key.\n'),
  retract(at(key,Loc)),
  assert(at(key,inv)),
  !.
pickup :-
    at(you, Loc),
    at(book, Loc),
    write('You picked up the Book of Knowledge.\n'),
    retract(at(book, Loc)),
    assert(at(book, inv)),
    !.
pickup:-
  write('There is nothing to pick up.\n').


throwaway:-
  at(you,Loc),
  at(key,inv),
  write('You throw the key away.\n'),
  retract(at(key,inv)),
  assert(at(key,Loc)),
  !.
throwaway:-
  write('There is nothing to throw away.\n'),
  !.




/*If you and the treasure are at the same place, you win.*/
treasure :- 
  at(treasure,Loc),
  at(you,Loc),
  at(book,inv),
  write('There is a treasure here.\n'),
  write('You find out the real treasure is the wisdom the old man has to share.\n'),
  write('Congratulations, you win!\n'),
  retract(at(you,Loc)),
  assert(at(you,done)),
  !.
treasure :-
  at(treasure,Loc),
  at(you,Loc),
  \+ at(book,inv),
  write('You wander around, but find nothing but an old man.\n'),
  write('He says, "do not return for the treasure until you have aquired the knowledge to speak to me.'),
  !.

/*But if you and the treasure are not in the same place, nothing happens.*/
treasure.

/* If you are at the cliff, you fall off and die. */
cliff :- at(you,cliff),
write('You fall off and die.\n'),
retract(at(you,cliff)),
assert(at(you,done)),
!.
/* But if you are not at the cliff nothing happens.*/
cliff.

/*Main loop.  Stop if player won or lost.*/
main :- at(you,done),
write('Thanks for playing.\n'),
!.

/*  Main loop.  Not done, so get a move from the user and make it.
Then run all our special behaviors. Then repeat. */
main :-
write('\n Next move -- '),
read(Move),
call(Move),
ogre,
treasure,
cliff,
gate,
key,
book,
main.

/*This is the starting point for the game.  We
assert the initial conditions, print an initial
report, then start the main loop.*/
go :- 
retractall(at(_,_)), /* clean up from previous runs */
retractall(unlocked(_)),
assert(at(you,valley)),
assert(at(ogre,maze(3))),
assert(at(key_room,maze(2))),
assert(at(key,key_room)),
assert(at(book,secret_room)),
assert(at(treasure,mountaintop)),
write('This is an adventure game. \n'),
write('Legal moves are left, righ, forward, backward, open, pick_up and drop.\n'),
write('End each move with a period.\n\n'),
report,
main.
