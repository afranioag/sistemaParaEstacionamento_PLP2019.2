% clientes(CPF, placa, carro, horaEntrada).
clientes(001, "mou4578", "MOTO", "14:30").
clientes(002, "abc1234", "CARRO", "14:30").
clientes(003, "aab4567", "CAMINHAO", "14:30").

% funcionario(CPF, VAGA, HoraEntrada).
funcionario(9988, "A001", "06:00").
funcionario(8877, "A002", "14:00").

% veiculos(modelo, preco, acrescimo).
veiculos("MOTO", 5, 2).
veiculos("CARRO", 10, 2).
veiculos("CAMINHAO", 20, 3).

%veiculo(id, modelo).
veiculo(1, "MOTO").
veiculo(2, "CARRO").
veiculo(3, "CAMINHAO").


menu :- repeat,
write("Selecione uma opcao:\n"),
write("1 - CheckIn\n"),
write("2 - Reservar \n"),
write("3 - CheckOut\n"),
write("4 - CheckIn Funcionario\n"),
write("5 - CheckOut Funcionario\n"),
readNum(X), (X =:= 1 -> checkin; X =:= 2 -> reserva; X =:= 3 -> checkout;
X=:=4 -> checkinFunc; X=:=5 -> checkoutFunc).

checkin :-
write("CPF \n"),
	readNum(X), (XX is X),

write("placa \n"),
	read_line_to_codes(user_input, Entrada), atom_string(Entrada, YY),
write("Veiculo \n"),
	read_line_to_codes(user_input, Entrada), atom_string(Entrada, VV),
write("HORA entrada \n"),
	read_line_to_codes(user_input, Entrada), atom_string(Entrada, HH),
	clientes(XX,YY,VV,HH).



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

readString(X):-
    read_line_to_string(user_input, X).

readNum(X):-
	read_line_to_codes(user_input,Y),
	string_to_atom(Y, Z),
	atom_number(Z,X).
