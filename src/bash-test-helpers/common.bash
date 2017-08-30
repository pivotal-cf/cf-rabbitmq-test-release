#!/bin/bash

set -eu

fail() {
  local message="${1?:missing message}"
  local caller_name="${FUNCNAME[1]}"

  echo "[FAIL][$caller_name] $message" >> "/var/vcap/sys/log/cf-rabbitmq-release-test-failures.log"

  exit 1
}

log() {
  local message="${1?:missing message}"
  local caller_name="${FUNCNAME[1]}"

  echo "[DEBUG][$caller_name] $message" >> "/var/vcap/sys/log/cf-rabbitmq-release-test-debug.log"
}

