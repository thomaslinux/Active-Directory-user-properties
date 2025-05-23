@echo OFF
set string=%*
:: launch user.ps1 with the arguments
powershell.exe -ExecutionPolicy Bypass -File ".\aduserfinal.ps1" %string%
