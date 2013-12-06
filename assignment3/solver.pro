:- dynamic(
	bestVal/1,
	%test_list/1,
	error/1,
	bestlist/1).

error(nil).
bestVal(99999999999999999).
bestlist([99,99,99,99,99,99,99,99]).
test_list([0,0,0,0,0,0,0,0]).

	
machinePenalty(A,Y,1).


forbiddenMachine(1,a).
forbiddenMachine(3,a).

partialAssignment(5,a).
partialAssignment(3,b).
partialAssignment(0,h).
partialAssignment(7,g).


adjacent_pair_val(a,b,5).
adjacent_pair_val(c,d,15).
tooNear(z,z).

task_position_pen(a,0,0).
task_position_pen(b,1,1).
task_position_pen(c,5,2).
task_position_pen(d,7,3).
task_position_pen(e,5,4).
task_position_pen(e,4,4).
task_position_pen(f,6,5).
task_position_pen(g,2,6).
task_position_pen(h,3,7).

%------------------------------------------------------------------------------

% Task letters

taskLetter(a).
taskLetter(b).
taskLetter(c).
taskLetter(d).
taskLetter(e).
taskLetter(f).
taskLetter(g).
taskLetter(h).

defaultRemaining([a,b,c,d,e,f,g,h]).

setup_forced_partial(List,8,List).
setup_forced_partial(List,Mach,Returned) :-
	error(nil),
	NewMach is Mach +1,
	setup_helper(List,Mach,ModList),!,
	error(nil),
	setup_forced_partial(ModList,NewMach,Returned),!.
	
setup_helper(List,Mach,Return) :-
	partialAssignment(Mach,Task),
	check_for_forbidden(Mach,Task),
	replace_at_position(List,Task,Mach,Return).
	
setup_helper(List,Mach,List) :-
	\+partialAssignment(Mach,Task).
	
setup_helper(List,Mach,List) :-	
	partialAssignment(Mach,Task),
	\+check_for_forbidden(Mach,Task),
	retract(error(nil)),
	asserta(error(NoValid)).

replace_at_position([_|T],Task,0,[Task|T]).
replace_at_position([H|T],Task,Position,[H|Rest]) :-

	NextPosition is Position - 1,
	replace_at_position(T,Task,NextPosition,Rest).
	

check_for_forbidden(Mach,Task) :-
	\+forbiddenMachine(Mach,Task).
	
/*
get_element(1,[H|_],H) :-
		
get_elem(List,Count,Max,Returnlist) :-	
	get_elem(List,Count+1,
	*/
getNextElement([],Elem,0).
getNextElement([H|[H1|T]],H,H1).	
getNextElement([H|T],Elem,ReturnElem) :-
	getNextElement(T,Elem,ReturnElem).
	
	
/*
get_value_of_list([],0).	
get_value_of_list(List,Value) :-
	mcalc_near_pen(List,0,Result),!,
	takelist(List,0,X),!,
	list_sum(X,Z),
	Value is Result + Z.
*/	
	
assignNext(List,Element,Position,NewList) :-
	getPosition(List,0,0,Posi),!,
	replace_at_position(List,Element,Posi,NewL),!,
	Position is Posi,
	NewList = NewL.
	
	

getPosition([H|T],H,N,N).
getPosition([H|T],Elem,Counter,Position) :-
	Next is Counter + 1,
	getPosition(T,Elem,Next,NPos),
	Position is NPos.


getRemainingTasks_helper(List,Remain,N,Return) :-
	getRemainingTasks(List,Remain,N,Return),!.
	

%Last Remove	
getRemainingTasks([H|T],ListOfRemaining,8,RemainingTasks) :- 
	taskLetter(H),
	removeElement_helper(H,ListOfRemaining,RemainingTasks).
	
%Normal	
getRemainingTasks([H|T],ListOfRemaining,N,RemainingTask) :- 
	taskLetter(H),
	removeElement_helper(H,ListOfRemaining,List),
	Next is N+1,
	getRemainingTasks_helper(T,List,Next,RemainingTask).

%Fail last remove
getRemainingTasks([H|T],ListOfRemaining,8,ListOfRemaining) :- 
	\+taskLetter(H).

%Normal fail remove	
getRemainingTasks([H|T],ListOfRemaining,N,RemainingTask) :-
	\+taskLetter(H),
	Next is N+1,
	getRemainingTasks_helper(T,ListOfRemaining,Next,RemainingTask).
	
removeElement_helper(Element,List,Return) :-
	removeElement(Element,List,Return),!.
	
removeElement(_, [], []).
removeElement(X, [X], []).
removeElement(X, [Y], [Y]).
removeElement(X, [X|XS], XS).
removeElement(X, [Y|XS], [Y|YS]) :-
	removeElement(X, XS, YS).
	
gatherList([],0).
gatherList(L,V) :-
	mcalc_near_pen(L,0,Result),
	takelist(L,0,X),
	list_sum(X,Z),
	V is Result + Z.

list_sum([],0).
list_sum([H|T],Sumr) :-
	list_sum(T,Rest),
	Sumr is H + Rest.
	


takelist([0|T],N,[0|Y]) :-	
	Next is N+1,
	takelist(T,Next,Y),!.

takelist([H|T],N,[X|Y]) :- 
	machinePenalty(N,H,X),
	Next is N+1,
	takelist(T,Next,Y),!.

takelist([],_,[]).
	
get_last_element([E],E).
get_last_element([_|T],X) :-
	get_last_element(T,X).

mcalc_near_pen(L,Current,R) :-
	calc_near_pen(L,Current,Result),!,%***********
	get_last_element(L,Y),!,
	[Head|_]=L,
	too_near_pen(Y,Head,V),
	R is Result + V.

calc_near_pen([],Current,Current).
calc_near_pen([E],Current,Current).	
calc_near_pen([E,E1|Rest],Current,Result) :-
	too_near_pen(E,E1,Val),
	Sum is Current + Val,
	calc_near_pen([E1|Rest],Sum,Result).
	
too_near_pen(X,Y,V) :-
	adjacent_pair_val(X,Y,Z),
	!,
	0<Z,
	V is Z;
	V is 0.
	
	
	
	

%%%%%%%%%%%%%%%
getNumberOfAssigned([],N,N).
getNumberOfAssigned([0|T],N,Return) :-
	getNumberOfAssigned(T,N,Return).
getNumberOfAssigned([H|T],N,Return) :-
	N is N + 1,
	getNumberOfAssigned(T,N,Return).
