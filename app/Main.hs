module Main where

import Data.List (sort)
import DBus
import DBus.Client

main :: IO ()
main = do
    client <- connectSession

    -- Request a list of connected clients from the bus
    reply <- call_ client (methodCall (objectPath_ "/org/freedesktop/DBus") (interfaceName_ "org.freedesktop.DBus") (memberName_ "ListNames"))
        { methodCallDestination = Just (busName_ "org.freedesktop.DBus")
        }

    -- org.freedesktop.DBus.ListNames() returns a single value, which is
    -- a list of names (here represented as [String])
    let Just names = fromVariant (methodReturnBody reply !! 0)

    -- Print each name on a line, sorted so reserved names are below
    -- temporary names.
    mapM_ putStrLn (sort names)
