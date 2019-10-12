import System.IO


main:: IO ()
main = do {
        boasVindas
        ; arch <- getLines
        ; appendFile "dados.txt" $ unwords arch }
        

boasVindas = putStrLn "BEM VINDO AO ESTACIONAMENTO DA UFCG\nDIGITE SEUS DADOS\n-> NOME\n-> TIPO DE VEICULO\n-> PLACA\n-> ID DE FUNCIONARIO OU CLIENTE VIP"


getLines :: IO [String]
getLines = do
        x <- getLine
        if x == ""
        then return []
        else do
          xs <- getLines
          return (x:xs)

