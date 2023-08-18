@echo off
setlocal EnableDelayedExpansion

whoami /user | find /i "S-1-5-18" > nul 2>&1 || (
	call RunAsTI.cmd "%~f0" "%*"
	exit /b
)

:: Enable Lanman Workstation (SMB) as a dependency
"C:\Users\Default\Desktop\3. Configuration\1. General Configuration\Lanman Workstation (SMB)\Enable Lanman Workstation (default).cmd" /silent
:: Enable EventLog as a dependency
call setSvc.cmd eventlog 2

:: Pin 'Network' to Explorer sidebar
reg add "HKCU\Software\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Classes\WOW6432Node\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "1" /f

call setSvc.cmd fdPHost 3
call setSvc.cmd FDResPub 3
call setSvc.cmd lmhosts 3
call setSvc.cmd netman 3
for /f "tokens=6 delims=[.] " %%a in ('ver') do (
    if %%a LSS 22000 (call setSvc.cmd NlaSvc 2) else (call setSvc.cmd NlaSvc 3)
)
call setSvc.cmd SSDPSRV 3

echo Finished, please reboot your device for changes to apply.
pause
exit /b