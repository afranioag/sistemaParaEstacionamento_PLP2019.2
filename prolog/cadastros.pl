:- use_module(cliente).
:- use_module(estacionamento).


menu :- repeat,
write("Selecione uma opcao:\n"),
write("1 - CheckIn\n"),
write("2 - Reservar \n"),
write("3 - CheckOut\n"),
write("4 - CheckIn Funcionario\n"),
write("5 - CheckOut Funcionario\n"),
readNum(X), (X =:= 1 -> checkin; X =:= 2 -> reserva; X =:= 3 -> checkout;
X=:=4 -> checkinFunc; X=:=5 -> checkoutFunc).

/*
 * Checkin do cliente
 */
% problema na lógica de verificação de reserva ou se cliente ja esta no estacionamento
checkin_cliente :-
    write("Bem vindo ao checkIn do estacionamento."),nl,
    writeln("CPF: "),
    read_line_to_codes(user_input,Cpf),atom_string(Cpf,Cpf1),
    writeln("Placa: "),
    read_line_to_codes(user_input,Placa),atom_string(Placa,Placa1),
    writeln("Veiculo: "),
    read_line_to_codes(user_input,Veiculo),atom_string(Veiculo,Veiculo1),
    recupera_cliente(Cpf1,Cliente),
    aloca_vaga(Vaga),
    get_time(T),stamp_date_time(T,date(_,_,_,Hora,_,_,_,_,_),'UTC'),
    (
        Cliente == [] ->
            (
                Vaga == 0 -> write("Nao ha vagas disponiveis."),nl;
                write("CheckIn novo cliente."),nl,
                number_string(1,Visitas),
                NovoCliente = [Cpf1,Placa1,Veiculo1,"normal",Vaga,Hora,Visitas,"0"],
                adiciona_cliente(NovoCliente),
                NovaVaga = [Vaga,1,1,Cpf1],
                atualiza_vaga(Vaga,NovaVaga),
                write("CheckIn feito! Vaga -> "),write(Vaga),nl
            )
        ;   (
            get_vaga(Cliente,V),V \== "0" -> write("Cliente ja fez checkin.Vaga -> "),write(V);
                get_reserva(Cliente,R),
                R == "1" ->
                    write("Cliente possui reserva. Checkin feito."),
                    write(" Vaga -> "), get_vaga(Cliente,V2), write(V2),
                    get_status(Cliente,Status),get_visitas(Cliente,Visitas),
                    number_string(Visitas1,Visitas), Visitas2 is Visitas1 + 1,number_string(Visitas2,Visitas3),
                    NovoCliente = [Cpf1,Placa1,Veiculo1,Status,V2,Hora,Visitas3,"0"],
                    atualiza_cliente(Cpf1,NovoCliente),
                    atualiza_vaga(V2,[V2,1,1,Cpf1])
                ;
                    Vaga == 0 -> write("Nao ha vagas disponiveis"),nl;
                    write("CheckIn feito. Vaga -> "),write(Vaga),nl,
                    NovaVaga = [Vaga,1,1,Cpf1],
                    atualiza_vaga(Vaga,NovaVaga),
                    get_status(Cliente,Status),get_visitas(Cliente,Visitas),
                    number_string(Visitas1,Visitas), Visitas2 is Visitas1 + 1,number_string(Visitas2,Visitas3),
                    NovoCliente = [Cpf1,Placa1,Veiculo1,Status,Vaga,Hora,Visitas3,"0"],
                    atualiza_cliente(Cpf1,NovoCliente)
            )
    ).
/*
 * Checkout do cliente
 */
checkout_cliente :-
    write("Pagar saida do estacionamento,"),nl,
    write("Digite seu cpf: "),nl,
    read_line_to_codes(user_input,Cpf),atom_string(Cpf,Cpf1),
    recupera_cliente(Cpf1,Cliente),
    (
        Cliente == [] -> write("Cliente nao existe."),nl
        ;
        (   get_vaga(Cliente,Vaga),
            (
                Vaga == "0" -> write("Cliente nao fez checkin."),nl;
                get_hora(Cliente,Hora),calcula_valor(Cliente,Valor),get_visitas(Cliente,Visitas),
                verifica_novo_status(Visitas,NovoStatus),
                atualiza_cliente(Cpf1,[Cpf1,"","",NovoStatus,"0",0,Visitas,"0"]),
                atualiza_vaga(Vaga,[Vaga,0,0,""])
            )
        )
    ).

verifica_reserva_ou_checkin("0","0").

reservar :-
    write("Reserva de vaga para clientes VIP"),nl,
    write("Digite seu cpf: "),
    read_line_to_codes(user_input,Cpf),atom_string(Cpf,Cpf1),
    recupera_cliente(Cpf1,Cliente),
    (
        Cliente == [] -> write("Cliente nao existe."),nl;
        get_status(Cliente,Status),
        (
            Status == "normal" -> write("Cliente nao é VIP."),nl;
            get_reserva(Cliente,Reserva),get_vaga(Cliente,Vaga),
            \+ verifica_reserva_ou_checkin(Vaga,Reserva) ->
                write("Cliente ja possui reserva ou ja fez checkin no estacionamento."),nl;
                aloca_vaga(NovaVaga),
                (
                    NovaVaga == "0" -> write("Nao foi possivel realizar reserva. Nao ha vagas disponiveis"),nl;
                    write("Reserva feita. Vaga -> "),write(NovaVaga),
                    atualiza_vaga(NovaVaga,[NovaVaga,0,1,Cpf1]),
                    get_visitas(Cliente,Visitas),
                    atualiza_cliente(Cpf1,[Cpf1,"","",Status,NovaVaga,0,Visitas,"1"])
                )

        )
    ).

/* ----------------------------------------------
C = cfp do cliente,
P = placa do veiculo,
V = veiculo modelo,
H = hora de entrada.
Ainda sendo possivel colocar o valor a ser pago e o tempo de permanencia
*/

checkout :- write("Informe o CPF: "),
readNum(C), (checkout(C)).

checkout(C) :- clientes(C, P, V, H),
	write("Saida do cliente: "),
	write(C),
	write("\nPlaca: "),
	write(P),
	write("\nVeiculo: "),
	write(V),
	write("\nHora de entrada: "),
	write(H).


reserva :- write("Reserva Ainda nao implementada").

checkinFunc :- write("Por favor informe seu CPF para checkin: "),
read(CPF), funcionario(CPF, "A003", "22:00").


checkoutFunc :- write("Por favor informe seu CPF para checkout: "),
read(CPF), checkoutFunc(CPF).

checkoutFunc(CPF) :- funcionario(CPF, V, H),
	write("Checkout: \n"),
	write("Funcionario: "),
	write(CPF),
	write("\nVaga: "),
	write(V),
	write("\n Entrada em: "),
	write(H).

main :-
    ler_cliente.

readString(X):-
    read_line_to_string(user_input, X).

readNum(X):-
	read_line_to_codes(user_input,Y),
	string_to_atom(Y, Z),
	atom_number(Z,X).
