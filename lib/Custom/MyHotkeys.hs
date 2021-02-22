module Custom.MyHotkeys where
    import Custom.MyScratchpads
    import XMonad
    import XMonad.Util.EZConfig
    import XMonad.Actions.CycleWS
    import XMonad.Actions.FindEmptyWorkspace
    import XMonad.Layout.Spacing
    import XMonad.Util.NamedScratchpad
    



    myNewKeys :: [((KeyMask, KeySym), X ())]
    myNewKeys = [
         ((mod4Mask .|. shiftMask,      xK_z),          spawn "xscreensaver-command -lock; xset dpms force off")
        , ((0,                          xK_Print),      spawn "cd scrots; scrot; cd ..")
        , ((mod4Mask,                   xK_p),          spawn "rofi -show drun -show-icons")
        , ((mod4Mask .|. shiftMask,     0xff67),        spawn "st -e nvim ~/.xmonad/xmonad.hs")
        , ((mod4Mask .|. controlMask,   0xff67),        spawn "st -e nvim ~/.xmonad/.xmobarrc")
        , ((mod4Mask .|. shiftMask,     xK_slash),      spawn "st -e nvim -R ~/.xmonad/hotkeys.txt")
        --, ((mod4Mask,                   xK_a ),         windows W.swapUp) -- swap up window  
        --, ((mod4Mask,                   MxK_z ),         windows W.swapDown) -- swap down window 
        , ((controlMask,                xK_Print),      spawn "cd scrots; sleep 0.2; scrot -s; cd ..") -- capture screenshot of focused window 
        , ((0,                          0x1008ff18),    spawn "brave")
        , ((0,                          0x1008ff19),    spawn "thunderbird")
        , ((0,                          0x1008ff5d),    spawn "nautilus -w")
        , ((0,                          0x1008ff1b),    spawn "rofi -show drun")
        , ((mod4Mask,                   xK_d),          kill)
        , ((mod4Mask,                   xK_Up),       moveTo Next NonEmptyWS)
        , ((mod4Mask,                   xK_Down),         moveTo Prev NonEmptyWS)
        , ((mod4Mask .|. shiftMask,     xK_Up),       shiftToNext >> nextWS)
        , ((mod4Mask .|. shiftMask,     xK_Down),         shiftToPrev >> prevWS)
        , ((mod4Mask,                   xK_Right),      nextScreen)
        , ((mod4Mask,                   xK_Left),       prevScreen)
        , ((mod4Mask .|. shiftMask,     xK_Right),      shiftNextScreen)
        , ((mod4Mask .|. shiftMask,     xK_Left),       shiftPrevScreen)
        , ((mod4Mask,                   xK_z),          toggleWS)
        , ((0,                          0x1008ff13),    spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
        , ((0,                          0x1008ff11),    spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
        , ((0,                          0x1008ff12),    spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ((0,                          0x1008ff14),    spawn "playerctl play-pause")
        , ((mod4Mask .|. shiftMask,     0x5d),          incScreenWindowSpacing 2 )
        , ((mod4Mask .|. shiftMask,     0x5b),          decScreenWindowSpacing 2 )
        , ((mod4Mask .|. controlMask,   xK_Right),      shiftNextScreen >> nextScreen >> tagToEmptyWorkspace)
        , ((mod4Mask .|. controlMask,   xK_Return),     namedScratchpadAction myScratchPads "terminal")
        , ((mod4Mask .|. controlMask,   xK_apostrophe),     namedScratchpadAction myScratchPads "note")
        , ((mod4Mask,                   xK_b),          spawn "brave")
        , ((mod4Mask .|. shiftMask,                   xK_t),          spawn "xtheme-picker.sh")
        ]
    
    removedKeys :: [(KeyMask, KeySym)]
    removedKeys = [
            (mod4Mask .|. shiftMask,    xK_c)
            --,(mod4Mask .|. shiftMask,    xK_slash)
        ]
