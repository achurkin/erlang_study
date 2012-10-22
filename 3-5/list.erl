-module(list).
-export([filter/2, reverse/1, concatenate/1]).

filter(List, Value) ->
	filter([], List, Value).

filter(Acc, [], _Value) ->
	reverse(Acc);
filter(Acc, List, Value) ->
	[Head | Tail] = List,
	if 
		Head =< Value  ->
			filter([Head | Acc], Tail, Value);
		true ->
			filter(Acc, Tail, Value)
	end.

reverse(List) ->
	reverse([], List).

reverse(Acc, []) ->
	Acc;
reverse(Acc, [Head | Tail]) ->
	reverse([Head | Acc], Tail).


concatenate(Lists) ->
	concatenate([], Lists).

concatenate(Acc, []) ->
	reverse(Acc);
concatenate(Acc, [List1, Remained]) ->
	NewAcc = concatenateTwoLists(Acc, List1),
	concatenate(NewAcc, Remained).

concatenateTwoLists(List1, []) ->
	List1;
concatenateTwoLists(List1, [Head | Tail]) ->
	concatenateTwoLists([Head | List1], Tail).


%TODO:: flatten function