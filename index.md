# UT99 in 2020
![Bannre](img_banner.png)

## Basic Installation
<!--
- Latest Official Patch 463 **[download]** checksum: `e9e3b13106d4a28fdd40ee93a3aa1ec04617508af701f752ab20f07bec9f4817`
- Latest Community Patch 451 **[download]** checksum: `e9e3b13106d4a28fdd40ee93a3aa1ec04617508af701f752ab20f07bec9f4817`
  this patch mostly
-->

These 3 ways are currently supported for this guide

### GOTY Disc Version
Do **not** install the 2nd disc.
### GOTY GOG Version
There are no further steps necessary after installation.
### GOTY Steam Version
This requires the official 463 patch, despite what the menu says ingame.

Note that if Verify Game Integrity through Steam is run, the files will be
reverted back and need to be patched again.

## Community Compatibility Fixes
These come in the form of `.dll` files that fix compatibility issues you will
otherwise confront on modern systems (> WinXP).

### Use updated d3d10 video-driver
Why to do it:
- fixes crashes / increases stability
- improves input latency significantly
- enables higher resolutions, automatic-fov and anti-aliasing/anisotropic-filtering

download the Direct 3D 10 video driver from [here](http://www.kentie.net/article/d3d10drv/) and unpack it (including the subdirectory it extracts) into your `UT99\System` directory

if you care for an explanation as to why this video-driver is prefered to its
alternatives see [here](#why-prefer-the-d3d10-video-driver)

#### Changing the video driver
the inital steps of getting the video driver selection window depends if you have started the game before or if this is a fresh installation

##### Option 1: I have started the game before
1. in the menu go to **Options** -> **Preferences**
2. at the top next to **Video Driver** press the **[Change]** button
3. confirm the preceding dialogue with **Yes**
4. UT99 will now close and open a new Window where you can select the video driver

##### Option 2: I haven't started the game before
merely start the game, the dialogue will appear by itself

##### Navigating the video driver selection window
1. check the Checkbox named **Show all devices**
2. you will now spot a **Direct3D 10 Support** entry in the list, select it and confirm your selection by pressing the **[Next >]** button
3. confirm your selection once again by pressing the preceding **[Next >]** button
4. relaunch the game by pressing the **[Run!]** button

##### Finishing touches
After switching to the Direct 3D 10 Driver start the game at least once so it will populate the `UnrealTournament.ini` (used for configuration) with defaults.

### Fix mouse / direct-input issues
Why to do it:
- fixes forced mouse acceleration (affects all Windows versions > WinXP)
- fixes an out of place looking otherwise permanent bulky crosshair-cursor
  appearing and sticking around ingame after ALT+TABing

get [UT99Dinput](https://github.com/Vorschreibung/UT99DInput) ([download](https://github.com/Vorschreibung/UT99DInput/releases/latest/download/UT99DInput-v2.zip)\) and put the `dinput.dll` in your `UT99\System` directory

in the menu ingame, make sure to enable the **DirectInput** setting found in the
**Controls** Settings Tab

## Configuration
Most of these will 

### Disable vsync
Why to do it:
- improves input latency significantly

using the Direct 3D 10 driver, add/set the following lines below the `[D3D10Drv.D3D10RenderDevice]`-section in `UT99/System/UnrealTournament.ini`
, replacing `60` with your *current refresh rate* supported by your monitor (**don't** go higher than that)

```
VSync=False
FPSLimit=60
RefreshRate=60
```

### Configuring Netspeed
Why to do it:
- fixes high-latency scenarios in Internet games

add/set the following lines below the `[Engine.Player]`-section in `UT99/System/UnrealTournament.ini`
```
ConfiguredInternetSpeed=20000
```

### Disable Automatic-Downloads
Why to do it:
- downloading any kind of is not a great idea

  @TODO

add/set the following lines below the `[IpDrv.TcpNetDriver]`-section in `UT99/System/UnrealTournament.ini`
```
AllowDownloads=False
```

### Max out anti-aliasing and anisotropic filtering
Why to do it:
- improves visuals

using the Direct 3D 10 driver, add/set the following lines below the `[D3D10Drv.D3D10RenderDevice]`-section in `UT99/System/UnrealTournament.ini`

```
Antialiasing=16
Anisotropy=16
```

### Customize fov

## Tips for Default Bindings
These Default Bindings **can not** be changed through the menu and have to
be set through the `UT99/System/User.ini` file.

Especially because some of these interfere with ALT+Tabing, they are added here
for completions sake and should be considered.

### Freeing ALT+Tab
#### Freeing TAB
by default TAB binds an awful version of the console (a better one can be bound
in the Input Menu named **asdasd** [see here](#console)), this will cause you to open a sticky
console every time you ALT+Tab that you have to exit via ESC before regaining
ingame control

to disable this simply free TAB

```
Tab=
```

<!--
or, another recommended alternative is binding Show-Scoreboard to TAB (it's by default on F1)
see [Show Scores](#Show-Scoreboard)
-->

#### Freeing ALT
by default the ALT key is bound to firing your weapon which can not be disabled
ingame, this will cause you to shoot your weapon every time you ALT+Tab

to disable this simply free Alt
```
Alt=
```

### Show Scoreboard
by default F1 is bound to toggle the Scoreboard, which is harder to reach,
consider binding it to something more comfortably within reach via the `ShowScores` Command, e.g.:

```
C=ShowScores
```

*HINT* there is no built-in way to show the Scoreboard only while holding down a
key, some guides propose a workaround by using |-pipes but these work
inconsistently, meaning in some cases the Scoreboard will not be hidden once you
release your key again and become sticky, requiring you to fallback to the F1
key to toggle it off, for these reasons it is not recommended here

### Console
Bind a better console via ...

## Reasoning

### Why prefer the d3d10 video driver?
I'm aware of the following alternative "modern" video drivers:

- [OpenGL]
- [D3d9]

Just because

## Tips & Tricks
### Installing .umod files
Drop [this script](dl/ut99-install-umod.bat) into the root of your UT99
Installation and then drag and drop the `.umod` files you want to install onto
it.

<!--
## Obsolete points
### Differences between opengl and direct3d
- big difference in lightning/gamma

### Disable vsync
- improves input latency

#### Direct3d 10
using the Direct 3D 10 driver, add/set the following lines to `[D3D10Drv.D3D10RenderDevice]`, replacing `144` with a *refresh rate supported by your monitor* that you want to use

```
VSync=False
FPSLimit=144
```
#### Opengl (without speeding up the game)
using the OpenGL driver, add the following lines to `[OpenGLDrv.OpenGLRenderDevice]`, replacing `144` with a *refresh rate supported by your monitor* that you want to use
```
RefreshRate=144
FrameRateLimit=144
SwapInterval=0
```

**explanation**  
`SwapInterval=0` disables vsync, but there is no fps limit enforced in the engine,
even worse: the simulation rate of the game is set to a fixed interval depending on the `RefreshRate` used,
meaning if the game starts with e.g. `RefreshRate=144` and you manage to render 1440 fps, the game will literally run 10x the speed,
to make sure your simulation neither speeds up nor slows down, the `RefreshRate` and `FrameRateLimit` variables have to be set to the **exact** same value
-->
