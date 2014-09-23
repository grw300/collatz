@echo off
rem
rem   File: $Id: //ComputerBasedInstruments/RF/software/rfErrors/trunk/1.5/setupEnv.bat#1 $
rem   Author:  Mike Hall, mike.hall@ni.com
rem   Created: 08 Nov 2000
rem
rem
rem   This batch file and the buildToolsRedirect.exe files must be
rem   integrated into your component's trunk directory.
rem   This batch file must be run before you can build anything.
rem   It finds the tools and sets up your environment.
rem
rem   Your component must have a package file and that package file must
rem   list a dependency on nibuild.  For example:
rem
rem      dependency nibuild
rem      {
rem         perforcePath = //sa/ss/build/export/110/110a31;
rem      }
rem
rem
rem   Usage:
rem      Normally no parameters are required.  Just run setupEnv.bat from
rem      your Windows command shell.
rem
rem      The script will create a cache file containing Perforce path locations.
rem      This cache file, and a helper batch file, will be written to the
rem      ./objects/_dependencies/build subdirectory.  If you need to have these
rem      files written elsewhere (if the current filesystem is read-only) then
rem      specify an alternate path by setting the environment variable
rem      NIBUILD_SETUPENV_DIR.  If this variable is set, this script will use
rem      the directory given in that environment variable to store the temporary
rem      files it creates. The path in that environment variable must use the
rem      format that is valid on this system.  On Windows, that means it must
rem      use backslashes, and can specify a drive letter.
rem
rem      For debugging purposes, the first parameter can be set to "-v".
rem
rem      All other parameters are passed directly to the buildToolsRedirect script.
rem
rem
rem   The make utility uses bash as it's shell.  The Cygwin port of bash to
rem   Win32 is included in the toolchain.  However Cygwin requires a mapping
rem   for the Unix /tmp directory to some Windows directory.  This batch file
rem   (actually the buildToolsRedirect.exe program called by this batch file)
rem   uses the Cygwin mount.exe program to create that mapping.
rem   This requires the Windows environment to include a TEMP or TMP variable
rem   which points to a valid directory.
rem
rem   If the user is already using Cygwin tools and prefers to have /tmp map
rem   to some directory besides TEMP or TMP, set the Windows environment
rem   variable CYGWIN_TMP to point to that directory.
rem
rem

SETLOCAL

rem
rem   Variables used by this script
rem
set _NIBUILD_SETUPENV_VERSION=4
set _NIBUILD_VERBOSE=
set _NIBUILD_SETUPENV_DIR=.\objects\_dependencies\build
set _NIBUILD_SETUPENV_IGNORECACHE=

rem
rem   Check for the help options first.
rem
if "%1" == "/?" goto showHelp
if "%1" == "-?" goto showHelp
if "%1" == "/h" goto showHelp
if "%1" == "-h" goto showHelp
if "%1" == "--help" goto showHelp

rem
rem   Check for the "-v" option.  It must be the first option, if specified.
rem
if "%1" == "/v" goto ifVerboseThen
if "%1" == "-v" goto ifVerboseThen
if "%1" == "--verbose" goto ifVerboseThen
goto endifVerbose
:ifVerboseThen
   rem   Remove the "-v" option from the commandline; we'll add it explicitly later
   shift
   set _NIBUILD_VERBOSE=-v
   if "%_NIBUILD_VERBOSE%" == "-v" echo [setupEnv.bat] Top of setupEnv.bat
:endifVerbose


rem
rem   Make sure buildToolsRedirect.exe exists.
rem
if not exist buildToolsRedirect.exe goto errNoRedirectExe


rem
rem   Check for the NIBUILD_SETUPENV_DIR environment variable.
rem
if not "%NIBUILD_SETUPENV_DIR%" == "" goto ifSpecialSetupEnvDirThen
goto endifSpecialSetupEnvDir
:ifSpecialSetupEnvDirThen
   if "%_NIBUILD_VERBOSE%" == "-v" echo [setupEnv.bat] Using directory: %NIBUILD_SETUPENV_DIR%
   set _NIBUILD_SETUPENV_DIR=%NIBUILD_SETUPENV_DIR%
   rem   Always ignoreCache, because everyone uses the same SETUPENV_DIR.
   set _NIBUILD_SETUPENV_IGNORECACHE=--ignoreCache
:endifSpecialSetupEnvDir


rem
rem   Pass all of the command-line options to buildToolsRedirect.exe
rem
set _NIBUILD_BTR_CMD=buildToolsRedirect.exe --setupEnvVersion=%_NIBUILD_SETUPENV_VERSION% --scriptType=DOS --cacheDir=%_NIBUILD_SETUPENV_DIR% %_NIBUILD_SETUPENV_IGNORECACHE% %_NIBUILD_VERBOSE% %1 %2 %3 %4 %5 %6 %7 %8 %9
if "%_NIBUILD_VERBOSE%" == "-v" echo [setupEnv.bat] Calling: %_NIBUILD_BTR_CMD%
%_NIBUILD_BTR_CMD% || goto errRunningBTR



