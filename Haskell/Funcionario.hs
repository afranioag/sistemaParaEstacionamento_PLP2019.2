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
    funcionarioLerArquivo,
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
recuperaFuncionario funcionario cpf = do
    encontrado
    where
        encontrado = isFuncionario (splitOn "\n" funcionario) cpf


funcionarioLerArquivo::IO String
funcionarioLerArquivo = readFile "dados/funcionarios.txt"

salvaFuncionario::Cliente->IO()
salvaFuncionario funcionario  = do
    funcionario <- lerArquivo
    let flag = recuperaFuncionario funcionario (funcionarioCpf funcionario)
    if flag /= "" then putStrLn $ "Funcionario já existe"
    else do
        appendFile "dados/funcinarios.txt" $ formataFuncionario funcionario

atualizaFuncionarioAux::String->[String]->Int->[String]
atualizaFuncionarioAux cpf [] vaga = []
atualizaFuncionarioAux cpf (x:xs) vaga =
    if (funcionario !! 0) == cpf then (formataFuncionario (clienteAlteraVaga vaga (geraFuncionario x))):atualizaFuncionarioAux cpf xs
    else x:atualizaFuncionarioAux cpf xs
    where funcionario = splitOn "-" x

atualizaFuncionario::String->Int->IO()
atualizaFuncionario cpf vaga= do
    funcionario <- lerArquivo
    let funcionarioAtualizado = atualizaFuncionarioAux cpf (splitOn "\n" funcionario) vaga
    removeFile "dados/funcionarios.txt"
    writeFile "dados/funcionarios.txt" $ init(unlines funcionarioAtualizado)

