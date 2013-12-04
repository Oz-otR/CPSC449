


/*            task,position,penalty  */
task_position_pen(a,0,0).
task_position_pen(b,1,1).
task_position_pen(c,5,2).
task_position_pen(d,7,3).
task_position_pen(e,5,4).
task_position_pen(e,4,4).
task_position_pen(f,6,5).
task_position_pen(g,2,6).
task_position_pen(h,3,7).


task_position_pen(c,0,2).
task_position_pen(d,0,3).
task_position_pen(c,1,2).
task_position_pen(d,1,3).
task_position_pen(c,2,2).
task_position_pen(d,2,3).
task_position_pen(c,3,2).
task_position_pen(d,3,3).
task_position_pen(c,4,2).
task_position_pen(d,4,3).
task_position_pen(c,6,2).
task_position_pen(d,5,3).
task_position_pen(c,7,2).
task_position_pen(d,6,3).


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



compare_lists(List1,List2,BestVal,BestList) :-
	mcalc_near_pen(List1,0,Result1),
	mcalc_near_pen(List2,0,Result2),
	takelist(List1,0,X1),
	takelist(List2,0,X2),
	list_sum(X1,Z1),
	list_sum(X2,Z2),
	Value1 is Result1 + Z1,
	Value2 is Result2 + Z2,
	Value1 > Value2,
	BestVal is Result2 + Z2,!,BestList = List2,!.

compare_lists(List1,List2,BestVal,BestList) :-
	mcalc_near_pen(List1,0,Result1),
	mcalc_near_pen(List2,0,Result2),
	takelist(List1,0,X1),
	takelist(List2,0,X2),
	list_sum(X1,Z1),
	list_sum(X2,Z2),
	Value1 is Result1 + Z1,
	Value2 is Result2 + Z2,
	Value2 >= Value1,
	BestVal is Result1 + Z1,!,BestList = List1,!.
		



tlist(V,N) :-
	mylist(L),
	otherlist(List2),
	compare_lists(L,List2,Result,List),
	%mcalc_near_pen(L,0,Result),!,
	%takelist(L,0,X),
	%list_sum(X,Z),
	V is Result,
	N = List.


rlist([H|T],V) :-
	%calc_near_pen([H|T],0,Result),
	takelist([H|T],0,V),
	%list_sum(X,Z),
	V is Z.
	
list_sum([],0).
list_sum([H|T],Sumr) :-
	list_sum(T,Restt),
	Sumr is H + Restt.
	


takelist([H|T],N,[X|Y]) :- 
	task_position_pen(N,H,X),
	Next is N+1,
	takelist(T,Next,Y),!.

takelist([],_,[]).
	
get_last_element([E],E).
get_last_element([_|T],X) :-
	get_last_element(T,X).

get_head([H|T],N) :-
	N is H.
	
mcalc_near_pen(L,Currentt,R) :-
	calc_near_pen(L,Currentt,Resultt),
	get_last_element(L,Y),
	[Head|_]=L,
	too_near_pen(Y,Head,V),
	R is Resultt + V.

calc_near_pen([],Current,Current).
calc_near_pen([E],Current,Current).	
calc_near_pen([E,E1|Rest],Current,Result) :-
	too_near_pen(E,E1,Val),
	Sum is Current + Val,
	calc_near_pen([E1|Rest],Sum,Result).
	
too_near_pen(X,Y,V) :-
	adjacent_pair_val(X,Y,Z),
	!,
	Z > 0,
	V is Z;
	V is 0.
	

/*
compared(X,Y,V) :- 
	gettask_letter_value(X,Z),
	gettask_letter_value(Y,W),
	Z = W,
	V is W.
	
compared(X,Y,V) :- 
	gettask_letter_value(X,Z),
	gettask_letter_value(Y,W),
	Z > W,
	V is W.

	
compared(X,Y,V) :-
	gettask_letter_value(X,Z),
	gettask_letter_value(Y,W),
	Z < W,
	V is Z.
*/



blank_list([0,0,0,0,0,0,0,0]).	
mylist([c,d,c,d,c,d,c]).
otherlist([a,b,c,d,e]).	

	


	

	
	
	
	
	
appendr([],X,X).	
appendr([X|Y],Z,[X|W]) :- 
	appendr(Y,Z,W).  




