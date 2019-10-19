import Cliente
import Funcionario
import Estacionamento
import Data.List.Split


checkInFuncionario:: IO()
checkInFuncionario = do
  putStrLn $ "Bem vindo ao checkin do funcionario."
  putStrLn $ "CPF: "
  listaFuncionarios <- funcionarioLerArquivo
  cpf <- getLine
  putStrLn $ "Vaga: "
  vaga <- readLn::IO Int
  let funcio = geraFuncionario (recuperaFuncionario listaFuncionarios cpf)
  if (funcionarioCpf funcio == "") then do
      putStrLn $ "Funcionario nao esta cadastrado!"
  else do
      if (funcionarioVaga funcio) /= 0 then putStrLn $ "Funcionario ja esta alocado"
      else do
        putStrLn $ "CheckIn Funcionario ja cadastrado.\nVaga alocada."
        vagas <- lerEstacionamento ("dados/vagasFuncionarios.txt")
        atualizaFuncionario cpf (formataFuncionario (Funcionario cpf vaga))
        atualizaVagaF (formataVaga(Vaga vaga True True cpf)) vagas (show(funcionarioVaga funcio))

checkInCliente:: IO()
checkInCliente = do
    putStrLn $ "Bem vindo ao checkIn do estacionamento."
    putStrLn $ "CPF: "
    clientes <- lerArquivo
    cpf <- getLine
    putStrLn $ "Placa: "
    placa <- getLine
    putStrLn $ "Veiculo: "
    veiculo <- getLine
    hora <- getHoraAtual
    minuto <- getMinutoAtual
    let cliente = geraCliente (recuperaCliente clientes cpf)
    vagas <- lerEstacionamento ("dados/vagas.txt")
    let vaga = alocaVaga (splitOn "\n" vagas)
    if (clienteCpf cliente == "") then do
        if vaga == 0 then putStrLn $ " Não há vagas disponiveis."
        else do
            putStrLn $ "CheckIn novo cliente."
            salvaCliente (Cliente cpf placa veiculo "normal" 0.0 vaga hora minuto 1 False)
            atualizaVaga (formataVaga (Vaga vaga True True cpf)) vagas (show vaga)
            putStrLn $ "CheckIn feito! Vaga -> " ++ (show vaga)
    else do
        if (clienteReserva cliente) then do
            putStrLn $ "Cliente possui reserva. CheckIn feito. Vaga -> " ++ (show (clienteVaga cliente))
            atualizaCliente cpf (formataCliente (Cliente (cpf) (placa) (veiculo) (clienteStatus cliente) 0.0 (clienteVaga cliente) hora minuto ((clienteVisitas cliente)+1) False))
            atualizaVaga (formataVaga (Vaga vaga True True cpf)) vagas (show(clienteVaga cliente))
        else do
            if vaga == 0 then putStrLn $ "Não há vagas disponiveis."
            else do
                putStrLn $ "CheckIn feito. Vaga -> " ++ (show vaga)
                atualizaVaga (formataVaga (Vaga vaga True True cpf)) vagas (show vaga)
                atualizaCliente cpf (formataCliente (Cliente (cpf) (placa) (veiculo) (clienteStatus cliente) 0.0 (vaga) hora minuto ((clienteVisitas cliente)+1) False))


reservar:: IO()
reservar = do
    putStrLn $ "Reserva de vaga para clientes VIP"
    putStrLn $ "Digite seu cpf: "
    cpf <- getLine
    clientes <- lerArquivo
    let cliente = geraCliente (recuperaCliente clientes cpf)
    if (clienteCpf cliente) == "" then putStrLn $ "Cliente não existe."
    else do
        let status = clienteStatus cliente
        if status == "normal" then putStrLn $ "Cliente não é VIP. Impossível fazer reserva"
        else do
            if (clienteReserva cliente) || (clienteVaga cliente) /= 0 then putStrLn $ "Cliente ja possui reserva ou ja está no estacionamento."
            else do
                vagas <- lerEstacionamento "dados/vagas.txt"
                let vaga = alocaVaga (splitOn "\n" vagas)
                if vaga /= 0 then do
                    putStrLn $ "Reserva feita. Vaga -> " ++ (show vaga)
                    atualizaVaga (formataVaga (Vaga vaga False True cpf)) vagas (show vaga)
                    atualizaCliente cpf (formataCliente (Cliente (cpf) ("") ("") (clienteStatus cliente) 0.0 vaga 0 0 (clienteVisitas cliente) True))
                else putStrLn $ "Não foi possível fazer reserva. Não há vagas disponiveis"

