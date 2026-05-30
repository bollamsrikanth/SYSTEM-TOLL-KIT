@echo off
title Tulaman Admin Toolkit
color 0A

:MENU
cls
echo ==================================================
echo             TULAMAN ADMIN TOOLKIT
echo ==================================================
echo.
echo 1. Quick Cleanup
echo 2. Deep Repair (DISM + SFC + CHKDSK)
echo 3. Internet Repair
echo 4. System Information Report
echo 5. Disk Cleanup + Recycle Bin
echo 6. Full Maintenance (Recommended)
echo 7. Exit
echo.
set /p choice=Enter your choice: 

if "%choice%"=="1" goto CLEANUP
if "%choice%"=="2" goto DEEPREPAIR
if "%choice%"=="3" goto NETWORK
if "%choice%"=="4" goto SYSINFO
if "%choice%"=="5" goto DISKCLEAN
if "%choice%"=="6" goto FULL
if "%choice%"=="7" exit

goto MENU

:CLEANUP
cls
echo Running Quick Cleanup...

del /s /f /q "%temp%\*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%x in ("C:\Windows\Temp\*") do rd /s /q "%%x" >nul 2>&1

del /s /f /q "C:\Windows\Prefetch\*" >nul 2>&1

echo Cleanup completed.
pause
goto MENU

:DEEPREPAIR
cls
echo Running DISM Repair...
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo Running SFC Scan...
sfc /scannow

echo.
echo Running CHKDSK Scan...
chkdsk C: /scan

echo.
echo Scheduling CHKDSK Repair on reboot...
echo Y | chkdsk C: /f

echo.
echo Deep Repair Completed.
pause
goto MENU

:NETWORK
cls
echo Resetting Network Settings...

ipconfig /flushdns
netsh winsock reset
netsh int ip reset

echo.
echo Network repair completed.
echo Restart PC for full effect.
pause
goto MENU

:SYSINFO
cls
echo Generating System Report...

set report=%USERPROFILE%\Desktop\Tulaman_System_Report.txt

echo ========================================== > "%report%"
echo        TULAMAN SYSTEM REPORT              >> "%report%"
echo ========================================== >> "%report%"
echo. >> "%report%"

echo COMPUTER NAME: %COMPUTERNAME% >> "%report%"
echo USERNAME: %USERNAME% >> "%report%"
echo DATE: %DATE% >> "%report%"
echo TIME: %TIME% >> "%report%"
echo. >> "%report%"

echo ===== SYSTEM INFO ===== >> "%report%"
systeminfo >> "%report%"

echo. >> "%report%"
echo ===== CPU INFO ===== >> "%report%"
wmic cpu get name >> "%report%"

echo. >> "%report%"
echo ===== RAM INFO ===== >> "%report%"
wmic memorychip get capacity >> "%report%"

echo. >> "%report%"
echo ===== DISK INFO ===== >> "%report%"
wmic diskdrive get model,size,status >> "%report%"

echo.
echo Report saved to Desktop:
echo %report%
pause
goto MENU

:DISKCLEAN
cls
echo Cleaning Recycle Bin...
powershell.exe -NoProfile -Command Clear-RecycleBin -Force >nul 2>&1

echo Running Disk Cleanup...
cleanmgr /verylowdisk

echo Disk cleanup completed.
pause
goto MENU

:FULL
cls
echo ==================================================
echo          RUNNING FULL MAINTENANCE
echo ==================================================

echo.
echo [1/6] Cleaning TEMP files...
del /s /f /q "%temp%\*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

echo [2/6] Cleaning Windows TEMP...
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1

echo [3/6] Cleaning Recycle Bin...
powershell.exe -NoProfile -Command Clear-RecycleBin -Force >nul 2>&1

echo [4/6] Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth

echo [5/6] Running SFC...
sfc /scannow

echo [6/6] Running CHKDSK Scan...
chkdsk C: /scan

echo.
echo Full maintenance completed.
echo Restart recommended.
pause
goto MENU
