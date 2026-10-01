#!/bin/bash
# Создаёт в корне флешки скрытые файлы-заглушки, чтобы Android не создавал стандартные папки.
#
# Путь к флешке можно задать двумя способами:
#   1) передать при запуске:  bash android_stubs_mac.sh /Volumes/USB
#   2) вписать ниже: замените [ПУТЬ_К_ФЛЕШКЕ] целиком, вместе со скобками,
#      например: DEFAULT_VOL="/Volumes/Romanov_new"

DEFAULT_VOL="[ПУТЬ_К_ФЛЕШКЕ]"

VOL="${1:-$DEFAULT_VOL}"

case "$VOL" in
  \[*) echo "Не указан путь к флешке. Передайте его при запуске или впишите в DEFAULT_VOL."; exit 1 ;;
esac
[ -d "$VOL" ] || { echo "Нет такого тома: $VOL"; exit 1; }

# Уберите из списка папки, которые вам на флешке нужны.
NAMES="Alarms Audiobooks DCIM Documents Download Movies Music Notifications Pictures Podcasts Recordings Ringtones LOST.DIR Android"

dot_clean "$VOL" 2>/dev/null   # убрать служебные ._ файлы macOS

for n in $NAMES; do
  p="$VOL/$n"
  if [ -d "$p" ]; then
    if rmdir "$p" 2>/dev/null; then
      echo "удалена пустая папка: $n"
    else
      echo "ПРОПУСК: в папке $n есть файлы"
      continue
    fi
  fi
  [ -e "$p" ] || touch "$p"
  chflags hidden "$p"
  echo "заглушка: $n"
done

echo "Готово."
