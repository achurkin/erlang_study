-module(echo).
-export([start/0, print/1, stop/0, loop/0]).

start() ->
	Pid = spawn(echo, loop, []),
	register('echo_proc', Pid).

loop() ->
	receive 
		{_From, Message} ->
			io:format("~w~n", [Message]),
			loop();
		stop ->
			true
	end.

print(Msg) ->
	echo_proc ! {self(), Msg}.

stop() ->
	echo_proc ! stop.