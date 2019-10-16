module Cliente(
    Cliente(..),
    geraCliente,
    clienteStatus,
    clienteVeiculo,
    clienteVaga,
    clienteMostraCliente,
    clienteAtualizaValor,
    salvaCliente,
    recuperaCliente,
    lerArquivo,
    removeCliente
)

where

import  Data.List.Split
import System.Directory

data Cliente = Cliente{cpf:: String, placa::String, veiculo::String, status::String, valor::Float, vaga::Int} | Funcionario{cpf::String, vaga::Int}deriving (Show)

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

geraCliente:: String->Cliente
geraCliente cliente  =
    if cliente /= "" then(Cliente (dados !! 0) (dados !! 1) (dados !! 2) (dados !! 3) (read (dados !! 4)::Float) (read(dados !! 5)::Int))
    else (Cliente "" "" "" "" 0 0)
    where
        dados = splitOn "-" cliente

formataCliente:: Cliente->String
formataCliente (Cliente a b c d e f) = a ++ "-" ++ b ++ "-" ++ c ++ "-" ++ d ++ "-" ++ (show e) ++ "-" ++ (show f)++ "\n"

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
lerArquivo = readFile "clientes.txt"

salvaCliente::Cliente->IO()
salvaCliente cliente  = do
    clientes <- lerArquivo
    let flag = recuperaCliente clientes (clienteCpf cliente)
    if flag /= "" then putStrLn $ "Cliente já existe"
    else do
        appendFile "clientes.txt" $ formataCliente cliente
        putStrLn $ "Cliente cadastrado."

removeClienteAux::String->[String]->[String]
removeClienteAux cpf [] = []
removeClienteAux cpf (x:xs) =
    if (splitOn "-" x !! 0) == cpf then removeClienteAux cpf xs
    else x:removeClienteAux cpf xs

removeCliente::String->IO()
removeCliente cpf = do
    clientes <- lerArquivo
    let removeCliente = removeClienteAux cpf (splitOn "\n" clientes)
    removeFile "clientes.txt"
    writeFile "clientes.txt" $ init(unlines removeCliente)

