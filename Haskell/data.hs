import Data.Time.Clock
import Data.Time.LocalTime

getHoraAtual = do
    now <- getCurrentTime
    timezone <- getCurrentTimeZone
    let (TimeOfDay hour minute second) = localTimeOfDay $ utcToLocalTime timezone now
    putStrLn $ show hour ++ ":" ++ show minute
