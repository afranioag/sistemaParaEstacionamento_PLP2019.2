:- module(estacionamento,[cria_estacionamento/1,aloca_vaga/1,atualiza_vaga/2]).

tamanho(10000).

formata_vaga(S,L) :-
    format(string(S),'~d-~d-~d-~s',L).

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
    Vaga = V.
vaga([X|Xs],Vaga):- vaga(Xs,Vaga).

aloca_vaga(Vaga) :-
    ler_arquivo(Vagas),
    vaga(Vagas,Vaga).

atualiza([],_,_,[]).
atualiza([X|Xs],Vaga,NovaVaga,[NovaVaga1|Resultado]) :-
    split_string(X,"-","",X1),
    nth0(0,X1,V), Vaga == V,
    formata_vaga(NovaVaga1,NovaVaga),
    atualiza(Xs,Vaga,NovaVaga,Resultado).
atualiza([X|Xs],Vaga,NovaVaga,[X|Resultado]).

atualiza_vaga(Vaga,NovaVaga) :-
    ler_arquivo(Vagas),
    atualiza(Vagas,Vaga,NovaVaga,Atualizado),
    atomic_list_concat(Atualizado,"\n",S),
    open('dados/vagas.txt',write,File),
    write(File,S),
    close(File).
