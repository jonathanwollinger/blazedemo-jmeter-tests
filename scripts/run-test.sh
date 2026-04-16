#!/bin/bash
set -e

TEST_FILE=$1
TEST_NAME=$2
DURATION=${3:-60}

if [ -z "$TEST_FILE" ] || [ -z "$TEST_NAME" ]; then
  echo "Usage: ./run-test.sh <test-file> <test-name> [duration]"
  exit 1
fi

echo "Starting test: $TEST_NAME"
echo "Duration: $DURATION seconds"

mkdir -p results reports

jmeter -n \
  -t "$TEST_FILE" \
  -l "results/$TEST_NAME.jtl" \
  -e -o "reports/$TEST_NAME" \
  -Jduration=$DURATION

echo "Test finished: $TEST_NAME"
echo "Report: reports/$TEST_NAME/index.html"