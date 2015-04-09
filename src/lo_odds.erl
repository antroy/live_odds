-module(lo_odds).

-behaviour(gen_server).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
        handle_cast/2,
        handle_call/3,
        handle_info/2,
        terminate/2,
        code_change/3]).

-export([get_odds/1]).

start_link() ->
    %                                  Initial State\     /gen_server additional options
    gen_server:start_link({local, ?MODULE}, ?MODULE, maps:new(), []).

% Server Code
init(S) -> 
    {ok, S}.

handle_cast({echo, _Msg}, S) -> 
    {noreply, S}.

% Unused for now
handle_call({odds, {GoalsA, GoalsB}}, _From, S) -> 
    OddsA = 1 + (((GoalsB + 1) * (8/10)) / (GoalsA + 1)),
    OddsB = 1 + (((GoalsA + 1) * (8/10)) / (GoalsB + 1)),
    OddsX = 1 + (2/10),
    {reply, {OddsA, OddsX, OddsB}, S}.

handle_info(_A, _S) ->
    {noreply, []}.
    
terminate(_A, _S) ->
    {noreply, []}.

code_change(_A, _B, _C) ->
    {noreply, []}.

%% Client Functions

get_odds(Msg) ->
    gen_server:call(?MODULE, {odds, Msg}).

