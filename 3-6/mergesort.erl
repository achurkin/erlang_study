-module(mergesort).
-export([sort/1, split/1]).

sort(List) ->
	{ok, First, Second} = split(List),
	First.


split(List) ->
	split(List, []).
split(List, Second) ->
	[Head | Tail] = List,
	if 
		length(Tail) =< length(Second) ->
			{ok, List, Second};
		true ->
			split(Tail, [Head | Second])
	end.