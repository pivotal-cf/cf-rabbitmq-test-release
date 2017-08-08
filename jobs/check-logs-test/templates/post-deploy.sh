#!/bin/bash -e

[ -z "$DEBUG" ] || set -x

# shellcheck disable=SC1091
. /var/vcap/jobs/check-logs-test/bin/files-to-inspect.sh
# shellcheck disable=SC1091
. /var/vcap/packages/bash-test-helpers/common.bash

main() {
  local file_to_inspect

  for file_to_inspect in "${FILES_TO_INSPECT[@]}"
  do
    check_file_exists_and_is_not_empty "$file_to_inspect"
  done
}

check_file_exists_and_is_not_empty() {
  local filepath="${0}"

  if [[ ! -s "${filepath}" ]]; then
   fail "Couldn't find file or found empty file at ${filepath}"
  fi
}

main
