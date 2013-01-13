-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).


new() ->
	[].

destroy(_) ->
	[].

read(Key, Db) ->
	case lists:keyfind(Key, 1, Db) of
		{Key, Value} -> Value;
		false -> {error, instance}
	end.


delete(Key, Db) ->
	lists:keydelete(Key, 1, Db).

match(Value, Db) ->
	F = fun(X) ->
		case X of 
			{Key, Value} -> [Key];
			false -> []
		end
	end,
	lists:flatmap(F, Db).

write(Key, Value, Db) ->
	case read(Key, Db) of
		{error, _} -> [{Key, Value} | Db];
		_ -> lists:keyreplace(Key, 1, Db, {Key, Value})
	end.
