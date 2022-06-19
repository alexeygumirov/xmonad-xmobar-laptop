--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- import Data.Default
import Data.List
import Data.Maybe (fromJust, maybeToList)
import Data.Monoid
import qualified Data.Map as M

import Graphics.X11.ExtraTypes.XF86

import System.Exit
import System.Info
import System.IO

import XMonad hiding ((|||))

import XMonad
import XMonad.Actions.CycleSelectedLayouts
import XMonad.Actions.CycleWindows
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.SpawnOn
import XMonad.Actions.Submap
import XMonad.Actions.WindowBringer

import XMonad.Hooks.CurrentWorkspaceOnTop
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
import XMonad.Layout.StateFull
import XMonad.Layout.TwoPanePersistent

import XMonad.Prompt

import qualified XMonad.StackSet as W

import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

-- For polybar
-- import qualified DBus as D
-- import qualified DBus.Client as D
-- import qualified Codec.Binary.UTF8.String as UTF8

-- Based on the Paper Color scheme for VIM
-- https://github.com/NLKNguyen/papercolor-theme
myBlack = "#1c1c1c"
myViolet = "#af005f"
myGolden = "#d7af5f"
myGrey = "#808080"
myBrown = "#d7875f"
--mySteelGrey = "#d0d0d0"
mySteelGrey = "#d9d9d9"
mySteelGreyDarker = "#b3b3b3"
myDarkGrey = "#585858"
myDarkGreen = "#5faf5f"
myLightGreen = "#afd700"
myLightViolet = "#af87d7"
myOragne = "#ffaf00"
myPink = "#ff5faf"
mySeaGreen = "#00afaf"
myTeal = "#5f8787"
myTealLighter = "#39acac"
myBlue = "#3DB6FF"
myGreen = "#45BF55"
myPurple = "#AB47BC"
-- myYellow = "#FFBE00"
myYellow = "#E6AC00"
myVioletDark = "#732E7F"
xmobarForeground = "#D9D9D9"
-- xmobarBackground = "#1D3030"
xmobarBackground = "#31353D"
xmobarForegroundShade = "#CDCDCD"


-- My Palette 1
palette1Black = "#1A1423"
palette1WarmGrey = "#C9C5BA"
palette1Garnet = "#DB3069"
palette1PineTreeGreen = "#04724D"
palette1LapisLazuli = "#1D84B5"
palette1CadmiumOrange = "#F86624"
palette1SlimyGreen = "#379634"

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
myFont = "xft:Hack Nerd Font:style=Regular:size=11:antialias=true:hinting=light,Font Awesome 5 Free:style=Solid:size=11:antialias=true:hinting=light"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- WindowBringer
-- Configuration to pass to rofi

mygotoMenu = gotoMenuArgs' "rofi" a
        where
            a = ["-dmenu","-i","-p","Go to window","-location","0","-lines","10","-theme","Paper"]

mybringMenu = bringMenuArgs' "rofi" a
        where
            a = ["-dmenu","-i","-p","Bring window","-location","0","-lines","10","-theme","Paper"]

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
      NS "scratch-term" (myTerminal ++ " -t scratch-term") (title =? "scratch-term")
        (customFloating $ W.RationalRect (0.04) (0.04) (0.92) (0.92))

    , NS "vimwiki" (myTerminal ++ " -t vimwiki -e /usr/bin/nvim +'source ~/vimwiki/mysession.vim'") (title =? "vimwiki")
        (customFloating $ W.RationalRect (0.1) (0.05) (0.8) (0.9))

    ,  NS "newsboat" (myTerminal ++ " -t newsboat -e newsboat") (title =? "newsboat")
        (customFloating $ W.RationalRect (0.1) (0.1) (0.8) (0.8))

    , NS "pavucontrol" "pavucontrol" (className =? "Pavucontrol")
        (customFloating $ W.RationalRect (0.63) (0.05) (0.36) (0.50))

    , NS "doublecmdNS" "(doublecmd -L $HOME -R $HOME --no-splas >/dev/null 2>&1 &)" (className =? "Doublecmd") nonFloating
        -- (customFloating $ W.RationalRect (0.05) (0.05) (0.9) (0.9))

    , NS "goldendict" "($HOME/.scripts/qt-launch 'goldendict' &)" (className =? "GoldenDict")
        (customFloating $ W.RationalRect (0.60) (0.03) (0.40) (0.96))

    , NS "veracrypt" "(veracrypt  > /dev/null 2>&1 &)" (className =? "VeraCrypt")
        (customFloating $ W.RationalRect (0.3) (0.3) (0.7) (0.7))

    , NS "Mail" "(mailspring  > /dev/null 2>&1 &)" (className =? "Mailspring") nonFloating
  ]


