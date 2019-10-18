module Cliente(
    Cliente(..),
    geraCliente,
    formataCliente,
    clienteReserva,
    clienteCpf,
    clientePlaca,
    clienteStatus,
    clienteVeiculo,
    clienteVisitas,
    clienteVaga,
    clienteMostraCliente,
    clienteAtualizaValor,
    salvaCliente,
    recuperaCliente,
    lerArquivo,
    atualizaCliente
)

where

import  Data.List.Split
import System.Directory

data Cliente = Cliente{cpf:: String, placa::String, veiculo::String, status::String, valor::Float, vaga::Int, hora::Int, minuto::Int,visitas::Int, reserva::Bool} deriving (Show)

clienteAlteraVaga::Int->Cliente->Cliente
clienteAlteraVaga vaga (Cliente a b c d e f g h i j) = ((Cliente a b c d e vaga g h i j))

clienteReserva::Cliente->Bool
clienteReserva (Cliente _ _ _ _ _ _ _ _ _ reserva) = reserva

clienteVisitas::Cliente->Int
clienteVisitas (Cliente _ _ _ _ _ _ _ _ visitas _) = visitas

clientePlaca::Cliente->String
clientePlaca (Cliente _ placa _ _ _ _ _ _ _ _) = placa

clienteCpf::Cliente->String
clienteCpf (Cliente cpf _ _ _ _ _ _ _ _ _) = cpf

clienteStatus::Cliente->String
clienteStatus (Cliente _ _ _ status _ _ _ _ _ _) = status

clienteVeiculo::Cliente->String
clienteVeiculo (Cliente _ _ veiculo _ _ _ _ _ _ _) =  veiculo

clienteVaga::Cliente->Int
clienteVaga (Cliente _ _ _ _ _ vaga _ _ _ _) = vaga

clienteAtualizaValor::Cliente->Float->Cliente
clienteAtualizaValor (Cliente a b c d e f g h i j) novo = (Cliente a b c d novo f g h i j)

clienteMostraCliente::Cliente->String
clienteMostraCliente (Cliente a b c d e f g h i j) = "\nCPF: " ++ a ++ "\nPlaca: " ++ b ++ "\nVeiculo: " ++ c ++ "\nStatus: " ++ d ++ "\nValor: " ++ (show e) ++ "\nVaga: " ++ (show f) ++ "\nHora: " ++ (show g) ++ ":" ++ (show h) ++ "\nVisitas: " ++ (show i)

stringToBool::String->Bool
stringToBool "True" = True
stringToBool "False" = False

geraCliente:: String->Cliente
geraCliente cliente  =
    if cliente /= "" then(Cliente (dados !! 0) (dados !! 1) (dados !! 2) (dados !! 3) (read (dados !! 4)::Float) (read(dados !! 5)::Int) (read(dados !! 6)::Int) (read(dados !! 7)::Int) (read(dados !! 8)::Int) (stringToBool (dados !! 9)))
    else (Cliente "" "" "" "" 0 0 0 0 0 False)
    where
        dados = splitOn "-" cliente

formataCliente:: Cliente->String
formataCliente (Cliente a b c d e f g h i j) = a ++ "-" ++ b ++ "-" ++ c ++ "-" ++ d ++ "-" ++ (show e) ++ "-" ++ (show f) ++  "-" ++ (show g) ++ "-" ++ (show h) ++ "-" ++ (show i) ++ "-" ++ (show j) ++ "\n"

isCliente:: [String]->String->String
isCliente [] key = ""
isCliente (x:xs) key =
    if (splitOn "-" x !! 0) == key then x
    else isCliente xs key

recuperaCliente:: String->String-> String
recuperaCliente clientes cpf = do
    encontrado
    where
        encontrado = isCliente (splitOn "\n" clientes) cpf

lerArquivo::IO String
lerArquivo = readFile "dados/clientes.txt"

salvaCliente::Cliente->IO()
salvaCliente cliente  = do
    clientes <- lerArquivo
    let flag = recuperaCliente clientes (clienteCpf cliente)
    if flag /= "" then putStrLn $ "Cliente já existe"
    else do
        appendFile "dados/clientes.txt" $ formataCliente cliente

atualizaClienteAux::String->[String]->String->[String]
atualizaClienteAux cpf [] cliente = []
atualizaClienteAux cpf (x:xs) cliente =
    if (antigo !! 0) == (novo !! 0) then (cliente):atualizaClienteAux cpf xs cliente
    else x:atualizaClienteAux cpf xs cliente
    where
        antigo = splitOn "-" x
        novo = splitOn "-" cliente

atualizaCliente::String->String->IO()
atualizaCliente cpf cliente= do
    clientes <- lerArquivo
    let clienteAtualizado = atualizaClienteAux cpf (splitOn "\n" clientes) cliente
    removeFile "dados/clientes.txt"
    writeFile "dados/clientes.txt" $ (unlines clienteAtualizado)

