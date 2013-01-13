-module(my_db).
-export([start/0, stop/0, write/2, delete/1, read/1, match/1, loop/1]).

-import(db).

start() ->
	Db = db:new(),
	Pid = spawn(my_db, loop, [Db]),
	register(db, Pid),
	ok.

loop(Db) ->
	receive
		{Pid, write, Key, Value} ->
			NewDb = db:write(Key, Value, Db),
			Pid ! ok,
			loop(NewDb);
		{Pid, delete, Key} ->
			NewDb = db:delete(Key, Db),
			Pid ! ok,
			loop(NewDb);
		{Pid, read, Key} ->
			Resp = db:read(Key, Db),
			Pid ! Resp,
			loop(Db);
		{Pid, match, Value} ->
			Resp = db:match(Value, Db),
			Pid ! Resp, 
			loop(Db);
		{Pid, stop} ->
			Pid ! ok,
			true;
		_ ->
			io:format("Unknown message type"), 
			loop(Db)
	end.

write(Key, Value) ->
	db ! {self(), write, Key, Value},
	receive 
		Msg ->
			Msg 
	end.

delete(Key) ->
	db ! {self(), delete, Key},
	receive 
		Msg ->
			Msg 
	end.

read(Key) ->
	db ! {self(), read, Key},
	receive 
		Msg ->
			Msg 
	end.

match(Value) ->
	db ! {self(), match, Value},
	receive 
		Msg ->
			Msg 
	end.

stop() ->
	db ! {self(), stop},
	receive 
		Msg ->
			Msg 
	end.





