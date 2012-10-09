-module(num).
-export([print/1]).

print(N) ->
	print(1, N).

print(Start, End) when Start < End ->
	io:format("Number ~p~n", [Start]),
	print(Start + 1, End);
print(Start, End) when Start == End ->
	io:format("Number ~p~n", [Start]).