:- module(estacionamento,[cria_estacionamento/1,aloca_vaga/1,atualiza_vaga/2,calcula_valor/2,verifica_novo_status/2]).
:- use_module(cliente).

veiculo("carro",10).
veiculo("moto",6).
veiculo("caminhao",15).
desconto(0.8).

tamanho(10000).

formata_vaga(S,L) :-
    format(string(S),'~s-~d-~d-~s',L).

cria_vagas(T,I,I).
cria_vagas([H|T],I,Max) :-
    I < Max,
    I1 is I + 1,
    format(string(H),'~d-0-0-',[I]),
    cria_vagas(T,I1,Max).

escreve_linhas(_File, []) :- !.
escreve_linhas(File,[Head|Tail]) :-
    writeln(File,Head),
    escreve_linhas(File,Tail).

cria_estacionamento(N) :-
    N1 is N + 1,
    cria_vagas(Vagas,1,N1),
    open('dados/vagas.txt',write,File),
    escreve_linhas(File,Vagas),
    close(File).

ler_arquivo(Result) :-
    open('dados/vagas.txt',read,Str),
    read_stream_to_codes(Str,Vagas),
    atom_string(Vagas,Vagas1),
    split_string(Vagas1,"\n","",Result).

vaga([],0).
vaga([X|Xs],Vaga) :-
    split_string(X,"-","",X1),
    nth0(1,X1,Ocupada),nth0(2,X1,Reserva),
    Ocupada == "0", Reserva == "0", nth0(0,X1,V),
    Vaga = V,!.
vaga([X|Xs],Vaga):- vaga(Xs,Vaga).

aloca_vaga(Vaga) :-
    ler_arquivo(Vagas),
    vaga(Vagas,Vaga).

recupera([X|Xs],Cpf,Vaga) :-
    split_string(X,"-","",X1),
    nth0(3,X1,C), C == Cpf, nth0(0,X1,Vaga),!.
recupera([X|Xs],Cpf,Vaga) :- recupera(Xs,Cpf,Vaga).
recupera([],_,0).

recupera_vaga_reservada(Cpf,Vaga) :-
    ler_arquivo(Vagas),
    recupera(Vagas,Cpf,Vaga).

atualiza([],_,_,[]).
atualiza([X|Xs],Vaga,NovaVaga,[NovaVaga1|Resultado]) :-
    split_string(X,"-","",X1),
    nth0(0,X1,V), Vaga == V,
    formata_vaga(NovaVaga1,NovaVaga),
    atualiza(Xs,Vaga,NovaVaga,Resultado).
atualiza([X|Xs],Vaga,NovaVaga,[X|Resultado]) :- atualiza(Xs,Vaga,NovaVaga,Resultado).

atualiza_vaga(Vaga,NovaVaga) :-
    ler_arquivo(Vagas),
    atualiza(Vagas,Vaga,NovaVaga,Atualizado),
    atomic_list_concat(Atualizado,"\n",S),
    open('dados/vagas.txt',write,File),
    write(File,S),
    close(File).

verifica_novo_status(Visitas,"vip") :- number_string(Visitas1,Visitas),Visitas1 >= 5.
verifica_novo_status(Visitas,"normal").

calcula(Veiculo,Tempo,Valor,"normal") :-
    veiculo(Veiculo,P), (Tempo > 0 -> Valor is P * Tempo;
    Valor is P * 1).
calcula(Veiculo,Tempo,Valor,"vip") :-
    veiculo(Veiculo,P), desconto(D), (Tempo > 0 ->
    Valor is P * Tempo * D; Valor is P * 1 * D).

calcula_valor(Cliente,Valor) :-
    get_status(Cliente,Status),get_hora(Cliente,Hora),get_veiculo(Cliente,Veiculo),
    get_time(T),
    stamp_date_time(T,date(_,_,_,H,_,_,_,_,_),'UTC'),
    number_string(Hora1,Hora),
    Tempo is H - Hora1,
    calcula(Veiculo,Tempo,Valor,Status).
