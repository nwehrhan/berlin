#!/bin/bash

CRON_FLAG=$1
DELAY_SEC=300
DELAY_FMT=$(date -u -d @"$DELAY_SEC" +'%-Hh %-Mm %-Ss')
COOKIE_JAR="/tmp/cookies.txt"
BASE_URL="https://service.berlin.de"

# Check if all dependencies are available
if ! command -v wget &>/dev/null; then
  echo "'wget' is not available"
  exit 1
fi

if ! command -v xmllint &>/dev/null; then
  echo "'xmllint' (libxml2) is not available"
  exit 1
fi

# Helper functions
function fetch {
  wget --keep-session-cookies --save-cookies "$COOKIE_JAR" --load-cookies "$COOKIE_JAR" --quiet --output-document - "$1"
}

function xpath_search {
  xmllint --format - --html --xpath "$1" 2>/dev/null
}

function notify {
  if command -v notify-send &>/dev/null; then
    notify-send --urgency=critical "$1" "$2"
  fi
  echo -e "$1, $2\a"
}

function scan_calendar {
  initial_target=$1
  target=$initial_target

  echo "$(date): Crawl available appointments"

  for i in {1..6}; do
    contents=$(fetch "$target")
    bookable=$(echo "$contents" | xpath_search "count(//td[@class='buchbar'])")
    non_bookable=$(echo "$contents" | xpath_search "count(//td[@class='nichtbuchbar'])")

    echo "$i. ${target:0:64}... (bookable=$bookable, non_bookable=$non_bookable)"
    if ((bookable > 0)); then
      notify "Slot available!" "$bookable days with free slots, see $initial_target"
      break
    fi

    next_page=$(echo "$contents" | xpath_search "string(//th[@class='next']/a/@href)")
    target="$BASE_URL$next_page"

    if [ "$next_page" == "" ]; then
      break
    fi
  done
}

TARGET=$(fetch $BASE_URL/dienstleistung/120686/ | xpath_search "string(//a[@class='btn']/@href)")

# Entry point
if ((${#CRON_FLAG} > 0)); then
  scan_calendar "$TARGET"
  exit
else
  while true; do
    scan_calendar "$TARGET"
    echo "Wait for next_page crawl in $DELAY_FMT"
    sleep ${DELAY_SEC}
  done
fi
