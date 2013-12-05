/*program reads in file and outputs it as a list of characters which is stored in the database.
*/

:- dynamic(
  contents/1,
  error/1,
  solver_solution/1,
  partialAssignment/2,
  forbiddenMachine/2,
  tooNear/2,
  machinePenalty/2,
  tooNearPenalty/2).

:- initialization(commandline).
commandline :- argument_value(1, X), argument_value(2, Y), write(X), write(Y), write('\n'), inputoutput(X,Y).
   
/*    X is the file name, Y is the output*/
inputoutput(X,Y):-
  retractall(contents(_)),
  retractall(error(_)),
  retractall(partialAssignment(_,_)),
  retractall(forbiddenMachine(_,_)),
  retractall(tooNear(_,_)),
  retractall(machinePenalty(_,_)),
  retractall(tooNearPenalty(_,_)),
  see(X),
  read_file(3,X1),       /*Y1 is the holder of character int code list*/
  seen,
  removeLast(X1, Y1),
  append(Y1,"\n\n\n", Y2),
  asserta(contents(Y2)),
  /*%Y = Y2,
  write_file('writetry.txt',Y).*/
  asserta(error(nil)),
  parse,
  error(Z),
  !,
  parseerrors(Z,Y), %check for errors, include output filename.
  solve,
  error(Z),
  !,
  parseerrors(Z,Y),
  retract(error(_)),
  solutionformat(Out),
  write_file(Y,Out),!.
  

read_file(-1,[]).
read_file(_,Y):-
    get0(Z),
    read_file(Z,W),
    Y = [Z|W].
    
parseerrors(nil, _).
parseerrors(invalidPartialAssignment, X):-
  write_file(X,"partial assignment error"),
  fail.
parseerrors(invalidMachineTask, X):-
  write_file(X,"invalid machine/task"),
  fail.
parseerrors(invalidMachinePenalty, X):-
  write_file(X,"machine penalty error"),
  fail.
parseerrors(invalidTask, X):-
  write_file(X,"invalid task"),
  fail.
parseerrors(invalidPenalty, X):-
  write_file(X,"invalid penalty"),
  fail.
parseerrors(parseErr, X):-
  write_file(X,"Error while parsing input file"),
  fail.
parseerrors(noValidSolution, X):-
  write_file(X,"No valid solution possible!"),
  fail.
  
solve:-
  asserta(error(nil)),
  asserta(solver_solution([a,b,d,c,f,g,e,h,99])).
  
solutionformat(FinalOutput):-
  Output1 = "Solution ",
  solver_solution(X),
  getelement(1,X,Y1),
  atom_codes(Y1,Z1),
  append(Output1,Z1,Output2),
  getelement(2,X,Y2),
  atom_codes(Y2,Z2),
  append(Output2,Z2,Output3),
  getelement(3,X,Y3),
  atom_codes(Y3,Z3),
  append(Output3,Z3,Output4),
  getelement(4,X,Y4),
  atom_codes(Y4,Z4),
  append(Output4,Z4,Output5),
  getelement(5,X,Y5),
  atom_codes(Y5,Z5),
  append(Output5,Z5,Output6),
  getelement(6,X,Y6),
  atom_codes(Y6,Z6),
  append(Output6,Z6,Output7),
  getelement(7,X,Y7),
  atom_codes(Y7,Z7),
  append(Output7,Z7,Output8),
  getelement(8,X,Y8),
  atom_codes(Y8,Z8),
  append(Output8,Z8,Output9),
  append(Output9,"; Quality: ",Output10),
  getelement(9,X,Y9),
  number_codes(Y9,Z9),
  append(Output10,Z9,FinalOutput), !.

getelement(1,[H|_],H).
getelement(X,[_|T],Z):-
  Y is X - 1,
  getelement(Y,T,Z).
  
  
/*knowledge base contains a predicate of output
 *for now: X = file name, Y = string to write*/
write_file(X,Y):-
  tell(X),
  outputstuff(Y),
  told,!.

outputstuff(Y):-
  atom_codes(X,Y),  
  write(X).
  

  
/*here starts the parser*/

/*
Order:
  Partial assignments
  Forbidden machines
  Too-near tasks
  Machine penalties
  Too-near penalties
*/

parse :-
  parse_.
parse :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
parse.