checkOut:: IO()
checkOut = do
    putStrLn $ "Pagar saida do estacionamento"
    putStrLn $ "Digite seu cpf: "
    cpf <- getLine
    clientes <- lerArquivo
    let cliente = geraCliente (recuperaCliente clientes cpf)
    if (clienteCpf cliente) == "" then putStrLn $ "Cliente não existe."
    else
        if (clienteVaga cliente) == 0 then putStrLn $ "Cliente não fez checkIn."
        else do
            valor <- calculaValor cliente
            let clienteAtualizado = clienteAtualizaValor cliente valor
            vagas <- lerEstacionamento "dados/vagas.txt"
            let novoStatus = if (clienteVisitas cliente) > 5 then "vip" else "normal"
            atualizaCliente cpf (formataCliente (Cliente cpf ("") ("") novoStatus 0.0 0 0 0 (clienteVisitas cliente) False))
            atualizaVaga (formataVaga (Vaga (clienteVaga cliente) False False (""))) vagas (show(clienteVaga cliente))
            putStrLn $ clienteMostraCliente clienteAtualizado

checkOutFuncionario:: IO()
checkOutFuncionario = do
   putStrLn $ "Fazendo checkout do Funcionario"
   putStrLn $ "Digite seu CPF: "
   cpf <- getLine
   listaFuncionarios <- funcionarioLerArquivo
   let funcionario = geraFuncionario (recuperaFuncionario listaFuncionarios cpf)
   if (funcionarioCpf funcionario) == "" then putStrLn $ "Funcionario nao cadastrado no sistema."
   else do
        if (funcionarioVaga funcionario) == 0 then putStrLn $ "Funcionario nao esta alocado."
        else do
            vagas <- lerEstacionamento "dados/vagasFuncionarios.txt"
            putStrLn $ mostraFuncionario funcionario
            atualizaFuncionario cpf (formataFuncionario(Funcionario cpf 0))
            atualizaVagaF (formataVaga(Vaga (funcionarioVaga funcionario) False False (""))) vagas (show(funcionarioVaga funcionario))
            putStrLn $ "Checkout realizado"

meuMenu:: Bool->IO()
meuMenu True = return ()
meuMenu saida = do
    vagas <- lerEstacionamento "dados/vagas.txt"
    --putStrLn $ "Vagas disponiveis: " ++ (show (contaVaga (splitOn "\n" vagas)))
    putStrLn $ "1 - CheckIn"
    putStrLn $ "2 - Reservar"
    putStrLn $ "3 - CheckOut"
    putStrLn $ "4 - CheckIn Funcionario"
    putStrLn $ "5 - CheckOut Funcionario"
    putStrLn $ "6 - Sair"
    putStr $ "opt>> "
    opt <- getLine
    if opt == "1"
        then do
            checkInCliente
            meuMenu False
    else
        if opt == "2"
            then do
                reservar
                meuMenu False
        else
            if opt == "3"
                then do
                    checkOut
                    meuMenu False
            else
                if opt == "4"
                    then do
                        checkInFuncionario
                        meuMenu False
                else
                    if opt == "5"
                        then do
                            checkOutFuncionario
                            meuMenu False
                        else
                            if opt == "6"
                                then meuMenu True
                            else do
                                putStrLn $ "Opção invalida"
                                meuMenu False

inicializaEstacionamento = do
    meuMenu False
