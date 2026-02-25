#!/usr/bin/env zsh

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

function gitwork() {
  local author="${1:-@me}"
  local daysAgo="${2:-7}"

  gh pr list -A $author -L 50 -S "merged:>=$(date -v-$daysAgo\d +%Y-%m-%d)" --json title,url,mergedAt > prs.json && ruby -e 'require "json"; prs = JSON.parse(File.read("prs.json")); prs.map { |pr| puts "<a href=\"#{pr["url"]}\">#{pr["title"]}</a><br>" }' | textutil -stdin -format html -convert rtf -stdout | pbcopy && rm prs.json

  echo "Copied list of PRs to clipboard"
}
