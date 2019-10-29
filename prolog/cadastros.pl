% clientes(CPF, placa, carro, horaEntrada).
clientes(001, "mou4578", "MOTO", "14:30").
clientes(002, "abc1234", "CARRO", "14:30").
clientes(003, "aab4567", "CAMINHAO", "14:30").

cadastro :- 
write("CPF \n"),
read(X), (XX is X),
write("placa \n"),
read(Y), (YY is Y),
write("Veiculo \n"),
read(V), (VV is ),
write("HORA entrada \n"),
read(H),(HH is H),
clientes(XX,YY,VV,HH).

menu :- repeat,
write("Selecione uma opcao:\n"),
write("1 - CheckIn\n"),
write("2 - Reservar \n"),
write("3 - CheckOut\n"),
write("4 - CheckIn Funcionario\n"),
write("5 - CheckOut Funcionario\n"),
read(X), (X =:= 1, cadastro).



% veiculos(modelo, preco, acrescimo).
veiculo("MOTO", 5, 2).
veiculo("CARRO", 10, 2).
veiculo("CAMINHAO", 20, 3).



checkin(C) :- clientes(C, P, V, H),
	write(C),
	write("\n"),
	write(P),
	write("\n"),
	write(V),
	write("\n"),
	write(H).
 
 
