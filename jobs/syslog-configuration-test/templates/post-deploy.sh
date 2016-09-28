#!/bin/bash -e

[ -z "$DEBUG" ] || set -x

# shellcheck disable=SC1091
. /var/vcap/jobs/syslog-configuration-test/bin/watched-log-files.sh

RSYSLOG_CONFIG_CHECK="$(rsyslogd -f /etc/rsyslog.d/rsyslog.conf -d -N 2 2>&1)"

main() {
  ensure_rsyslog_imfile_module_loaded
  ensure_rsyslog_watches_log_files
}

fail() {
  echo "$*"
  exit 1
}

ensure_rsyslog_imfile_module_loaded() {
  [[ $RSYSLOG_CONFIG_CHECK = *"loading module '/usr/lib/rsyslog/imfile.so'"* ]] ||
  fail "rsyslog imfile not loaded, can't watch log files"
}

ensure_rsyslog_watches_log_files() {
  local watched_log_file

  for watched_log_file in "${WATCHED_LOG_FILES[@]}"
  do
    [[ $RSYSLOG_CONFIG_CHECK = *"name: 'File', value '$watched_log_file'"* ]] ||
    fail "rsyslog not watching $watched_log_file"
  done
}

main