rem
rem   Call the batch file that was created by the buildToolsRedirect program
rem
if not exist %_NIBUILD_SETUPENV_DIR%\fixupPath.bat goto errNoFixupBatch

if "%_NIBUILD_VERBOSE%" == "-v" echo [setupEnv.bat] Transferring control to: %_NIBUILD_SETUPENV_DIR%\fixupPath.bat ...

rem   We need to clean up the environment (using ENDLOCAL) *before*
rem   transferring control to fixupPath.  If we were to call fixupPath and then
rem   call ENDLOCAL, we would undo its work.  Before calling ENDLOCAL, though,
rem   we must branch on which directory we're supposed to use, because once
rem   we've called ENDLOCAL, our local _NIBUILD_SETUPENV_DIR variable will be
rem   cleared.
if "%_NIBUILD_SETUPENV_DIR%" == "%NIBUILD_SETUPENV_DIR%" goto ifSpecialFixupPathDirThen
goto ifSpecialFixupPathDirElse
:ifSpecialFixupPathDirThen
   rem   Use the user-defined setupEnv path to call fixupPath.
   if "%_NIBUILD_VERBOSE%" == "-v" echo [setupEnv.bat] ... using a user-defined setupEnv dir.

   ENDLOCAL
   rem   Don't use "call" when calling fixupPath, so we transfer control to it.
   %NIBUILD_SETUPENV_DIR%\fixupPath.bat

   rem   We'll only get here if the fixupPath.bat miraculously disappeared.
   goto errFixupDisappeared

goto endifSpecialFixupPathDir
:ifSpecialFixupPathDirElse
   rem   Use the default path to call fixupPath.
   if "%_NIBUILD_VERBOSE%" == "-v" echo [setupEnv.bat] ... using the default setupEnv dir.

   ENDLOCAL
   rem   Don't use "call" when calling fixupPath, so we transfer control to it.
   .\objects\_dependencies\build\fixupPath.bat

   rem   We'll only get here if the fixupPath.bat miraculously disappeared.
   goto errFixupDisappeared

:endifSpecialFixupPathDir



rem
rem   Show the help and exit.
rem
:showHelp
echo [setupEnv.bat] usage:
echo   setupEnv [-h] [-v] [buildToolsRedirect options]
echo     -h  -  display this help and the buildToolRedirect script help.
echo     -v  -  verbose (debugging) output is generated.  If specified,
echo            this option MUST be the first option on the command-line.
echo.
echo   All other parameters are passed directly to the buildToolsRedirect script.
echo.
echo   Normally no parameters are required.  Just run setupEnv.bat from your
echo   Windows command shell.
echo.
echo   The script will create a cache file containing Perforce path locations.
echo   This cache file, and a helper batch file, will be written to the
echo   ./objects/_dependencies/build subdirectory.  If you need to have these
echo   files written elsewhere (if the current filesystem is read-only) then
echo   specify an alternate path by setting the environment variable
echo   NIBUILD_SETUPENV_DIR.  If this variable is set, this script will use
echo   the directory given in that environment variable to store the temporary
echo   files it creates. The path in that environment variable must use the
echo   format that is valid on this system.  On Windows, that means it must
echo   use backslashes, and can specify a drive letter.
echo.
echo   Help from buildToolsRedirect:
if exist buildToolsRedirect.exe call buildToolsRedirect.exe --help

if "%_NIBUILD_VERBOSE%" == "-v" echo [setupEnv.bat] Done with setupEnv.bat
exit /B 0


rem
rem   ------------   Errors   ----------------------
rem

:errNoRedirectExe
echo.
echo [setupEnv.bat]
echo ERROR: The program buildToolsRedirect.exe is not present in the same
echo directory as setupEnv.bat.  Be sure that you have correctly integrated
echo the build tools into your dependencies.
echo Also be sure to run this script from your component's trunk directory.
goto exitWithError


:errRunningBTR
echo.
echo [setupEnv.bat]
echo ERROR: Unable to locate the toolchain on your disk.  The helper app,
echo buildToolsRedirect.exe, returned an error.  See its output above for
echo more details. buildToolsRedirect.exe exited with status: '%errorlevel%'
goto exitWithError


:errNoFixupBatch
echo.
echo [setupEnv.bat]
echo ERROR: Unable to add the toolchain to your path because the fixup batch
echo file that was supposed to be auto-generated could not be found.  Try
echo running this batch file again with the -v option for more information.
goto exitWithError


:errFixupDisappeared
echo.
echo [setupEnv.bat]
echo ERROR: The fixup batch file we generated was here just a second ago, but
echo it seems to have disappeared.
goto exitWithError


:exitWithError

rem   The easiest and most consistent way to exit with an error: call a
rem   program that doesn't exist. This has to be the last thing we do in the
rem   batch file -- we can't even call `goto` or `exit` after it.
someProgramThatDoesntExists.exe 2>NUL