parse_ :-
  contents(X),!,
  titleHeader(X, R1),!,
  fpaHeader(R1, R2),!,
  fmHeader(R2,R3),!,
  tntHeader(R3, R4),!,
  mpHeader(R4, R5), !,
  tnpHeader(R5, R6),!,
  hasNoCrap(R6).

titleHeader([], []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
titleHeader(X, R) :- 
  removePrefix("Name:", X, Q),!,
  line_end(Q, R1),!,
  getTrimmedLine(R1, _, R2),!,
  line_end(R2, R).

fpaHeader([], []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
fpaHeader(X, R) :-
  removePrefix("forced partial assignment:", X, Q),!,
  line_end(Q, R1),!,
  parsePartialAssignments(R1, R).

fmHeader([], []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
fmHeader(X, R) :-
  removePrefix("forbidden machine:", X, Q),!,
  line_end(Q, L),!,
  parseForbiddenMachines(L, R).

tntHeader([], []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
tntHeader(X, R) :-
  removePrefix("too-near tasks:", X, Q),!,
  line_end(Q, L),!,
  parseTooNearTasks(L, R).

mpHeader([], []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
mpHeader(X, R) :-
  removePrefix("machine penalties:", X, Q),!,
  line_end(Q, L),!,
  parseMachinePenalties(L, R).

tnpHeader([], []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
tnpHeader(X, R) :-
  removePrefix("too-near penalities", X, Q),!,
  line_end(Q, L),!,
  parseTooNearPenalties(L, R).

hasNoCrap([]).
hasNoCrap([10|I]) :-
  hasNoCrap(I).
hasNoCrap([32|I]) :-
  hasNoCrap(I).
  
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
  error(nil),!,
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
paTuple(_, 0, 0).
  
paTuple_(Word, M, T) :-
  removePrefix("(", Word, R1),!,
  notSpace(R1),!,
  machineNumber(R1, M, R2),!,
  removePrefix(",", R2, R3),!,
  notSpace(R3),!,
  taskNumberConstraint(R3, T, R4),!,
  removePrefix(")", R4, []),!.

%------------------------------------------------------------------------------
% Forbidden machines.
%------------------------------------------------------------------------------
parseForbiddenMachines(I, R) :-
  getTrimmedLine(I, [], R).
parseForbiddenMachines(I, R) :-
  getTrimmedLine(I, Line, R1),!,
  parseForbiddenMachine(Line),!,
  parseForbiddenMachines(R1, R).

parseForbiddenMachine(I) :-
  parseForbiddenMachine_(I),!.
parseForbiddenMachine(_) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidForbiddenMachine)).

parseForbiddenMachine_(I) :-
  error(nil),
  fmTuple(I, M, T),!,
  assertz(forbiddenMachine(M,T)), !.

fmTuple(Word, M, T) :-
  fmTuple_(Word, M, T).
fmTuple(_, 0, 0) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
  
fmTuple_(Word, M, T) :-
  removePrefix("(", Word, R1),!,
  notSpace(R1),!,
  machineNumber(R1, M, R2),!,
  removePrefix(",", R2, R3),!,
  notSpace(R3),!,
  taskNumberConstraint(R3, T, R4),!,
  removePrefix(")", R4, []),!.

%------------------------------------------------------------------------------
% Too-near tasks.
%------------------------------------------------------------------------------
parseTooNearTasks(I, R) :-
  getTrimmedLine(I, [], R).
parseTooNearTasks(I, R) :-
  getTrimmedLine(I, Line, R1),!,
  parseTooNearTask(Line),!,
  parseTooNearTasks(R1, R).

parseTooNearTask(I) :-
  parseTooNearTask_(I),!.
parseTooNearTask(_) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidTooNearTask)).

parseTooNearTask_(I) :-
  error(nil),
  tnTuple(I, M, T),!,
  assertz(tooNear(M,T)), !.

tnTuple(Word, M, T) :-
  tnTuple_(Word, M, T).
tnTuple(_, 0, 0) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
  
tnTuple_(Word, M, T) :-
  removePrefix("(", Word, R1),!,
  notSpace(R1),!,
  taskNumberConstraint(R1, M, R2),!,
  removePrefix(",", R2, R3),!,
  notSpace(R3),!,
  taskNumberConstraint(R3, T, R4),!,
  removePrefix(")", R4, []),!.
%------------------------------------------------------------------------------
% Machine penalties.
%------------------------------------------------------------------------------

parseMachinePenalties(I, R) :-
  parseMachinePenalties_(I, R1, 1),
  line_end(R1, R).
parseMachinePenalties(_, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidMachinePenalty)).

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
  asserta(error(parseErr)).

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

%------------------------------------------------------------------------------
% Too near penalties.
%------------------------------------------------------------------------------
parseTooNearPenalties(I, R) :-
  getTrimmedLine(I, [], R).
parseTooNearPenalties(I, R) :-
  getTrimmedLine(I, Line, R1),!,
  parseTooNearPenalty(Line),!,
  parseTooNearPenalties(R1, R).

parseTooNearPenalty(I) :-
  parseTooNearPenalty_(I),!.
parseTooNearPenalty(_) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidTooNearTask)).

