
module Custom.MyScratchpads where
    import XMonad
    import XMonad.Util.NamedScratchpad
    import qualified XMonad.StackSet as W


    ------------------------------------------------------------------------
    -- SCRATCHPADS
    ------------------------------------------------------------------------
    -- Allows to have several floating scratchpads running different applications.
    -- Import Util.NamedScratchpad.  Bind a key to namedScratchpadSpawnAction.
    myScratchPads :: [NamedScratchpad]
    myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                    ]
      where
        spawnTerm  = "st" ++ " -n scratchpad"
        findTerm   = resource =? "scratchpad"
        manageTerm = customFloating $ W.RationalRect l t w h
                   where
                     h = 0.9
                     w = 0.9
                     t = 0.95 -h
                     l = 0.95 -w
