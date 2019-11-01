module Estacionamento(
    Vaga(..),
    getHoraAtual,
    getMinutoAtual,
    recuperaVagaReservada,
    alocaVaga,
    formataVaga,
    criaEstacionamento,
    atualizaVaga,
    atualizaVagaF,
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


data Vaga = Vaga{id::Int, ocupada::Bool, reservada::Bool, cpfCliente::String} deriving (Show)

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

getClienteVaga::Vaga->String
getClienteVaga (Vaga _ _ _ cliente) = cliente


alocaVaga::[String]->Int
alocaVaga [] = 0
alocaVaga (x:xs) = if (vaga !! 1) == "False" && (vaga !! 2) == "False" then (read (vaga !! 0)::Int) else alocaVaga xs
    where vaga = splitOn "-" x

recuperaVagaReservada::[String]->String->Int
recuperaVagaReservada [] _ = 0
recuperaVagaReservada (x:xs) cpf = if (vaga !! 3) == cpf then (read (vaga !! 0)::Int) else recuperaVagaReservada xs cpf
    where vaga = splitOn "-" x

lerEstacionamento::String->IO String
lerEstacionamento arquivo = readFile arquivo

atualizaVagaAux::String->[String]->String->[String]
atualizaVagaAux vaga [] _ = []
atualizaVagaAux vaga (x:xs) id =
    if (antiga !! 0) == (nova !! 0) then vaga:atualizaVagaAux vaga xs id else x:atualizaVagaAux vaga xs id
    where
        antiga = splitOn "-" x
        nova = splitOn "-" vaga


atualizaVagaF::String->String->String->IO()
atualizaVagaF vaga estacionamento id = do
    let novoEstacionamento = atualizaVagaAux vaga (splitOn "\n" estacionamento) id
    removeFile "dados/vagasFuncionarios.txt"
    writeFile "dados/vagasFuncionarios.txt" $ unlines novoEstacionamento


atualizaVaga::String->String->String->IO()
atualizaVaga vaga estacionamento id = do
    let novoEstacionamento = atualizaVagaAux vaga (splitOn "\n" estacionamento) id
    removeFile "dados/vagas.txt"
    writeFile "dados/vagas.txt" $ unlines novoEstacionamento

formataVaga::Vaga->String
formataVaga (Vaga a b c d) = (show a) ++ "-" ++ (show b) ++ "-" ++ (show c) ++ "-" ++ d

criaEstacionamento::IO()
criaEstacionamento = do
    writeFile "dados/vagas.txt" $ unlines vagasNormais
    writeFile "dados/funcionarios.txt" $ unlines vagasFuncionarios
    where
        vagasNormais = [formataVaga (Vaga x False False "") | x <- [1..2000]]
        vagasFuncionarios = [formataVaga (Vaga z False False "") | z <- [1..200]]

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
calculaValor (Cliente _ _ veiculo status  _ _ hora _ _ _) = do
    temp <- getHoraAtual
    let diff = temp - hora
    let valor = calculaValorAux veiculo status diff
    return valor
