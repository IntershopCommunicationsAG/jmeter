#!/bin/bash

set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export HEAP="-Xmn${n}m -Xms${s}m -Xmx${x}m"

if [ ! -z "$NONGUI" -a "$NONGUI" == "TRUE" ]
then
  EXTRA_ARGS="-n"
fi

if [ ! -z "$SERVER_IP" ]
then
  EXTRA_ARGS="$EXTRA_ARGS -s -Djava.rmi.server.hostname=${SERVER_IP}"
fi

if [ ! -z "$TEST_DIR" -a ! -z "$TEST_PLAN" -a -d "/tests/${TEST_DIR}" ]
then
  EXTRA_ARGS="$EXTRA_ARGS -t /tests/${TEST_DIR}/${TEST_PLAN}.jmx"
  if [ ! -z "$NONGUI" ]
  then
    EXTRA_ARGS="$EXTRA_ARGS -X"
  fi
fi

if [ ! -z "$TEST_DIR" -a ! -z "$TEST_PLAN" -a -d "/testlogs/${TEST_DIR}" ]
then
  EXTRA_ARGS="$EXTRA_ARGS -l /testlogs/${TEST_DIR}/${TEST_PLAN}.jtl -j /testlogs/${TEST_DIR}/jmeter.log"
fi

EXTRA_ARGS="$EXTRA_ARGS -Jdatadir=/testdata"

if [ ! -z "$REMOTE_HOSTS" ]
then
  EXTRA_ARGS="$EXTRA_ARGS -R ${REMOTE_HOSTS}"
fi

echo "START Running Jmeter on `date`"
echo "HEAP=${HEAP}"

echo "jmeter ALL ARGS=${EXTRA_ARGS} $@"
jmeter ${EXTRA_ARGS} $@
