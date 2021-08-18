#!/bin/bash

DELAY_SEC=600

PATTERN="An diesem Tag einen Termin buchen"

function show_notification {
  # Show notification on macOS when osascript is present, otherwise print to console
  if command -v osascript &> /dev/null
  then
    osascript -e 'display notification "Termin slot available for Anmeldung!"'
  else
    echo "Termin slot available for Anmeldung!"
  fi
}

function zap {
  $(curl ***REMOVED***)
}

function printUrl {
  echo "$(date):    $slot_count slots available now! Access here: ${FULL_URL}"
}

function makeNoise {
  echo -e "\a"
if command -v say &> /dev/null
then
    $(say 'Availability found! Availability found!')
fi
  echo -e "\a"
}

FULL_URL="`wget https://service.berlin.de/dienstleistung/120686/ -qO- | grep "Termin berlinweit suchen</a" |  sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | sed 's/\&amp;/\&/g'`"

while true
do
  slot_exists=`wget ${FULL_URL} -qO- | grep -c "${PATTERN}"`
  [[ $slot_exists -gt 0 ]] && zap && show_notification && printUrl && makeNoise
  sleep ${DELAY_SEC}
done
