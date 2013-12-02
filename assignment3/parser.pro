parse(X, ERR) :-
  titleHeader(X, R1, ERR),!,
  fpaHeader(R1, R2, ERR),!,
  mpHeader(R2, R3, ERR).

titleHeader([], [], parseErr).
titleHeader(X, R, ERR) :- 
  removePrefix("Name:", X, Q),
  line_end(Q, R, ERR).
titleHeader(_,[],parseErr).
titleHeader(_,[],_).

fpaHeader([], [], parseErr2).
fpaHeader(X, R, ERR) :-
  removePrefix("forced partial assignment:", X, Q),
  line_end(Q, R, ERR).
fpaHeader(_,[],parseErr2).
fpaHeader(_,[],_).

mpHeader([], [], parseErr3).
mpHeader(X, R, ERR) :-
  removePrefix("machine penalties:", X, Q),
  line_end(Q, R, ERR).
mpHeader(_,[],parseErr3).
mpHeader(_,[],_).


%------------------------------------------------------------------------------
% Forced partial assignments.
%------------------------------------------------------------------------------
parsePartialAssignment(I, R, Err) :- parsePartialAssignment_(I, R, Err),!.
parsePartialAssignment(_, _, err).

parsePartialAssignment_(I, R, ERR) :-
  removePrefix("(", I, R1),!,
  machineNumber(R1, NUM1, R2),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, NUM2, R4),!,
  removePrefix(")", R4, R),!,
  assertz(partialAssignment(NUM1,NUM2)), !.
parsePartialAssignment_(_, [], err).

%------------------------------------------------------------------------------
% Forbidden machines.
%------------------------------------------------------------------------------
parseForbiddenMachine(I, R, Err) :- parseForbiddenMachine_(I, R, Err),!.
parseForbiddenMachine(_, _, err).

parseForbiddenMachine_(I, R, ERR) :-
  removePrefix("(", I, R1),!,
  machineNumber(R1, NUM1, R2),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, NUM2, R4),!,
  removePrefix(")", R4, R),!,
  assertz(forbiddenMachine(NUM1,NUM2)), !.
parseForbiddenMachine_(_, [], err).

%------------------------------------------------------------------------------
% Too-near tasks.
%------------------------------------------------------------------------------
parseTooNearTasks(I, R, Err) :- parseTooNearTasks_(I, R, Err),!.
parseTooNearTasks(_, _, err).

parseTooNearTasks_(I, R, ERR) :-
  removePrefix("(", I, R1),!,
  taskNumber(R1, NUM1, R2, ERR),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, NUM2, R4, ERR),!,
  removePrefix(")", R4, R),!,
  assertz(tooNearTask(NUM1,NUM2)), !.
parseTooNearTasks_(_, [], err).

%------------------------------------------------------------------------------
% Too-near tasks.
%------------------------------------------------------------------------------

%------------------------------------------------------------------------------
% Too near penalties.
%------------------------------------------------------------------------------
parseTooNearPenalties(I, R, Err) :- parseTooNearPenalties_(I, R, Err),!.
parseTooNearPenalties(_, _, parseErr).

parseTooNearPenalties_(I, R, Err) :-
  removePrefix("(", I, R1),!,
  taskNumber(R1, T1, R2, Err),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, T2, R4, Err),!,
  removePrefix(",", R4, R5),!,
  penaltyNumber(R5, P, R6, Err),!,
  removePrefix(")", R6, R),!,
  assertz(tooNearPenalty(T1,T2,P)), !.
parseTooNearPenalties_(_, [], err).


/*
Takes input string I and returns the first found Task
number in O, with the unprocessed input in R. Error codes
are in the final variable.
*/
taskNumber([65|T], 1, T, _) :- !.
taskNumber([66|T], 2, T, _) :- !.
taskNumber([67|T], 3, T, _) :- !.
taskNumber([68|T], 4, T, _) :- !.
taskNumber([69|T], 5, T, _) :- !.
taskNumber([70|T], 6, T, _) :- !.
taskNumber([71|T], 7, T, _) :- !.
taskNumber([72|T], 8, T, _) :- !.
taskNumber(_, _, [], invalidTask).

/*
Takes input string I and returns the first found integer
in O, with the unprocessed input in R. Error codes
are in the final variable.
*/
penaltyNumber([], _, _, invalidPenalty).
penaltyNumber(I, O, R, _) :-
  number(I, O, R).
penaltyNumber(_, _, [], invalidPenalty).


machineNumber([],_, _) :-
  error(nil),
  retract(error(nil)),
  error(invalidMachine).

machineNumber(I, O, R) :- 
  error(nil),
  number(I, O, R),
  O < 8,
  O > 0.

machineNumber(_, _, []) :-
  error(nil),
  retract(error(nil)),
  error(invalidMachine).

number([H|T], O, R) :-
  error(nil),
  isDigit(H),!,
  number_([H|T], [], N, R),
  number_codes(O, N),!.

number_([H|I], SOFAR, O, R) :-
  error(nil),
  isDigit(H),
  append(SOFAR, [H], NEXT),
  number_(I, NEXT, O, R).
number_(I, SOFAR, SOFAR, I) :-
  error(nil).

isDigit(N) :- N > 47, N < 58.

line_end([], [], ERR).
line_end(X, R, ERR) :- removePrefix(" ", X, R1), line_end(R1, R, ERR).
line_end(X, R, ERR) :- removePrefix("\n", X, R).
line_end(_,_,parseErr).

removeLast([_|[]], []).
removeLast([H|T], [H|Q]) :- removeLast(T, Q).

toAtoms([H|[]],[C]) :- atom_codes(C, [H]).
toAtoms([H|T], [C|R]) :- atom_codes(C, [H]), toAtoms(T, R).

toString([H|[]], [C]) :- atom_codes(H, [C]).
toString([H|T], [C|R]) :- atom_codes(H, [C]), toString(T, R).

removePrefix([], Y, Y).
removePrefix([H|[]], [H|Y], Y).
removePrefix([H|X], [H|Y], R) :- removePrefix(X, Y, R).
