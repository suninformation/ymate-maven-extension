#!/bin/bash
cd `dirname $0`
CURRENT_DIR=`pwd`
cd ../target/lib
LIB_DIR=`pwd`
cd ../classes
CLASS_DIR=`pwd`

MAIN_CLASS='net.ymate.port.starter.Main'
SERVER_NAME='PortServer'
PIDS=`ps -ef | grep java | grep "$LIB_DIR" |grep "$MAIN_CLASS $SERVER_NAME"|awk '{print $2}'`
if [ -n "$PIDS" ]; then
    echo "Fail!! The $SERVER_NAME already started! PID:"$PIDS
    exit 1
fi

LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'|tr "\n" ":"`
cd $CURRENT_DIR
nohup java -Djava.net.preferIPv4Stack=true -server -Xms1g -Xmx1g -classpath $LIB_JARS$CLASS_DIR $MAIN_CLASS $SERVER_NAME nohup.out 2>&1 &

PIDS=`ps -ef | grep java | grep "$LIB_DIR" |grep "$MAIN_CLASS $SERVER_NAME"|awk '{print $2}'`
if [ -z "$PIDS" ]; then
    echo "Fail!! The $SERVER_NAME not start!"
    exit 1
fi

echo "Start "$SERVER_NAME" success! PID:"$PIDS