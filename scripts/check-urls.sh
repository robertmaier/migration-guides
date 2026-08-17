#!/usr/bin/env bash
# Checks every url field in packages/*.json returns a 2xx status.
set -euo pipefail

FAILED=0

while IFS= read -r url; do
  status=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 15 --retry 2 \
    -A "Mozilla/5.0 js-migration-guides/url-checker" "$url")
  if [[ "$status" =~ ^2 ]]; then
    echo "  OK  ($status) $url"
  else
    echo "  FAIL ($status) $url"
    FAILED=1
  fi
done < <(jq -r '.migrations[].url' packages/*.json | sort -u)

if [[ $FAILED -ne 0 ]]; then
  echo ""
  echo "One or more URLs are unreachable."
  exit 1
fi
