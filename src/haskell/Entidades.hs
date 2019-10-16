module Entidades(
    Cliente(..)
)

where

data Cliente = Cliente { id:: Int,
                         placa:: String,
                         carro:: String,
                         valor:: Float
                        } deriving (Show)
