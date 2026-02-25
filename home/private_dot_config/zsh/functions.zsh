#!/usr/bin/env zsh

function psg() {
  if [[ -z "$1" ]]; then
    echo "Usage: psg <pattern>"
    return 1
  fi
  ps aux | grep -i "$1" | grep -v "grep"
}

function port() {
  if [[ -z "$1" ]]; then
    echo "Usage: port <port>"
    return 1
  fi
  lsof -i:"$1" -P -n | head -20
}

function kill_port() {
  if [[ -z "$1" ]]; then
    echo "Usage: kill_port <port>"
    return 1
  fi
  local pids=$(lsof -ti:"$1")
  if [[ -z "$pids" ]]; then
    echo "No process found on port $1"
    return 1
  fi
  echo "$pids" | xargs kill -9
  echo "Killed process(es) on port $1"
}

function ip() {
  echo "Local:  $(ipconfig getifaddr en0 2>/dev/null || echo 'not connected')"
  echo "Public: $(curl -4 -s ifconfig.me)"
}

function flush_dns() {
  sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder
  echo "DNS cache flushed"
}

function b64() {
  if [[ -z "$1" ]]; then
    base64
  else
    echo -n "$1" | base64
  fi
}

function b64d() {
  if [[ -z "$1" ]]; then
    base64 --decode
  else
    echo -n "$1" | base64 --decode
    echo
  fi
}

function gitwork() {
  local author="${1:-@me}"
  local daysAgo="${2:-7}"

  gh pr list -A $author -L 50 -S "merged:>=$(date -v-$daysAgo\d +%Y-%m-%d)" --json title,url,mergedAt > prs.json && ruby -e 'require "json"; prs = JSON.parse(File.read("prs.json")); prs.map { |pr| puts "<a href=\"#{pr["url"]}\">#{pr["title"]}</a><br>" }' | textutil -stdin -format html -convert rtf -stdout | pbcopy && rm prs.json

  echo "Copied list of PRs to clipboard"
}
