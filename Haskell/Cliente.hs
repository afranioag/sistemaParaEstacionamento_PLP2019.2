module Cliente(
    Cliente(..),
    clienteStatus,
    clienteVeiculo,
    clienteVaga,
    clienteMostraCliente,
    salvaCliente,
    recuperaCliente
)

where

import Data.List.Split

data Cliente = Cliente{cpf:: String, placa::String, veiculo::String, status::String, valor::Float, vaga::Int}

clienteCpf::Cliente->String
clienteCpf (Cliente cpf _ _ _ _ _) = cpf

clienteStatus::Cliente->String
clienteStatus (Cliente _ _ _ status _ _) = status

clienteVeiculo::Cliente->String
clienteVeiculo (Cliente _ _ veiculo _ _ _) =  veiculo

clienteVaga::Cliente->Int
clienteVaga (Cliente _ _ _ _ _ vaga) = vaga

clienteAtualizaValor::Cliente->Float->Cliente
clienteAtualizaValor (Cliente a b c d e f) novo = (Cliente a b c d novo f)

clienteMostraCliente::Cliente->String
clienteMostraCliente (Cliente a b c d e f) = "\nCPF: " ++ a ++ "\nPlaca: " ++ b ++ "\nVeiculo: " ++ c ++ "\nStatus: " ++ d ++ "\nValor: " ++ (show e) ++ "\nVaga: " ++ (show f)

formataCliente:: Cliente->String
formataCliente (Cliente a b c d e f) = a ++ "-" ++ b ++ "-" ++ c ++ "-" ++ d ++ "-" ++ (show e) ++ "-" ++ (show f)++ "\n"

isCliente:: [String]->String->String
isCliente [] key = ""
isCliente (x:xs) key =
    if (splitOn "-" x !! 0) == key then x
    else isCliente xs key

-- incompleta
recuperaCliente:: String->String-> String
recuperaCliente clientes cpf = do
    let encontrado = isCliente (splitOn "\n" clientes) cpf
    if encontrado == "" then "" else encontrado

lerArquivo::IO String
lerArquivo = readFile "clientes.txt"
-- incompleta
salvaCliente::Cliente->IO()
salvaCliente cliente  = do
    clientes <- lerArquivo
    let flag = recuperaCliente clientes (clienteCpf cliente)
    if flag /= "" then putStrLn $ "Cliente já existe" else appendFile "clientes.txt" $ formataCliente cliente
--buscaCliente::String->Cliente
--
