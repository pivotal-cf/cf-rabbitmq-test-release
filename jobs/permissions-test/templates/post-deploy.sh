#!/bin/bash -e

[ -z "$DEBUG" ] || set -x

# shellcheck disable=SC1091
. /var/vcap/jobs/permissions-test/bin/directories-to-inspect.sh

main() {
  ensure_all_inspected_directories_are_not_world_readable
}

fail() {
  echo "$*"
  exit 1
}

ensure_all_inspected_directories_are_not_world_readable() {
  local directory_to_inspect

  for directory_to_inspect in "${DIRECTORIES_TO_INSPECT[@]}"
  do
    files_breaking_the_rules=$(find -L "$directory_to_inspect" -perm -o=r -type f)
    [[ -z "${files_breaking_the_rules}" ]] ||
    fail "the following files are world readable: ${files_breaking_the_rules}"
  done
}

main
