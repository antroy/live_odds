# live_odds
Live_odds application in Erlang

## Mix / Relx

Build tools for Erlang.
Mix can be downloaded from:

Mix
    Build / Dependencies management
    http://s3.hex.pm/builds/mix/mix

Relx
    Release tool. Simpler than rel-tools.
    https://github.com/erlware/relx/releases/download/v1.2.0/relx

Install Rebar:
    Build/Release tool used under the hood to build gproc
    mix local.rebar

## Supervisors

Used to manage processes.
Specification for the exit from init is here: http://www.erlang.org/doc/man/supervisor.html

## Calling in to other languages

Uses standard Erlang messaging - libraries for other languages to implement the mailbox.





