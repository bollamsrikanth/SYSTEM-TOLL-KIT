@echo off
title Tulaman Windows Repair Tool
color 0A

echo ==================================================
echo        TULAMAN WINDOWS REPAIR TOOL
echo ==================================================
echo.

:: CHECK ADMIN RIGHTS
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this file as Administrator.
    pause
    exit
)

:: CREATE RESTORE POINT
echo Creating System Restore Point...
powershell -Command "Checkpoint-Computer -Description 'BeforeRepairTool' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1

:: CLEAN USER TEMP
echo.
echo [1/10] Cleaning User TEMP files...
del /s /f /q "%temp%\*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

:: CLEAN WINDOWS TEMP
echo [2/10] Cleaning Windows TEMP files...
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%x in ("C:\Windows\Temp\*") do rd /s /q "%%x" >nul 2>&1

:: CLEAN PREFETCH
echo [3/10] Cleaning Prefetch files...
del /s /f /q "C:\Windows\Prefetch\*" >nul 2>&1

:: CLEAN RECYCLE BIN
echo [4/10] Emptying Recycle Bin...
powershell.exe -NoProfile -Command Clear-RecycleBin -Force >nul 2>&1

:: WINDOWS UPDATE CACHE CLEANUP
echo [5/10] Cleaning Windows Update Cache...

net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1

del /f /s /q C:\Windows\SoftwareDistribution\Download\* >nul 2>&1

net start wuauserv >nul 2>&1
net start bits >nul 2>&1

:: DISK CLEANUP
echo [6/10] Running Disk Cleanup...
cleanmgr /verylowdisk

:: DISM REPAIR
echo [7/10] Running DISM Health Restore...
DISM /Online /Cleanup-Image /RestoreHealth

:: SYSTEM FILE CHECKER
echo [8/10] Running SFC Scan...
sfc /scannow

:: CHECK DISK SCAN
echo [9/10] Running CHKDSK Scan...
chkdsk C: /scan

:: SCHEDULE FULL DISK REPAIR
echo [10/10] Scheduling Disk Repair on Reboot...
echo Y | chkdsk C: /f

echo.
echo ==================================================
echo         ALL TASKS COMPLETED SUCCESSFULLY
echo ==================================================
echo.
echo Recommended:
echo - Restart the computer
echo - Let CHKDSK run during boot
echo.
pause
