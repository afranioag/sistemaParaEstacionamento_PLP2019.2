import Data.Time.Clock
import Data.Time.LocalTime
import Data.Time.Calendar

getHoraAtual = do
    now <- getCurrentTime
    timezone <- getCurrentTimeZone
    let (TimeOfDay hour minute second) = localTimeOfDay $ utcToLocalTime timezone now
    putStrLn $ show hour ++ ":" ++ show minute

getDataAtual = do
    now <- getCurrentTime
    let (year, month, day) = toGregorian $ utctDay now
    putStrLn $ show day ++ "/" ++ show month ++ "/" ++ show year