------------------------------------------------------------------------
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.

myWorkspaces :: [String]
myWorkspaces = ["\59333 ","\62057 ","\62002 ","\64239 ","\63256 ","\63616 ","\58224 ","\59156 ","\61818 "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool set_desktop "++show (i-1)++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Border colors for unfocused and focused windows, respectivelyscreen.

myNormalBorderColor  = myGrey
-- myFocusedBorderColor = "#32cd32"
myFocusedBorderColor = myOragne

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    -- launch customized dmenu
    , ((modm,               xK_p     ), spawn "$HOME/.scripts/dlauncher")

    -- launch dmenu_run
    , ((modm .|. shiftMask, xK_p     ), spawn "$HOME/.scripts/dmenu_script")

    -- launch lastpass dmenu (Super + Alt + L)
    , ((modm .|. mod1Mask,  xK_l     ), unGrab >> spawn "$HOME/.scripts/lastpassmenu")

    -- launch  emoji select with dmenu
    , ((modm,          xK_slash     ), spawn "$HOME/.scripts/dmenuemoji -insert")

    -- launch  emoji select with dmenu
    , ((modm .|. mod1Mask, xK_slash ), spawn "$HOME/.scripts/dmenuemoji -copy")

    -- close focused window
    , ((modm .|. shiftMask, xK_BackSpace     ), kill)

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
    -- , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm,               xK_t     ), withFocused toggleFloat)

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
    , ((modm        , xK_grave       ),  spawn "$HOME/.scripts/lockscript lock")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm           , xK_q        ), spawn "xmonad --recompile; xmonad --restart")

    -- Select Display
    , ((0, xF86XK_Display), spawn "$HOME/.scripts/displayselect-dmenu")


    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | gxmessage -font 'Hack Nerd Font Mono 12' -name 'myKeyBindings' -default okay -wrap -file -"))

    -- Mute volume
    , ((0, xF86XK_AudioMute), spawn "$HOME/.scripts/laptopvolume -mutetoggle")

    -- Mute volume
    , ((modm .|. controlMask , xK_F1), spawn "$HOME/.scripts/laptopvolume -mutetoggle")
    -- Toggle output sink
    , ((modm .|. mod1Mask , xK_F1), spawn "$HOME/.scripts/python/output-device-switch.py -toggle")

    -- Decrease volume
    , ((0, xF86XK_AudioLowerVolume), spawn "$HOME/.scripts/laptopvolume -down")

    -- Decrease volume
    , ((modm .|. controlMask , xK_F2), spawn "$HOME/.scripts/laptopvolume -down")

    -- Increase volume
    , ((0, xF86XK_AudioRaiseVolume), spawn "$HOME/.scripts/laptopvolume -up")

    -- Increase volume
    , ((modm .|. controlMask , xK_F3), spawn "$HOME/.scripts/laptopvolume -up")

    -- Enable/disable microphone
    -- , ((0, xF86XK_AudioMicMute), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    , ((0, xF86XK_AudioMicMute), spawn "amixer set Capture toggle")

    -- Enable/disable microphone
    -- , ((modm .|. controlMask , xK_F4), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    , ((modm .|. controlMask , xK_F4), spawn "amixer set Capture toggle")

    -- Toggle input source
    , ((modm .|. mod1Mask , xK_F4), spawn "$HOME/.scripts/python/input-device-switch.py -toggle")
  
    -- Decrease brightness
    , ((0, xF86XK_MonBrightnessDown), spawn "$HOME/.scripts/monbrightness -down")

    -- Decrease brightness
    , ((modm .|. controlMask , xK_F5), spawn "$HOME/.scripts/monbrightness -down")

    -- Increase brightness
    , ((0, xF86XK_MonBrightnessUp), spawn "$HOME/.scripts/monbrightness -up")

    -- Increase brightness
    , ((modm .|. controlMask , xK_F6), spawn "$HOME/.scripts/monbrightness -up")

    -- Toggle layouts us,ru <-> de,ru
    , ((modm , xK_F12), spawn "$HOME/.scripts/keyboard-toggle")

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
    , ((modm, xK_d), namedScratchpadAction scratchpads "goldendict")
    , ((modm, xK_u), submap . M.fromList $
       [ ((0, xK_b),  unGrab >> spawn "$HOME/.scripts/bt-manager")
       , ((0, xK_c),  spawn "/usr/bin/speedcrunch")
       , ((0, xK_m),  namedScratchpadAction scratchpads "Mail")
       , ((0, xK_n),  namedScratchpadAction scratchpads "newsboat")
       , ((0, xK_r), spawn "$HOME/.scripts/rofi-music")
       , ((0, xK_v),  namedScratchpadAction scratchpads "veracrypt")
       , ((0, xK_y), unGrab >> spawn "$HOME/.scripts/ydl")
       ])

    -- xrandr select mode
    , ((modm, xK_F1), submap . M.fromList $
        [ ((0, xK_1), spawn "$HOME/.scripts/displayselect-dmenu 1")
        , ((0, xK_2), spawn "$HOME/.scripts/displayselect-dmenu 2")
        , ((0, xK_3), spawn "$HOME/.scripts/displayselect-dmenu 3")
        , ((0, xK_4), spawn "$HOME/.scripts/displayselect-dmenu 4")
        , ((0, xK_5), spawn "$HOME/.scripts/displayselect-dmenu 5")
        , ((0, xK_6), spawn "$HOME/.scripts/displayselect-dmenu 6")
        , ((0, xK_7), spawn "$HOME/.scripts/displayselect-dmenu 7")
        ])
    -- display select dmenu
    , ((modm, xK_F2), spawn "$HOME/.scripts/displayselect-dmenu")

    -- Magnifier
    , ((modm .|. controlMask, xK_equal), sendMessage MagnifyMore)
    , ((modm .|. controlMask, xK_minus), sendMessage MagnifyLess)
    , ((modm .|. controlMask, xK_m), sendMessage Toggle)

    -- Screenshots
    , ((modm, xK_Print), submap . M.fromList $
       [ ((0, xK_f),     spawn "$HOME/.scripts/myscreenshot -f")
       , ((0, xK_p),     spawn "$HOME/.scripts/myscreenshot -p")
       , ((0, xK_s),     spawn "$HOME/.scripts/myscreenshot -s")
       , ((0, xK_r),     spawn "$HOME/.scripts/myscreenshot -r")
       , ((0, xK_w),     spawn "$HOME/.scripts/myscreenshot -w")
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
    -- Original mapping
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    [((modm .|. mask, key), f sc)
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, mask) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]]

    where
            toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else (W.float w (W.RationalRect (0.1) (0.1) (0.8) (0.8)) s))



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
           $ noBorders Full

tiled     = renamed [Replace "tiled"]
           $ mySpacing 4
           $ smartBorders
           $ limitWindows 8
           $ magnifierOff
           $ ResizableTall 1 (2/100) (1/2) []

mtiled     = renamed [Replace "mtiled"]
           $ Mirror tiled

reflH     = renamed [Replace "reflH"]
           $ mySpacing 4
           $ smartBorders
           $ limitWindows 8
           $ magnifierOff
           $ reflectHoriz
           $ ResizableTall 1 (2/100) (1/2) []

two    = renamed [Replace "two"]
           $ mySpacing 4
           $ smartBorders
           $ limitWindows 8
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
myManageHook = composeAll $
    [ isDialog                         --> doRectFloat (W.RationalRect 0.15 0.15 0.70 0.70)        ]
    ++
    [ className =? mC                  --> doShift (myWorkspaces !! 2) | mC <- myMessangersClass   ]
    ++
    [ className =? oC                  --> doShift (myWorkspaces !! 4) | oC <- myOfficeClass       ]
    ++
    [ className =? fC                  --> doFloat                     | fC <- myFloatClass        ]
    ++
    [ className =? cfC                 --> doCenterFloat               | cfC <- myCenterFloatClass ]
    ++
    [ title     =? cfT                 --> doCenterFloat               | cfT <- myCenterFloatTitle ]
    ++
    [ className =? "Virt-manager"      --> doShift     (myWorkspaces !! 8)
    , className =? "mpv"               --> doShift     (myWorkspaces !! 5)
    , className =? "Deadbeef"          --> doRectFloat (W.RationalRect 0.00 0.03 0.50 0.50)
    , className =? "Arandr"            --> doRectFloat (W.RationalRect 0.25 0.25 0.50 0.50)
    , className =? "GoldenDict"        --> doRectFloat (W.RationalRect 0.60 0.03 0.40 0.96)
    , className =? "Gsimplecal"        --> doRectFloat (W.RationalRect 0.77 0.03 0.20 0.25)
    , title     =? "MyDrivesMessage"   --> doRectFloat (W.RationalRect 0.72 0.03 0.28 0.40)
    , title     =? "myKeyBindings"     --> doRectFloat (W.RationalRect 0.60 0.03 0.40 0.90)
    , className =? "SpeedCrunch"       --> doRectFloat (W.RationalRect 0.72 0.03 0.28 0.40)
    , className =? "Blueman-manager"   --> doRectFloat (W.RationalRect 0.25 0.25 0.50 0.50)
    , className =? "Blueman-assistant" --> doRectFloat (W.RationalRect 0.25 0.25 0.50 0.50)
    , className =? "Blueman-sendto"    --> doRectFloat (W.RationalRect 0.20 0.10 0.60 0.80)
    , resource  =? "desktop_window"    --> doIgnore
    , resource  =? "kdesktop"          --> doIgnore 
    ]
    where
        myMessangersClass  = [ "Skype"
                             , "Slack"
                             , "Signal"
                             , "telegram-desktop"
                             ]
        myOfficeClass      = [ "draw.io"
                             , "libreoffice"
                             , "libreoffice-calc"
                             , "libreoffice-draw"
                             , "libreoffice-impress"
                             , "libreoffice-math"
                             , "libreoffice-writer"
                             , "DesktopEditors"
                             , "Gimp"
                             , "XMind"
                             , "Simple-scan"
                             ]
        myFloatClass       = [ "Xfce4-notifyd" ]
        myCenterFloatClass = [ "Blueman-services"
                             , "Blueman-adapters"
                             , "Xfce4-clipman-settings"
                             , "Xfce4-clipman-history"
                             ]
        myCenterFloatTitle = [ "Administrator privileges required"
                             , "Network Connections"
                             , "Xfce Power Manager"
                             ]
        unfloat            = ask >>= doF . W.sink

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty
    -- fullscreenEventHook is needed for different applications (e.g. xidlehook) identifying 
    -- if any application is in the Full Screen mode
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()

addSpaces :: String -> String
addSpaces xs = if length xs == 0
                  then xs
                  else if length xs <= 80
                      then if mod (length xs) 2 == 0
                            then addSpaces ( " " ++ xs ++ " ")
                            else addSpaces ( xs ++ " ")
                      else xs

myShorten :: Int -> String -> String
myShorten n xs | length xs < n = xs
               | otherwise     = take (n - length end) xs ++ end
               where
                    end = "…"

myPP x = xmobarPP 
    { ppOutput = hPutStrLn x
    , ppOrder = \(workspace:layout:title:extras)
        -> [workspace,wrap "<action=`xdotool key super+space`>" "</action>" layout]++extras++[title]
    , ppSep = " "
    , ppExtras = [wrapL "<box type=Bottom width=2><action=`xdotool key super+j`>[" "]</action></box>" windowCount]
    , ppCurrent = xmobarColor myVioletDark myYellow . wrap " " " "
    , ppVisible = xmobarColor myBlue "" . clickable
    , ppHidden = xmobarColor myYellow "" . clickable
    , ppHiddenNoWindows = xmobarColor mySteelGrey "" . clickable
    , ppTitle = xmobarColor myBlack mySteelGreyDarker . addSpaces . pad . myShorten 80
    , ppLayout = (\x -> case x of
        "tiled" -> "<icon=layout-monadtall.xpm/>"
        "mtiled" -> "<icon=layout-monadwide.xpm/>"
        "reflH" -> "<icon=layout-monadtall-mirr.xpm/>"
        "two" -> "<icon=layout-columns.xpm/>"
        "monocle" -> "<icon=layout-max.xpm/>"
        _ -> x
        )
    }

myLogHook h = dynamicLogWithPP . namedScratchpadFilterOutWorkspacePP $ myPP h

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
    spawnOnce "/usr/bin/nitrogen --restore --set-zoom &"
    setWMName "LG3D"

------------------------------------------------------------------------
main = do
    nScreens <- countScreens
    if nScreens == 1
        then do 
            xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
            xmonad $ docks $ ewmh defaults {
                    manageHook = namedScratchpadManageHook scratchpads <+> manageHook defaults
                    , layoutHook = layoutHook defaults
                    , logHook = currentWorkspaceOnTop >> myLogHook xmproc0
                    }
        else do
            xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
            xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc1"
            xmonad $ docks $ ewmh defaults {
                    manageHook = namedScratchpadManageHook scratchpads <+> manageHook defaults
                    , layoutHook = layoutHook defaults
                    , logHook = currentWorkspaceOnTop >> myLogHook xmproc0 >> myLogHook xmproc1
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
    "mod-Shift-BS     Close/kill the focused window",
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
    "mod-f          Double Commander",
    "mod-d          GoldenDict",
    "mod-v          Vimwiki",
    "mod-x          Terminal",
    "mod-Shift-v    Volume control",
    "mod-u,c        SpeedCrunch",
    "mod-u,n        Newsboat RSS",
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
    "mod-Shift-q        Quit (logout)",
    "mod-q              Restart Xmonad",
    "mod-[1..9]         Switch to workSpace N",
    "mod-Backtick       Lock screen",
    "mod-Shift-Backtick Switch User",
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
