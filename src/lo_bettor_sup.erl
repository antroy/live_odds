-module(lo_bettor_sup).
-behaviour(supervisor).

-export([start_link/0,start_bettor/2]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_bettor(Name, SubscribeToIds) ->
  supervisor:start_child(?MODULE, [Name, SubscribeToIds]).

init([]) ->
  Bettors = {lo_bettor, {lo_bettor, start_link, []},
           permanent, brutal_kill, worker, [lo_bettor]},
  Procs = [Bettors],
  {ok, {{simple_one_for_one, 1, 5}, Procs}}.
