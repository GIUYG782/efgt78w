@echo off
setlocal EnableDelayedExpansion

:: Function to generate a 4-digit HEX string from %RANDOM%
call :genHex hex1
call :genHex hex2
set volid_c=!hex1!!hex2!
call :genHex hex3
call :genHex hex4
set volid_d=!hex3!!hex4!
call :genHex hex5
call :genHex hex6
set volid_e=!hex5!!hex6!

:: Show the new volume IDs
echo Changing Volume IDs...
echo C: = !volid_c! >nul
echo D: = !volid_d! >nul 
echo E: = !volid_e! >nul
echo.

:: Apply Volume IDs using VolumeID.exe (must be in the same folder)
volumeid64.exe C: !volid_c! >nul
volumeid64.exe D: !volid_d! >nul
volumeid64.exe E: !volid_e! >nul

echo.
echo Disk Changed, Restart Your pc!
pause
exit /b

:: Function to generate 4-digit hex from %RANDOM%
:genHex
set /a rand=%RANDOM% %% 65536
set "hex="
for /f %%A in ('powershell -command "[Convert]::ToString(%rand%,16).PadLeft(4,'0')"') do set "%1=%%A"
exit /b
