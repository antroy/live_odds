-module(lo_match_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Match = {lo_match, {lo_match, start_link, []},
           permanent, brutal_kill, worker, [lo_match]},
  Procs = [Match],
  {ok, {{one_for_one, 1, 5}, Procs}}.
