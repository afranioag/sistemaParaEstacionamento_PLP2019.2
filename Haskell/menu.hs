import Cliente

opcoes = putStrLn $ "1 - VIP\n2 - Normal"

pegaStatus:: IO String
pegaStatus = do
    opcoes
    opt <- readLn:: IO Int
    if opt == 1 then return "vip"
    else if opt == 2 then return "normal"
        else pegaStatus

cadastro:: IO()
cadastro = do
    putStrLn $ "Cadastre seu veículo"
    putStrLn $ "CPF: "
    cpf <- getLine
    putStrLn $ "Placa: "
    placa <- getLine
    putStrLn $ "Veiculo: "
    veiculo <- getLine
    putStrLn $ "Status: "
    status <- pegaStatus
    -- função não implementada
    salvaCliente (Cliente cpf placa veiculo status 0.0 10)

{-reserva:: IO()-}
--reserva = do
    --putStrLn $ "Reserva de vaga para clientes VIP"
    --putStrLn $ "Digite seu cpf: "
    --cpf <- getLine
    --if verificaCpf cpf then fazReserva cpf
    --else putStrLn $ "Cliente não existe."

--pagar:: IO()
--pagar = do
    --putStrLn $ "Pagar saida do estacionamento"
    --putStrLn $ "Digite a palca do veículo: "
    --placa <- getLine
    --let valor = calculaValor placa
    --let cliente = buscaCliente placa
    --let clienteAtualizado = clienteAtualizaValor cliente valor
    --clienteMostraCliente cliente

meuMenu:: Bool->IO()
meuMenu True = return ()
meuMenu saida = do
    putStrLn $ "1 - Cadastrar"
    putStrLn $ "2 - Reservar"
    putStrLn $ "3 - Pagar"
    putStrLn $ "4 - Sair"
    putStr $ "opt>> "
    opt <- getLine
    if opt == "1"
        then do
            putStrLn $ "cadastrar"
            cadastro
            meuMenu False
    else
        if opt == "2"
            then do
                putStrLn $ "reservar"
                meuMenu False
        else
            if opt == "3"
                then do
                    putStrLn $ "Pagar"
                    meuMenu False
            else
                if opt == "4"
                    then meuMenu True
                else do
                    putStrLn $ "Opção invalida"
                    meuMenu False

inicializaEstacionamento = do
    meuMenu False
