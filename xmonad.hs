{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}

------------------------------------------
--      Imports
------------------------------------------
-- Custom 
import Custom.MyHotkeys
import Custom.MyScratchpads
------------------------------------------
-- General
import System.IO
import System.IO.Unsafe
import Graphics.X11.XRM
import Data.Map    (fromList)
import Data.Monoid (mappend)
import Data.Ratio
import Data.Maybe
import qualified Data.Bifunctor as BI
import Data.List as DL
import Data.Char as DC
import Control.Arrow ((***), second)
------------------------------------------
-- Xmonad
import XMonad
import XMonad hiding ((|||))
import qualified XMonad.StackSet as W  
------------------------------------------
-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
------------------------------------------
-- Utilities
--import Xmonad.Util.Dzen
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig(removeKeys, additionalKeys)
import XMonad.Util.NamedScratchpad
------------------------------------------
--Layout
import XMonad.Layout (Mirror)
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.TwoPane
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Layout.Fullscreen (fullscreenSupport)
------------------------------------------
-- Actions
--import XMonad.Actions.Volume              -- couldn't get xmonad-extras installed
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import XMonad.Actions.FindEmptyWorkspace
------------------------------------------

------------------------------------------
--	FromXResources 
------------------------------------------

getFromXres :: String -> IO String
getFromXres key = fromMaybe "" . findValue key <$> runProcessWithInput "xrdb" ["-query"] ""
  where
    findValue :: String -> String -> Maybe String
    findValue xresKey xres =
      snd <$> (
                DL.find ((== xresKey) . fst)
                $ catMaybes
                $ splitAtColon
                <$> lines xres
              )

    splitAtColon :: String -> Maybe (String, String)
    splitAtColon str = splitAtTrimming str <$> (DL.elemIndex ':' str)

    splitAtTrimming :: String -> Int -> (String, String)
    splitAtTrimming str idx = BI.bimap trim trim . (BI.second tail) $ splitAt idx str

    trim :: String -> String
    trim = DL.dropWhileEnd (DC.isSpace) . DL.dropWhile (DC.isSpace)

fromXres :: String -> String
fromXres = unsafePerformIO . getFromXres



------------------------------------------
--  My Layouts
------------------------------------------
myBorderWidth = 1
myNormalBorderColor = fromXres "xmonad.normBord"--white
myFocusedBorderColor = fromXres "xmonad.focusBord"--spawn "xrdb -query | grep xmonad.focusBord | grep \"#.*\" -o" --red
myTerminal = "st"
myModMask = mod4Mask
myWorkspaces  = ["1:Main","2:Media","3:Game","4:Code","5:Work","6:Comm", "7", "8", "9"]
myLayouts = avoidStruts $
            myTall ||| myFlipTall ||| myTwoPane ||| myGrid ||| myFull 
    where
        myTall = spacing 6 $ ResizableTall nmaster delta ratio []
        myFlipTall = Flip myTall
        myGrid = spacing 6 $ Grid
        myTwoPane = spacing 4 $ TwoPane delta ratio
        myFull = spacing 0 $ noBorders $ Full
        nmaster = 1
        ratio = 1/2
        delta = 3/100

-- | Flip a layout, compute its 180 degree rotated form.
newtype Flip l a = Flip (l a) deriving (Show, Read)

instance LayoutClass l a => LayoutClass (Flip l) a where
    runLayout (W.Workspace i (Flip l) ms) r = (map (second flipRect) *** fmap Flip)
                                                `fmap` runLayout (W.Workspace i l ms) (flipRect r)
                                         where screenWidth = fromIntegral $ rect_width r
                                               flipRect (Rectangle rx ry rw rh) = Rectangle (screenWidth - rx - (fromIntegral rw)) ry rw rh
    handleMessage (Flip l) = fmap (fmap Flip) . handleMessage l
    description (Flip l) = "Flip "++ description l

------------------------------------------
--      Main Section
------------------------------------------
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/.xmobarrc"

    xmonad $ ewmh $ fullscreenSupport $ defaultConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> namedScratchpadManageHook myScratchPads <+> manageDocks <+> manageHook defaultConfig
        , layoutHook = myLayouts
        --, startupHook = do 
            --spawn "xrandr --output DVI-D-1-1 --primary --left-of DP-3 --auto" 
            --spawn "xrandr --output DP-3 --right-of DVI-D-1-1"
            --spawn "picom -CG --config ~/.config/picom/picom.conf &"
        , workspaces = myWorkspaces
	, terminal = myTerminal
        , logHook = dynamicLogWithPP xmobarPP  
             { ppOutput = hPutStrLn xmproc  
             , ppTitle = xmobarColor "#2CE3FF" "" . shorten 50  
              , ppLayout = const "" -- to disable the layout info on xmobar  
             }
        , modMask = myModMask     -- Rebind Mod to the Windows key
        , borderWidth = myBorderWidth
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
        } `additionalKeys` myNewKeys
        
        `removeKeys` removedKeys
