:- module(cliente, [formata_cliente/2,adiciona_cliente/1,ler_cliente/0,atualiza_cliente/2,imprime_cliente/1]).
:- use_module(library(readutil)).

imprime_cliente(L) :-
    nth0(0,L,Cpf),nth0(1,L,Placa),nth0(2,L,Veiculo),nth0(3,L,Status),
    nth0(4,L,Valor),nth0(5,L,Vaga),nth0(6,L,Hora),nth0(7,L,Visitas),
    format(string(S),'CPF:~s\nPlaca:~s\nVeiculo:~s\nStatus:~s\nValor:~d\nVaga:~d\nHora:~d\nVisitas:~d',[Cpf,Placa,Veiculo,Status,Valor,Vaga,Hora,Visitas]),
    write(S).

formata_cliente(S,L) :-
    format(string(S),'~s-~s-~s-~s-~d-~d-~d-~d-~d',L).

adiciona_cliente(S) :-
    open('dados/clientes.txt',append,File),
    writeln(File,S),
    close(File).

target([H|T],Flag) :- H == Flag.

encontrado([],_,[]).
encontrado([X|Xs],Cpf,Cliente) :-
    split_string(X,"-","",X1),
    target(X1,Cpf),
    Cliente = X.
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

% falta implementar mensagens do menu
ler_cliente :-
    read_line_to_codes(user_input,Cpf),atom_string(Cpf,I1),
    read_line_to_codes(user_input,Placa),atom_string(Placa,I2),
    read_line_to_codes(user_input,Veiculo),atom_string(Veiculo,I3),
    formata_cliente(S,[I1,I2,I3,"normal",0,1,0,0,0]),
    adiciona_cliente(S),
    write(S).

ler_arquivo(Result) :-
    open('dados/clientes.txt',read,Str),
    read_stream_to_codes(Str,Clientes),
    atom_string(Clientes,Clientes1),
    split_string(Clientes1,"\n","",Result).
