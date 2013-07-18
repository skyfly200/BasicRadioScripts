:: Writen by skyler Fly-Wilson with much help from the internet
:: A project for Automating Way High Radio
:: This script plays a radio clip next, and the switches back to music
:: The script pulls files from playlists, on called RC and another called ALL

@echo off
:: cd to the directory with the clever exe and the playlists
cd C:\clever

:: State variables for modifying Inserts function
set rc=0
set ss=0

:: Used to insert song next
:Insert
:: Get state of shuffle and store in sh
FOR /F %%i IN ('clever.exe getshuffle') DO SET sh=%%i
:: Get time remaining
FOR /F "tokens=* USEBACKQ" %%F IN (`clever.exe timeleft`) DO (
SET var=%%F)
:: Parse time remaining into seconds
set "var1=%var::="^&REM #%
set "var2=%var:*:=%"
set /A timeLeft = %var1% * 60 + %var2% - 0.8

:: If timeLeft is greater than 1 than repeat Insert code, else switch playlist
if %timeLeft% GTR 1 (goto Insert) else (
:: delay for milisconds
ping -n 1 -w 250 127.0.0.1 > nul
:: If shuffle is off turn on and set ss(shuffle switched)
if %sh%==off (clever.exe swshuffle set ss=1) 
:: If on a Radio Clip, play ALL(all music playlist)
if %rc%==1 (
goto ALL)
:: Else play RC(Radio Clip)
if %rc%==0 (
goto RC)
)

:RC
:: Switch to the radio clip playlist
clever.exe loadplay RC.m3u
:: Set rc state variable
set rc=1
:: Go back to insert to have it play the music playlist after the radio clip
goto Insert 

:ALL
:: Switch to all music playlist
clever.exe loadplay All.m3u
:: if shuffle was turned on turn it off
if %ss%==1 clever.exe swshuffle
:: end the script
exit