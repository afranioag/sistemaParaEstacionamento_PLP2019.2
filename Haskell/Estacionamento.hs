module Estacionamento(
    padronizaTaxas,
    alocaVaga,
    calculaTempo,
    calculaValor,
    reservaVaga,

)

where

import Data.List.Split

-- Recebe a string do arquivo de taxas e transforma em uma lisa de pares
padronizaTaxas:: [String]->[(String, String)]
padronizaTaxas [] = []
padronizaTaxas (x:y:xs) = (x,y):padronizaTaxas xs
