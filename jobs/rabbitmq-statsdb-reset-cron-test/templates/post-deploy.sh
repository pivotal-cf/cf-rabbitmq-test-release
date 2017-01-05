#!/bin/bash -e

[ -z "$DEBUG" ] || set -x

CRONTAB_FILE="/etc/cron.d/rabbitmq-statsdb-reset"

main() {
  check_file_exists_and_is_not_empty
  check_file_contains_command_to_restart_rabbitmq_statsdb
}

check_file_exists_and_is_not_empty() {
  if [[ ! -s "${CRONTAB_FILE}" ]]; then
   fail "Couldn't find cron file or found empty file at ${CRONTAB_FILE}"
  fi
}

check_file_contains_command_to_restart_rabbitmq_statsdb() {
  if ! grep -q "rabbitmqctl eval \"supervisor2:terminate_child(rabbit_mgmt_sup_sup, rabbit_mgmt_sup),rabbit_mgmt_sup_sup:start_child().\"" "${CRONTAB_FILE}"; then
    fail "Did not find the expected rabbitmqctl command in crontab at ${CRONTAB_FILE}"
  fi
}

fail() {
  echo "$*"
  exit 1
}

main
