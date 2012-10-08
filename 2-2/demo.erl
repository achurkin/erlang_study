-module(demo).
-export([double/1]).

% Это комментарий

double(Value) ->
	times(Value, 2).
times(X, Y) ->
	X * Y.	