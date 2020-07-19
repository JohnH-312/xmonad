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
        , ((controlMask,                xK_Print),      spawn "sleep 0.2; scrot -s")
        , ((0,                          xK_Print),      spawn "scrot")
        , ((mod4Mask,                   xK_p),          spawn "rofi -show drun")
        , ((mod4Mask .|. shiftMask,     0xff67),        spawn "code -n ~/.xmonad")
        , ((mod4Mask .|. controlMask,   0xff67),        spawn "code -n ~/.xmobarrc")
        --, ((mod4Mask,                   xK_a ),         windows W.swapUp) -- swap up window  
        --, ((mod4Mask,                   MxK_z ),         windows W.swapDown) -- swap down window 
        , ((controlMask,                xK_Print),      spawn "sleep 0.2; scrot -s") -- capture screenshot of focused window 
        , ((mod4Mask,                   xK_Escape),     spawn "xscreensaver-command -l")
        , ((0,                          0x1008ff18),    spawn "chromium")
        , ((0,                          0x1008ff19),    spawn "thunderbird")
        , ((0,                          0x1008ff5d),    spawn "nautilus -w")
        , ((0,                          0x1008ff1b),    spawn "rofi -show drun")
        , ((mod4Mask,                   xK_d),          kill)
        , ((mod4Mask,                   xK_Down),       moveTo Next NonEmptyWS)
        , ((mod4Mask,                   xK_Up),         moveTo Prev NonEmptyWS)
        , ((mod4Mask .|. shiftMask,     xK_Down),       shiftToNext >> nextWS)
        , ((mod4Mask .|. shiftMask,     xK_Up),         shiftToPrev >> prevWS)
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
        
        ]
    
    removedKeys :: [(KeyMask, KeySym)]
    removedKeys = [
            (mod4Mask .|. shiftMask,    xK_c)
        ]