@echo off & setlocal EnableExtensions EnableDelayedExpansion
cls

:: Set tool paths here
set LWTOOLS_PATH="%USERPROFILE%\Desktop\lwtools"
set TOOLSHED_PATH="%USERPROFILE%\Desktop\toolshed"
set MAME_PATH="%USERPROFILE%\Desktop\MESS"
set VCC_PATH="%USERPROFILE%\Desktop\VCC\" 
set VCC_COMMAND="%USERPROFILE%\Desktop\VCC\VCC.exe"
set XROAR_PATH="%USERPROFILE%\Desktop\XRoar\"
set XROAR_COMMAND="%USERPROFILE%\Desktop\XRoar\xroar.exe"

:: Set environment paths here
set DISKETTE_NAME=dinorun.dsk
set "DISKETTE_PATH=%USERPROFILE%\Desktop\CoCo Development\RunDinoRun\"
set "SRC_PATH=%USERPROFILE%\Desktop\CoCo Development\RunDinoRun\src\"
set "BIN_PATH=%USERPROFILE%\Desktop\CoCo Development\RunDinoRun\bin\"
set "INC_PATH=%USERPROFILE%\Desktop\CoCo Development\RunDinoRun\src\include\"

copy "c:\Users\Paul\Desktop\CoCo Development\RunDinoRun\src\include\*.*" "c:\Users\Paul\Desktop\lwtools\include\dinorun\*.*"

:: Set filename to uppercase?
:: Set line below equal to FALSE if not worried about uppercase only files
set uppercase=TRUE

:: ///
:: /// NO NEED TO EDIT BELOW THIS LINE ///
:: ///
set filename=%1
if "%uppercase%" NEQ "TRUE" goto :start

:toupper
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do set filename=!filename:%%L=%%L!

:: Build paths for scripting
:start
set source_path="%SRC_PATH%%filename%.asm"
set binary_path="%BIN_PATH%%filename%.BIN"
set disk_path="%DISKETTE_PATH%%DISKETTE_NAME%"

:: Echo paths to console
echo.
echo  Assembling: %source_path%
::echo    Writing: %disk_path%
::echo  Launching: %binary_path%
echo.

:: Assemble the source code to binary
cd %LWTOOLS_PATH%
lwasm %source_path% --6809 --symbols --6800compat --output=%binary_path% --format=decb
if %ERRORLEVEL% neq 0 goto:done

:: Copy binary file to disk image
echo.
echo     Writing: %disk_path%
cd %TOOLSHED_PATH%
decb copy -2 -b %binary_path% -r %disk_path%,%filename%.BIN
if %ERRORLEVEL% == 248 (echo The target disk %disk_path% is full)
if %ERRORLEVEL% neq 0 goto:done

:: Emulator left blank - exit script
if "%2" == "" goto:done

:: Check which platform to test on
echo   Launching: %binary_path%
echo.
echo   Close emulator to resume command window...
if "%2" == "vcc" goto:vcc
if "%2" == "xroar" goto:xroar

:: MAME/MESS executes here as default emulator
:: Use: coco,coco2,coco2b,coco3 on command line to select target platform
:mess
cd %MAME_PATH%
messui64.exe %2 %3 -menu -skip_gameinfo -window -flop1 %disk_path% -autoboot_delay 1 -autoboot_command "\nLOADM\"%filename%\":EXEC\n"
::cd %CODE_PATH%
goto:done

:: VCC executes here
:vcc
cd %BIN_PATH%
%VCC_COMMAND% %filename%.BIN
goto:done

:: XRoar executes here
:xroar
cd %XROAR_PATH%
%XROAR_COMMAND% %binary_path%
::%XROAR_COMMAND% "%CODE_PATH%%filename%.BIN"

:: Change directory back to source path and exit
:done
echo   Returning to command line...
cd %CODE_PATH%
:end
