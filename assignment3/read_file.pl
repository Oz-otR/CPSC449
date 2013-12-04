/*program reads in file and outputs it as a list of characters which is stored in the database.
*/

:-dynamic(contents/1).
    
/*    X is the file name, Y is the output*/
inputoutput(X,Y):-
  retractall(contents(_)),
  see(X),
  read_file(3,X1),       /*Y1 is the holder of character int code list*/
  seen,
  removeLast(X1, Y1),
  assert(contents(Y1)),
  /*%Y = Y2,
  write_file('writetry.txt',Y).*/
  parse,
  error(Z),
  !,
  parseerrors(Z,Y), %check for errors, include output filename.
  retract(error(_)).
  solve,
  error(Z),
  !,
  parseerrors(Z,Y),
  retract(error(_)).
  solutionformat(Out),
  write_file(Y,Out),!.
  

read_file(-1,[]).
read_file(_,Y):-
    get0(Z),
    read_file(Z,W),
    Y = [Z|W].
    
removeLast([_|[]],[]).
removeLast([H|T],[H|Q]) :- removeLast(T,Q).

parseerrors(nil, _).
parseerrors(forcedPartialError, X):-
  write_file(X,"partial assignment error"),
  fail.
parseerrors(invalidMachineTask, X):-
  write_file(X,"invalid machine/task"),
  fail.
parseerrors(machinePenaltyError, X):-
  write_file(X,"machine penalty error"),
  fail.
parseerrors(invalidTaskError, X):-
  write_file(X,"invalid task"),
  fail.
parseerrors(invalidPenaltyError, X):-
  write_file(X,"invalid penalty"),
  fail.
parseerrors(parseErr, X):-
  write_file(X,"Error while parsing input file"),
  fail.

parse:-
  asserta(error(nil)).
  
solve:-
  asserta(error(nil)).
  
solutionformat(FinalOutput):-
  Output1 = "Solution ",
  solver_solution(X),
  getelement(1,X,Y1),
  append(Output1,[Y1,32],Output2),
  getelement(2,X,Y2),
  append(Output2,[Y2],Output3),
  getelement(3,X,Y3),
  append(Output3,[Y3],Output4),
  getelement(4,X,Y4),
  append(Output4,[Y4],Output5),
  getelement(5,X,Y5),
  append(Output5,[Y5],Output6),
  getelement(6,X,Y6),
  append(Output6,[Y6],Output7),
  getelement(7,X,Y7),
  append(Output7,[Y7],Output8),
  getelement(8,X,Y8),
  append(Output8,[Y8],Output9),
  append(Output9,"; Quality: ",Output10),
  getelement(9,X,Y9),
  Z0 is Y9 mod 1000,
  Z1 is Y9 mod 100,
  Ones is Y9 mod 10,
  Tens is Z1 // 10,
  Hundreds is Z0 // 100,
  Thousands is Y9 // 1000,
  List = [Thousands, Hundreds, Tens, Ones],
  append(Output10,List,FinalOutput).

getelement(0,[H|T],H).
getelement(X,[H|T],Z):-
  Y is X - 1,
  getelement(Y,T,Z).
  
  
/*knowledge base contains a predicate of output
 *for now: X = file name, Y = string to write*/
write_file(X,Y):-
  tell(X),
  outputstuff(Y),
  told,!.
/*  
outputstuff([]).
outputstuff([Head|Tail]):-
  atom_codes(X,[Head]),
  write(X),
  outputstuff(Tail).*/

outputstuff(Y):-
  atom_codes(X,Y),
  write(X).