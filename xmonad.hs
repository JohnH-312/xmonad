------------------------------------------
--      Imports
------------------------------------------
-- Custom 
import Custom.MyHotkeys
import Custom.MyScratchpads
------------------------------------------
-- General
import System.IO
import Graphics.X11.ExtraTypes
import Data.Map    (fromList)
import Data.Monoid (mappend)
import Data.Ratio
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
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(removeKeys, additionalKeys)
import XMonad.Util.NamedScratchpad
------------------------------------------
--Layout
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.TwoPane
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
------------------------------------------
-- Actions
--import XMonad.Actions.Volume              -- couldn't get xmonad-extras installed
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import XMonad.Actions.FindEmptyWorkspace
------------------------------------------


------------------------------------------
--  My Layouts
------------------------------------------
myBorderWidth = 1
myModMask = mod4Mask
myWorkspaces  = ["1:Main","2:Media","3:Game","4:Code","5:Work","6", "7", "8", "9"]
myLayouts = avoidStruts $
            myTall ||| Mirror myTall ||| myTwoPane ||| Mirror myTwoPane ||| myGrid ||| myFull 
    where
        myTall = spacing 6 $ ResizableTall nmaster delta ratio []
        --mySpiral = spacing 4 $ spiral
        myGrid = spacing 6 $ Grid
        myTwoPane = spacing 4 $ TwoPane delta ratio
        myFull = spacing 0 $ Full
        nmaster = 1
        ratio = 1/2
        delta = 3/100


------------------------------------------
--      Main
------------------------------------------
main = do
    xmproc <- spawnPipe "xmobar"


    xmonad $ ewmh $ defaultConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> namedScratchpadManageHook myScratchPads <+> manageDocks <+> manageHook defaultConfig
        , layoutHook = myLayouts
        , startupHook = do 
            spawn "xrandr --output DVI-1-0 --primary --left-of DP-2 --auto" 
            spawn "xrandr --output DP-2 --right-of DVI-1-0 --rotate right"
            spawn "compton -CG --active-opacity 1.0 --shadow-ignore-shaped &"
        , workspaces = myWorkspaces
        , logHook = dynamicLogWithPP xmobarPP  
             { ppOutput = hPutStrLn xmproc  
             , ppTitle = xmobarColor "#2CE3FF" "" . shorten 50  
              , ppLayout = const "" -- to disable the layout info on xmobar  
             }
        , modMask = myModMask     -- Rebind Mod to the Windows key
        , borderWidth = myBorderWidth
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
        } `additionalKeys` myNewKeys
        
        `removeKeys` removedKeys
