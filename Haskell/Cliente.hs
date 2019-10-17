module Cliente(
    Cliente(..),
    geraCliente,
    clienteCpf,
    clienteStatus,
    clienteVeiculo,
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

data Cliente = Cliente{cpf:: String, placa::String, veiculo::String, status::String, valor::Float, vaga::Int, hora::Int, minuto::Int} | Funcionario{cpf::String, vaga::Int}deriving (Show)

clienteAlteraVaga::Int->Cliente->Cliente
clienteAlteraVaga vaga (Cliente a b c d e f g h) = ((Cliente a b c d e vaga g h))

clienteCpf::Cliente->String
clienteCpf (Cliente cpf _ _ _ _ _ _ _) = cpf

clienteStatus::Cliente->String
clienteStatus (Cliente _ _ _ status _ _ _ _) = status

clienteVeiculo::Cliente->String
clienteVeiculo (Cliente _ _ veiculo _ _ _ _ _) =  veiculo

clienteVaga::Cliente->Int
clienteVaga (Cliente _ _ _ _ _ vaga _ _) = vaga

clienteAtualizaValor::Cliente->Float->Cliente
clienteAtualizaValor (Cliente a b c d e f g h) novo = (Cliente a b c d novo f g h)

clienteMostraCliente::Cliente->String
clienteMostraCliente (Cliente a b c d e f g h) = "\nCPF: " ++ a ++ "\nPlaca: " ++ b ++ "\nVeiculo: " ++ c ++ "\nStatus: " ++ d ++ "\nValor: " ++ (show e) ++ "\nVaga: " ++ (show f) ++ "\nHora: " ++ (show g) ++ ":" ++ (show h)

geraCliente:: String->Cliente
geraCliente cliente  =
    if cliente /= "" then(Cliente (dados !! 0) (dados !! 1) (dados !! 2) (dados !! 3) (read (dados !! 4)::Float) (read(dados !! 5)::Int) (read(dados !! 6)::Int) (read(dados !! 7)::Int))
    else (Cliente "" "" "" "" 0 0 0 0)
    where
        dados = splitOn "-" cliente

formataCliente:: Cliente->String
formataCliente (Cliente a b c d e f g h) = a ++ "-" ++ b ++ "-" ++ c ++ "-" ++ d ++ "-" ++ (show e) ++ "-" ++ (show f) ++  "-" ++ (show g) ++ "-" ++ (show h) ++"\n"

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

atualizaClienteAux::String->[String]->Int->[String]
atualizaClienteAux cpf [] vaga = []
atualizaClienteAux cpf (x:xs) vaga =
    if (cliente !! 0) == cpf then (formataCliente (clienteAlteraVaga vaga (geraCliente x))):atualizaClienteAux cpf xs
    else x:atualizaClienteAux cpf xs
    where cliente = splitOn "-" x

atualizaCliente::String->Int->IO()
atualizaCliente cpf vaga= do
    clientes <- lerArquivo
    let clienteAtualizado = atualizaClienteAux cpf (splitOn "\n" clientes) vaga
    removeFile "dados/clientes.txt"
    writeFile "dados/clientes.txt" $ init(unlines clienteAtualizado)

