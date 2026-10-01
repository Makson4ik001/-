@echo off
chcp 65001 >nul
rem Создаёт в корне флешки скрытые файлы-заглушки, чтобы Android не создавал стандартные папки.
rem
rem Букву флешки можно задать двумя способами:
rem   1) передать при запуске:  android_stubs_windows.bat E:
rem   2) вписать ниже: замените [БУКВА_ФЛЕШКИ] целиком, вместе со скобками,
rem      например: set "DEFAULT_VOL=E:"

set "DEFAULT_VOL=[БУКВА_ФЛЕШКИ]"

set "VOL=%~1"
if "%VOL%"=="" set "VOL=%DEFAULT_VOL%"

if "%VOL:~0,1%"=="[" (
  echo Не указана буква флешки. Передайте её при запуске или впишите в DEFAULT_VOL.
  pause
  exit /b 1
)
if not exist "%VOL%\" (
  echo Нет такого диска: %VOL%
  pause
  exit /b 1
)

rem Уберите из списка папки, которые вам на флешке нужны.
for %%n in (Alarms Audiobooks DCIM Documents Download Movies Music Notifications Pictures Podcasts Recordings Ringtones LOST.DIR Android) do call :stub "%%n"

echo Готово.
pause
exit /b 0

:stub
set "P=%VOL%\%~1"
if exist "%P%\" (
  del /a /q "%P%\._*" 2>nul
  rd "%P%" 2>nul
  if exist "%P%\" (
    echo ПРОПУСК: в папке %~1 есть файлы
    exit /b 0
  )
  echo удалена пустая папка: %~1
)
if not exist "%P%" type nul > "%P%"
attrib +h "%P%"
echo заглушка: %~1
exit /b 0
