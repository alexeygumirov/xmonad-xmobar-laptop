--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import Data.List
import Data.Monoid
import qualified Data.Map as M

import Graphics.X11.ExtraTypes.XF86
-- import Graphics.X11.Xinerama
-- import Graphics.X11.Xlib
-- import Graphics.X11.Xlib.Extras (getWindowAttributes, WindowAttributes, Event)

import System.Exit
import System.Info
import System.IO

import XMonad hiding ((|||))

import XMonad
import XMonad.Actions.CycleSelectedLayouts
import XMonad.Actions.CycleWindows
--import XMonad.Actions.GridSelect
-- import XMonad.Actions.MouseResize
--import XMonad.Actions.OnScreen
import XMonad.Actions.SpawnOn
import XMonad.Actions.Submap
import XMonad.Actions.WindowBringer

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout.LayoutCombinators as LLC
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
-- import XMonad.Layout.StackTile
import XMonad.Layout.StateFull
import XMonad.Layout.TwoPanePersistent
-- import XMonad.Layout.WindowArranger

import XMonad.Prompt

import qualified XMonad.StackSet as W

import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- For polybar
-- import qualified DBus as D
-- import qualified DBus.Client as D
-- import qualified Codec.Binary.UTF8.String as UTF8

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

myFont :: String
myFont = "xft:Hack Nerd Font:Regular:size=16"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- WindowBringer
-- Configuration to pass to rofi

mygotoMenu = gotoMenuArgs' "rofi" a
        where
            a = ["-dmenu","-p","Go to window","-location","0","-lines","10","-theme","Paper"]

mybringMenu = bringMenuArgs' "rofi" a
        where
            a = ["-dmenu","-p","Bring window","-location","0","-lines","10","-theme","Paper"]

------------------------------------------------------------------------
-- GRID SELECT
------------------------------------------------------------------------
-- GridSelect displays items (programs, open windows, etc.) in a 2D grid
-- and lets the user select from it with the cursor/hjkl keys or the mouse.

-- gridSelect menu layout
-- mygridConfig  = defaultGSConfig
--    { gs_cellheight   = 40
--    , gs_cellwidth    = 300
--    , gs_cellpadding  = 6
--    , gs_originFractX = 0.5
--    , gs_originFractY = 0.5
--    , gs_font         = myFont
--    }

------------------------------------------------------------------------
-- scratchPads
scratchpads :: [NamedScratchpad]
scratchpads = [
-- run htop in xterm, find it by title, use default floating window placement
      NS "scratch-term" "alacritty -t scratch-term -e /home/alexgum/.scripts/tmux-scratchpad" (title =? "scratch-term")
        (customFloating $ W.RationalRect (0.02) (0.04) (0.96) (0.92))

    , NS "vimwiki" "alacritty -t vimwiki -e /usr/bin/nvim +'source ~/vimwiki/mysession.vim'" (title =? "vimwiki")
        (customFloating $ W.RationalRect (0.02) (0.04) (0.96) (0.92))

    , NS "pavucontrol" "pavucontrol" (className =? "Pavucontrol")
        (customFloating $ W.RationalRect (0.63) (0.05) (0.36) (0.50))

    , NS "doublecmdNS" "(doublecmd -L '/home/alexgum/' -R '/home/alexgum/' --no-splas >/dev/null 2>&1 &)" (className =? "Doublecmd")
        (customFloating $ W.RationalRect (0.05) (0.05) (0.9) (0.9))
  ]


------------------------------------------------------------------------
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]

-- xmobarEscape :: String -> String
-- xmobarEscape = concatMap doubleLts
--   where
--         doubleLts '<' = "<<"
--        doubleLts x   = [x]

-- myWorkspaces :: [String]
-- myWorkspaces = clickable . (map xmobarEscape)
--                $ ["1:Dev","2:Web","3:Talk","4:Mail","5:Sys","6:View","7:Misc","8:VM"]
--   where
--         clickable l = [ "<action=xdotool key super+" ++ show (n) ++ "> " ++ ws ++ " </action>" |
--                       (i,ws) <- zip [1..8] l,
--                       let n = i ]


myWorkspaces = ["1:\61728 ","2:爵 ","3:\62002 ","4:\64239 ","5:\63256 ","6:\63616 ","7:\58224 ","8:\59156 ","9:\62779 "]

