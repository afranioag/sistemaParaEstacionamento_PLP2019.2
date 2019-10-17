module Funcionario(
    Funcionario(..)
    geraFuncionario,
    funcionarioCpf,
    funcionarioVaga,
    formataFuncionario,
    mostraFuncionario,
    alteraVagaFuncionario
    salvaFuncionario,
    recuperaFuncionario,
    lerArquivo,
    atualizaFuncionario
)

where

import  Data.List.Split
import System.Directory

data Funcionario = Funcionario{cpf::String, vaga::Int}deriving (Show)

alteraVagaFuncionario:: Int-> Funcionario-> Funcionario
alteraVagaFuncionario vaga (Funcionario a b) = ((Funcionario a vaga))

geraFuncionario:: String->Funcionario
geraFuncionario = 
        if funcionario /= "" then(Funcionario (dados !! 0) (read (dados !! 1)::Int))
        else (Funcionario "" 0)
        where
            dados = splitOn "-" funcionario

funcionarioCpf:: Funcionario->String
funcionarioCpf (Funcionario cpf _) = cpf

funcionarioVaga:: Funcionario->Int
funcionarioVaga (Funcionario _ vaga) = vaga

formataFuncionario:: Funcionario->String
formataFuncionario (Funcionario a b) = a ++ "-" ++ (show b) ++ "\n"

mostraFuncionario:: Funcionario->String
mostraFuncionario (Funcionario a b) = "\nCPF: " ++ a ++ "\nVaga: " ++ (show b)

isFuncionario:: [String]->String->String
isFuncionario [] key = ""
isFuncionario (x:xs) key =
    if (splitOn "-" x !! 0) == key then x
    else isFuncionario xs key

recuperaFuncionario:: String->String-> String
recuperaFuncionario clientes cpf = do
    encontrado
    where
        encontrado = isFuncionario (splitOn "\n" clientes) cpf


lerArquivo::IO String
lerArquivo = readFile "dados/clientes.txt"

salvaFuncionario::Cliente->IO()
salvaFuncionario cliente  = do
    clientes <- lerArquivo
    let flag = recuperaFuncionario clientes (clienteCpf cliente)
    if flag /= "" then putStrLn $ "Cliente já existe"
    else do
        appendFile "dados/clientes.txt" $ formataCliente cliente

atualizaFuncionarioAux::String->[String]->Int->[String]
atualizaFuncionarioAux cpf [] vaga = []
atualizaFuncionarioAux cpf (x:xs) vaga =
    if (cliente !! 0) == cpf then (formataCliente (clienteAlteraVaga vaga (geraCliente x))):atualizaFuncionarioAux cpf xs
    else x:atualizaFuncionarioAux cpf xs
    where cliente = splitOn "-" x

atualizaFuncionario::String->Int->IO()
atualizaFuncionario cpf vaga= do
    clientes <- lerArquivo
    let clienteAtualizado = atualizaFuncionarioAux cpf (splitOn "\n" clientes) vaga
    removeFile "dados/clientes.txt"
    writeFile "dados/clientes.txt" $ init(unlines clienteAtualizado)

