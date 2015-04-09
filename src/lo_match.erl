-module(lo_match).

-behaviour(gen_server).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
        handle_cast/2,
        handle_call/3,
        handle_info/2,
        terminate/2,
        code_change/3]).

-export([
         subscribe_to/1, 
         print_event/1,
         publish_odds/1,
         sub/1
        ]).

start_link() ->
    %                                  Initial State\     /gen_server additional options
    gen_server:start_link({local, ?MODULE}, ?MODULE, maps:new(), []).

print_event(E) ->
    io:format("Match State: ~p~n", [E]).


publish_odds({{match_info, Id}, {starts_in, Countdown}}) -> 
    Odds = lo_odds:get_odds({0,0}),
    lo_ps:publish({lo_match, Id}, {Id, Odds}),
    io:format("Pre-Match State: ~p [~p]~n    Odds: ~p~n", [Id, Countdown, Odds]);

publish_odds({{match_info, Id}, {Period, Time, {GoalsA, GoalsB}}}) -> 
    Odds = lo_odds:get_odds({GoalsA, GoalsB}),
    lo_ps:publish({lo_match, Id}, {Id, Odds}),
    io:format("Match State (~p) ~ps: ~p (~p, ~p)~n    Odds: ~p~n", [Period, Time, Id, GoalsA, GoalsB, Odds]);

publish_odds(E) -> 
    io:format("Match State: ~p~n", [E]).

subscribe_to([H|Events]) -> 
    football_events:subscribe(H),
    io:format("Subscribed to ~p~n", [H]),
    lo_match:subscribe_to(Events);

subscribe_to([]) -> 
    true.

% Server Code
init(S) -> 
    timer:send_interval(3000, subscribe_matches),
    {ok, S}.

handle_cast({sub, Id}, S) -> 
    football_events:subscribe(Id),
    io:format("Blah Blah", []),
    {noreply, S}.

% Unused for now
handle_call({echo, Msg}, _From, S) -> 
    {reply, ok, S}.

handle_info(subscribe_matches, S) ->
    Events = football_events:matches(),
    lo_match:subscribe_to(Events),
    {noreply, S};

handle_info(Msg, S) ->
    lo_match:publish_odds(Msg),
    {noreply, S}.
    
terminate(_A, _S) ->
    {noreply, []}.

code_change(_A, _B, _C) ->
    {noreply, []}.

%% Client Functions
sub(Id) ->
    gen_server:cast(?MODULE, {sub, Id}).

