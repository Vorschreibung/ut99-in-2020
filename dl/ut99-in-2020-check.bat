@ECHO OFF
REM UT99 in 2020 Companion Script v1.2 (2020-09-07) (d221325f285d52f0)
REM https://vorschreibung.github.io/ut99-in-2020/
REM - - - - - - - - - - - - - - - - - - - - - - - 
REM this is a simple companion script to the UT99 in 2020 guide that is to be 
REM dropped in the root directory of your UT99 installation
REM
REM on execution it will check your installation for misconfigurations and
REM point you back to the guide how to fix them
REM
REM this script will **never** change your config or write/change any files
REM it will only read files and print output to the console
REM
REM the ?BAT? tag is used in comments to explain/provide info about batch intrinsics in case you are not familiar with batch


REM ?BAT? you should **never** expand variables via %VAR% but always !var! instead, for an in-detail explanation please see:
REM https://stackoverflow.com/questions/14347038/why-are-my-set-commands-resulting-in-nothing-getting-stored/14347131#14347131
SETLOCAL EnableDelayedExpansion

REM R1. check if the S3TC textures are installed by checking the filesize of a Texture Pack 
REM ?BAT? the function GetFileSize is defined at the very bottom of the file
CALL :GetFileSize "./Textures/Ancient.utx"
IF !size!==30778134 (
    ECHO [ERROR] You seem to be using the S3TC Textures from Disk 2 of the
    ECHO GOTY disk edition^^!
    ECHO This causes network mismatch problems with other players who lack
    ECHO it in multiplayer and its usage is widely discouraged.
    ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#goty-disc-version ^)
    REM ?BAT? ECHO. prints a newline
    ECHO.
)

REM R2. check for an altered steam executable
CALL :GetFileSize "./System/UnrealTournament.exe"
IF !size!==249856 (
    ECHO [ERROR] You seem to be using the Steam version without having installed
    ECHO the official 436 patch over it.
    ECHO This may cause mismatch problems in netplay with non-steam editions.
    ECHO Please install the official 436 patch.
    ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#goty-steam-version ^)
    ECHO.
)

REM R3. check for d3d10drv.dll
IF NOT EXIST "./System/d3d10drv.dll" (
    ECHO [ERROR] You are missing the d3d10 Video Driver^^!
    ECHO This causes stability issues and various display problems on modern systems.
    ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#use-updated-d3d10-video-driver ^)
    ECHO.
    SET "d3d10MissingOrDisabled=1"
)

REM R4. check for dinput.dll
IF NOT EXIST "./System/dinput.dll" (
    ECHO [ERROR] You are missing the dinput Compatibility Fix^^!
    ECHO This causes forced mouse acceleration due to a compatibility issue
    ECHO as well as causing glitches after ALT+Tabing.
    ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#use-ut99dinput ^)
    ECHO.
)

REM iterate over all lines in UnrealTournament.ini to check for misconfigurations
FOR /F "usebackq tokens=*" %%A IN ("./System/UnrealTournament.ini") DO (
    SET "rawLine=%%A"

    REM if current line is a section, just remember it and continue (?BAT? there is neither *CONTINUE* nor *GOTO* available in FOR-loops, we can only *CALL*, which is super expensive)
    IF "!rawLine:~0,1!"=="[" (
        SET section=!rawLine:~1,-1!
    )  ELSE (
        REM if it's not a section, it's a key/val pair, extract them by splitting on '='
        FOR /F "tokens=1,2 delims==" %%a IN ("!rawLine!") DO (
            SET "key=%%a"
            SET "val=%%b"
        )

        REM === RULES
        REM R5. use d3d10
        IF "!d3d10MissingOrDisabled!"=="" (
                IF "!section!"=="Engine.Engine" IF "!key!"=="GameRenderDevice" IF NOT "!val!"=="D3D10Drv.D3D10RenderDevice" (
                    ECHO [ERROR] You have not enabled the D3D10RenderDevice.
                    ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#changing-the-video-driver ^)
                    ECHO.
                    SET "d3d10MissingOrDisabled=1"
                )
        )

        REM R6. store d3d10 vsync-related settings - see below for consistency checks
        IF "!section!"=="D3D10Drv.D3D10RenderDevice" IF "!key!"=="VSync" (
            SET "d3d10Vsync=!val!"
        )
        IF "!section!"=="D3D10Drv.D3D10RenderDevice" IF "!key!"=="FPSLimit" (
            SET "d3d10FpsLimit=!val!"
        )
        IF "!section!"=="D3D10Drv.D3D10RenderDevice" IF "!key!"=="RefreshRate" (
            SET "d3d10RefreshRate=!val!"
        )

        REM R7. netspeed
        IF "!section!"=="Engine.Player" IF "!key!"=="ConfiguredInternetSpeed" IF NOT "!val!"=="20000" (
            ECHO [ERROR] You have set non-standard Internet Netspeed. This can lead to low ping
            ECHO You have currently set ConfiguredInternetSpeed=!val!, we expected 20000.
            ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#configuring-netspeed ^)
            ECHO.
        )

        REM R8. directinput
        IF "!section!"=="WinDrv.WindowsClient" IF "!key!"=="UseDirectInput" IF NOT "!val!"=="True" (
            ECHO [ERROR] You have disabled Direct Input. This leads to buggy mouse aim.
            ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#use-ut99dinput ^)
            ECHO.
        )

        REM R9. allow-downloads
        IF "!section!"=="IpDrv.TcpNetDriver" IF "!key!"=="AllowDownloads" IF "!val!"=="True" (
            ECHO [warning] You have allowed automatic downloads while joining servers.
            ECHO This could download and execute harmful files on your PC^^!
            ECHO Make sure to only connect to trusted servers as long as you have this enabled.
            ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#disable-automatic-downloads ^)
            ECHO.
        )
    )
)

