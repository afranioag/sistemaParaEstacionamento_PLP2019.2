module Cliente(
    Cliente(..),
    clienteStatus,
    clienteVeiculo,
    clienteVaga,
    clienteVeiculo,
    clienteMostraCliente
)

where

data Cliente = Cliente{cpf::String, veiculo::String, status::String, valor::Float, vaga::Int}

clienteStatus::Cliente->String
clienteStatus (Cliente _ _ status _ _) = status

clienteVeiculo::Cliente->String
clienteVeiculo (Cliente _ veiculo _ _ _) =  veiculo

clienteVaga::Cliente->Int
clienteVaga (Cliente _ _ _ _ vaga) = vaga

clienteAtualizaValor::Cliente->Cliente
clienteAtualizaValor (Cliente a b c d e) novo = (Cliente a b c d novo e)

clienteMostraCliente::Cliente->String
clienteMostraCliente (Cliente a b c d e) = "Cliente: " ++ a ++ "\nVeiculo: " ++ b ++ "\nStatus: " ++ c ++ "\nValor: " ++ (show d) ++ "\nVaga: " ++ e
