-module(lo_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Odds = {lo_odds, {lo_odds, start_link, []},
           permanent, brutal_kill, worker, [lo_odds]},
  MatchSup = {lo_match_sup, {lo_match_sup, start_link, []},
           permanent, brutal_kill, supervisor, [lo_match_sup]},
  BettorSup = {lo_bettor_sup, {lo_bettor_sup, start_link, []},
           permanent, brutal_kill, supervisor, [lo_bettor_sup]},
  Procs = [Odds, MatchSup, BettorSup],
  {ok, {{one_for_one, 1, 5}, Procs}}.
