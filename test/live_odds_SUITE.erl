-module(live_odds_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0, test1/1]).

all() -> [test1].

test1(_Config) ->
    1 = 1.
