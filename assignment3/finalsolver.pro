task_position_pen(a,4,0).
task_position_pen(b,3,1).
task_position_pen(c,5,2).
task_position_pen(d,7,3).
task_position_pen(e,1,4).
task_position_pen(f,6,5).
task_position_pen(g,2,6).
task_position_pen(h,3,7).





task_letter_value(a,0).
task_letter_value(b,1).
task_letter_value(c,2).
task_letter_value(d,3).
task_letter_value(e,4).
task_letter_value(f,5).
task_letter_value(g,6).
task_letter_value(h,7).

adjacent_pair_val(a,b,5).
adjacent_pair_val(c,d,15).

bestVal([99999999999999]).
error_list([err]).
test_list([0,0,0,0,0,0,0,0]).
error([0]).
bestlist([-1,-1,-1,-1,-1,-1,-1,-1]).
%forced partial err	1
%too near task		2
%
%

solver(Best_list,Value) :-
	test_list(solvable),
	setup_forced_partial(solvable,0,Returned),
	error(nil),
	getRemaingTasks(Returned,Remaining),
	main_solve(Returned,Remaining),
	error(nil),
	Value is bestVal(X),
	Best_list = bestlist.
	
%Potentially updates best
main_solver(CurrentList,[]) :-
	tList(CurrentList,BestList,Value,List),
	retract(BestList),
	retract(BestVal),
	BestList = List,
	BestVal is Value,
	asserta(Value),
	asserta(BestList).
	
main_solver(CurrentList,Remaining) :-
	
	error(nil),
	bestlist(X),
	get_value_of_list(X,Y),
	get_value_of_list(CurrentList,Z),
	Y>Z,
	getNextTaskToTry(Remaining,NewRemain,Element),

	main_solver_helper(CurrentList, Remaining).
	
%Normal loop
main_solver_helper(CurrentList,RemainingList) :-

	getNextTaskToTry(RemainingList,NewRemaining,Element),
	assignnext(CurrentList,Element,Position,NewList),%%%
	\+forbiddenMachine(Position,Element),
	getNextElement(NewList,Element,Nextelem),
	\+tooNear(Element,NextElem),
	main_solver(NewList,NewRemaining),
	main_solver_helper(CurrentList,NewRemainingList).
	

%Too near error
main_solver_helper(CurrentList,RemainingList) :-

	getNextTaskToTry(RemainingList,NewRemaining,elem),
	assignnext(Element,Position,NewList),
	\+forbiddenMachine(Position,Elem),
	getNextElement(Nextelem),
	tooNear(Element,NextElem),
	retract(error(nil)),
	asserta(error(toonear)).

%Too near error
main_solver_helper(CurrentList,RemainingList) :-

	getNextTaskToTry(RemainingList,NewRemaining,elem),
	assignnext(Element,Position,NewList),
	forbiddenMachine(Position,Elem),
	retract(error(nil)),
	asserta(error(forbidden)).	
	
getNextTaskToTry([H|T],T,Element) :-
	Element is H.
	
setup_forced_partial(List,8,List).	
setup_forced_partial(Blank,Mach,ReturnedList) :-
	partialAssignment(Mach,Task),
	check_for_forbidden(Mach,Task),
	error(nil),
	replace_at_position(Blank,Task,Mach,NewList),
	NewMach is Mach + 1,
	setup_forced_partial(NewList,NewMach,RList),
	ReturnedList = RList.
	

replace_at_position([_|T],Task,0,[Task|T]).
replace_at_position([H|T],Task,Position,[H|Rest]) :-

	NextPosition is Position - 1,
	replace_at_position(T,Task,NextPosition,Re),
	Rest = Re.
	
	
check_for_forbidden(Mach,Task) :-
	forbiddenMachine(Mach,Task),
	retract(error(nil)),
	asserta(error(forbidden)).
	
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
	
	
	
	
get_value_of_list(List,Value) :-
	mcalc_near_pen(List,0,Result),
	takelist(List,0,X),
	list_sum(X,Z),
	Value is Result + Z.
	
	
assignNext(List,Element,Position,NewList) :-
	getPosition(List,Element,0,Posi),
	replace_at_position(List,Element,Posi,NewL),!,
	Position is Posi,
	NewList = NewL.
	
	
getPosition([H|T],H,N,N).

getPosition([H|T],Elem,Counter,Position) :-
	Next is Counter + 1,
	getPosition(T,Elem,Counter,NPos),
	Position is NPos.
	
	
	
	
	
	
	
	
	
	
	