REM R6. d3d10 vsync - check for enabled vsync and inconsistencies between FPSLimit and RefreshRate
IF "!d3d10MissingOrDisabled!"=="" (
    IF "!d3d10Vsync!"=="False" (
        IF NOT "!d3d10RefreshRate!"=="" IF NOT "!d3d10FpsLimit!"=="" (
            IF NOT "!d3d10RefreshRate!"=="!d3d10FpsLimit!" (
                ECHO [ERROR] For d3d10, your RefreshRate ^(!d3d10RefreshRate!^) and
                ECHO FPSLimit ^(!d3d10FpsLimit!^) do not match^^!
                ECHO This will result in too fast/too slow gameplay^^!
                ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#disable-vsync ^)
                ECHO.
            )
        )
        IF "!d3d10RefreshRate!"=="" IF "!d3d10FpsLimit!"=="" (
            ECHO [ERROR] For d3d10, you have set neither RefreshRate no FPSLimit^^!
            ECHO This will result in too fast/too slow gameplay^^!
            ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#disable-vsync ^)
            ECHO.
        )
        IF NOT "!d3d10RefreshRate!"=="" IF "!d3d10FpsLimit!"=="" (
            ECHO [ERROR] For d3d10, you haven't set FPSLimit^^!
            ECHO This will result in too fast/too slow gameplay^^!
            ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#disable-vsync ^)
            ECHO.
        )
        IF "!d3d10RefreshRate!"=="" IF NOT "!d3d10FpsLimit!"=="" (
            ECHO [ERROR] For d3d10, you haven't set RefreshRate^^!
            ECHO This will possibly result in too fast/too slow gameplay^^!
            ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#disable-vsync ^)
            ECHO.
        )
    ) ELSE (
        ECHO [warning] You have enabled Vsync.
        ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#disable-vsync ^)
        ECHO.
    )
)

REM iterate over all lines in User.ini to check bindings that can't be set through the menu ingame
FOR /F "usebackq tokens=*" %%A IN ("./System/User.ini") DO (
    SET "rawLine=%%A"

    REM if current line is a section, just remember it and continue
    IF "!rawLine:~0,1!"=="[" (
        SET section=!rawLine:~1,-1!
    )  ELSE (
        REM if it's not a section, it's a key/val pair, extract them by splitting on '='
        FOR /F "tokens=1,2 delims==" %%a IN ("!rawLine!") DO (
            SET "key=%%a"
            SET "val=%%b"
        )

        REM === RULES
        REM R10. check alt-tab
        IF "!section!"=="Engine.Input" IF "!key!"=="Tab" IF "!val!"=="Type" (
            SET "defaultTab=1"
        )

        IF "!section!"=="Engine.Input" IF "!key!"=="Alt" IF "!val!"=="Fire" (
            SET "defaultAlt=1"
        )
    )
)

REM R10. check alt-tab - report only once in the case of both being set to default
IF "!defaultTab!"=="1" IF "!defaultAlt!"=="1" (
    ECHO [warning] You have both Alt and Tab set to default. 
    ECHO This interferes with ALT+Tabing.
    ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#freeing-alttab ^)
    ECHO.
) ELSE (
    IF "!defaultTab!"=="1" IF "!defaultAlt!"=="" (
        ECHO [warning] You have Tab set to default. This interferes with ALT+Tabing.
        ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#freeing-tab ^)
        ECHO.
    )
    IF "!defaultTab!"=="" IF "!defaultAlt!"=="1" (
        ECHO [warning] You have Alt set to default. This interferes with ALT+Tabing.
        ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#freeing-alt ^)
        ECHO.
    )
)

REM iterate over all lines in Manifest.ini to check the currently installed version
FOR /F "usebackq tokens=*" %%A IN ("./System/Manifest.ini") DO (
    SET "rawLine=%%A"

    REM if current line is a section, just remember it and continue
    IF "!rawLine:~0,1!"=="[" (
        SET "section=!rawLine:~1,-1!"
    )  ELSE (
        REM if it's not a section, it's a key/val pair, extract them by splitting on '='
        FOR /F "tokens=1,2 delims==" %%a IN ("!rawLine!") DO (
            SET "key=%%a"
            SET "val=%%b"
        )

        REM === RULES
        REM R11. check the currently installed version
        IF "!section!"=="UnrealTournament" IF "!key!"=="Version" IF NOT "!val!"=="436" (
            ECHO [ERROR] You have installed version !val! while the latest official patch is 436.
            ECHO ^( see https://vorschreibung.github.io/ut99-in-2020/#installing-the-latest-official-patch-436 ^)
            ECHO.
        )
    )
)

REM we're done
ECHO Finished checking your configuration.
ECHO If no warnings/errors were printed just now your configuration passed.

PAUSE
GOTO :EOF

REM ?BAT? a function to be called via CALL - reads the size of a file passed and stores it into the global %size%
:GetFileSize
SET size=%~z1
GOTO :EOF
