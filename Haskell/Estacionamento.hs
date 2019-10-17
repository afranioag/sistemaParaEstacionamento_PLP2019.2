module Estacionamento(
    getHoraAtual,
    getMinutoAtual,
    alocaVaga,
    criaEstacionamento,
    atualizaVaga,
    lerEstacionamento,
    calculaValor
    --reservaVaga,
)

where

import Data.List.Split
import System.Directory
import Cliente
import Data.Time.Clock
import Data.Time.LocalTime
import Data.Time.Calendar


data Vaga = Vaga{id::Int, ocupada::Bool} deriving (Show)

getMinutoAtual::IO Int
getMinutoAtual = do
    now <- getCurrentTime
    timezone <- getCurrentTimeZone
    let (TimeOfDay hour minute second) = localTimeOfDay $ utcToLocalTime timezone now
    return minute

getHoraAtual::IO Int
getHoraAtual = do
    now <- getCurrentTime
    timezone <- getCurrentTimeZone
    let (TimeOfDay hour minute second) = localTimeOfDay $ utcToLocalTime timezone now
    return hour

-- se retorna -1 é pq o estacionamento esta lotado
alocaVaga::[String]->Int
alocaVaga [] = -1
alocaVaga (x:xs) = if (vaga !! 1) == "False" then (read (vaga !! 0)::Int) else alocaVaga xs
    where vaga = splitOn "-" x

lerEstacionamento::String->IO String
lerEstacionamento arquivo = readFile arquivo

-- atualiza a vaga indicando que ela esta ocupada
myReplace::String->[String]->String
myReplace flag [] = flag
myReplace flag (x:xs) = x ++ "-" ++  myReplace flag xs

atualizaVagaAux::String->[String]->String->[String]
atualizaVagaAux flag [] _ = []
atualizaVagaAux flag (x:xs) id =
    if (vaga !! 0) == id then (myReplace flag (init vaga)):atualizaVagaAux xs id else x:atualizaVagaAux xs id
    where
        vaga = splitOn "-" x

atualizaVaga::String->String->String->IO()
atualizaVaga flag id estacionamento = do
    vagas <- lerEstacionamento estacionamento
    let novoEstacionamento = atualizaVagaAux flag (splitOn "\n" vagas) id
    removeFile estacionamento
    writeFile estacionamento $ unlines novoEstacionamento

formataVaga::Vaga->String
formataVaga (Vaga a b) = (show a) ++ "-" ++ (show b)

criaEstacionamento::IO()
criaEstacionamento = do
    writeFile "dados/vagas.txt" $ unlines vagasNormais
    writeFile "dados/clientes.txtvagasVip.txt" $ unlines vagasVip
    writeFile "dados/funcionarios.txt" $ unlines vagasFuncionarios
    where
        vagasNormais = [formataVaga (Vaga x False) | x <- [1..2000]]
        vagasVip = [formataVaga (Vaga y False) | y <- [1..500]]
        vagasFuncionarios = [formataVaga (Vaga z False) | z <- [1..200]]

calculaValorAux::String->String->Int->Float
calculaValorAux veiculo "vip" diff
    |veiculo == "carro" = temp * 10 * 0.80
    |veiculo == "moto" = temp * 6 * 0.80
    |veiculo == "caminhao" =  temp * 15 * 0.80
    |otherwise = 0.0
    where
        temp = if diff > 0 then fromIntegral diff:: Float else 1.0
calculaValorAux veiculo "normal" diff
    |veiculo == "carro" = temp * 10
    |veiculo == "moto" = temp * 6
    |veiculo == "caminhao" = temp * 15
    |otherwise = 0.0
    where
        temp = if diff > 0 then fromIntegral diff:: Float else 1.0

calculaValor::Cliente->IO Float
calculaValor (Cliente _ _ veiculo status  _ _ hora _) = do
    temp <- getHoraAtual
    let diff = temp - hora
    let valor = calculaValorAux veiculo status diff
    return valor
