-module(lis).
-export([create/1, reverse_create/1]).

create(N) ->
	create(N, []).

create(0, Acc) ->
	Acc;
create(N, Acc) ->
	create(N - 1, [ N | Acc]).


reverse_create(N) ->
	reverse_create(1, N, []).

reverse_create(Start, Max, Acc) when Max < Start ->
	Acc;
reverse_create(Start, Max, Acc) ->
	reverse_create(Start + 1, Max, [Start | Acc]).
	