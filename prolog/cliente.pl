:- module(cliente, [formata_cliente/2,adiciona_cliente/1,atualiza_cliente/2,imprime_cliente/1,recupera_cliente/2,get_cpf/2,get_hora/2,get_vaga/2,get_placa/2,get_status/2,get_reserva/2,get_veiculo/2,get_visitas/2]).
:- use_module(library(readutil)).

get_cpf(Cliente,Cpf) :-
    nth0(0,Cliente,Cpf).
get_placa(Cliente,Placa) :-
    nth0(1,Cliente,Placa).
get_veiculo(Cliente,Veiculo) :-
    nth0(2,Cliente,Veiculo).
get_vaga(Cliente,Vaga) :-
    nth0(5,Cliente,Vaga).
get_reserva(Cliente,Reserva) :-
    nth0(8,Cliente,Reserva).
get_status(Cliente,Status) :-
    nth0(3,Cliente,Status).
get_visitas(Cliente,Visitas) :-
    nth0(7,Cliente,Visitas).
get_hora(Cliente,Hora) :-
    nth0(6,Cliente,Hora).

imprime_cliente(L) :-
    nth0(0,L,Cpf),nth0(1,L,Placa),nth0(2,L,Veiculo),nth0(3,L,Status),
    nth0(4,L,Valor),nth0(5,L,Vaga),nth0(6,L,Hora),nth0(7,L,Visitas),
    format(string(S),'CPF:~s\nPlaca:~s\nVeiculo:~s\nStatus:~s\nValor:~d\nVaga:~d\nHora:~d\nVisitas:~d',[Cpf,Placa,Veiculo,Status,Valor,Vaga,Hora,Visitas]),
    write(S).

formata_cliente(Out,L) :-
    format(string(Out),'~s-~s-~s-~s-~d-~s-~d-~s-~s',L).

adiciona_cliente(C) :-
    open('dados/clientes.txt',append,File),
    formata_cliente(S,C),
    writeln(File,S),
    close(File).

target([H|T],Flag) :- H == Flag.

encontrado([],_,[]).
encontrado([X|Xs],Cpf,Cliente) :-
    split_string(X,"-","",X1),
    target(X1,Cpf),
    Cliente = X1,!.
encontrado([X|Xs],Cpf,Cliente):- encontrado(Xs,Cpf,Cliente).

recupera_cliente(Cpf,Cliente) :-
    ler_arquivo(Clientes),
    encontrado(Clientes,Cpf,Cliente).


atualiza([],_,_,[]).
atualiza([X|Xs],Cpf,NovoCliente,[NovoCliente1|Resultado]) :-
    split_string(X,"-","",X1),
    target(X1,Cpf),
    formata_cliente(NovoCliente1,NovoCliente),
    atualiza(Xs,Cpf,NovoCliente,Resultado).
atualiza([X|Xs],Cpf,NovoCliente,[X|Resultado]) :- atualiza(Xs,Cpf,NovoCliente,Resultado).

atualiza_cliente(Cpf,NovoCliente) :-
    ler_arquivo(Clientes),
    atualiza(Clientes,Cpf,NovoCliente,Atualizado),
    atomic_list_concat(Atualizado,"\n",S),
    delete_file('dados/clientes.txt'),
    open('dados/clientes.txt',write,File),
    write(File,S),
    close(File).

ler_arquivo(Result) :-
    open('dados/clientes.txt',read,Str),
    read_stream_to_codes(Str,Clientes),
    atom_string(Clientes,Clientes1),
    split_string(Clientes1,"\n","",Result).
