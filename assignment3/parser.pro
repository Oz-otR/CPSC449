:- dynamic(error/1).
error(nil).

parse(X) :-
  asserta(error(nil)),
  titleHeader(X, R1),!,
  fpaHeader(R1, R2),!,
  parsePartialAssignments(R2, R3),!,
  mpHeader(R2, R3).

titleHeader([], []).
titleHeader(X, R) :- 
  removePrefix("Name:", X, Q),
  line_end(Q, R).
titleHeader(_,[]).
titleHeader(_,[],_).

fpaHeader([], []).
fpaHeader(X, R) :-
  removePrefix("forced partial assignment:", X, Q),
  line_end(Q, R).
fpaHeader(_,[]).
fpaHeader(_,[],_).

mpHeader([], []).
mpHeader(X, R) :-
  removePrefix("machine penalties:", X, Q),
  line_end(Q, R).
mpHeader(_,[]).
mpHeader(_,[],_).

%------------------------------------------------------------------------------
% Forced partial assignments.
%------------------------------------------------------------------------------
parsePartialAssignments([],[]) :-
  error(nil).
parsePartialAssignments(I, R) :-
  error(nil),
  line_end(I, R).
parsePartialAssignments(I, R) :-
  error(nil),
  parsePartialAssignment(I, R1),!,
  line_end(R1, R2),!,
  parsePartialAssignments(R2, R).

parsePartialAssignment(I, R) :-
  parsePartialAssignment_(I, R),!.
parsePartialAssignment(_, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidPartialAssignment)).

parsePartialAssignment_(I, R) :-
  error(nil),
  removePrefix("(", I, R1),!,
  machineNumber(R1, NUM1, R2),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, NUM2, R4),!,
  removePrefix(")", R4, R),!,
  assertz(partialAssignment(NUM1,NUM2)), !.

%------------------------------------------------------------------------------
% Forbidden machines.
%------------------------------------------------------------------------------
parseForbiddenMachines([], []) :-
  error(nil).
parseForbiddenMachines(I, R) :-
  error(nil),
  line_end(I, R).
parseForbiddenMachines(I, R) :-
  error(nil),
  parseForbiddenMachine(I, R1),
  line_end(R1, R2),
  parseForbiddenMachines(R1, R).

parseForbiddenMachine(I, R) :-
  parseForbiddenMachine_(I, R, Err),!.
parseForbiddenMachine(_, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidForbiddenMachine)).

parseForbiddenMachine_(I, R) :-
  removePrefix("(", I, R1),!,
  machineNumber(R1, NUM1, R2),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, NUM2, R4),!,
  removePrefix(")", R4, R),!,
  assertz(forbiddenMachine(NUM1,NUM2)), !.

%------------------------------------------------------------------------------
% Too-near tasks.
%------------------------------------------------------------------------------
parseTooNearTasks([], []) :-
  error(nil).
parseTooNearTasks(I, R) :-
  error(nil),
  line_end(I, R).
parseTooNearTasks(I, R) :-
  error(nil),
  parseTooNearTask(I, R1),
  line_end(R1, R2),
  parseTooNearTasks(R2, R).

parseTooNearTask(I, R) :-
  parseTooNearTask_(I, R),!.
parseTooNearTask(_, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidTooNearTask)).

parseTooNearTask_(I, R) :-
  removePrefix("(", I, R1),!,
  taskNumber(R1, NUM1, R2),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, NUM2, R4),!,
  removePrefix(")", R4, R),!,
  assertz(tooNearTask(NUM1,NUM2)), !.

%------------------------------------------------------------------------------
% Machine penalties.
%------------------------------------------------------------------------------

%------------------------------------------------------------------------------
% Too near penalties.
%------------------------------------------------------------------------------
parseTooNearPenalties([], []) :-
  error(nil).
parseTooNearPenalties(I, R) :-
  error(nil),
  line_end(I, R).
parseTooNearPenalties(I, R) :-
  error(nil),
  parseTooNearPenalty(I, R1),
  line_end(R1, R2),
  parseTooNearPenalties(R2, R).

parseTooNearPenalty(I, R) :-
  parseTooNearPenalty_(I, R).
parseTooNearPenalty(_, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidTooNear)).

parseTooNearPenalty_(I, R) :-
  removePrefix("(", I, R1),!,
  taskNumber(R1, T1, R2),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, T2, R4),!,
  removePrefix(",", R4, R5),!,
  penaltyNumber(R5, P, R6),!,
  removePrefix(")", R6, R),!,
  assertz(tooNearPenalty(T1,T2,P)), !.


/*
Takes input string I and returns the first found Task
number in O, with the unprocessed input in R. Error codes
are in the final variable.
*/
taskNumber([65|T], 1, T) :- error(nil).
taskNumber([66|T], 2, T) :- error(nil).
taskNumber([67|T], 3, T) :- error(nil).
taskNumber([68|T], 4, T) :- error(nil).
taskNumber([69|T], 5, T) :- error(nil).
taskNumber([70|T], 6, T) :- error(nil).
taskNumber([71|T], 7, T) :- error(nil).
taskNumber([72|T], 8, T) :- error(nil).
taskNumber(_, _, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidTask)).

/*
Takes input string I and returns the first found integer
in O, with the unprocessed input in R. Error codes
are in the final variable.
*/
penaltyNumber([], _, _) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidPenalty)).
penaltyNumber(I, O, R) :-
  error(nil),
  number(I, O, R).
penaltyNumber(_, _, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidPenalty)).

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
  asserta(error(invalidMachine)).

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

line_end(X, R) :- removePrefix(" ", X, R1), line_end(R1, R).
line_end(X, R) :- removePrefix("\n", X, R).

removeLast([_|[]], []).
removeLast([H|T], [H|Q]) :- removeLast(T, Q).

toAtoms([H|[]],[C]) :- atom_codes(C, [H]).
toAtoms([H|T], [C|R]) :- atom_codes(C, [H]), toAtoms(T, R).

toString([H|[]], [C]) :- atom_codes(H, [C]).
toString([H|T], [C|R]) :- atom_codes(H, [C]), toString(T, R).

removePrefix([], Y, Y).
removePrefix([H|[]], [H|Y], Y).
removePrefix([H|X], [H|Y], R) :- removePrefix(X, Y, R).
