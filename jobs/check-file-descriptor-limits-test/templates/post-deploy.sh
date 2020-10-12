#!/usr/bin/env bash

set -e

[ -z "$DEBUG" ] || set -x

export PATH="$PATH:/var/vcap/packages/rabbitmq-server/bin/:/var/vcap/packages/erlang/bin:/var/vcap/packages/jq-1.5/bin"

main() {
  # shellcheck disable=1091
  . "/var/vcap/packages/bash-test-helpers/common.bash"

  # shellcheck disable=SC1091
  . "/var/vcap/jobs/check-file-descriptor-limits-test/bin/rabbitmq-vars.sh"

  check_file_descriptor_limit_has_been_set_correctly
}


check_file_descriptor_limit_has_been_set_correctly() {
  current_node_name="$(rabbitmqctl eval "node().")"
  current_fd_total="$(rabbitmqctl eval "file_handle_cache:ulimit().")"

  log "Current node ($current_node_name) has fd_total: $current_fd_total"

  if [[ "$current_fd_total" -ne "${RABBITMQ_FILE_DESCRIPTOR_LIMIT}" ]]
  then
    fail "Expected fd_limit to be $RABBITMQ_FILE_DESCRIPTOR_LIMIT but it was $current_fd_total"
  fi
}

main
