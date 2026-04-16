#!/bin/bash
set -e

INPUT=${1:-public/summary.json}
OUTPUT=${2:-public/badge.svg}

THROUGHPUT=$(jq -r '.throughput' "$INPUT")
P90=$(jq -r '.p90' "$INPUT")
STATUS=$(jq -r '.status' "$INPUT")

if [ "$STATUS" = "PASS" ]; then
  COLOR="#4c1"
else
  COLOR="#e05d44"
fi

VALUE="${STATUS} - ${THROUGHPUT}rps p90:${P90}ms"
LABEL="performance"

CHAR_WIDTH=7
PADDING=10

LABEL_WIDTH=$(( ${#LABEL} * CHAR_WIDTH + 40 ))
VALUE_WIDTH=$(( ${#VALUE} * CHAR_WIDTH + 20 ))

TOTAL_WIDTH=$(( LABEL_WIDTH + VALUE_WIDTH ))

LABEL_TEXT_X=$(( LABEL_WIDTH / 2 + 10 ))
VALUE_TEXT_X=$(( LABEL_WIDTH + VALUE_WIDTH / 2 ))

ESCAPED_VALUE=$(printf '%s\n' "$VALUE" | sed 's/[&/]/\\&/g')

sed -e "s/{{COLOR}}/$COLOR/g" \
    -e "s/{{VALUE}}/$ESCAPED_VALUE/g" \
    -e "s/{{LABEL_WIDTH}}/$LABEL_WIDTH/g" \
    -e "s/{{VALUE_WIDTH}}/$VALUE_WIDTH/g" \
    -e "s/{{TOTAL_WIDTH}}/$TOTAL_WIDTH/g" \
    -e "s/{{LABEL_TEXT_X}}/$LABEL_TEXT_X/g" \
    -e "s/{{VALUE_TEXT_X}}/$VALUE_TEXT_X/g" \
    templates/badge.svg.template > "$OUTPUT"

echo "Badge generated!"