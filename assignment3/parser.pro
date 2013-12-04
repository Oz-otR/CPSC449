:- dynamic(error/1).
error(nil).
testPA("(1,A)\n(2,B)  \n(3,C)\n(4,D)\n").
testMP("1 2 3 4 5 6 7 8\n1 2 3 4 5 6 7 8\n1 2 3 4 5 6 7 8\n1 2 3 4 5 6 7 8\n1 2 3 4 5 6 7 8\n1 2 3 4 5 6 7 8\n1 2 3 4 5 6 7 8 \n\n").
test :-
  retract(error(X)),
  asserta(error(nil)),
  retractall(partialAssignment(X,Y)),
  testPA(L),!,
  parsePartialAssignments(L, R).

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
parsePartialAssignments(I, R) :-
  getTrimmedLine(I, [], R).
parsePartialAssignments(I, R) :-
  getTrimmedLine(I, Line, R1),!,
  parsePartialAssignment(Line),!,
  parsePartialAssignments(R1, R).

parsePartialAssignment(I) :-
  parsePartialAssignment_(I),!.
parsePartialAssignment(_) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidPartialAssignment)).

parsePartialAssignment_(I) :-
  error(nil),
  paTuple(I, M, T),!,
  \+ partialAssignment(M,X),!,
  \+ partialAssignment(Y,T),!,
  assertz(partialAssignment(M,T)), !.

paTuple(Word, M, T) :-
  paTuple_(Word, M, T).
paTuple(_, 0, 0) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
  
paTuple_(Word, M, T) :-
  removePrefix("(", Word, R1),!,
  machineNumber(R1, M, R2),!,
  removePrefix(",", R2, R3),!,
  taskNumber(R3, T, R4),!,
  removePrefix(")", R4, []),!.

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

parseMachinePenalties(I, R) :-
  parseMachinePenalties_(I, R, 1).

parseMachinePenalties_(I, R, 8) :-
  error(nil),
  getTrimmedLine(I, Line, R),!,
  parseMachinePenalty(Line, 8).
parseMachinePenalties_(I, R, Num) :-
  error(nil),
  getTrimmedLine(I, Line, R1),!,
  parseMachinePenalty(Line, Num),!,
  Next is Num + 1,!,
  parseMachinePenalties_(R1, R, Next).

parseMachinePenalty(I, Row) :-
  parseMachinePenalty_(I, 1, Row),!.
parseMachinePenalty(_, _) :-
  error(nil),!,
  retract(error(nil)),!,
  asserta(error(invalidMachinePenalty)).

parseMachinePenalty_([], _, _) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidMachinePenalty)).
parseMachinePenalty_(I, _, _):-
  removePrefix(" ", I, _),!,
  error(nil),!,
  retract(error(nil)),!,
  asserta(error(parseErr)).
parseMachinePenalty_(I, 8, Row) :-
  error(nil),!,
  parseWord(I, Row, 8, []).
parseMachinePenalty_(I, Num, Row):-
  error(nil),!,
  parseWord(I, Row, Num, R),!,
  Next is Num + 1,!,
  parseMachinePenalty_(R, Next, Row).

parseWord(Line, M, T, R) :-
  getWord(Line, Word, R),!,
  penaltyNumber(Word, P, []),!,
  assertz(machinePenalty(M, T, P)),!.

getWord([], [], []).
getWord([10|I], [], I).
getWord([32|I], [], I).
getWord([C|I], [C|O], R) :-
  getWord(I, O, R).

getTrimmedLine(I, O, R):-
  getLine(I, Line, R),!,
  rtrim(Line, O).

getLine([],[],[]).
getLine([10|I], [], I).
getLine([C|I], [C|Next], R) :-
  getLine(I, Next, R).

rtrim([],[]).
rtrim([10], []).
rtrim([32], []).
rtrim([10|T], []) :-
  rtrim(T, []).
rtrim([32|T], []) :-
  rtrim(T, []).
rtrim([H|T], [H|O]) :-
  rtrim(T, O).

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
