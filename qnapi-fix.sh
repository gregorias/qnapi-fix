#!/usr/bin/env bash
# Usage: qnapi-fix.sh (MOVIE_FILE|SUBTITLE_FILE)
#
# This script:
#
# 1. Converts the subtitle file from latin1 encoding to utf8,
# 2. Fixes broken Polish letters.

BASENAME="${1%???}"
if [[ -f "${BASENAME}txt" ]]; then
  SUB_FILE="${BASENAME}txt"
elif [[ -f "${BASENAME}srt" ]]; then
  SUB_FILE="${BASENAME}srt"
else
  echo "Could not find the subtitle file."
  exit 1
fi

if file -i "${SUB_FILE}" | grep utf-8; then
  echo "The "${SUB_FILE}" is already in UTF8, which is unexpected."
  exit 1
else
  echo "Transforming character encoding." && \
  iconv -f latin1 -t utf8 "${SUB_FILE}" > "${SUB_FILE}.bak"
fi

echo "Fixing characters." && \
sed -f letters.sed "${SUB_FILE}.bak" > "${SUB_FILE}" && \
rm "${SUB_FILE}.bak"
