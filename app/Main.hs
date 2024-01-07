{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}
{-# LANGUAGE TypeApplications #-}

{--
  This module defines a simple Servant based backend.
  The backend consists of two parts:
  1. An HTTP file server that serves the contents of the *static* directory.
     This directory contains the devanagari-ui single page client application.
  2. An API that provides the actual transliteration operation. The API is
     implemented by using the devanagari-transliterations library
--}
module Main (main) where

import           Control.Exception        (IOException, catch)
import           Data.Char.Devanagari
import           Data.Text                (Text)
import           Network.Socket.Free      (getFreePort)
import           Network.Wai.Handler.Warp (run)
import           Servant
import           System.Environment       (getArgs)
import           System.Exit              (exitFailure)
import           System.Info              (os)
import           System.Process           (createProcess, shell)

-- | API for the devanagari-ui
--   POST /transliterate with an input text returns a tuple of four texts in four scripts:
--   (devanagari, harvard-kyoto, iast, iso)
--   GET /static serves the static files in the static directory
type DevanagariAPI =
  "transliterate"
    :> ReqBody '[JSON] Text
    :> Post '[JSON] (Text, Text, Text, Text) -- POST /transliterate
  :<|> Raw                                   -- GET  /static

devanagariServer :: Server DevanagariAPI
devanagariServer = transliterationHandler :<|> serveDirectoryFileServer "static"
  where
    transliterationHandler :: Text -> Handler (Text, Text, Text, Text)
    transliterationHandler input = do
      let tokens = tokenize input
          deva = toDevanagari tokens
          iso = toIso tokens
          iast = toIast tokens
          hk = toHarvard tokens
      return (deva, hk, iast, iso)

app :: Application
app = serve (Proxy @DevanagariAPI) devanagariServer

main :: IO ()
main = do
  -- get the port number from the command line arguments or a random free port
  port <- getPort
  catch
    -- write dynamic port to static/js/port.js so that is visible to the client
    (writeFile "static/js/port.js" ("var port = " ++ show port ++ ";"))
    ( \(_ex :: IOException) -> do
        putStrLn $
          "Error: could not write port to static/js/port.js. "
            ++ "Please run the program from the devanagari-ui root directory."
        exitFailure
    )
  putStrLn $ "serving devanagari-ui on http://localhost:" ++ show port
  launchInBrowser (show port)
  run port app

-- | get the port number from the command line arguments or a random free port
getPort :: IO Int
getPort = do
  args <- getArgs
  nextFreePort <- getFreePort
  let port = 
        case args of
          [p] -> read p
          _   -> nextFreePort
  return port

-- | convenience function that opens the page in the default web browser
launchInBrowser :: String -> IO ()
launchInBrowser port = do
  _ <- createProcess (shell $ openCommand ++ url)
  pure ()
  where
    url = "http://localhost:" ++ port
    openCommand = case os of
      "darwin"  -> "open "
      "linux"   -> "xdg-open "
      "mingw32" -> "start "
      _         -> "open "
