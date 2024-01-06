{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Data.Text (Text)
import Servant
import Data.Char.Devanagari (tokenize, toDevanagari, toIso, toIast, toHarvard)
import Network.Wai.Handler.Warp (run, openFreePort)
import           System.Process           (createProcess, shell)
import           System.Info              (os)

type DevanagariAPI = "transliterate" :> Summary "transliterate any Unicode input"
                      :> ReqBody '[ JSON] Text
                      :> Post    '[ JSON] (Text, Text, Text, Text)                 -- POST   /transliterate
                      :<|> Raw                                                     -- GET    /static


devanagariServer :: Server DevanagariAPI
devanagariServer = transliterationHandler :<|> serveDirectoryFileServer "static"
  where
    transliterationHandler :: Text -> Handler (Text, Text, Text, Text)
    transliterationHandler input = do 
      let tokens = tokenize input
          deva   = toDevanagari tokens
          iso    = toIso tokens
          iast   = toIast tokens
          hk     = toHarvard tokens
      return (deva, hk, iast, iso)

devanagariAPI :: Proxy DevanagariAPI
devanagariAPI = Proxy

app :: Application
app = serve devanagariAPI devanagariServer

main :: IO ()
main = do
  (port, _socket) <- openFreePort
  -- write dynamic port to static/js/port.js so that is visible to the client
  writeFile "static/js/port.js" ("var port = " ++ show port ++ ";")
  putStrLn $ "serving devanagari converter on http://localhost:" ++ show port
  launchSiteInBrowser (show port)
  run port app
  

-- | convenience function that opens the 3penny UI in the default web browser
launchSiteInBrowser :: String -> IO ()
launchSiteInBrowser port = do 
  _  <- createProcess  (shell $ openCommand ++ url) 
  pure () 
    where
      url = "http://localhost:" ++ port
      openCommand = case os of
        "darwin"  -> "open "
        "linux"   -> "xdg-open "
        "mingw32" -> "start "
        _         -> "open "
