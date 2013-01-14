-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).


start() ->
	register(frequency, spawn(frequency, init, [])).

init() ->
	Frequencies = {get_frequencies(), []},
	loop(Frequencies).

get_frequencies() -> [10, 11, 12, 13, 14, 15].

stop() -> call(stop).
allocate() -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

call(Message) ->
	frequency ! {request, self(), Message},
	receive
		{reply, Reply} -> Reply
	end.

loop(Frequencies) ->
	receive
		{request, Pid, allocate} ->
			{NewFrequencies, Reply} = allocate(Frequencies, Pid),
			reply(Pid, Reply),
 			loop(NewFrequencies);
		{request, Pid, {deallocate, Freq}} ->
			case deallocate(Frequencies, Freq, Pid) of
				{reply, NewFrequencies} ->
					reply(Pid, ok),
					NewFreq = NewFrequencies;
				{error, instance} ->
					reply(Pid, {error, "Prohibited"}),
					NewFreq = Frequencies
			end,
			loop(NewFreq);
		{request, Pid, stop} ->
			{_Free, Allocated} = Frequencies,
			if
				length(Allocated) > 0 ->
					reply(Pid, {error, not_free}),
					loop(Frequencies);
				true ->
					reply(Pid, ok)
			end
	end.

reply(Pid, Reply) ->
	Pid ! {reply, Reply}.


allocate({[], Allocated}, _Pid) ->
	{{[], Allocated}, {error, no_frequency}};
allocate({[Freq | Free], Allocated}, Pid) ->
	ClientFreqs = lists:filter(
		fun(X) ->
			{_HFreq, HPid} = X,
			HPid == Pid
		end, Allocated),
	if
		length(ClientFreqs) < 3 ->
			{{Free, [{Freq, Pid} | Allocated]}, {ok, Freq}};
		true ->
			{{[Freq | Free], Allocated}, {error, to_many}}	
	end.

deallocate({Free, Allocated}, Freq, Pid) ->
	case lists:keyfind(Freq, 1, Allocated) of
		{Freq, Pid} ->
			NewAllocated = lists:keydelete(Freq, 1, Allocated),
			{reply, {[Freq | Free], NewAllocated}};
		_ -> {error, instance}
	end.





