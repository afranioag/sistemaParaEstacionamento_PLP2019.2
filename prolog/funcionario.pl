:- module(funcionario, [atualiza_funcionario/2,recupera_funcionario/2,vaga_funcionario/2]).

vaga_funcionario(Funcionario,Vaga) :- nth0(1,Funcionario,Vaga).

formata_funcionario(Out,L) :-
    format(string(Out),'~s-~s',L).

target([H|T],Flag) :- H == Flag.

encontrado([],_,[]).
encontrado([X|Xs],Cpf,Funcionario) :-
    split_string(X,"-","",X1),
    target(X1,Cpf),
    Funcionario = X1,!.
encontrado([X|Xs],Cpf,Funcionario):- encontrado(Xs,Cpf,Funcionario).

recupera_funcionario(Cpf,Funcionario) :-
    ler_arquivo(Funcionarios),
    encontrado(Funcionarios,Cpf,Funcionario).

atualiza([],_,_,[]).
atualiza([X|Xs],Cpf,NovoCliente,[NovoCliente1|Resultado]) :-
    split_string(X,"-","",X1),
    target(X1,Cpf),
    formata_funcionario(NovoCliente1,NovoCliente),
    atualiza(Xs,Cpf,NovoCliente,Resultado).
atualiza([X|Xs],Cpf,NovoCliente,[X|Resultado]) :- atualiza(Xs,Cpf,NovoCliente,Resultado).

atualiza_funcionario(Cpf,NovoFuncionario) :-
    ler_arquivo(Funcionarios),
    atualiza(Funcionarios,Cpf,NovoFuncionario,Atualizado),
    atomic_list_concat(Atualizado,"\n",S),
    open('dados/funcionarios.txt',write,File),
    write(File,S),
    close(File).

ler_arquivo(Result) :-
    open('dados/funcionarios.txt',read,Str),
    read_stream_to_codes(Str,Funcionarios),
    atom_string(Funcionarios,Funcionarios1),
    split_string(Funcionarios1,"\n","",Result).
