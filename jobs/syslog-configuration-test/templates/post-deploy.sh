#!/bin/bash -e

[ -z "$DEBUG" ] || set -x

# shellcheck disable=SC1091
. /var/vcap/jobs/syslog-configuration-test/bin/watched-log-files.sh


main() {
  load_ryslogd_config_check
  ensure_rsyslog_imfile_module_loaded
  ensure_rsyslog_watches_log_files
}

fail() {
  echo "$*"
  exit 1
}


# because of differing behaviours of rsyslogd versions, we cannot assume that
# this command will exit 0 with identical configuration.
#
# e.g.: rsyslogd v8.22.0 will exit 1
#       rsyslogd v8.23.0 will exit 0
#
# The output will look the same regardless of the exit code
load_ryslogd_config_check() {
  set +e
  RSYSLOG_CONFIG_CHECK="$(rsyslogd -d -N 2 2>&1)"
  set -e
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