parseTooNearPenalty_(I) :-
  error(nil),
  tnpTuple(I, M, T, P),!,
  assertz(tooNearPenalty(M,T,P)), !.

tnpTuple(Word, M, T, P) :-
  tnpTuple_(Word, M, T, P).
tnpTuple(_, 0, 0) :-
  error(nil),
  retract(error(nil)),
  asserta(error(parseErr)).
  
tnpTuple_(Word, M, T, P) :-
  removePrefix("(", Word, R1),!,
  notSpace(R1),!,
  taskNumberPenalty(R1, M, R2),!,
  removePrefix(",", R2, R3),!,
  notSpace(R3),!,
  taskNumberPenalty(R3, T, R4),!,
  removePrefix(",", R4, R5),!,
  notSpace(R5),!,
  penaltyNumber(R5, P, R6),!,
  removePrefix(")", R6, []),!.

/*
Takes input string I and returns the first found Task
number in O, with the unprocessed input in R. Error codes
are in the final variable.
*/
taskNumberConstraint(I, P, T) :-
  error(nil),
  taskNumber(I, P, T).
taskNumberConstraint(_, _, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidMachineTask)).

taskNumberPenalty(I, P, T) :-
  error(nil),
  taskNumber(I, P, T).
taskNumberPenalty(_, _, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidTask)).

taskNumber([65|T], 1, T).
taskNumber([66|T], 2, T).
taskNumber([67|T], 3, T).
taskNumber([68|T], 4, T).
taskNumber([69|T], 5, T).
taskNumber([70|T], 6, T).
taskNumber([71|T], 7, T).
taskNumber([72|T], 8, T).
taskNumber([97|T], 1, T).
taskNumber([98|T], 2, T).
taskNumber([99|T], 3, T).
taskNumber([100|T], 4, T).
taskNumber([101|T], 5, T).
taskNumber([102|T], 6, T).
taskNumber([103|T], 7, T).
taskNumber([104|T], 8, T).

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

notSpace(I) :- \+ isSpace(I).
isSpace([9|I]).
isSpace([10|I]).
isSpace([32|I]).

getWord([], [], []).
getWord([9|I], [], I).
getWord([10|I], [], I).
getWord([32|I], [], I).
getWord([C|I], [C|O], R) :-
  C \== 10,
  C \== 32,
  getWord(I, O, R).

getTrimmedLine(I, O, R):-
  getLine(I, Line, R),!,
  rtrim(Line, O).

getLine([],[],[]).
getLine([10|I], [], I).
getLine([C|I], [C|Next], R) :-
  getLine(I, Next, R).

rtrim([],[]).
rtrim([9], []).
rtrim([10], []).
rtrim([32], []).
rtrim([9|T], []) :-
  rtrim(T, []).
rtrim([10|T], []) :-
  rtrim(T, []).
rtrim([32|T], []) :-
  rtrim(T, []).

rtrim([H|T], [H|O]) :-
  rtrim(T, O).

machineNumber([],_, _) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidMachineTask)).
machineNumber(I, O, R) :- 
  error(nil),
  number(I, O, R),
  O < 8,
  O > 0.
machineNumber(_, _, []) :-
  error(nil),
  retract(error(nil)),
  asserta(error(invalidMachineTask)).

number([H|T], O, R) :-
  error(nil),
  isDigit(H),!,
  number_([H|T], [], N, R),!,
  number_codes(O, N),!.

number_([H|I], SOFAR, O, R) :-
  error(nil),
  isDigit(H),
  append(SOFAR, [H], NEXT),
  number_(I, NEXT, O, R).
number_(I, SOFAR, SOFAR, I) :-
  error(nil).

isDigit(N) :- N > 47,!, N < 58.

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
