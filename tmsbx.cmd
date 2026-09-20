@echo off
rem tmsbx - wrapper around `sbx run` that includes all mixins from .\mixins
rem Works on Windows with plain cmd.exe. No extra software needed.

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
rem Remove trailing backslash
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "MIXINS_DIR=%SCRIPT_DIR%\mixins"

set "MIXIN_ARGS="
if exist "%MIXINS_DIR%" (
    for /d %%D in ("%MIXINS_DIR%\*") do (
        if exist "%%D\spec.yaml" (
            set "MIXIN_ARGS=!MIXIN_ARGS! --mixin "%%D""
        )
    )
)

if not defined MIXIN_ARGS (
    echo tmsbx: no mixins found in %MIXINS_DIR% 1>&2
    exit /b 1
)

sbx run "%SCRIPT_DIR%" %MIXIN_ARGS% %*
exit /b %ERRORLEVEL%