-- Border colors for unfocused and focused windows, respectivelyscreen.
--
myNormalBorderColor  = "#808080"
-- myFocusedBorderColor = "#32cd32"
myFocusedBorderColor = "#FF8C00"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    -- launch customized dmenu
    , ((modm,               xK_p     ), spawn "/home/alexgum/.scripts/dlauncher")

    -- launch dmenu_run
    , ((modm .|. shiftMask, xK_p     ), spawn "/home/alexgum/.scripts/dmenu_script")

    -- launch xmenu
    -- , ((modm .|. mod1Mask,  xK_p     ), spawn "/home/alexgum/.scripts/myxmenu")

    -- launch lastpass dmenu (Super + Alt + L)
    , ((modm .|. mod1Mask,  xK_l     ), spawn "/home/alexgum/.scripts/lastpassmenu")

    -- launch  emoji selec with dmenu
    , ((modm,          xK_slash     ), spawn "/home/alexgum/.scripts/dmenuemoji i")

    -- launch  emoji selec with dmenu
    , ((modm .|. mod1Mask, xK_slash ), spawn "/home/alexgum/.scripts/dmenuemoji")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    --  Cycle through "monocle and tiled"
    , ((modm,               xK_a  ), cycleThroughLayouts ["monocle","tiled"] )

    --  Cycle through "two and mtiled"
    , ((modm .|. shiftMask, xK_a  ), cycleThroughLayouts ["two","mtiled","reflH"] )

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Toggle no borders
    , ((modm .|. shiftMask, xK_n     ), sendMessage $ MT.Toggle NOBORDERS)

    -- Toggle full screen for a window
    , ((modm,               xK_b     ), sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask,  xK_Return), windows W.swapMaster)
    
    -- Rotate unfocused Down
    -- , ((modm .|. controlMask, xK_u), rotUnfocusedDown)

    -- Rotate unfocused Up
    -- , ((modm .|. controlMask, xK_i), rotUnfocusedUp)

    -- Rotate focused Down
    , ((modm .|. controlMask, xK_j), rotFocusedDown)

    -- Rotate focused Up
    , ((modm .|. controlMask, xK_k), rotFocusedUp)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm .|. shiftMask, xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm .|. shiftMask, xK_l     ), sendMessage Expand)

    -- Shrink the mirror area
    , ((modm .|. controlMask, xK_h     ), sendMessage MirrorShrink)

    -- Expand the mirror
    , ((modm .|. controlMask, xK_l     ), sendMessage MirrorExpand)


    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts)

    -- Lock screen
    , ((modm              , xK_s     ),  spawn "/home/alexgum/.scripts/lockscript lock")

    -- Lock screen picture update
    -- , ((modm .|. shiftMask, xK_s     ),  spawn "/home/alexgum/.scripts/lockscreenpicture")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Select Display
    , ((0, xF86XK_Display), spawn "/home/alexgum/.scripts/displayselect-dmenu")

    -- xrandr default
    , ((modm              , xK_F1    ), spawn "/home/alexgum/.scripts/displayselect-twm 1")

    -- xrandr primary-dual - Laptop main
    , ((modm              , xK_F2    ), spawn "/home/alexgum/.scripts/displayselect-twm 2")

    -- xrandr home-docked-monitor 
    , ((modm              , xK_F3    ), spawn "/home/alexgum/.scripts/displayselect-twm 3")

    -- xrandr primary-dual - Monitor main
    , ((modm              , xK_F4    ), spawn "/home/alexgum/.scripts/displayselect-twm 4")

    -- xrandr primary-dual - mirror Laptop screen
    , ((modm              , xK_F5    ), spawn "/home/alexgum/.scripts/displayselect-twm 5")

    -- display select dmenu
    , ((modm              , xK_F6    ), spawn "/home/alexgum/.scripts/displayselect-dmenu")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | gxmessage -timeout 10 -font 'Hack Nerd Font Mono 12' -name 'myKeyBindings' -default okay -wrap -file -"))

    -- Mute volume
    , ((0, xF86XK_AudioMute), spawn "/home/alexgum/.scripts/laptopvolume -mutetoggle")

    -- Mute volume
    , ((modm .|. controlMask , xK_F1), spawn "/home/alexgum/.scripts/laptopvolume -mutetoggle")

    -- Decrease volume
    , ((0, xF86XK_AudioLowerVolume), spawn "/home/alexgum/.scripts/laptopvolume -down")

    -- Decrease volume
    , ((modm .|. controlMask , xK_F2), spawn "/home/alexgum/.scripts/laptopvolume -down")

    -- Increase volume
    , ((0, xF86XK_AudioRaiseVolume), spawn "/home/alexgum/.scripts/laptopvolume -up")

    -- Increase volume
    , ((modm .|. controlMask , xK_F3), spawn "/home/alexgum/.scripts/laptopvolume -up")

    -- Enable/disable microphone
    , ((0, xF86XK_AudioMicMute), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")

    -- Enable/disable microphone
    , ((modm .|. controlMask , xK_F4), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
  
    -- Decrease brightness
    , ((0, xF86XK_MonBrightnessDown), spawn "/home/alexgum/.scripts/monbrightness -down")

    -- Decrease brightness
    , ((modm .|. controlMask , xK_F5), spawn "/home/alexgum/.scripts/monbrightness -down")

    -- Increase brightness
    , ((0, xF86XK_MonBrightnessUp), spawn "/home/alexgum/.scripts/monbrightness -up")

    -- Increase brightness
    , ((modm .|. controlMask , xK_F6), spawn "/home/alexgum/.scripts/monbrightness -up")

    -- Grid Select
    -- , ((modm, xK_g), goToSelected mygridConfig)

    -- Window Bringer - go to Window
    , ((modm, xK_o), mygotoMenu)

    -- Window Bringer - bring me Window
    , ((modm, xK_i), mybringMenu)

    -- Scratchpads
    , ((modm, xK_v), namedScratchpadAction scratchpads "vimwiki")
    , ((modm, xK_x), namedScratchpadAction scratchpads "scratch-term")
    , ((modm .|. shiftMask, xK_v), namedScratchpadAction scratchpads "pavucontrol")
    , ((modm, xK_f), namedScratchpadAction scratchpads "doublecmdNS")

    -- Magnifier
    , ((modm .|. controlMask, xK_equal), sendMessage MagnifyMore)
    , ((modm .|. controlMask, xK_minus), sendMessage MagnifyLess)
    , ((modm .|. controlMask, xK_m), sendMessage Toggle)

    -- Screenshots
    , ((modm, xK_Print), submap . M.fromList $
       [ ((0, xK_f),     spawn "xfce4-screenshooter -f -c -s ~/Documents/screenshot_$(date +\"%Y-%m-%d_%H%M%S\").png")
       , ((0, xK_r),     spawn "xfce4-screenshooter -r -m -c -s ~/Documents/screenshot_$(date +\"%Y-%m-%d_%H%M%S\").png")
       ])
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- monocle    = renamed [Replace "monocle"]
--            $ noBorders Full

monocle    = renamed [Replace "monocle"]
           $ noBorders StateFull

tiled     = renamed [Replace "tiled"]
           $ limitWindows 8
           $ mySpacing 4
           $ magnifierOff
           $ ResizableTall 1 (2/100) (1/2) []

mtiled     = renamed [Replace "mtiled"]
           $ Mirror tiled

reflH     = renamed [Replace "reflH"]
           $ limitWindows 8
           $ mySpacing 4
           $ magnifierOff
           $ reflectHoriz
           $ ResizableTall 1 (2/100) (1/2) []

two    = renamed [Replace "two"]
           $ limitWindows 8
           $ mySpacing 4
           $ magnifierOff
           $ TwoPanePersistent Nothing (2/100) (1/2)

myLayout = avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
           where
                myDefaultLayout = monocle
                                  LLC.||| tiled
                                  LLC.||| two
                                  LLC.||| mtiled
                                  LLC.||| reflH

--      -- default tiling algorithm partitions the screen into two panes
--      tiled   = spacing 2 $ Tall nmaster delta ratio
-- 
--      -- The default number of windows in the master pane
--      nmaster = 1
-- 
--      -- Default proportion of screen occupied by master pane
--      ratio   = 1/2
-- 
--      -- Percent of screen to increment by when resizing panes
--      delta   = 3/100


------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS (use last value of WM_CLASS).
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ 
      className =? "Evolution"      --> doShift ( myWorkspaces !! 3)
    , className =? "Evolution-alarm-notify" --> doFloat
    , className =? "Evolution-alarm-notify" --> doShift ( myWorkspaces !! 3)
    , className =? "Evolution-alarm-notify" --> doF W.focusDown
    , className =? "Evolution-alarm-notify"   --> doShift ( myWorkspaces !! 3)
    , className =? "Thunderbird"    --> doShift ( myWorkspaces !! 3)
    , className =? "Slack"          --> doShift ( myWorkspaces !! 2)
    , className =? "Skype"          --> doShift ( myWorkspaces !! 2)
    , className =? "draw.io"        --> doShift ( myWorkspaces !! 4)
    --, className =? "firefox"        --> doShift ( myWorkspaces !! 1)
    --, className =? "Gscan2pdf"      --> doShift ( myWorkspaces !! 6)
    --, className =? "Simple-scan"    --> doShift ( myWorkspaces !! 6)
    , className =? "Virt-manager"   --> doShift ( myWorkspaces !! 7)
    , className =? "Deadbeef"       --> doCenterFloat
    , className =? "Arandr"       --> doRectFloat (W.RationalRect 0.25 0.25 0.5 0.5)
    , className =? "Gimp"           --> doFloat
    --, className =? "Slack"          --> doFloat
    , title     =? "Volume Control" --> doCenterFloat
    , title     =? "Administrator privileges required" --> doCenterFloat
    , title     =? "MyDrivesMessage" --> doRectFloat (W.RationalRect 0.72 0.03 0.28 0.4)
    , title     =? "myKeyBindings" --> doRectFloat (W.RationalRect 0.60 0.03 0.40 0.9)
    , title     =? "Network Connections" --> doCenterFloat
    , title     =? "vimwiki" --> doCenterFloat
    , title     =? "scratch-term"   --> doCenterFloat
    , title     =? "Xfce Power Manager"   --> doCenterFloat
    , className   =? "Doublecmd" --> doCenterFloat
    , className   =? "SpeedCrunch" --> doRectFloat (W.RationalRect 0.72 0.03 0.28 0.4)
    , className   =? "Blueman-services" --> doCenterFloat
    , className   =? "Blueman-manager" --> doRectFloat (W.RationalRect 0.25 0.25 0.5 0.5)
    , className   =? "Blueman-assistant" --> doRectFloat (W.RationalRect 0.25 0.25 0.5 0.5)
    , className   =? "Blueman-sendto" --> doRectFloat (W.RationalRect 0.2 0.1 0.6 0.8)
    , className   =? "Blueman-adapters" --> doCenterFloat
    , className   =? "Xfce4-clipman-settings" --> doCenterFloat
    , className   =? "Xfce4-clipman-history" --> doCenterFloat
    , className =? "mpv"            --> doShift ( myWorkspaces !! 5)
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , className =? "Xfce4-notifyd" --> doIgnore
    -- , isFullscreen --> doFullFloat
    ]
        where
            office = ["libreoffice","libreoffice-writer","libreoffice-calc"]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty
-- myEventHook = fullscreenEventHook <+> docksEventHook
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()

myLogHook h = dynamicLogWithPP . namedScratchpadFilterOutWorkspacePP $ xmobarPP
    { ppOutput = hPutStrLn h
    -- , ppTitle = xmobarColor "green" "" . shorten 30
    , ppOrder = \(workspace:layout:title:extras)
        -> [workspace,"<action=`xdotool key super+space`>",layout,"</action>","<action=`xdotool key super+j`>","<fc=#FF00FF><"]++extras++["></fc>","</action>"]
    , ppSep = " "
    , ppExtras = [windowCount]
    , ppCurrent = xmobarColor "green" "" . wrap "|" "|"
    , ppHidden = xmobarColor "yellow" ""
    , ppHiddenNoWindows = xmobarColor "grey" ""
    -- , ppLayout = xmobarColor "cyan" "" . wrap "<" ">" . shorten 10
    , ppLayout = xmobarColor "cyan" "" . 
        (\x -> case x of
        "tiled" -> "●<fn=1>\xf7a5</fn>"
        "mtiled" -> "<fn=1>\xf7a4</fn>"
        "reflH" -> "<fn=1>\xf7a5</fn>●"
        "two" -> "●<fn=1>\xf7a5</fn>○"
        "monocle" -> "<fn=1>\xf065</fn>"
        _ -> x
        )
    }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawn "killall -r picom; sleep 1; picom --experimental-backends &"
    setWMName "LG3D"

------------------------------------------------------------------------
main = do
    nScreens <- countScreens
    if nScreens == 1
        then do 
            xmproc0 <- spawnPipe "xmobar -x 0 /home/alexgum/.config/xmobar/xmobarrc"
            xmonad $ docks $ ewmh defaults {
                    manageHook = namedScratchpadManageHook scratchpads <+> manageHook defaults
                    , layoutHook = layoutHook defaults
                    , logHook = myLogHook xmproc0
                    }
        else do
            xmproc0 <- spawnPipe "xmobar -x 0 /home/alexgum/.config/xmobar/xmobarrc"
            xmproc1 <- spawnPipe "xmobar -x 1 /home/alexgum/.config/xmobar/xmobarrc1"
            xmonad $ docks $ ewmh defaults {
                    manageHook = namedScratchpadManageHook scratchpads <+> manageHook defaults
                    , layoutHook = layoutHook defaults
                    , logHook = myLogHook xmproc0 >> myLogHook xmproc1
                    }

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        -- logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The modifier key is 'Win'. Keybindings:",
    "",
    "mod-Enter        Launch terminal",
    "mod-p            Launch my programs",
    "mod-Shift-p      Launch dmenu run",
    "mod-Shift-c      Close/kill the focused window",
    "mod-a            Cycle through 'Monocle' and 'Tall'",
    "mod-Shift-a      Cycle through 'Two Pane', 'Mirror Tiled','Refl. Tall'",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "mod-Shift-n      Toggle No-borders for current workspace",
    "mod-b            Toggle full screen no borders for focused window",
    "mod-Shift-b      Toggle struts (hide/show status bar)",
    "",
    "mod-Alt-l      Lastpass menu",
    "mod-/          Emojis menu - auto insert",
    "mod-Alt-/      Emojis menu - Copy to buffer",
    "",
    "-- Screenshots",
    "mod-Print,f     Fullscreen shot",
    "mod-Print,r     Region shot",
    "",
    "-- Scratchpads",
    "mod-x          Terminal",
    "mod-v          Vimwiki",
    "mod-f          Double Commander",
    "mod-Shift-v    Volume control",
    "",
    "-- Display & media",
    "mod-F1           Laptop display (master)",
    "mod-F2           Laptop display (master) + HDMI (slave)",
    "mod-F3           HDMI (master)",
    "mod-F4           HDMI (master) + Laptop display (slave)",
    "mod-F5           Mirror: Laptop display -> HDMI",
    "mod-F6           Select display mode manually",
    "mod-Control-F1   Toggle output master mute",
    "mod-Control-F2   Master volume down",
    "mod-Control-F3   Master volume up",
    "mod-Control-F4   Toggle microfon mute",
    "mod-Control-F5   Laptop screen brightness down",
    "mod-Control-F6   Laptop screen brightness up",
    "",
    "mod-Tab           Move focus to the next window",
    "mod-j             Move focus to the next window",
    "mod-k             Move focus to the previous window",
    "mod-m             Move focus to the master window",
    "mod-i             Bring window menu",
    "mod-o             Go to window menu",
    "",
    "-- modifying the window order",
    "mod-Shift-Enter   Swap the focused window and the master window",
    "mod-Shift-j       Swap the focused window with the next window",
    "mod-Shift-k       Swap the focused window with the previous window",
    "",
    "-- Two Pane modifiers",
    "mod-Control-j     Rotate focused down (for two pane)",
    "mod-Control-k     Rotate focused up (for two pane)",
    "",
    "-- resizing",
    "mod-Shift-h       Shrink the master area",
    "mod-Shift-l       Expand the master area",
    "mod-Control-h     Shrink focused vertically",
    "mod-Control-l     Expand focused vertically",
    "",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "mod-,     Increment the number of windows in the master area",
    "mod-.     Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit (logout)",
    "mod-q        Restart Xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "mod-s        Lock screen",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging",
    "",
    "mod-Shift-/  Hotkeys list"]
