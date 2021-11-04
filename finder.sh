#!/bin/bash

DELAY_SEC=300

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
  $(curl url_here)
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

function searchPageAndReport {
  time=`date`
  echo "About to search page; ${time}"
  slot_exists=`wget ${FULL_URL} -qO- | grep -c "${PATTERN}"`
  echo "Finished Searching page; ${time}"
  [[ $slot_exists -gt 0 ]] && show_notification && printUrl && makeNoise

}

FULL_URL="`wget https://service.berlin.de/dienstleistung/120686/ -qO- | grep "Termin berlinweit suchen</a" |  sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | sed 's/\&amp;/\&/g'`"

CRON_FLAG=$1

if (( ${#CRON_FLAG} > 0 ))
then
  searchPageAndReport
  exit
else
  while true
  do
    searchPageAndReport
    sleep ${DELAY_SEC}
  done
fi


