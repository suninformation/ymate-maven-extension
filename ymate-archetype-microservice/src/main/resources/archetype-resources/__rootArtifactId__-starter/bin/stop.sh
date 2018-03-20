#!/bin/bash
cd `dirname $0`
cd ../target/lib
LIB_DIR=`pwd`
cd ../classes
CLASS_DIR=`pwd`

MAIN_CLASS='net.ymate.port.starter.Main'
SERVER_NAME='PortServer'
PIDS=`ps -ef | grep java | grep "$LIB_DIR" |grep "$MAIN_CLASS $SERVER_NAME"|awk '{print $2}'`
if [ -z "$PIDS" ]; then
    echo "Fail!! The $SERVER_NAME not start!"
    exit 1
fi

for PID in $PIDS ;
do
    kill $PID > /dev/null 2>&1
done
echo "Stop "$SERVER_NAME" success! PID:"$PIDS
