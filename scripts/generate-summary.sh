#!/bin/bash
set -e

FILE=$1
OUTPUT=reports/summary.json

if [ ! -f "$FILE" ]; then
  echo "JTL file not found: $FILE"
  exit 1
fi

RESPONSE_TIMES=$(awk -F',' 'NR>1 {print $2}' "$FILE" | sort -n)
COUNT=$(echo "$RESPONSE_TIMES" | wc -l)

if [ "$COUNT" -eq 0 ]; then
  echo "No samples found"
  exit 1
fi

INDEX=$(echo "$COUNT * 0.9" | bc | cut -d'.' -f1)
[ "$INDEX" -eq 0 ] && INDEX=1

P90=$(echo "$RESPONSE_TIMES" | sed -n "${INDEX}p")

START=$(awk -F',' 'NR==2 {print $1}' "$FILE")
END=$(awk -F',' 'END {print $1}' "$FILE")

DURATION=$(echo "($END - $START)/1000" | bc)

if [ "$DURATION" -le 0 ]; then
  DURATION=1
fi

THROUGHPUT=$(echo "$COUNT / $DURATION" | bc)

STATUS="PASS"

if (( THROUGHPUT < 250 )) || (( P90 > 2000 )); then
  STATUS="FAIL"
fi

mkdir -p reports

cat <<EOF > $OUTPUT
{
  "throughput": "$THROUGHPUT",
  "p90": "$P90",
  "status": "$STATUS"
}
EOF

echo "Performance Summary:"
cat $OUTPUT

if [ "$STATUS" = "FAIL" ]; then
  echo "Performance test FAILED (SLA not met)"
  exit 1
fi