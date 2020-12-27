# Xmonad and Xmobar setup for laptop

Here I publish my Xmonad and Xmobar setup for the laptop.
Key features of this setup is ability of the proper dynamic monitor setup: laptop screen + second HDMI connected monitor.

- Monitor can be connected and disconnected any time.
- Each monitor has its instance of Xmobar.
- Instances of the Xmobar are added/removed dynamically.

I use `systemd` service for the detection of the external monitor/screen attachment/detachment.

## Screenshot

![Dual screen shot](screenshot/dual_screen.png)

## Sequence (logic)

1. I start all applets, notify daemon and system tray application (`trayer`) in the `.xprofile`.
    - It also launches `displaymode` script, which detects if the laptop lid is open or closed and whether HDMI monitor is attached or not. Depending on the condition it sets up appropriate displays configuration with `xrandr`.
2. In order to detect attachment or detachment of the screen I made my own `systemd` service for this event. (See chapter below).
  - Both `systemd` service and `displaymode` script restart `xmonad` process when display setup is changed because `xmonad` dynamically spawns necessary number of `xmobar` instances on the screen.

## Systemd service setup

## Xmonad.hs critical section

I use `XMonad.Layout.IndependentScreens` to detect number of screens.

And then in the `main` function:

```
main = do
    nScreens <- countScreens
    if nScreens == 1
        then do 
            xmproc0 <- spawnPipe "xmobar -x 0 /home/alexgum/.config/xmobar/xmobarrc"
            xmonad $ docks defaults {
                    manageHook = manageDocks <+> namedScratchpadManageHook scratchpads <+> manageHook defaults
                    , layoutHook = avoidStruts $ layoutHook defaults
                    , logHook = myLogHook xmproc0
                    }
        else do
            xmproc0 <- spawnPipe "xmobar -x 0 /home/alexgum/.config/xmobar/xmobarrc"
            xmproc1 <- spawnPipe "xmobar -x 1 /home/alexgum/.config/xmobar/xmobarrc1"
            xmonad $ docks defaults {
                    manageHook = manageDocks <+> namedScratchpadManageHook scratchpads <+> manageHook defaults
                    , layoutHook = avoidStruts $ layoutHook defaults
                    , logHook = myLogHook xmproc0 >> myLogHook xmproc1
                    }
```

Each time when `xmobar` is restarted, it re-detects number of displays and spawns necessary number of bars.

What is good, is that when display is in the **mirror** mode (`xrandr --output eDP --primary --auto --output HDMI-A-0 --auto --same-as eDP`), then `xmobar` correctly sees it as one screen only and spawns only one `xmobar` instance.
