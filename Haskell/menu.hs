import Cliente
import Funcionario
import Estacionamento
import Data.List.Split

opcoes = putStrLn $ "1 - VIP\n2 - Normal"

pegaStatus:: IO String
pegaStatus = do
    opcoes
    opt <- readLn:: IO Int
    if opt == 1 then return "vip"
    else if opt == 2 then return "normal"
        else pegaStatus

checkInFuncionario:: IO()
checkInFuncionario = do
    putStrLn $ "Bem vindo ao checkin do funcionario."
    putStrLn $ "CPF: "
    listaFuncionarios <- funcionarioLerArquivo
    cpf <- getLine
    putStrLn $ "Vaga: "
    vaga <- getLine
    let funcio = geraFuncionario (recuperaFuncionario listaFuncionarios cpf)
    if (funcionarioCpf funcio == "") then do
        putStrLn $ "CheckIn novo funcionario"
        vagas <- lerEstacionamento ("dados/vagasFuncionarios.txt")
        let vaga = alocaVaga (splitOn "\n" vagas)
        salvaFuncionario (Funcionario cpf vaga)
        atualizaVaga "True" (show vaga) ("dados/vagasFuncionarios.txt")
        putStrLn $ "CheckIn feito!"
    else do
        putStrLn $ "CheckIn Funcionario ja cadastrado."

-- Falta implementar o checkin caso o cliente ja exista.
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
    if (clienteCpf cliente == "") then do
        putStrLn $ "CheckIn novo cliente."
        vagas <- lerEstacionamento ("dados/vagas.txt")
        let vaga = alocaVaga (splitOn "\n" vagas)
        salvaCliente (Cliente cpf placa veiculo "normal" 0.0 vaga hora minuto)
        atualizaVaga "True" (show vaga) ("dados/vagas.txt")
        putStrLn $ "CheckIn feito!"
    else do
        putStrLn $ "CheckIn cliente antigo."
        let temp = clienteVaga
        if temp != -1 then



reserva:: IO()
reserva = do
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
            vagas <- lerEstacionamento "dados/vagas.txt"
            let vaga = alocaVaga (splitOn "\n" vagas)
            atualizaVaga "True" (show vaga) "dados/vagas.txt"
            atualizaCliente cpf vaga

checkOut:: IO()
checkOut = do
    putStrLn $ "Pagar saida do estacionamento"
    putStrLn $ "Digite seu cpf: "
    cpf <- getLine
    clientes <- lerArquivo
    let cliente = geraCliente (recuperaCliente clientes cpf)
    if (clienteCpf cliente) == "" then putStrLn $ "Cliente não existe."
    else do
        valor <- calculaValor cliente
        let clienteAtualizado = clienteAtualizaValor cliente valor
        atualizaCliente cpf (-1)
        atualizaVaga "False" (show clienteVaga) "dados/vagas.txt"
        putStrLn $ clienteMostraCliente clienteAtualizado

checkOutFuncionario:: IO()
checkOutFuncionario = do
    putStrLn $ "Fazendo checkout do Funcionario"
    putStrLn $ "Digite seu CPF: "
    cpf <- getLine
    listaFuncionarios < funcionarioLerArquivo
    let funcionario = geraFuncionario (recuperaFuncionario listaFuncionarios cpf)
    if (funcionarioCpf funcionario) == "" then putStrLn $ "Funcionario nao cadastrado no sistema."
    else do
        atualizaFuncionario cpf (-1)
        atualizaVaga "False" (show funcionarioVaga) "dados/vagasFuncionarios.txt"
        putStrLn $ mostraFuncionario funcionario

meuMenu:: Bool->IO()
meuMenu True = return ()
meuMenu saida = do
    putStrLn $ "1 - CheckIn"
    putStrLn $ "2 - Reservar"
    putStrLn $ "3 - CheckOut"
    putStrLn $ "4 - CheckIn Funcionario"
    putStrLn $ "5 - Sair"
    putStr $ "opt>> "
    opt <- getLine
    if opt == "1"
        then do
            checkInCliente
            meuMenu False
    else
        if opt == "2"
            then do
                putStrLn $ "reservar"
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
                        then meuMenu True
                    else do
                        putStrLn $ "Opção invalida"
                        meuMenu False

inicializaEstacionamento = do
    criaEstacionamento
    meuMenu False
