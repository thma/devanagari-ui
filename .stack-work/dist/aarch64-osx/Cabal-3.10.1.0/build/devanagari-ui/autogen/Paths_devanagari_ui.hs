{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_devanagari_ui (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/mahlerth/code/devanagari-ui/.stack-work/install/aarch64-osx/44806f06d5e588e6226e857865044f0bc08405c3a5ae05b57faae4cc799ca55c/9.6.3/bin"
libdir     = "/Users/mahlerth/code/devanagari-ui/.stack-work/install/aarch64-osx/44806f06d5e588e6226e857865044f0bc08405c3a5ae05b57faae4cc799ca55c/9.6.3/lib/aarch64-osx-ghc-9.6.3/devanagari-ui-0.1.0.0-AXNCOkr135M1dTjFAoDcqL-devanagari-ui"
dynlibdir  = "/Users/mahlerth/code/devanagari-ui/.stack-work/install/aarch64-osx/44806f06d5e588e6226e857865044f0bc08405c3a5ae05b57faae4cc799ca55c/9.6.3/lib/aarch64-osx-ghc-9.6.3"
datadir    = "/Users/mahlerth/code/devanagari-ui/.stack-work/install/aarch64-osx/44806f06d5e588e6226e857865044f0bc08405c3a5ae05b57faae4cc799ca55c/9.6.3/share/aarch64-osx-ghc-9.6.3/devanagari-ui-0.1.0.0"
libexecdir = "/Users/mahlerth/code/devanagari-ui/.stack-work/install/aarch64-osx/44806f06d5e588e6226e857865044f0bc08405c3a5ae05b57faae4cc799ca55c/9.6.3/libexec/aarch64-osx-ghc-9.6.3/devanagari-ui-0.1.0.0"
sysconfdir = "/Users/mahlerth/code/devanagari-ui/.stack-work/install/aarch64-osx/44806f06d5e588e6226e857865044f0bc08405c3a5ae05b57faae4cc799ca55c/9.6.3/etc"

getBinDir     = catchIO (getEnv "devanagari_ui_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "devanagari_ui_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "devanagari_ui_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "devanagari_ui_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "devanagari_ui_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "devanagari_ui_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
