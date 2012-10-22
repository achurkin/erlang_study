-module(quicksort).
-export([sort/1]).

sort(List) ->
	filter(List).


filter([]) ->
	[];	
filter([Head | Tail]) ->
	{ok, Greater, Less} = filter(Head, Tail, [], []),
	filter(Less) ++ [Head] ++ filter(Greater).

filter(_, [], GreaterList, LessList) ->
	{ok, GreaterList, LessList};
filter(BaseElement, [Head | Tail], GreaterList, LessList) ->
	if 
		Head < BaseElement ->
			filter(BaseElement, Tail, GreaterList, [Head | LessList]);
		true ->
			filter(BaseElement, Tail, [Head | GreaterList], LessList)
	end.