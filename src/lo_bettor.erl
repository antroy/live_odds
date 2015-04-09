-module(lo_bettor).

-behaviour(gen_server).

-export([start_link/2]).

%% gen_server callbacks
-export([init/1,
        handle_cast/2,
        handle_call/3,
        handle_info/2,
        terminate/2,
        code_change/3]).

start_link(Name, Ids) ->
    gen_server:start_link({via, lo_ps, Name}, ?MODULE, {Name, Ids}, []).

% Server Code
init({Name, [H|Tail]}) -> 
    lo_ps:subscribe({lo_match, H}),
    lo_bettor:init({Name, Tail}),
    {ok, {Name, [H|Tail]}};

init(S) -> 
    {ok, S}.

handle_cast({echo, _Msg}, S) -> 
    {noreply, S}.

% Unused for now
handle_call(_, _From, S) -> 
    {reply, ok, S}.

handle_info({Id, Odds}, {Name, S}) ->
    io:format("~p Got Odds for ~p: ~p~n", [Name, Id, Odds]),
    {noreply, {Name, S}}.
    
terminate(_A, S) ->
    {noreply, S}.

code_change(_A, _B, S) ->
    {noreply, S}.

%% Client Functions

