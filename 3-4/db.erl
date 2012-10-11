-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

new() ->
	[].

write(Key, Value, Db) ->
	case get_by_key(Key, Db) of
		{_Name, _Value} ->
			NewDb = delete(Key, Db),
			[{Key, Value} | NewDb];
		false -> [{Key, Value} | Db]
	end.

destroy(_A) ->
	[].

delete(Key, Db) ->
	delete([], Key, Db).

delete(Acc, _Key, []) ->
	Acc;
delete(Acc, Key, Db) ->
	[Head | Tail] = Db,
	case Head of
		{Key, _} -> delete(Acc, Key, Tail);
		{_, _} -> delete([Head | Acc], Key, Tail)
	end.

read(Key, Db) ->
	case get_by_key(Key, Db) of
		{_Name, Value} -> {ok, Value};
		false -> {error, instance}
	end.

match(Value, Db) ->
	match([], Value, Db). 

match(Acc, _Value, []) ->
	Acc;
match(Acc, Value, Db) ->
	[Head | Tail] = Db,
	case Head of
		{Key, Value} -> match([Key | Acc], Value, Tail);
		_ -> match(Acc, Value, Tail)
	end.	


get_by_key(_Key, Db) when Db == [] ->
	false;
get_by_key(Key, Db) ->
	[Head | Tail] = Db,
	case Head of
		{Key, _} -> Head;
		_ -> get_by_key(Key, Tail)
	end.

