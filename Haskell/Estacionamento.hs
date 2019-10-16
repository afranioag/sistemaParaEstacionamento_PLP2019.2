module Estacionamento(
    padronizaTaxas,
    alocaVaga,
    criaEstacionamento,
    atualizaVaga,
    lerEstacionamento
    --calculaTempo,
    --calculaValor,
    --reservaVaga,

)

where

import Data.List.Split
import System.Directory

data Vaga = Vaga{id::Int, ocupada::Bool} deriving (Show)

-- se retorna -1 é pq o estacionamento esta lotado
alocaVaga::[String]->Int
alocaVaga [] = -1
alocaVaga (x:xs) = if (vaga !! 1) == "False" then (read (vaga !! 0)::Int) else alocaVaga xs
    where vaga = splitOn "-" x

lerEstacionamento::String->IO String
lerEstacionamento arquivo = readFile arquivo

-- atualiza a vaga indicando que ela esta ocupada
myReplace::[String]->String
myReplace [] = "True"
myReplace (x:xs) = x ++ "-" ++  myReplace xs

atualizaVagaAux::[String]->String->[String]
atualizaVagaAux [] _ = []
atualizaVagaAux (x:xs) id =
    if (vaga !! 0) == id then (myReplace (init vaga)):atualizaVagaAux xs id else x:atualizaVagaAux xs id
    where
        vaga = splitOn "-" x

atualizaVaga::String->String->IO()
atualizaVaga id estacionamento = do
    vagas <- lerEstacionamento estacionamento
    let novoEstacionamento = atualizaVagaAux (splitOn "\n" vagas) id
    removeFile estacionamento
    writeFile estacionamento $ unlines novoEstacionamento


formataVaga::Vaga->String
formataVaga (Vaga a b) = (show a) ++ "-" ++ (show b)

criaEstacionamento::IO()
criaEstacionamento = do
    writeFile "vagas.txt" $ unlines vagasNormais
    writeFile "vagasVip.txt" $ unlines vagasVip
    writeFile "funcionarios.txt" $ unlines vagasFuncionarios
    where
        vagasNormais = [formataVaga (Vaga x False) | x <- [1..2000]]
        vagasVip = [formataVaga (Vaga y False) | y <- [1..500]]
        vagasFuncionarios = [formataVaga (Vaga z False) | z <- [1..200]]

-- Recebe a string do arquivo de taxas e transforma em uma lisa de pares
padronizaTaxas:: [String]->[(String, String)]
padronizaTaxas [] = []
padronizaTaxas (x:y:xs) = (x,y):padronizaTaxas xs



