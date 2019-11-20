:- module (estacionamento,[cria_estacionamento/1]).

cria_vagas(T,I,I).
cria_vagas([H|T],I,Max) :-
    I < Max,
    I1 is I + 1,
    format(string(H),'~d-False-False-',[I]),
    cria_vagas(T,I1,Max).

escreve_linhas(_File, []) :- !.
escreve_linhas(File,[Head|Tail]) :-
    writeln(File,Head),
    escreve_linhas(File,Tail).

cria_estacionamento(N) :-
    N1 is N + 1,
    cria_vagas(Vagas,1,N1),
    open('vagas.txt',append,File),
    escreve_linhas(File,Vagas),
    close(File).


