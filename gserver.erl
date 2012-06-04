-module (gserver).

-export ([server/0, wait_connect/2, get_request/3, handle/2]).

server() ->
    {ok, ListenSocket} = gen_tcp:listen(9889, [binary, {active, false}]),
    wait_connect(ListenSocket, 0).

wait_connect(ListenSocket, Count) -> 
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(?MODULE, wait_connect, [ListenSocket, Count + 1]),
    get_request(Socket, [], Count).

get_request(Socket, BinaryList, Count) ->
    case gen_tcp:recv(Socket, 0, 5000) of
        {ok, Binary} -> 
            get_request(Socket, [Binary|BinaryList], Count);
        {error, closed} ->
            handle(lists:reverse(BinaryList), Count)
    end.

handle(Binary, Count) ->
    io:format("count = ~p~n",integer_to_list(Count)).
