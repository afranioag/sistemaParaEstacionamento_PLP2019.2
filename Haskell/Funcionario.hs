module Funcionario(
    Funcionario(..),
    geraFuncionario,
    funcionarioCpf,
    funcionarioVaga,
    formataFuncionario,
    mostraFuncionario,
    alteraVagaFuncionario,
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

funcionarioCpf:: Funcionario->String
funcionarioCpf (Funcionario cpf _) = cpf

funcionarioVaga:: Funcionario->Int
funcionarioVaga (Funcionario _ vaga) = vaga

formataFuncionario:: Funcionario->String
formataFuncionario (Funcionario a b) = a ++ "-" ++ (show b) ++ "\n"

mostraFuncionario:: Funcionario->String
mostraFuncionario (Funcionario a b) = "\nCPF: " ++ a ++ "\nVaga: " ++ (show b)

geraFuncionario:: String->Funcionario
geraFuncionario funcionario  =
    if funcionario /= "" then(Funcionario (dados !! 0) (read (dados !! 1)::Int))
    else (Funcionario "" 0)
    where
        dados = splitOn " " funcionario

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

salvaFuncionario::Funcionario->IO()
salvaFuncionario funcionario  = do
    funcionarioIO <- funcionarioLerArquivo
    let flag = recuperaFuncionario funcionarioIO (funcionarioCpf funcionario)
    if flag /= "" then putStrLn $ "Funcionario já existe"
    else do
        appendFile "dados/funcionarios.txt" $ formataFuncionario funcionario

atualizaFuncionarioAux::String->[String]->String->[String]
atualizaFuncionarioAux cpf [] funcionario = []
atualizaFuncionarioAux cpf (x:xs) funcionario =
    if (antigo !! 0) == (novo !! 0) then (funcionario):atualizaFuncionarioAux cpf xs funcionario
    else x:atualizaFuncionarioAux cpf xs funcionario
    where
        antigo = splitOn "-" x
        novo = splitOn "-" funcionario

atualizaFuncionario::String->String->IO()
atualizaFuncionario cpf funcionario= do
    funcionarios <- funcionarioLerArquivo
    let funcionarioAtualizado = atualizaFuncionarioAux cpf (splitOn "\n" funcionarios) funcionario
    removeFile "dados/funcionarios.txt"
    writeFile "dados/funcionarios.txt" $ (unlines funcionarioAtualizado)
