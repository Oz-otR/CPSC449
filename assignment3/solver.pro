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

best_value_err([99999999999999]).
error_list([err]).
test_list([0,0,0,0,0,0,0,0]).
error([0]).
%forced partial err	1
%too near task		2
%
%

solver(Best_list,Value) :-
	setup_forced_partial(     returns:CurrentList,Error)
	check_too_near_task(Error)
	error =:= 0,
	main_solver(CurrentList,FinalList,BestValue)
	Best_list is FinalList,
	Value is BestValue;
	
	Best_list is error_list(X),
	Value is best_value_err(Y).

% Danny's random doodling
%
main_solver(CurrentList,Final,Value) :-
	main_solver(CurrentList, Final, Value).
	
check_partial(CurrentList) :- something.
check_forbiddenMachine(CurrentList) :- something.
check_tooNear(CurrentList) :- something.
check_penality(CurrentList, Penalty) :- something.
	
%	
	
	

setup_forced_partial(Blank,    ,ReturnedList,Error) :-
	
	get_assignment(X,Task,Position),
	replace_at_position(Blank,Task,Position,NewList,Error),
	setup_forced_partial(NewList,      ReturnedList,Error),
	
	

check_error() :- stub

get_penalty_value() :- stub

replace_at_position([_|T],Task,0,[Task|T],Error).
replace_at_position([H|T],Task,Position,[H|Rest],Error) :-
	Position >= 0,
	Position < 8,
	NextPosition = Position - 1,
	Error is 0,
	replace_at_position(T,Task,NextPosition,Rest);
	Error is 9.
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	



