#!/bin/bash -e

[ -z "$DEBUG" ] || set -x

# shellcheck disable=SC1091
. /var/vcap/jobs/check-logs-test/bin/files-to-inspect.sh
# shellcheck disable=SC1091
. /var/vcap/packages/bash-test-helpers/common.bash

main() {
  local file_to_inspect

  local start_timestamp
  start_timestamp=$(date +%s)
  sleep 1
  local port=5672

  echo 0091AMQP | nc localhost $port

  RETVAL=$?
  if [[ $RETVAL != 0 ]]; then
    echo "Failed to send a message to port $port"
    exit 1
  fi

  echo "About to inspect files..."
  for file_to_inspect in "${FILES_TO_INSPECT[@]}"
  do
    echo "Inspecting $file_to_inspect..."
    dir_name=$(dirname "$file_to_inspect")
    file_expression=$(basename "$file_to_inspect")
    file=$(find "$dir_name" -mindepth 1 -maxdepth 1 -type f | grep -E "$file_expression")

    if [[ -z "$file" ]]
    then
      echo "Unable to find file in [${dir_name}] matching pattern [${file_expression}]"
      exit 1
    fi

    mod_ts="$(ls -lc --time-style=+%s "$file" | awk '{ print $6 }')"
    if [[ ! $mod_ts -gt $start_timestamp ]]
    then
      echo "Expected file [${file_to_inspect}] to have been modified"
      exit 1
    fi
  done
}

main
